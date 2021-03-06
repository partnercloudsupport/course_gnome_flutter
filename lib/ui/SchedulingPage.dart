import 'package:flutter/material.dart';

import 'package:course_gnome/ui/SearchPage.dart';
import 'package:course_gnome/ui/CalendarPage.dart';

import 'package:course_gnome/model/Calendar.dart';
import 'package:course_gnome/model/Course.dart';

import 'package:course_gnome/utilities/Utilities.dart';
import 'package:course_gnome/utilities/Networking.dart';

//enum ActivePage { Search, Calendar }

class SchedulingPage extends StatefulWidget {
  @override
  _SchedulingPageState createState() => _SchedulingPageState();
}

class _SchedulingPageState extends State<SchedulingPage>
    with TickerProviderStateMixin {
  // Scheduling logic
  var _calendars = Calendars();
  var _ready = false;
  bool _inSplitView;
  PageController _pageController = PageController(keepPage: true);
  TabController _tabController;
  TextEditingController _calendarNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initCal();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _calendarNameController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  initCal() async {
    await _calendars.init();
    _tabController = TabController(
      length: _calendars.list.length,
      vsync: this,
      initialIndex: _calendars.currentCalendarIndex,
    );
    _tabController.addListener(_tabChanged);
    setState(() {
      _ready = true;
    });
  }

  _toggleActivePage() {
    _unfocusKeyboard();
    var _page = _pageController.page.round() == 0 ? 1 : 0;
    _pageController.animateToPage(_page,
        duration: Duration(milliseconds: 250), curve: Curves.easeOut);
  }

  _unfocusKeyboard() {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  // Search Page logic
  _toggleOffering(Course course, Offering offering, CGColor color) {
    setState(() {
      _calendars.list[_calendars.currentCalendarIndex]
          .toggleOffering(course, offering, color);
    });
  }

  var _offset = 0;

  // search object
  var _oldSearchObject = SearchObject();
  var _searchObject = SearchObject();
  var _courseResults = CourseResults(total: 0, results: []);

  _search(String name) async {
    if (name.isEmpty) {
      return;
    }
    setState(() {
      _offset = 0;
      _searchObject.name = name;
    });
    _courseResults = await Networking.getCourses(_searchObject, _offset);
    return;
  }

  _loadMoreResults() async {
    setState(() {
      _offset += 10;
    });
    try {
      final _moreResults = await Networking.getCourses(_searchObject, _offset);
      setState(() {
        _courseResults.results.addAll(_moreResults.results);
      });
    } catch (err) {
      setState(() {
        _offset -= 10;
      });
    }
    return;
  }

  _clearResults() {
    setState(() {
      _courseResults.clear();
    });
  }

  // Calendar Page logic
  _tabChanged() {
    setState(() {
      _calendars.currentCalendarIndex = _tabController.index;
    });
    print(_tabController.index);
  }

  _addCalendar() {
    final name = _calendarNameController.text;
    if (name.isEmpty) return;
    setState(() {
      _calendars.addCalendar(name);
      _tabController = TabController(
        length: _calendars.list.length,
        vsync: this,
      );
      _tabController.addListener(_tabChanged);
    });
    Navigator.pop(context);
    _tabController.animateTo(_calendars.list.length - 1);
    _calendarNameController.clear();
  }

  _editCalendar() {
    _calendars.list[_calendars.currentCalendarIndex].name =
        _calendarNameController.text;
    Navigator.pop(context);
    _calendarNameController.clear();
  }

  _deleteCalendar() {
    final first = _tabController.index > 0 ? 1 : 0;
    _tabController.animateTo(_tabController.index - first);
    setState(() {
      _calendars.removeCalendar(
          _calendars.list[_calendars.currentCalendarIndex + first]);
      if (_calendars.currentCalendarIndex != 0) {
        --_calendars.currentCalendarIndex;
      }
      _tabController = TabController(
        length: _calendars.list.length,
        vsync: this,
      );
      _tabController.addListener(_tabChanged);
    });
    Navigator.pop(context);
  }

  _removeOffering(String id) {
    setState(() {
      _calendars.currentCalendar().removeOffering(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    // wait until calendars init
    _inSplitView = MediaQuery.of(context).size.width > Breakpoints.lg;
    final search = SearchPage(
      calendars: _calendars,
      clearResults: _clearResults,
      courseResults: _courseResults,
      inSplitView: _inSplitView,
      loadMoreResults: _loadMoreResults,
      search: _search,
      searchObject: _searchObject,
      toggleActivePage: _toggleActivePage,
      toggleOffering: _toggleOffering,
      offset: _offset,
    );
    final calendar = CalendarPage(
      _calendars,
      _calendarNameController,
      _tabController,
      _addCalendar,
      _editCalendar,
      _deleteCalendar,
      _removeOffering,
      _inSplitView,
      _toggleActivePage,
    );
    return _ready
        ? _inSplitView
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: search,
                  ),
                  Expanded(child: calendar)
                ],
              )
            : PageView(
                controller: _pageController,
                children: [search, calendar],
                onPageChanged: (i) => _unfocusKeyboard,
              )
        : Container();
  }
}

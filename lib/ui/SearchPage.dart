import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:course_gnome/ui/CalendarPage.dart';
import 'package:course_gnome/ui/ProfilePage.dart';

import 'package:course_gnome/model/Course.dart';
import 'package:course_gnome/model/Calendar.dart';

import 'package:course_gnome/utilities/Utilities.dart';
import 'package:course_gnome/utilities/Networking.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static const _borderRadius = 3.0;
  Offering _expandedOffering;
  final _searchTextFieldController = TextEditingController();
  var _searching = false;
  var _showingSearchResults = false;

  var _offset = 0;
  // search object
  var _oldSearchObject = SearchObject();
  var _searchObject = SearchObject();
  var _courseResults = CourseResults(total: 0, results: []);

  // cal
  var _calendars = Calendars();

  _toggleOffering(Course course, Offering offering, CGColor color) {
    setState(() {
      _calendars.list[_calendars.currentCalendarIndex]
          .toggleOffering(course, offering, color);
    });
  }

  _offeringExpanded(Offering offering) {
    _expandedOffering = offering;
  }

  _search(String name) async {
    if (name.isEmpty) {
      _clearSearch();
      return;
    }
    setState(() {
      _showingSearchResults = false;
      _offset = 0;
      _searchObject.name = name;
      _searching = true;
    });
    _courseResults = await Networking.getCourses(_searchObject, _offset);
    setState(() {
      _searching = false;
    });
  }

  _loadMoreResults() async {
    setState(() {
      _searching = true;
      _offset += 10;
    });
    try {
      final _moreResults = await Networking.getCourses(_searchObject, _offset);
      setState(() {
        _searching = false;
        _courseResults.results.addAll(_moreResults.results);
      });
    } catch (err) {
      setState(() {
        _searching = false;
        _offset -= 10;
      });
    }
  }

  _clearSearch() {
    _searchTextFieldController.clear();
    setState(() {
      _courseResults.clear();
    });
  }

  _onSearchFieldTap() {
    setState(() {
      _showingSearchResults = true;
    });
  }

  _dismissSearch() {
    setState(() {
      _showingSearchResults = false;
    });
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  // TODO
  _goToProfile() {
//    Navigator.replace(
//      context,
//      MaterialPageRoute(
//        builder: (context) => ProfilePage(),
//      ),
//    );
  }

  _goToCalendar() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CalendarPage(_calendars),
      ),
    );
  }

  // TODO
  _goToFilter() {}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _calendars = Calendars();
    _calendars.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Search'),
        centerTitle: false,
        leading: _showingSearchResults
            ? IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: _dismissSearch,
              )
            : IconButton(
                icon: Icon(Icons.person),
                onPressed: _goToProfile,
              ),
        actions: [
          //TODO
//          IconButton(
//            icon: Icon(Icons.filter_list),
//            onPressed: _goToFilter,
//          ),
          IconButton(
            padding: EdgeInsets.only(right: 15.0),
            icon: Icon(Icons.calendar_today),
            onPressed: _goToCalendar,
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        left: false,
        right: false,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              title: SafeArea(
                child: Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: TextField(
                    onTap: _onSearchFieldTap,
                    controller: _searchTextFieldController,
                    onSubmitted: (text) => _search(text),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search for anything',
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: _searchTextFieldController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: Colors.grey,
                              ),
                              onPressed: () => _clearSearch(),
                            )
                          : null,
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.search,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                        const Radius.circular(_borderRadius)),
                    color: Colors.white,
                  ),
                ),
              ),
              floating: true,
              snap: true,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int i) {
                  return CourseCard(
                    offeringExpanded: _offeringExpanded,
                    currentCalendar:
                        _calendars.list[_calendars.currentCalendarIndex],
                    toggleOffering: _toggleOffering,
                    expandedOffering: _expandedOffering,
                    course: _courseResults.results[i],
                    borderRadius: _borderRadius,
                    color: CGColors.array[i % CGColors.array.length],
                  );
                },
                addAutomaticKeepAlives: true,
                childCount: _courseResults.results.length,
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.only(top: 30),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Column(
                      children: [
                        !_searching
                            ? _courseResults.total > _offset + 10
                                ? RaisedButton.icon(
                                    icon: Icon(
                                      Icons.expand_more,
                                      color: Colors.white,
                                    ),
                                    color: CGColors.cgred,
                                    label: Text(
                                      'Load More',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    onPressed: _loadMoreResults,
                                  )
                                : Container()
                            : Container(
                                width: 60,
                                child: AspectRatio(
                                  aspectRatio: 1.0,
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation(
                                        CGColors.cgred,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final Function offeringExpanded, toggleOffering;
  final Offering expandedOffering;
  final Calendar currentCalendar;
  final Course course;
  final double borderRadius;
  final CGColor color;
  CourseCard(
      {this.toggleOffering,
      this.offeringExpanded,
      this.currentCalendar,
      this.expandedOffering,
      this.course,
      this.borderRadius,
      this.color});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Card(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: color.med,
                borderRadius: const BorderRadius.only(
                  topLeft: const Radius.circular(2),
                  topRight: const Radius.circular(2),
                ),
              ),
              height: 4,
            ),
            Container(
              padding: EdgeInsets.all(7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        course.departmentAcronym + course.departmentNumber,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle
                            .copyWith(color: color.med),
                      ),
                      Text(
                        course.credit == '0'
                            ? course.credit + ' credit'
                            : course.credit + ' credits',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle
                            .copyWith(color: color.med),
                      ),
                    ],
                  ),
                  Text(
                    course.name,
                    style: Theme.of(context).textTheme.title.copyWith(
                        color: color.med, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            // offerings
            Column(
              children: List.generate(
                course.offerings.length,
                (j) => OfferingTile(
                    course,
                    currentCalendar,
                    toggleOffering,
                    offeringExpanded,
                    expandedOffering,
                    color,
                    course.offerings[j]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OfferingTile extends StatelessWidget {
  final Course course;
  final Function offeringExpanded, toggleOffering;
  final CGColor color;
  final Offering expandedOffering, offering;
  final Calendar currentCalendar;
  OfferingTile(this.course, this.currentCalendar, this.toggleOffering,
      this.offeringExpanded, this.expandedOffering, this.color, this.offering);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: currentCalendar.ids.contains(offering.crn)
          ? color.light
          : Colors.transparent,
      child: GestureDetector(
        onLongPress: () {
          HapticFeedback.selectionClick();
          toggleOffering(course, offering, color);
        },
        child: ExpansionTile(
          onExpansionChanged: offeringExpanded(offering),
          initiallyExpanded: expandedOffering == offering,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: 2,
                  child: Text(offering.sectionNumber,
                      style: TextStyle(color: color.med))),
              Expanded(
                flex: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    offering.classTimes.length,
                    (k) => ClassTimeRow(offering.classTimes[k], color.med),
                  ),
                ),
              ),
              Expanded(
                  flex: 3,
                  child: Text(
                    offering.crn,
                    style: TextStyle(color: color.med),
                    textAlign: TextAlign.right,
                  )),
            ],
          ),
          children: [ExtraInfoContainer(color.med, offering, course)],
        ),
      ),
    );
  }
}

class ClassTimeRow extends StatelessWidget {
  final ClassTime classTime;
  final Color color;
  ClassTimeRow(this.classTime, this.color);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Row(
          children: List.generate(
            5,
            (i) => Container(
                  margin: EdgeInsets.only(right: 2),
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: classTime.days[i + 1] ? color : Colors.transparent,
                    border: Border.all(color: color, width: 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(2),
                    ),
                  ),
                ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 3.0),
          child: Text(
            classTime.timeRangeToString(),
            style: TextStyle(color: color),
          ),
        )
      ],
    );
  }
}

class ExtraInfoContainer extends StatelessWidget {
  final Color color;
  final Offering offering;
  final Course course;
  ExtraInfoContainer(this.color, this.offering, this.course);

  openCoursePage() async {
    final url = course.bulletinLink;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          offering.instructors != null
              ? Text('Instructors: ' + offering.instructors,
                  style: TextStyle(color: color))
              : Container(),
          course.bulletinLink != null
              ? FlatButton.icon(
                  padding: EdgeInsets.all(0),
                  icon: Icon(
                    Icons.open_in_browser,
                    color: color,
                  ),
                  label: Text(
                    'See More',
                    style: TextStyle(color: color),
                  ),
                  onPressed: () => openCoursePage(),
                )
              : Container(),
        ],
      ),
    );
  }
}

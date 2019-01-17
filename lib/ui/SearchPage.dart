import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:course_gnome/ui/CalendarPage.dart';
import 'package:course_gnome/ui/ProfilePage.dart';
import 'package:course_gnome/ui/custom/CGExpansionTile.dart';

import 'package:course_gnome/model/Calendar.dart';
import 'package:course_gnome/model/Course.dart';

import 'package:course_gnome/utilities/Utilities.dart';
import 'package:course_gnome/utilities/Networking.dart';

class SearchPage extends StatefulWidget {
  final Calendars _calendars;
  final Function _toggleOffering;
  final bool _inSplitView;
  final VoidCallback _toggleActivePage;
  Key _key;

  SearchPage(
    this._calendars,
    this._toggleOffering,
    this._inSplitView,
    this._toggleActivePage,
  ) {
    this._key = PageStorageKey("search");
  }

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
//    Navigator.push(
//      context,
//      MaterialPageRoute(
//        builder: (context) => CalendarPage(widget._calendars),
//      ),
//    );
  }

  // TODO
  _goToFilter() {}

//  @override
//  void initState() {
//    super.initState();
//  }

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
          Stack(
            children: <Widget>[
              FloatingActionButton(
                backgroundColor: Colors.transparent,
                highlightElevation: 0,
                elevation: 0,
                onPressed: widget._toggleActivePage,
                child: Stack(
                  children: [
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      disabledColor: Colors.white,
                      onPressed: null,
                    ),
                    Stack(
                      children: <Widget>[
                        Container(
                          decoration:
                              widget._calendars.currentCalendar().ids.length > 0
                                  ? BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      border: Border.all(
                                          color: CGColors.cgred, width: 4))
                                  : null,
                          width: 28,
                          height: 28,
                        ),
                        Positioned(
                          top: 5,
                          left: 9,
                          child:
                              widget._calendars.currentCalendar().ids.length > 0
                                  ? Text(
                                      widget._calendars
                                          .currentCalendar()
                                          .ids
                                          .length
                                          .toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: CGColors.cgred),
                                    )
                                  : Container(),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
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
                    currentCalendar: widget._calendars
                        .list[widget._calendars.currentCalendarIndex],
                    toggleOffering: widget._toggleOffering,
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
            Column(
              children: List.generate(
                course.offerings.length,
                (j) => Container(
                      color:
                          currentCalendar.ids.contains(course.offerings[j].crn)
                              ? color.med.withOpacity(0.1)
                              : Colors.transparent,
                      child: CGExpansionTile(
                        key: PageStorageKey<Offering>(course.offerings[j]),
                        color: color.med,
                        onLongPress: () {
                          HapticFeedback.selectionClick();
                          toggleOffering(course, course.offerings[j], color);
                        },
                        onExpansionChanged:
                            offeringExpanded(course.offerings[j]),
                        initiallyExpanded:
                            expandedOffering == course.offerings[j],
                        title: GestureDetector(
                          child: OfferingRow(color.med, course.offerings[j]),
                        ),
                        children: [
                          ExtraInfoContainer(color, course.offerings[j], course)
                        ],
                      ),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OfferingRow extends StatelessWidget {
  final Color color;
  final Offering offering;

  OfferingRow(this.color, this.offering);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
//              CGChip(),
        Expanded(
          flex: 2,
          child: Text(
            offering.sectionNumber,
            style: TextStyle(color: color),
          ),
        ),
        width > Breakpoints.sm && offering.instructors != null
            ? Expanded(
                flex: 7,
                child: Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Text(
                    offering.instructors,
                    style: TextStyle(color: color),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            : Container(),
        Expanded(
          flex: 8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              offering.classTimes.length,
              (k) => ClassTimeRow(offering.classTimes[k], color),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            offering.crn,
            style: TextStyle(color: color),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

class CGChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xffffcdd2),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Text(
        'C',
        style: TextStyle(color: Color(0xffc62828)),
      ),
      padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
      margin: EdgeInsets.only(right: 5),
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
                  margin: EdgeInsets.only(right: 2, top: 2),
                  width: 13,
                  height: 13,
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
  final CGColor color;
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
    final width = MediaQuery.of(context).size.width;
    String locationString =
        offering.classTimes.length > 1 ? 'Locations: ' : 'Location: ';
    offering.classTimes
        .forEach((time) => locationString += time.location + ', ');
    locationString = Helper.removeLastChars(2, locationString);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              width < Breakpoints.sm && offering.instructors != null
                  ? Text(
                      'Instructors: ' + offering.instructors,
                      style: TextStyle(color: color.med),
                    )
                  : Container(),
              Text(
                locationString,
                style: TextStyle(color: color.med),
              ),
            ],
          ),
        ),
        offering.linkedOfferings != null
            ? Container(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
                color: CGColors.lightGray,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Choose a Linked Course',
                      style: TextStyle(color: color.med),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: List.generate(
                        offering.linkedOfferings.length,
                        (i) => FlatButton(
//                              color: color.light,
                              onPressed: () {},
                              child: OfferingRow(color.med, offering),
                            ),
                      ),
                    ),
                  ],
                ),
              )
            : Container(),
        course.bulletinLink != null
            ? FlatButton.icon(
                padding: EdgeInsets.only(left: 15),
                icon: Icon(
                  Icons.open_in_browser,
                  color: color.med,
                ),
                label: Text(
                  'See More',
                  style: TextStyle(color: color.med),
                ),
                onPressed: () => openCoursePage(),
              )
            : Container(),
      ],
    );
  }
}

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

  // cal
  var _calendars = Calendars();

  _toggleOffering(Course course, Offering offering, Color color) {
    setState(() {
      _calendars.list[_calendars.currentCalendarIndex].toggleOffering(course, offering, color);
    });
  }
  var _courseResults = List<Course>();
  _offeringExpanded(Offering offering) {
    _expandedOffering = offering;
  }
  _search(String text) async {
    if (text.isEmpty) {
      _clearSearch();
      return;
    }
    setState(() {
      _searching = true;
    });
    final List<Course> results = await Networking.getCourses(text);
    setState(() {
      _searching = false;
      _courseResults = results;
    });
  }
  _clearSearch() {
    _searchTextFieldController.clear();
    setState(() {
      _courseResults.clear();
    });
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
        builder: (context) => CalendarPage(
          _calendars
        ),
      ),
    );
  }

  // TODO
  _goToFilter() {}


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _calendars=Calendars();
    _calendars.addCalendar("My Calendar");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Search'),
        centerTitle: false,
        leading: IconButton(
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
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              title: Container(
                margin: EdgeInsets.only(bottom: 5),
                child: TextField(
                  controller: _searchTextFieldController,
                  onSubmitted: (text) => _search(text),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search for anything',
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: _searchTextFieldController.text.isNotEmpty ? IconButton(
                      icon: Icon(Icons.clear, color: Colors.grey,),
                      onPressed: ()=>_clearSearch(),
                    ) : null,
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
              floating: true,
              snap: true,
            ),
            _searching ? SliverList(
              delegate: SliverChildListDelegate(
                [LinearProgressIndicator()]
              ),
            ) : SliverPadding(padding: EdgeInsets.all(0)),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int i) {
                  return CourseCard(
                    offeringExpanded: _offeringExpanded,
                    currentCalendar: _calendars.list[_calendars.currentCalendarIndex],
                    toggleOffering: _toggleOffering,
                    expandedOffering: _expandedOffering,
                    course: _courseResults[i],
                    borderRadius: _borderRadius,
                    color: CGColors
                        .colorArray400[i % CGColors.colorArray400.length],
                  );
                },
                addAutomaticKeepAlives: true,
                childCount: _courseResults.length,



//                b
//                _searched
//                    ? _classTimes.length > 0
//                        ? List.generate(
//                            _classTimes.length,
//                            (i) => CourseCard(
//                                  offeringExpanded: _offeringExpanded,
//                                  expandedOffering: _expandedOffering,
//                                  course: _classTimes[i],
//                                  borderRadius: _borderRadius,
//                                  color: CGColors.colorArray400[
//                                      i % CGColors.colorArray400.length],
//                                ),
//                          )
//                        : [Container(child: Text('No results'),)]
//                    : [Container()]
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
  final Color color;
  CourseCard(
      {
        this.toggleOffering,
      this.offeringExpanded,
      this.currentCalendar,
      this.expandedOffering,
      this.course,
      this.borderRadius,
      this.color});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
//      decoration: BoxDecoration(
//          border: Border(left: BorderSide(color: color))
//      ),
      child: Row(
        children: <Widget>[
//            Container(
//              width: 4,
//              decoration: BoxDecoration(
//                color: color,
//                borderRadius: BorderRadius.only(
//                  topLeft: Radius.circular(borderRadius),
//                  bottomLeft: Radius.circular(borderRadius),
//                ),
//              ),
//            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
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
                                .copyWith(color: color),
                          ),
                          Text(
                            course.credit == '0'
                                ? course.credit + ' credit'
                                : course.credit + ' credits',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle
                                .copyWith(color: color),
                          ),
                        ],
                      ),
                      Text(
                        course.name,
                        style: Theme.of(context).textTheme.title.copyWith(
                            color: color, fontWeight: FontWeight.bold),
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
        ],
      ),
    );
  }
}

class OfferingTile extends StatelessWidget {
  final Course course;
  final Function offeringExpanded, toggleOffering;
  final Color color;
  final Offering expandedOffering, offering;
  final Calendar currentCalendar;
  OfferingTile(this.course, this.currentCalendar, this.toggleOffering,
      this.offeringExpanded, this.expandedOffering, this.color, this.offering);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: currentCalendar.ids.contains(offering.id)
          ? Colors.yellow
          : Colors.transparent,
      child: GestureDetector(
        onLongPress: () {
          HapticFeedback.selectionClick();
        toggleOffering(course, offering, color);
        },
        child: ExpansionTile(
          onExpansionChanged: offeringExpanded(offering),
          initiallyExpanded: expandedOffering == offering,
          key: key,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: 1,
                  child: Text(offering.sectionNumber,
                      style: TextStyle(color: color))),
              Expanded(
                flex: 7,
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
                  child: Text(offering.id, style: TextStyle(color: color))),
            ],
          ),
          children: [ExtraInfoContainer(color, offering)],
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
                    color: classTime.days[i] ? color : Colors.transparent,
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
            classTime.rangeToString(),
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
  ExtraInfoContainer(this.color, this.offering);

  openCoursePage() async {
    final url = offering.bulletinLink;
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
          Text('Instructors: ' + offering.instructors,
              style: TextStyle(color: color)),
          FlatButton.icon(
            padding: EdgeInsets.all(0),
            icon: Icon(Icons.open_in_browser, color: color,),
            label: Text('See More',style: TextStyle(color: color),),
            onPressed: ()=>openCoursePage(),
          )
        ],
      ),
    );
  }
}

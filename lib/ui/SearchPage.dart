import 'package:flutter/material.dart';
import 'package:course_gnome/ui/CalendarPage.dart';
import 'package:course_gnome/ui/ProfilePage.dart';
import 'package:course_gnome/model/Course.dart';
import 'package:course_gnome/utilities/Utilities.dart';
import 'package:flutter/services.dart';
import 'package:course_gnome/utilities/Networking.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static const _borderRadius = 3.0;
  Offering _expandedOffering;
  var _searched = false;

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
        builder: (context) => CalendarPage(),
      ),
    );
  }

  // TODO
  _goToFilter() {}

  _offeringExpanded(Offering offering) {
    _expandedOffering = offering;
  }

  // mock data
  var _courseResults = List<Course>();
  var _selectedOfferings = Map<String, Offering>();

  _toggleOfferingSelected(Offering offering) {
    if (_selectedOfferings.containsKey(offering.crn)) {
      setState(() {
        _selectedOfferings.remove(offering.crn);
      });
    } else {
      setState(() {
        _selectedOfferings[offering.crn] = offering;
      });
    }
  }

  _search(String text) async {
    _searched = true;
    final List<Course> results = await Networking.getCourses(text);
    setState(() {
      _courseResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Search'),
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
              expandedHeight: 60,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: TextField(
                          onSubmitted: (text) => _search(text),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search for anything',
                            prefixIcon: Icon(Icons.search),
                          ),
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                              const Radius.circular(_borderRadius)),
                          color: Colors.white,
                        ),
                      ),
                    ],
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
                    toggleOfferingSelected: _toggleOfferingSelected,
                    offeringExpanded: _offeringExpanded,
                    selectedOfferings: _selectedOfferings,
                    expandedOffering: _expandedOffering,
                    course: _courseResults[i],
                    borderRadius: _borderRadius,
                    color: CGColors
                        .colorArray400[i % CGColors.colorArray400.length],
                  );
                },
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
  final Function offeringExpanded, toggleOfferingSelected;
  final Offering expandedOffering;
  final Map<String, Offering> selectedOfferings;
  final Course course;
  final double borderRadius;
  final Color color;
  CourseCard(
      {this.toggleOfferingSelected,
        this.offeringExpanded,
        this.selectedOfferings,
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
                    (j) => OfferingTile(selectedOfferings, toggleOfferingSelected, offeringExpanded, expandedOffering,
                        color, course.offerings[j]),
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
  final Map<String, Offering> selectedOfferings;
  final Function offeringExpanded, toggleOfferingSelected;
  final Color color;
  final Offering expandedOffering, offering;
  OfferingTile(this.selectedOfferings,
      this.toggleOfferingSelected, this.offeringExpanded, this.expandedOffering, this.color, this.offering);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: selectedOfferings.containsKey(offering.crn) ? Colors.yellow : Colors.transparent,
      child: GestureDetector(
        onLongPress: () {
          HapticFeedback.selectionClick();
          toggleOfferingSelected(offering);
        },
        child: ExpansionTile(
          onExpansionChanged: offeringExpanded(offering),
          initiallyExpanded: expandedOffering == offering,
          key: key,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(offering.sectionNumber, style: TextStyle(color: color)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  offering.classTimes.length,
                  (k) => ClassTimeRow(offering.classTimes[k], color),
                ),
              ),
              Text(offering.crn, style: TextStyle(color: color)),
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
                      borderRadius: BorderRadius.all(Radius.circular(2))),
                ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 3.0),
          child:
              Text(classTime.rangeToString(), style: TextStyle(color: color)),
        )
      ],
    );
  }
}

class ExtraInfoContainer extends StatelessWidget {
  final Color color;
  final Offering offering;
  ExtraInfoContainer(this.color, this.offering);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
      alignment: Alignment.centerLeft,
      child: Column(
        children: <Widget>[
          Text('Instructors: ' + offering.instructors, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}

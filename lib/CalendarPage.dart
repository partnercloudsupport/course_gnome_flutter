import 'package:flutter/material.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  var hourHeight = 100.0;
  var dayWidth = 150.0;
  var initialDayScroll = 0.0;

  List<ScrollController> dayControllers = List<ScrollController>();

  final sundayController = ScrollController();
  final mondayController = ScrollController();
  final tuesdayController = ScrollController();
  final wednesdayController = ScrollController();
  final thursdayController = ScrollController();
  final fridayController = ScrollController();
  final saturdayController = ScrollController();

  final dayStrings = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"
  ];

  var dayBeingScrolled;

  sundayScroll() {
    scrollOthers(0, sundayController);
  }

  mondayScroll() {
    scrollOthers(1, mondayController);
  }

  tuesdayScroll() {
    scrollOthers(2, tuesdayController);
  }

  wednesdayScroll() {
    scrollOthers(3, wednesdayController);
  }

  thursdayScroll() {
    scrollOthers(4, thursdayController);
  }

  fridayScroll() {
    scrollOthers(5, fridayController);
  }

  saturdayScroll() {
    scrollOthers(6, saturdayController);
  }

  scrollOthers(int day, ScrollController controller) {
    if (day != dayBeingScrolled) return;
    for (var i = 0; i < dayControllers.length; ++i) {
      if (i != day) {
        dayControllers[i].position.jumpTo(controller.offset);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    dayControllers.addAll([
      sundayController,
      mondayController,
      tuesdayController,
      wednesdayController,
      thursdayController,
      fridayController,
      saturdayController
    ]);
    sundayController.addListener(sundayScroll);
    mondayController.addListener(mondayScroll);
    tuesdayController.addListener(tuesdayScroll);
    wednesdayController.addListener(wednesdayScroll);
    thursdayController.addListener(thursdayScroll);
    fridayController.addListener(fridayScroll);
    saturdayController.addListener(saturdayScroll);
  }

  @override
  void dispose() {
    sundayController.removeListener(sundayScroll);
    mondayController.removeListener(mondayScroll);
    tuesdayController.removeListener(tuesdayScroll);
    wednesdayController.removeListener(wednesdayScroll);
    thursdayController.removeListener(thursdayScroll);
    fridayController.removeListener(fridayScroll);
    saturdayController.removeListener(saturdayScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Calendar'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.format_list_bulleted), onPressed: () => {}),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: GestureDetector(
          onScaleUpdate: (details)=>print(details.focalPoint),
          child: new SizedBox(
            width: dayWidth*7,
            child: new ListView(
              children: List.generate(
                10,
                (i) => Row(
                      children: List.generate(
                        7,
                        (j) => Container(
                            decoration: BoxDecoration(border:Border(top: BorderSide(), right: BorderSide())),
                            height: hourHeight,
                            width: dayWidth,
                            child: Text('d')),
                      ),
                    ),
              ),
            ),
          ),
        ),
      ),
//      body: Column(
//        children: <Widget>[
//          Text('d'),
//          Expanded(
//            child: ListView(
//              scrollDirection: Axis.horizontal,
//              children: List.generate(7, (i) {
//                var container = Container(
//                  decoration: BoxDecoration(
//                    border: Border(
//                      right: BorderSide(),
//                    ),
//                  ),
//                  width: dayWidth,
//                  child: GestureDetector(
//                    onPanDown: (details) {
//                      setState(() {
//                        dayBeingScrolled = i;
//                      });
//                    },
//                    child: ListView(
//                      controller: dayControllers[i],
//                      children: List.generate(
//                        12,
//                        (j) => Container(
//                              decoration: BoxDecoration(
//                                  border: Border(top: BorderSide())),
//                              height: hourHeight,
//                              child: Text('d'),
//                            ),
//                      ),
//                    ),
//                  ),
//                );
//                return container;
//              }),
//            ),
//          ),
//        ],
//      ),
    );
  }
}

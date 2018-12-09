import 'package:flutter/material.dart';
import 'dart:math';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  static const hourCount = 17;
  static const startHour = 7;
  static const dayCount = 7;
  var hourHeight = 100.0;
  var dayWidth = 150.0;

  var classTimes = List<List<ClassTime>>.generate(7, (i) => List<ClassTime>());

  final hourController = ScrollController();
  final dayController = ScrollController();
  final horizontalCalController = ScrollController();
  final verticalCalController = ScrollController();

  calHorizontallyScrolled() {
    dayController.jumpTo(horizontalCalController.offset);
  }

  calVerticallyScrolled() {
    hourController.jumpTo(verticalCalController.offset);
  }

//  scaleStart(ScaleStartDetails details) {}
//  scaleUpdate(ScaleUpdateDetails details) {}
//  scaleEnd(ScaleEndDetails details) {}

  @override
  void initState() {
    super.initState();
    horizontalCalController.addListener(calHorizontallyScrolled);
    verticalCalController.addListener(calVerticallyScrolled);

    // test class time
    classTimes[1].addAll([
      ClassTime(
        startTime: TimeOfDay(hour: 8, minute: 00),
        endTime: TimeOfDay(hour: 9, minute: 15),
        departmentInfo: 'AFST 1000',
        id: '12122',
        name: 'Science for Dweebs u feel me',
        color: Colors.deepPurple,
      ),
      ClassTime(
        startTime: TimeOfDay(hour: 9, minute: 45),
        endTime: TimeOfDay(hour: 10, minute: 35),
        departmentInfo: 'CSCI 2010',
        id: '92281',
        name: 'Science for Nerds! And dweebs! haha!',
        color: Colors.deepOrange,
      ),
    ]);
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
      body: Column(
        children: <Widget>[
          DayList(dayCount, dayWidth, dayController),
          Expanded(
            child: SafeArea(
              child: Row(
                children: <Widget>[
                  HourList(hourCount, startHour, hourHeight, hourController),
                  Calendar(
                      dayCount,
                      hourCount,
                      startHour,
                      dayWidth,
                      hourHeight,
                      horizontalCalController,
                      verticalCalController,
                      classTimes),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Calendar extends StatelessWidget {
  static const BorderSide border = BorderSide(color: Colors.grey, width: 0.25);
  final int dayCount, hourCount, startHour;
  final double dayWidth, hourHeight;
  final ScrollController horizontalCalController, verticalCalController;
  final List<List<ClassTime>> classTimes;
  Calendar(
      this.dayCount,
      this.hourCount,
      this.startHour,
      this.dayWidth,
      this.hourHeight,
      this.horizontalCalController,
      this.verticalCalController,
      this.classTimes);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: SingleChildScrollView(
          controller: verticalCalController,
          scrollDirection: Axis.vertical,
          child: GestureDetector(
//            onScaleStart: (details) => scaleStart(details),
//            onScaleUpdate: (details) => scaleUpdate(details),
//            onScaleEnd: (details) => scaleEnd(details),
            child: SizedBox(
              height: hourHeight * hourCount,
              child: ListView(
                scrollDirection: Axis.horizontal,
                controller: horizontalCalController,
                children: List.generate(
                  dayCount,
                  (i) => Stack(
                        children: <Widget>[
                          Column(
                            children: List.generate(
                              hourCount,
                              (j) => Container(
                                    decoration: BoxDecoration(
                                      border: i == dayCount - 1
                                          ? const Border(
                                              top: border,
                                              left: border,
                                              right: border,
                                            )
                                          : const Border(
                                              top: border,
                                              left: border,
                                            ),
                                    ),
                                    height: hourHeight,
                                    width: dayWidth,
                                  ),
                            ),
                          ),
                          classTimes[i].length != 0
                              ? Stack(
                                  children: List.generate(
                                    classTimes[i].length,
                                    (k) => ClassBlock(startHour, dayWidth,
                                        hourHeight, classTimes[i][k]),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DayList extends StatelessWidget {
  static const dayStrings = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"
  ];
  final int dayCount;
  final double dayWidth;
  final ScrollController dayController;
  DayList(this.dayCount, this.dayWidth, this.dayController);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(10, 10, 10, 0.05),
      padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
      height: 40,
      child: SafeArea(
        bottom: false,
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          controller: dayController,
          scrollDirection: Axis.horizontal,
          children: List.generate(
            dayCount,
            (i) => Container(
                  alignment: Alignment.center,
                  width: dayWidth,
                  child: Text(
                    dayStrings[i],
                  ),
                ),
          ),
        ),
      ),
    );
  }
}

class HourList extends StatelessWidget {
  final int hourCount, startHour;
  final double hourHeight;
  final ScrollController hourController;
  HourList(
      this.hourCount, this.startHour, this.hourHeight, this.hourController);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(8, 0, 4, 8),
      width: 30,
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        controller: hourController,
        children: List.generate(
          hourCount,
          (i) => Container(
                height: hourHeight,
                child: Text(
                  ((i + startHour - 1) % 12 + 1).toString(),
                  textAlign: TextAlign.right,
                ),
              ),
        ),
      ),
    );
  }
}

class ClassBlock extends StatelessWidget {
  static const borderRadius = 3.0;
  static const lighteningFactor = 80;
  final int startHour;
  final double dayWidth, hourHeight;
  final ClassTime classTime;
  ClassBlock(this.startHour, this.dayWidth, this.hourHeight, this.classTime);

  double calculateOffset() {
    return classTime.startTime.hour * hourHeight +
        classTime.startTime.minute * hourHeight / 60 -
        startHour * hourHeight;
  }

  double calculateHeight() {
    double hour =
        (classTime.endTime.hour - classTime.startTime.hour) * hourHeight;
    double min = (classTime.endTime.minute - classTime.startTime.minute) *
        (hourHeight / 60);
    return hour + min;
  }

  String formatTime() {
    var minute = classTime.startTime.minute;
    var minuteString = minute.toString();
    if (minute < 10) {
      minuteString += '0';
    }
    return classTime.startTime.hour.toString() + ':' + minuteString;
  }
  
  Color lightenColor(Color color) {
    print(color.blue);
    print(color.green);
    print(color.red);
    print(color.blue + lighteningFactor);
    print(color.green + lighteningFactor);
    print(color.red + lighteningFactor);
    final blue = (color.blue+lighteningFactor).clamp(0, 255);
    final green = (color.green+lighteningFactor).clamp(0, 255);
    final red = (color.red+lighteningFactor).clamp(0, 255);
    return color.withBlue(blue).withGreen(green).withRed(red).withOpacity(0.3);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        color: lightenColor(classTime.color),
      ),
      margin: EdgeInsets.only(top: calculateOffset()),
      height: calculateHeight(),
      width: dayWidth,
      child: Row(
        children: <Widget>[
          Container(
            width: 4,
            decoration:BoxDecoration(
                color: classTime.color,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(borderRadius),bottomLeft: Radius.circular(borderRadius))
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(classTime.departmentInfo, style: TextStyle(color: classTime.color),),
//                  Text(formatTime(), style: TextStyle(color: classTime.color),),
                  Text(classTime.id, style: TextStyle(color: classTime.color, fontWeight: FontWeight.bold),),
                  Text(classTime.name, style: TextStyle(color: classTime.color),),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ClassTime {
  TimeOfDay startTime, endTime;
  String departmentInfo, id, name;
  Color color;
  ClassTime(
      {this.startTime,
      this.endTime,
      this.departmentInfo,
      this.id,
      this.name,
      this.color});

  int offset() {
    return startTime.hour * 2;
  }
}

enum Weekday { Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday }

import 'package:flutter/material.dart';
import 'package:course_gnome/model/Calendar.dart';
import 'package:course_gnome/model/Course.dart';

class CalendarPage extends StatefulWidget {
  final List<Calendar> calendars;
  final int currentCalendarIndex;
  CalendarPage(this.calendars, this.currentCalendarIndex);
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage>
    with SingleTickerProviderStateMixin {
  static const hourCount = 17;
  static const startHour = 7;
  static const dayCount = 7;
  var hourHeight = 100.0;
  var dayWidth = 125.0;

  ScrollController hourController;
  ScrollController dayController;
  ScrollController horizontalCalController;
  ScrollController verticalCalController;

  calHorizontallyScrolled() {
    dayController.jumpTo(horizontalCalController.offset);
  }

  calVerticallyScrolled() {
    hourController.jumpTo(verticalCalController.offset);
  }

  TabController _tabController;
  
//  scaleStart(ScaleStartDetails details) {}
//  scaleUpdate(ScaleUpdateDetails details) {}
//  scaleEnd(ScaleEndDetails details) {}

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: widget.calendars.length, vsync: this, initialIndex: widget.currentCalendarIndex);
    hourController = ScrollController();
    verticalCalController = ScrollController();
    dayController = ScrollController(initialScrollOffset: dayWidth);
    horizontalCalController = ScrollController(initialScrollOffset: dayWidth);
    horizontalCalController.addListener(calHorizontallyScrolled);
    verticalCalController.addListener(calVerticallyScrolled);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
            IconButton(icon: Icon(Icons.playlist_add), onPressed: () => {}),
          ],
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorColor: Colors.white,
            tabs: List.generate(
              widget.calendars.length,
              (i) => Tab(text: widget.calendars[i].name),
            ),
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: List.generate(
            widget.calendars.length,
            (i) => Column(
                  children: <Widget>[
                    DayList(dayCount, dayWidth, dayController),
                    Expanded(
                      child: SafeArea(
                        child: Row(
                          children: <Widget>[
                            HourList(hourCount, startHour, hourHeight,
                                hourController),
                            CalendarView(
                                dayCount,
                                hourCount,
                                startHour,
                                dayWidth,
                                hourHeight,
                                horizontalCalController,
                                verticalCalController,
                                widget.calendars[i].blocksByDay),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
          ),
        ));
  }
}

class CalendarView extends StatelessWidget {
  static const BorderSide border = BorderSide(color: Colors.grey, width: 0.25);
  final int dayCount, hourCount, startHour;
  final double dayWidth, hourHeight;
  final ScrollController horizontalCalController, verticalCalController;
  final List<List<ClassBlock>> classBlocks;
  CalendarView(
      this.dayCount,
      this.hourCount,
      this.startHour,
      this.dayWidth,
      this.hourHeight,
      this.horizontalCalController,
      this.verticalCalController,
      this.classBlocks);
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
                          classBlocks[i].length != 0
                              ? Stack(
                                  children: List.generate(
                                    classBlocks[i].length,
                                    (k) => ClassBlockWidget(startHour, dayWidth,
                                        hourHeight, classBlocks[i][k]),
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

class ClassBlockWidget extends StatelessWidget {
  static const borderRadius = 3.0;
  static const lighteningFactor = 80;
  final int startHour;
  final double dayWidth, hourHeight;
  final ClassBlock classBlock;
  ClassBlockWidget(
      this.startHour, this.dayWidth, this.hourHeight, this.classBlock);

  double calculateOffset() {
    return classBlock.offset * hourHeight - startHour * hourHeight;
  }

  Color lightenColor(Color color) {
    final blue = (color.blue + lighteningFactor).clamp(0, 255);
    final green = (color.green + lighteningFactor).clamp(0, 255);
    final red = (color.red + lighteningFactor).clamp(0, 255);
    return color.withBlue(blue).withGreen(green).withRed(red).withOpacity(0.3);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        color: lightenColor(classBlock.color),
      ),
      margin: EdgeInsets.only(top: calculateOffset()),
      height: classBlock.height * hourHeight,
      width: dayWidth,
      child: Row(
        children: <Widget>[
          Container(
            width: 4,
            decoration: BoxDecoration(
                color: classBlock.color,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(borderRadius),
                    bottomLeft: Radius.circular(borderRadius))),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    classBlock.departmentInfo,
                    style: TextStyle(color: classBlock.color),
                  ),
//                  Text(formatTime(), style: TextStyle(color: classTime.color),),
                  Text(
                    classBlock.id,
                    style: TextStyle(
                        color: classBlock.color, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    classBlock.name,
                    style: TextStyle(color: classBlock.color),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

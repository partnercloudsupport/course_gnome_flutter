import 'package:flutter/material.dart';
import 'package:course_gnome/model/Calendar.dart';
import 'package:course_gnome/model/Course.dart';

class CalendarPage extends StatefulWidget {
  final Calendars calendars;
  CalendarPage(this.calendars);
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage>
    with TickerProviderStateMixin {
  static const hourCount = 17;
  static const startHour = 7;
  static const dayCount = 7;
  var hourHeight = 100.0;
  var dayWidth = 125.0;

  TabController _tabController;
  TextEditingController _calendarNameController;
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

//  scaleStart(ScaleStartDetails details) {}
//  scaleUpdate(ScaleUpdateDetails details) {}
//  scaleEnd(ScaleEndDetails details) {}

  _tabChanged() {
    widget.calendars.currentCalendarIndex = _tabController.index;
  }
  
  _addCalendar() {
    final name = _calendarNameController.text;
    if (name.isEmpty)
      return;
    setState(() {
      widget.calendars.addCalendar(name);
      _tabController = TabController(
          length: widget.calendars.list.length,
          vsync: this
      );
    });
    Navigator.pop(context);
    _tabController.animateTo(widget.calendars.list.length-1);
    _calendarNameController.clear();
  }

  _editCalendar() {
    widget.calendars.list[widget.calendars.currentCalendarIndex].name =_calendarNameController.text;
    Navigator.pop(context);
  }
  
  _deleteCalendar() {
    setState(() {
      widget.calendars.removeCalendar(widget.calendars.list[widget.calendars.currentCalendarIndex]);
      _tabController = TabController(
          length: widget.calendars.list.length,
          vsync: this
      );
    });
    if (widget.calendars.list.length == widget.calendars.currentCalendarIndex) {

    }
    Navigator.pop(context);
  }
  
  _showAddCalendarDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Add Calendar'),
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                autofocus: true,
                controller: _calendarNameController,
                textCapitalization: TextCapitalization.words,
                onSubmitted: (text)=>_addCalendar(),
                maxLength: 20,
                maxLengthEnforced: true,
                style: Theme.of(context).textTheme.headline
              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  child: Text('Add'),
                  onPressed: ()=>_addCalendar(),
                ),
                FlatButton(
                  child: Text('Cancel'),
                  onPressed: ()=>Navigator.pop(context),
                )
              ],
            )
          ],
        );
      }
    );
  }

  _showEditCalendarDialog(){
    _calendarNameController.text = widget.calendars.list[widget.calendars.currentCalendarIndex].name;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('Edit Calendar'),
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                    autofocus: true,
                    controller: _calendarNameController,
                    textCapitalization: TextCapitalization.words,
                    onSubmitted: (text)=>_editCalendar(),
                    maxLength: 20,
                    maxLengthEnforced: true,
                    style: Theme.of(context).textTheme.headline
                ),
              ),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Text('Save'),
                    onPressed: ()=>_editCalendar(),
                  ),
                  FlatButton(
                    child: Text('Cancel'),
                    onPressed: ()=>Navigator.pop(context),
                  )
                ],
              )
            ],
          );
        }
    );
  }

  _showDeleteCalendarDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('Delete Calendar'),
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('Delete calendar ' + widget.calendars.list[widget.calendars.currentCalendarIndex].name + '?')
              ),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Text('Delete'),
                    onPressed: ()=>_deleteCalendar(),
                  ),
                  FlatButton(
                    child: Text('Cancel'),
                    onPressed: ()=>Navigator.pop(context),
                  )
                ],
              )
            ],
          );
        }
    );
  }

  @override
  void initState() {
    super.initState();
    _calendarNameController = TextEditingController();
    _tabController = TabController(
        length: widget.calendars.list.length,
        vsync: this,
        initialIndex: widget.calendars.currentCalendarIndex,
    );
    _tabController.addListener(_tabChanged);
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
    _calendarNameController.dispose();
    hourController.dispose();
    dayController.dispose();
    horizontalCalController.dispose();
    verticalCalController.dispose();
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
          IconButton(icon: Icon(Icons.playlist_add), onPressed: () => _showAddCalendarDialog()),
          IconButton(icon: Icon(Icons.edit), onPressed: () => _showEditCalendarDialog()),
          widget.calendars.list.length > 1 ? IconButton(icon: Icon(Icons.remove_circle_outline), onPressed: () => _showDeleteCalendarDialog()) : Container(),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          tabs: List.generate(
            widget.calendars.list.length,
            (i) => Tab(text: widget.calendars.list[i].name),
          ),
        ),
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: List.generate(
          widget.calendars.list.length,
          (i) => Column(
                children: <Widget>[
                  DayList(dayCount, dayWidth, dayController),
                  Expanded(
                    child: SafeArea(
                      child: Row(
                        children: <Widget>[
                          HourList(
                              hourCount, startHour, hourHeight, hourController),
                          CalendarView(
                              dayCount,
                              hourCount,
                              startHour,
                              dayWidth,
                              hourHeight,
                              horizontalCalController,
                              verticalCalController,
                              widget.calendars.list[i].blocksByDay),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
        ),
      ),
    );
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
                          Container(
                            child: Column(
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

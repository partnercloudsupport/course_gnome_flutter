import 'package:flutter/material.dart';
import 'dart:collection';
import 'dart:math';

import 'package:course_gnome/model/Course.dart';

class Calendars {
  List<Calendar> list;
  int currentCalendarIndex;
  Calendars() {
    list = [];
  }
  addCalendar(String name) {
    // get new id
    int id;
    while(true){
      id = Random().nextInt(100);
      if (list.indexWhere((cal)=>cal.id == id)==-1)
        break;
    }
    final cal = Calendar(name, id);
    list.add(cal);
//    // behavior for now is we set this calendar to be the current one
    currentCalendarIndex = list.length-1;
  }
  removeCalendar(Calendar calendar) {
    list.remove(calendar);
  }
}

class Calendar {
  int id;
  String name;
  HashSet<String> ids;
  List<List<ClassBlock>> blocksByDay;

  Calendar(name, id) {
    this.name = name;
    this.id = id;
    ids = HashSet<String>();
    blocksByDay = List.generate(7, (i) => List<ClassBlock>());
  }

  toggleOffering(Course course, Offering offering, Color color) {
    if (ids.contains(offering.id)) {
      removeOffering(offering.id);
    } else {
      addOffering(course, offering, color);
    }
  }
  addOffering(Course course, Offering offering, Color color) {
    ids.add(offering.id);
    for (var classTime in offering.classTimes) {
      final offset = classTime.startTime.hour + classTime.startTime.minute / 60;
      final height = classTime.endTime.hour -
          classTime.startTime.hour +
          (classTime.endTime.minute - classTime.startTime.minute) / 60;
      final departmentInfo =
          course.departmentAcronym + ' ' + course.departmentNumber;
      for (var i = 0; i < classTime.days.length; ++i) {
        if (!classTime.days[i]) {
          continue;
        }
        blocksByDay[i].add(ClassBlock(
            offset, height, departmentInfo, offering.id, course.name, color));
      }
    }
  }
  removeOffering(String id) {
    ids.remove(id);
    blocksByDay.forEach((list) =>
      list.removeWhere((block)=>block.id == id)
    );
  }

}

class ClassBlock {
  double offset, height;
  String departmentInfo, id, name;
  Color color;
  ClassBlock(this.offset, this.height, this.departmentInfo, this.id, this.name,
      this.color);
}


//String formatTime() {
//  var minute = classTime.startTime.minute;
//  var minuteString = minute.toString();
//  if (minute < 10) {
//    minuteString += '0';
//  }
//  return classTime.startTime.hour.toString() + ':' + minuteString;
//}

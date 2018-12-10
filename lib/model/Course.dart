import 'package:flutter/material.dart';
class Course {
  String departmentAcronym, departmentNumber, name, credit, description, bulletinLink;
  List<Offering> offerings;
  Course({this.departmentAcronym, this.departmentNumber, this.name, this.credit,
      this.description, this.bulletinLink, this.offerings});
}

class Offering {
  String sectionNumber, status, id, instructors, bulletinLink;
  List<ClassTime> classTimes;
  Offering({this.sectionNumber, this.status, this.id, this.classTimes, this.instructors, this.bulletinLink});
}

class ClassTime {
  TimeOfDay startTime, endTime;
  String location;
  List<bool> days;
  ClassTime({this.startTime, this.endTime, this.location, this.days});
  
  String timeToString(TimeOfDay time) {
    var minuteString = time.minute.toString();
    if (time.minute < 10) {
      minuteString += '0';
    }
    final hourString = ((time.hour-1) % 12 + 1).toString();
    return hourString + ':' + minuteString;
  }

  String rangeToString() {
    return timeToString(startTime) + '-' + timeToString(endTime);
  }
}
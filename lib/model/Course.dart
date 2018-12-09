import 'package:flutter/material.dart';
class Course {
  String departmentAcronym, departmentNumber, name, credit, description, bulletinLink;
  List<Offering> offerings;
  Course({this.departmentAcronym, this.departmentNumber, this.name, this.credit,
      this.description, this.bulletinLink, this.offerings});
}

class Offering {
  String sectionNumber, status, crn;
  List<ClassTime> classTimes;
  Offering({this.sectionNumber, this.status, this.crn, this.classTimes});
}

class ClassTime {
  TimeOfDay startTime, endTime;
  String location;
  List<bool> days;
  ClassTime({this.startTime, this.endTime, this.location, this.days});

  String startTimeToString() {
    var minuteString = startTime.minute.toString();
    if (startTime.minute < 10) {
      minuteString += '0';
    }
    return startTime.hour.toString() + ':' + minuteString;
  }
  String endTimeToString() {
    var minuteString = endTime.minute.toString();
    if (endTime.minute < 10) {
      minuteString += '0';
    }
    return endTime.hour.toString() + ':' + minuteString;
  }
  String rangeToString() {
    return startTimeToString() + '-' + endTimeToString();
  }
}
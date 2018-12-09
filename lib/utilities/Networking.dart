import 'package:course_gnome/model/Course.dart';
import 'package:flutter/material.dart';

class Networking {
  static Future<List<Course>> getCourses(String text) async {
    return List.generate(
      10,
          (i) => Course(
        credit: '3',
        name: 'Literature and Ladies',
        departmentAcronym: 'TRDA',
        departmentNumber: '1002',
        description: 'A nice class!',
        offerings: [
          Offering(
            crn: '13919',
            sectionNumber: '10',
            status: 'Open',
            classTimes: [
              ClassTime(
                  startTime: TimeOfDay(hour: 10, minute: 10),
                  endTime: TimeOfDay(hour: 11, minute: 20),
                  days: [false, true, true, false, false, false, false]),
              ClassTime(
                  startTime: TimeOfDay(hour: 1, minute: 20),
                  endTime: TimeOfDay(hour: 2, minute: 50),
                  days: [false, false, true, false, true, false, false]),
            ],
          ),
          Offering(
            crn: '21812',
            sectionNumber: '12',
            status: 'Closed',
            classTimes: [
              ClassTime(
                  startTime: TimeOfDay(hour: 2, minute: 20),
                  endTime: TimeOfDay(hour: 3, minute: 15),
                  days: [false, true, false, false, true, false, false]),
              ClassTime(
                  startTime: TimeOfDay(hour: 12, minute: 20),
                  endTime: TimeOfDay(hour: 5, minute: 0),
                  days: [false, true, true, true, true, false, false]),
            ],
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';

import 'package:course_gnome/model/Course.dart';

class Networking {
  static Future<List<Course>> getCourses(String text) async {
//    try {
//      final dynamic resp = await CloudFunctions.instance.call(
//        functionName: 'getCourses',
//        parameters: <String, dynamic>{
//          'name': text,
//        },
//      );
//      print(resp);
//      final coursesJson = resp['courses'];
//    } on CloudFunctionsException catch (e) {
//      print('caught firebase functions exception');
//      print(e.code);
//      print(e.message);
//      print(e.details);
//    } catch (e) {
//      print('caught generic exception');
//      print(e);
//    }
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
            bulletinLink: 'https://google.com',
            instructors: 'Bob Dole, Tim T',
            id: '13919',
            sectionNumber: '10',
            status: 'Open',
            classTimes: [
              ClassTime(
                  startTime: TimeOfDay(hour: 10, minute: 10),
                  endTime: TimeOfDay(hour: 11, minute: 20),
                  days: [false, true, true, false, false, false, false]),
              ClassTime(
                  startTime: TimeOfDay(hour: 15, minute: 20),
                  endTime: TimeOfDay(hour: 16, minute: 50),
                  days: [false, false, true, false, true, false, false]),
            ],
          ),
          Offering(
            bulletinLink: 'https://google.com',
            instructors: 'Amanda Bines, Tim A',
            id: '21812',
            sectionNumber: '12',
            status: 'Closed',
            classTimes: [
              ClassTime(
                  startTime: TimeOfDay(hour: 11, minute: 20),
                  endTime: TimeOfDay(hour: 12, minute: 15),
                  days: [false, true, false, false, true, false, false]),
              ClassTime(
                  startTime: TimeOfDay(hour: 12, minute: 20),
                  endTime: TimeOfDay(hour: 17, minute: 0),
                  days: [false, true, true, true, true, false, false]),
            ],
          ),
        ],
      ),
    );
  }
}
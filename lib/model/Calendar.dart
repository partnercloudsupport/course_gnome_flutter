import 'package:flutter/material.dart';

class Calendar {
  String name;
  List<List<ClassBlock>> blocks;
  Calendar(name) {
    this.name = name;
    blocks = List.generate(7, (i) => List<ClassBlock>());
  }
}

class ClassBlock {
  TimeOfDay startTime, endTime;
  String departmentInfo, id, name;
  Color color;
  ClassBlock({this.startTime, this.endTime, this.departmentInfo, this.id, this.name, this.color});
}

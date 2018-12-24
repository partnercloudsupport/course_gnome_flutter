import 'package:flutter/material.dart';


class CGColor {
  Color light, med, dark;
  CGColor(int light, int med, int dark){
    this.light = Color(light);
    this.med = Color(med);
    this.dark = Color(dark);
  }
}

class CGColors {

  static final cgred = const Color(0xFFD50110);
  static final lightGray = const Color(0xffFAFAFA);

  static final red = CGColor(0xffFCE6EA, 0xffD74660, 0xff96263A);
  static final orange = CGColor(0xffFDEADC,0xffE4813D,0xffA05320);
  static final gold = CGColor(0xffFDF0D4,0xffE1AC3D,0xff9E7520);
  static final green = CGColor(0xffE3F6EC,0xff30B36E,0xff157A45);
  static final turquoise = CGColor(0xffDAF4F2,0xff21AEA8,0xff0A7671);
  static final lightblue = CGColor(0xffD8ECF7,0xff298BC7,0xff1D618B);
  static final darkblue = CGColor(0xffDAE3F7,0xff335EC3,0xff244289);
  static final purple = CGColor(0xffE9DFF6,0xff7C4DBE,0xff573685);
  static final gray = CGColor(0xffDEE2E8,0xff455C78,0xff304154);

  static final array = [
    red, orange, gold, green, turquoise, lightblue, darkblue, purple, gray
  ];

}

class Helper {
  static removeLastChar(String string) {
    return string.replaceRange(string.length-1, string.length, '');
  }
}
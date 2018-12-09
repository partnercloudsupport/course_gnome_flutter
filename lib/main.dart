import 'package:flutter/material.dart';
import 'package:course_gnome/ui/SearchPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: const Color(0xFFD50110),
        fontFamily: 'Lato',
      ),
      home: SearchPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
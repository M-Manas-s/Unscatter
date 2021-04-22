import 'package:flutter/material.dart';

TextStyle kAppBarTitleStyle = TextStyle(
  fontFamily: 'Barlow',
  letterSpacing: 8,
  fontSize: 29,
  fontWeight: FontWeight.w500,
);

TextStyle kCourseNameDB = TextStyle(
  fontSize: 20,
  letterSpacing: 4,
);

TextStyle kTimeDB = TextStyle(
  fontSize: 13,
  letterSpacing: 2,
);
ThemeData kAppTheme = ThemeData.dark().copyWith(
  primaryColor: Color(0xFF0A0E23),
  scaffoldBackgroundColor: Color(0xFF0F142d),
  accentColor: Color(0xFFE45465),
);

ThemeData kAppTheme2 = ThemeData.dark().copyWith(
  primaryColor: Color(0xFF11163A),
  scaffoldBackgroundColor: Color(0xFF0F1434),
  accentColor: Color(0xFFE45465),
);
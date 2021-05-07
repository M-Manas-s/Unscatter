import 'package:flutter/material.dart';
import 'package:unicorndial/unicorndial.dart';

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
  cardColor: Color(0xFF0F142d),
  colorScheme: ThemeData.dark().colorScheme.copyWith(
    surface: Color(0xFF0A0E23),
  ),
);

ThemeData kAppTheme2 = ThemeData.dark().copyWith(
  primaryColor: Color(0xFF11163A),
  scaffoldBackgroundColor: Color(0xFF0F1434),
  accentColor: Color(0xFFE45465),
);

final List<UnicornButton> floatingButtonsOneOptionSelected= [
  UnicornButton(
    hasLabel: true,
    labelText: "Suspend",
    currentButton: FloatingActionButton(
      onPressed: () {},
      heroTag: "suspend",
      backgroundColor: Color(0xFFE45465),
      mini: true,
      child: Icon(Icons.pause, color: Colors.white),
    ),
  ),
  UnicornButton(
    hasLabel: true,
    labelText: "Remove",
    currentButton: FloatingActionButton(
      onPressed: () {},
      heroTag: "Remove",
      backgroundColor: Color(0xFFE45465),
      mini: true,
      child: Icon(Icons.delete, color: Colors.white),
    ),
  ),
  UnicornButton(
    hasLabel: true,
    labelText: "Edit",
    currentButton: FloatingActionButton(
      onPressed: () {},
      heroTag: "edit",
      backgroundColor: Color(0xFFE45465),
      mini: true,
      child: Icon(Icons.edit, color: Colors.white),
    ),
  )
];

final List<UnicornButton> floatingButtonsManyOptionsSelected = [
  UnicornButton(
    hasLabel: true,
    labelText: "Suspend",
    currentButton: FloatingActionButton(
      onPressed: () {},
      heroTag: "suspend",
      backgroundColor: Color(0xFFE45465),
      mini: true,
      child: Icon(Icons.pause, color: Colors.white),
    ),
  ),
  UnicornButton(
    hasLabel: true,
    labelText: "Remove",
    currentButton: FloatingActionButton(
      onPressed: () {},
      heroTag: "Remove",
      backgroundColor: Color(0xFFE45465),
      mini: true,
      child: Icon(Icons.delete, color: Colors.white),
    ),
  ),
];
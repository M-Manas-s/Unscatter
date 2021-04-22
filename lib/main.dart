import 'package:flutter/material.dart';
import 'package:unscatter/constants/constants.dart';
import 'package:unscatter/screens/Dashboard.dart';
import 'package:unscatter/screens/AddOrModify.dart';
import 'package:unscatter/screens/Delete.dart';

void main() {
  runApp(
    MaterialApp(
      home: LandingPage(),
      routes: {
        Dashboard.id : (context) => Dashboard(),
        AddOrModify.id : (context) => AddOrModify(),
        Delete.id : (context) => Delete(),
      },
      theme: kAppTheme,
    )
  );
}

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 8,
        title : Text("Unscatter",
        style: kAppBarTitleStyle
        ),
        centerTitle: true,
      ),

      body: Dashboard(),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFE45465),
        child: Icon(Icons.add, color: Colors.white,),
      ),

    );
  }
}

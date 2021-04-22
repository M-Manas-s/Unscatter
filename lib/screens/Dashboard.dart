import 'package:flutter/material.dart';
import 'package:unscatter/classes/DashboardCard.dart';

List<Widget> list = [
  WeekDayText(day: "MONDAY", date: "19th April"),
  DashboardCard(courseName: "CSE", courseID: "2004",time: "9:00 AM - 9:50 AM",theory: true,
      extraClass: false),
  DashboardCard(courseName: "CSE", courseID: "1003",time: "10:00 AM - 10:50 AM",theory: true,
      extraClass: false),
  DashboardCard(courseName: "MAT", courseID: "2001",time: "11:00 AM - 11:50 AM",theory: true,
      extraClass: false),
  DashboardCard(courseName: "PHY", courseID: "1701",time: "12:00 PM - 12:50 AM",theory: true,
      extraClass: true),
];

class Dashboard extends StatefulWidget {

  static String id = "Dashboard";

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left:8, right:8),
      margin: EdgeInsets.only(top:20),
      child: ListView(
        children: list,//.map((e) => e).toList(),
      )
    );
  }
}

class WeekDayText extends StatelessWidget {

  String day;
  String date;

  WeekDayText({@required this.day, @required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(day,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 22,
            letterSpacing: 5,
          )),
          SizedBox(height: 3),
          Text(date,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 17,
                letterSpacing: 4,
              )),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}


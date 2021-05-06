import 'package:flutter/material.dart';
import 'package:unscatter/classes/DashboardCard.dart';
import 'package:unicorndial/unicorndial.dart';
import 'package:unscatter/constants/constants.dart';

List<Widget> list = [
  WeekDayText(day: "MONDAY", date: "19th April"),
  DashboardCard(
      courseName: "CSE",
      courseID: "2004",
      time: "9:00 AM - 9:50 AM",
      theory: true,
      extraClass: false),
  DashboardCard(
      courseName: "CSE",
      courseID: "1003",
      time: "10:00 AM - 10:50 AM",
      theory: true,
      extraClass: false),
  DashboardCard(
      courseName: "MAT",
      courseID: "2001",
      time: "11:00 AM - 11:50 AM",
      theory: true,
      extraClass: false),
  DashboardCard(
      courseName: "PHY",
      courseID: "1701",
      time: "12:00 PM - 12:50 AM",
      theory: false,
      extraClass: true),
  DashboardCard(
      courseName: "CSE",
      courseID: "1003",
      time: "10:00 AM - 10:50 AM",
      theory: true,
      extraClass: false),
];

class Dashboard extends StatefulWidget {
  static String id = "Dashboard";

  bool startSelecting = false;
  List<int> selectedItem = [];
  List<int> heading = [0];

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  @override
  Widget build(BuildContext context) {
    Size query = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: UnicornDialer(
        onMainButtonPressed: () {},
        backgroundColor: Colors.black38,
        parentButtonBackground: Theme.of(context).accentColor,
        orientation: UnicornOrientation.VERTICAL,
        parentButton: widget.startSelecting
            ? Icon(Icons.assignment, color: Colors.white)
            : Icon(Icons.add, color: Colors.white),
        childButtons: widget.startSelecting ? ( widget.selectedItem.length==1 ? floatingButtonsOneOptionSelected : floatingButtonsManyOptionsSelected ) : null,
      ),
      body: Container(
        height: query.height,
        margin: EdgeInsets.only(top: 20),
        child: Column(
          children: [
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(
                      left: query.width * 0.025, right: query.width * 0.025),
                  child: GestureDetector(
                    onLongPress: () {
                      setState(() {
                        if (!widget.startSelecting) {
                          widget.startSelecting = true;
                          widget.selectedItem.add(index);
                        }
                      });
                    },
                    onPanDown: (var x) {
                      if (widget.startSelecting)
                        setState(() {
                          if (widget.selectedItem.contains(index))
                            widget.selectedItem
                                .removeWhere((element) => element == index);
                          else
                            widget.selectedItem.add(index);
                          if (widget.selectedItem.length == 0)
                            widget.startSelecting = false;
                        });
                    },
                    child: Container(
                      child: Row(children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          width: widget.startSelecting ? 0.1 * query.width : 0,
                          child: !widget.heading.contains(index) &&
                                  widget.startSelecting
                              ? Checkbox(
                                  value: widget.selectedItem.contains(index),
                                  onChanged: (bool value) {},
                                )
                              : Container(),
                        ),
                        Expanded(flex: 8, child: list[index]),
                      ]),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
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
                fontSize: 21,
                letterSpacing: 4,
              )),
          SizedBox(height: 3),
          Text(date,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
                letterSpacing: 4,
              )),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}

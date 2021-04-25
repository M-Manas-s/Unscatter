import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unscatter/constants/constants.dart';

class DashboardCard extends StatefulWidget {

  String courseName;
  String courseID;
  String time;
  bool theory;
  bool extraClass;

  DashboardCard({@required this.courseName, @required this.courseID,
  @required this.time, @required this.theory, @required this.extraClass});

  @override
  _DashboardCardState createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  @override
  Widget build(BuildContext context) {
    Size query = MediaQuery.of(context).size;
    return Container(
       width: query.width*0.9,
        margin: EdgeInsets.only(top: 5, bottom: 5),
        decoration: BoxDecoration(
          boxShadow: [
            // BoxShadow(
            //   color: Colors.black,
            //   blurRadius: 1.0,
            //   offset: Offset(0, 14),
            //   spreadRadius: -13,
            // )
          ],
        ),
        child: Card(
          color: !widget.extraClass? Color(0xFF282B4E) : Theme.of(context).accentColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(10.0),
            splashColor: Color(0xFF1E7777).withAlpha(30),
            onTap: () {},
            child: Container(
              padding: EdgeInsets.fromLTRB(
                  query.width * (1 / 20),
                  query.width * (1 / 40),
                  query.width * (1 / 20),
                  query.width * (1 / 40)),
              child: Row(
                children: [
                  Expanded(
                    flex: 7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "${widget.courseName} ${widget.courseID}",
                          style: kCourseNameDB,
                        ),
                        Text(widget.time,
                        style: kTimeDB),
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed))
                                return Theme.of(context).accentColor;
                              return !widget.extraClass?Theme.of(context)
                                  .accentColor:Color(0xFF282B4E); // Use the component's default.
                            },
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.red))),
                        ),
                        child: Text(
                          widget.theory?'T':'L',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                      ))
                ],
              ),
            ),
          ),
        ));
  }
}

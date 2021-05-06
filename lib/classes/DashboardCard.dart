import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unscatter/classes/CustomCard.dart';
import 'package:unscatter/constants/constants.dart';

class DashboardCard extends StatefulWidget {
  String courseName;
  String courseID;
  String time;
  bool theory;
  bool extraClass;

  DashboardCard(
      {@required this.courseName,
      @required this.courseID,
      @required this.time,
      @required this.theory,
      @required this.extraClass});

  @override
  _DashboardCardState createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  @override
  Widget build(BuildContext context) {
    return CustomCard(
      color: widget.extraClass ? Theme.of(context).accentColor : null,
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
                Text(widget.time, style: kTimeDB),
              ],
            ),
          ),
          Expanded(
              flex: 1,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Theme.of(context).accentColor;
                      return !widget.extraClass
                          ? Theme.of(context).accentColor
                          : Color(0xFF282B4E); // Use the component's default.
                    },
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red))),
                ),
                child: Text(
                  widget.theory ? 'T' : 'L',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              ))
        ],
      ),
    );
  }
}

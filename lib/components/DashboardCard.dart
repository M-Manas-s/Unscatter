import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unscatter/components/CustomCard.dart';
import 'package:unscatter/constants/constants.dart';
import 'package:unscatter/constants/enums.dart';

class DashboardCard extends StatefulWidget {
  final String courseName;
  final String courseID;
  final String time;
  final ClassType classType;
  final SpecialClass specialClass;

  DashboardCard(
      {@required this.courseName,
      @required this.courseID,
      @required this.time,
      @required this.classType,
      @required this.specialClass});

  @override
  _DashboardCardState createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  @override
  Widget build(BuildContext context) {
    return CustomCard(
      color: widget.specialClass == SpecialClass.Extra ? Theme.of(context).accentColor : Color(0xFF282B4E),
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
              child: Container(
                width: 36,
                padding: EdgeInsets.all(0),
                margin: EdgeInsets.all(0),
                child: TextButton(
                  onPressed: (){},
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Theme.of(context).accentColor;
                        return widget.specialClass != SpecialClass.Extra
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
                    widget.classType == ClassType.Theory ? 'T' : 'L',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}

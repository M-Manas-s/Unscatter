import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unscatter/classes/DashBoardClass.dart';
import 'package:unscatter/components/CustomCard.dart';
import 'package:unscatter/constants/constants.dart';
import 'package:unscatter/constants/enums.dart';

class DashboardCard extends StatefulWidget {
  final DashBoardClass dbc;
  DashboardCard({@required this.dbc,});
  
  @override
  _DashboardCardState createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  @override
  Widget build(BuildContext context) {
    return CustomCard(
      color: widget.dbc.specialClass == SpecialClass.Extra ? Theme.of(context).accentColor : Color(0xFF282B4E),
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "${widget.dbc.courseName} ${widget.dbc.courseID}",
                  style: kCourseNameDB,
                ),
                Text(widget.dbc.time, style: kTimeDB),
                SizedBox(height: 5,),
                Row(
                  children: [
                    Text(widget.dbc.classroom+ ' - Prof. ', style: kTimeDB),
                    Text(widget.dbc.facultyName, style: kTimeDB),
                  ],
                ),

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
                        return widget.dbc.specialClass != SpecialClass.Extra
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
                    widget.dbc.classType == ClassType.Theory ? 'T' : 'L',
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

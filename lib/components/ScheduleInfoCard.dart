import 'package:flutter/material.dart';
import 'package:unscatter/classes/TimeSlot.dart';
import 'package:unscatter/components/CustomCard.dart';
import 'package:intl/intl.dart';
import 'package:unscatter/constants/enums.dart';

class ScheduleInfoCard extends StatelessWidget {
  final TimeSlot ts;
  final ClassType type;

  const ScheduleInfoCard({Key key, @required this.ts,  @required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  DateFormat("EEEE").format(DateTime.parse(ts.startDayTime.split(' ')[0])),
                  style: TextStyle(
                      fontSize: 28,
                      letterSpacing: 2,
                      fontFamily: 'Barlow',
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat("jm").format(DateTime.parse(ts.startDayTime.split(' ')[0]+' '+ts.startDayTime.split(' ')[2]))+' - ',
                      style: TextStyle(
                        fontSize: 17,
                        fontFamily: 'Itim',
                      ),
                    ),
                    Text(
                    DateFormat("jm").format(DateTime.parse(ts.startDayTime.split(' ')[0]+' '+ts.endDayTime.split(' ')[2])),
                      style: TextStyle(
                        fontSize: 17,
                        fontFamily: 'Itim',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 4,
            child: CustomCard(
              radius: 7,
              child: Center(
                child:FittedBox(
                  fit: BoxFit.contain,
                  child:Text(
                    type.toString().split('.')[1],
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
              color: Theme.of(context).accentColor,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              margin: EdgeInsets.all(0),
            ),
          ),
        ],
      ),
    );
  }
}

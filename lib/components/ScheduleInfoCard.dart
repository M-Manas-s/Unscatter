import 'package:flutter/material.dart';
import 'package:unscatter/classes/Lecture.dart';
import 'package:unscatter/components/CustomCard.dart';

class ScheduleInfoCard extends StatelessWidget {
  final Lecture lecture;
  final Function delete;
  final Function edit;

  const ScheduleInfoCard({Key key, @required this.lecture, @required this.delete, @required this.edit}) : super(key: key);

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
                  lecture.weekday.toString().split('.')[1],
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
                      '${lecture.startTime.format(context)} - ',
                      style: TextStyle(
                        fontSize: 17,
                        fontFamily: 'Itim',
                      ),
                    ),
                    Text(
                      lecture.endTime.format(context),
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
            flex: 5,
            child: Column(
              children: [
                CustomCard(
                  radius: 7,
                  child: Text(
                    lecture.type.toString().split('.')[1],
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  color: Theme.of(context).accentColor,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  margin: EdgeInsets.all(0),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomCard(
                      child: GestureDetector(
                        onPanDown: (details) {
                          edit();
                        },
                        child: Icon(
                          Icons.edit,
                          size: 17,
                        ),
                      ),
                      color: Colors.indigo,
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      margin: EdgeInsets.all(0),
                    ),
                    CustomCard(
                      child: GestureDetector(
                        onPanDown: (details) {
                          delete();
                        },
                        child: Icon(
                          Icons.delete,
                          size: 17,
                        ),
                      ),
                      color: Colors.indigo,
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      margin: EdgeInsets.all(0),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

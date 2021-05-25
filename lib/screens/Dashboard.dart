import 'package:flutter/material.dart';
import 'package:unscatter/classes/TimeSlot.dart';
import 'package:unscatter/components/DashboardCard.dart';
import 'package:unscatter/constants/constants.dart';
import 'package:unscatter/constants/enums.dart';
import 'package:unscatter/screens/AddOrModify.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unscatter/screens/AddOrModifyFaculty.dart';
import 'package:unscatter/screens/Login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


// ignore: must_be_immutable
class Dashboard extends StatefulWidget {
  static String id = "Dashboard";

  bool startSelecting = false;
  List<int> selectedItem = [];
  List<int> heading = [0];

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  SharedPreferences prefs;
  List list = [];
  bool loadingDB = true;

  void initializeDBread() async{
    prefs = await SharedPreferences.getInstance();
    getData(prefs.getString('user'));
  }

  void getData(String user) async{
    print(user);
    switch(user){
      case 'Faculty' :

        String facid,fname;
        await FirebaseFirestore.instance
            .collection('Faculty')
            .where('Email', isEqualTo: prefs.getString('email'))
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            facid = doc['FacultyID'];
            fname = doc['Name'];
          });
        });

        print(facid);

        await FirebaseFirestore.instance
            .collection('CoursesTimeSlot')
            .where('FacultyID', isEqualTo: facid)
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) async {
              TimeSlot ts = TimeSlot(startDayTime: doc['StartDayTime'],endDayTime: doc['EndDayTime']);
              String cname = doc['CourseName'];
              String cid = doc['CourseID'];
              ClassType ct = doc['Type'] =='Theory' ? ClassType.Theory : ClassType.Lab;
              String classInfo;
              await FirebaseFirestore.instance
                  .collection('ClassTimeSlot')
                  .where('EndDayTime', isEqualTo: ts.endDayTime)
                  .where('StartDayTime', isEqualTo: ts.startDayTime)
                  .get()
                  .then((QuerySnapshot querySnapshot) {
                querySnapshot.docs.forEach((doc) {
                  classInfo = doc['Block'] + ' ' + doc['ClassNo'];
                });
              });
              String time = DateFormat("jm").format(DateTime.parse(ts.startDayTime.split(' ')[0]+' '+ts.startDayTime.split(' ')[2]))+' - '
              + DateFormat("jm").format(DateTime.parse(ts.startDayTime.split(' ')[0]+' '+ts.endDayTime.split(' ')[2]));
              setState(() {
                print(
                  "courseName: $cname, courseID: $cid, classType: $ct, classroom: $classInfo, time: $time (${ts.startDayTime.split(' ')[0]}), facultyName: $fname"
                );
                list.add(DashboardCard(
                  courseName: cname,
                  courseID: cid,
                  classType: ct,
                  classroom: classInfo,
                  time: time,
                  facultyName: fname,
                ));
              });

          });
        });
        setState(() {
          print(list.length);
          loadingDB = false;
        });
        break;
    }
  }

  @override
  void initState() {
    initializeDBread();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size query = MediaQuery.of(context).size;
    FirebaseAuth _auth = FirebaseAuth.instance;

    return Scaffold(
      appBar: AppBar(
        elevation: 8,
        title: Text("Unscatter", style: kAppBarTitleStyle),
        centerTitle: true,
        actions: [
          PopupMenuButton<int>(
              itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
                    PopupMenuItem<int>(
                        value: 1, child: Text('Sign Out')),
                  ],
              onSelected: (int value) async {
                  await _auth.signOut();
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.remove('email');
                  prefs.remove('user');
                  Navigator.pushNamed(context, LoginPage.id);
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).accentColor,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pushNamed(context, prefs.getString('user')=='Faculty' ? AddOrModifyFaculty.id : AddOrModify.id);
        },
      ),
      body: Container(
        height: query.height,
        margin: EdgeInsets.only(top: 20),
        child: Column(
          children: [
            loadingDB ? Container() :
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
  final String day;
  final String date;

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

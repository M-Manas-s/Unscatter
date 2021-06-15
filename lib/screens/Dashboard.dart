import 'package:flutter/material.dart';
import 'package:unscatter/classes/DashBoardClass.dart';
import 'package:unscatter/classes/TimeSlot.dart';
import 'package:unscatter/components/DashboardCard.dart';
import 'package:unscatter/constants/constants.dart';
import 'package:unscatter/constants/enums.dart';
import 'package:unscatter/screens/AddOrModify.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unscatter/screens/AddOrModifyFaculty.dart';
import 'package:unscatter/screens/Delete.dart';
import 'package:unscatter/screens/Login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:unicorndial/unicorndial.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
  bool loadingDB = true;
  List dispList = [];

  void initializeDBread() async {
    prefs = await SharedPreferences.getInstance();
    // print("initiating");
    getData(prefs.getString('user'));
    //list.sort((a,b) => a.weekday.compareTo(b.weekday));
    // print("Loaded");
    // print(list.length);
    // for ( var x in list )
    //     print("ok");
  }

  int getWeekdayNum(String weekday) {
    switch (weekday) {
      case "Mon":
        return 1;
        break;
      case "Tue":
        return 2;
        break;
      case "Wed":
        return 3;
        break;
      case "Thu":
        return 4;
        break;
      case "Fri":
        return 5;
        break;
      case "Sat":
        return 6;
        break;
      case "Sun":
        return 7;
        break;
    }
    return 0;
  }

  String getWeekdayString(int weekday) {
    switch (weekday) {
      case 1:
        return "Monday";
        break;
      case 2:
        return "Tuesday";
        break;
      case 3:
        return "Wednesday";
        break;
      case 4:
        return "Thursday";
        break;
      case 5:
        return "Friday";
        break;
      case 6:
        return "Saturday";
        break;
      case 7:
        return "Sunday";
        break;
    }
    return " ";
  }

  void getData(String user) async {
    print(user);
    List<DashBoardClass> list = [];
    switch (user) {
      case 'Faculty':
        String facid, fname;
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

        await FirebaseFirestore.instance
            .collection('CoursesTimeSlot')
            .where('FacultyID', isEqualTo: facid)
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            TimeSlot ts = TimeSlot(
                startDayTime: doc['StartDayTime'],
                endDayTime: doc['EndDayTime']);
            String cname = doc['CourseName'];
            String cid = doc['CourseID'];
            ClassType ct =
                doc['Type'] == 'Theory' ? ClassType.Theory : ClassType.Lab;

            //print(getWeekdayNum(DateFormat("E").format(DateTime.parse(ts.startDayTime.split(' ')[0]+' '+ts.startDayTime.split(' ')[2]))));
            String time = DateFormat("jm").format(DateTime.parse(
                    ts.startDayTime.split(' ')[0] +
                        ' ' +
                        ts.startDayTime.split(' ')[2])) +
                ' - ' +
                DateFormat("jm").format(DateTime.parse(
                    ts.startDayTime.split(' ')[0] +
                        ' ' +
                        ts.endDayTime.split(' ')[2]));
            //print("courseName: $cname, courseID: $cid, classType: $ct, classroom: $classInfo, time: $time (${ts.startDayTime.split(' ')[0]}), facultyName: $fname");
            setState(() {
              list.add(
                new DashBoardClass(
                    courseName: cname,
                    courseID: cid,
                    classType: ct,
                    time: time,
                    ts: ts,
                    facultyName: fname,
                    weekday: getWeekdayNum(DateFormat("E").format(
                        DateTime.parse(ts.startDayTime.split(' ')[0] +
                            ' ' +
                            ts.startDayTime.split(' ')[2])))),
              );
            });
          });
        });

        for (int i = 0; i < list.length; i++) {
          await FirebaseFirestore.instance
              .collection('ClassTimeSlot')
              .where('EndDayTime', isEqualTo: list[i].ts.endDayTime)
              .where('StartDayTime', isEqualTo: list[i].ts.startDayTime)
              .get()
              .then((QuerySnapshot querySnapshot) {
            querySnapshot.docs.forEach((doc) {
              list[i].classroom = (doc['Block'] + ' ' + doc['ClassNo']);
            });
          });
        }

        list.sort((a, b) => a.ts.startDayTime.compareTo(b.ts.startDayTime));

        setState(() {
          if ( list.length!=0 ) {
            dispList.add(WeekDayText(day: getWeekdayString(list[0].weekday)));
            dispList.add(DashboardCard(dbc: list[0]));
          }
          else
            dispList.add(
              Center(
                child : Text("No Courses Undertaken!",
                style: TextStyle(fontSize: 20),)
              )
            );
          for (int i = 1; i < list.length; i++) {
            if (list[i].weekday != list[i - 1].weekday)
              dispList.add(WeekDayText(day: getWeekdayString(list[i].weekday)));
            dispList.add(DashboardCard(dbc: list[i]));
          }
          loadingDB = false;
        });
        break;

      case "Student":

        String regno;
        List<DashBoardClass> listFinal = [];
        await FirebaseFirestore.instance
            .collection('Student')
            .where('Email', isEqualTo: prefs.getString('email'))
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            regno = doc['Regno'];
          });
        });

        await FirebaseFirestore.instance
            .collection('StudentCourses')
            .where('Regno', isEqualTo: regno)
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            list.add(
              new DashBoardClass(
                  courseName: doc["CourseName"],
                  courseID: doc["CourseID"],
                  classType: doc['Type'] == 'Theory' ? ClassType.Theory : ClassType.Lab,
                  facid : doc["FacultyID"],
            ));
          });
        });


        for (int i=0; i<list.length; i++) {

          await FirebaseFirestore.instance
              .collection('CoursesTimeSlot')
              .where('FacultyID', isEqualTo: list[i].facid)
              .where('CourseName', isEqualTo : list[i].courseName)
              .where('CourseID', isEqualTo : list[i].courseID)
              .where('Type', isEqualTo: list[i].classType.toString().split('.')[1] )
              .get()
              .then((QuerySnapshot querySnapshot) {
            querySnapshot.docs.forEach((doc) {
              TimeSlot ts = TimeSlot(
                  startDayTime: doc['StartDayTime'],
                  endDayTime: doc['EndDayTime']);
              String time = DateFormat("jm").format(DateTime.parse(
                  ts.startDayTime.split(' ')[0] +
                      ' ' +
                      ts.startDayTime.split(' ')[2])) +
                  ' - ' +
                  DateFormat("jm").format(DateTime.parse(
                      ts.startDayTime.split(' ')[0] +
                          ' ' +
                          ts.endDayTime.split(' ')[2]));

              listFinal.add(
                  new DashBoardClass(
                      courseName: list[i].courseName,
                      courseID: list[i].courseID,
                      classType: list[i].classType,
                      facid: list[i].facid,
                      time: time,
                      ts: ts,
                      weekday: getWeekdayNum(DateFormat("E").format(
                          DateTime.parse(ts.startDayTime.split(' ')[0] +
                              ' ' +
                              ts.startDayTime.split(' ')[2]))))
              );
            });
          });
        }

        for ( int i=0; i<listFinal.length; i++ )
          {
            await FirebaseFirestore.instance
                .collection('ClassTimeSlot')
                .where('EndDayTime', isEqualTo: listFinal[i].ts.endDayTime)
                .where('StartDayTime', isEqualTo: listFinal[i].ts.startDayTime)
                .get()
                .then((QuerySnapshot querySnapshot) {
              querySnapshot.docs.forEach((doc) {
                listFinal[i].classroom = (doc['Block'] + ' ' + doc['ClassNo']);
              });
            });

            await FirebaseFirestore.instance
                .collection('Faculty')
                .where('FacultyID', isEqualTo: listFinal[i].facid)
                .get()
                .then((QuerySnapshot querySnapshot) {
              querySnapshot.docs.forEach((doc) {
                listFinal[i].facultyName = doc['Name'];
              });
            });
          }
        listFinal.sort((a, b) => a.ts.startDayTime.compareTo(b.ts.startDayTime));
        setState(() {
          if ( listFinal.length!=0 ) {
            dispList.add(
                WeekDayText(day: getWeekdayString(listFinal[0].weekday)));
            dispList.add(DashboardCard(dbc: listFinal[0]));
          }
          else
            dispList.add(Center(
                child : Text("No Courses Undertaken!",
                  style: TextStyle(fontSize: 20),)
            ));
          for (int i = 1; i < listFinal.length; i++) {
            if (listFinal[i].weekday != listFinal[i - 1].weekday)
              dispList.add(WeekDayText(day: getWeekdayString(listFinal[i].weekday)));
            dispList.add(DashboardCard(dbc: listFinal[i]));
          }
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

    return ModalProgressHUD(
      progressIndicator: SpinKitChasingDots(
        color: Theme.of(context).accentColor,
        size: 30.0,
      ),
      inAsyncCall: loadingDB,
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
            elevation: 8,
            title: Text("Unscatter", style: kAppBarTitleStyle),
            centerTitle: true,
            actions: [
              PopupMenuButton<int>(
                  itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
                        PopupMenuItem<int>(value: 1, child: Text('Sign Out')),
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
          floatingActionButton: UnicornDialer(
            onMainButtonPressed: () {},
            backgroundColor: Colors.black38,
            parentButtonBackground: Theme.of(context).accentColor,
            orientation: UnicornOrientation.VERTICAL,
            parentButton: widget.startSelecting
                ? Icon(Icons.assignment, color: Colors.white)
                : Icon(Icons.add, color: Colors.white),
            childButtons: [
              UnicornButton(
                hasLabel: true,
                labelText: "Add",
                currentButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.pushNamed(context, prefs.getString('user')=='Faculty' ? AddOrModifyFaculty.id : AddOrModify.id);
                  },
                  heroTag: "Add",
                  backgroundColor: Color(0xFFE45465),
                  mini: true,
                  child: Icon(Icons.add, color: Colors.white),
                ),
              ),
              UnicornButton(
                hasLabel: true,
                labelText: "Remove",
                currentButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Delete.id);
                  },
                  heroTag: "Remove",
                  backgroundColor: Color(0xFFE45465),
                  mini: true,
                  child: Icon(Icons.delete, color: Colors.white),
                ),
              ),
            ],
          ),
          body: Container(
            height: query.height,
            margin: EdgeInsets.symmetric(vertical: 20),
            child: loadingDB
                ? Container()
                : ListView.builder(
                    physics: ScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: dispList.length,
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
                                width:
                                    widget.startSelecting ? 0.1 * query.width : 0,
                                child: !widget.heading.contains(index) &&
                                        widget.startSelecting
                                    ? Checkbox(
                                        value: widget.selectedItem.contains(index),
                                        onChanged: (bool value) {},
                                      )
                                    : Container(),
                              ),
                              Expanded(flex: 8, child: dispList[index]),
                            ]),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}

class WeekDayText extends StatelessWidget {
  final String day;

  WeekDayText({@required this.day});

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
        ],
      ),
    );
  }
}

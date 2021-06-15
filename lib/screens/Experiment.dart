import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:unscatter/classes/DashBoardClass.dart';
import 'package:unscatter/classes/TimeSlot.dart';
import 'package:unscatter/constants/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

DateTime t1= DateTime(2021,5,17,8,00);
DateTime t2= DateTime(2021,5,17,8,55);
DateTime t3= DateTime(2021,5,17,9,50);
DateTime t4= DateTime(2021,5,17,10,45);
DateTime t5= DateTime(2021,5,17,11,40);
DateTime l1= DateTime(2021,5,17,14,00);
DateTime l2= DateTime(2021,5,17,15,50);

class Experiment extends StatefulWidget {
  const Experiment({Key key}) : super(key: key);

  @override
  _ExperimentState createState() => _ExperimentState();
}

class _ExperimentState extends State<Experiment> {

  DateTime te(DateTime d)
  {
    return d.add(Duration(minutes: 50));
  }

  DateTime le(DateTime d)
  {
    return d.add(Duration(hours : 1,minutes: 40));
  }

  DateTime ad(DateTime dt, int d)
  {
    return dt.add(Duration(days: d));
  }

  Future<void> addUser() async {
    CollectionReference timeSlots = FirebaseFirestore.instance.collection(
        'ClassTimeSlot');

    // DateFormat("yyyy-MM-dd - kk:mm").format(ad(t1,4))
    // Call the user's CollectionReference to add a new user
    // return timeSlots
    //     .add({
    //   'Block' : 'AB1',
    //   'ClassNo' : '608',
    //   'StartDayTime': DateFormat("yyyy-MM-dd - kk:mm").format(ad(t2,2)),
    //   'EndDayTime' : DateFormat("yyyy-MM-dd - kk:mm").format(ad(te(t2),2)),
    // })
    //     .then((value) => print("Added"))
    //     .catchError((error) => print("Failed to add user: $error"));

    // await FirebaseFirestore.instance.collection('ClassTimeSlot')
    //     .add({
    //     'Block' : 'AB1',
    //     'ClassNo' : '212',
    //     'StartDayTime' : DateFormat("yyyy-MM-dd - kk:mm").format(ad(l2,2)),
    //     'EndDayTime' : DateFormat("yyyy-MM-dd - kk:mm").format(ad(le(l2),2)),
    // })
    //     .then((value) => print("User Added"))
    //     .catchError((error) => print("Failed to add user: $error"));

    // await FirebaseFirestore.instance
    //     .collection('ClassTimeSlot')
    //     .where('EndDayTime', isEqualTo: '2021-05-19 - 11:35')
    //     .where('StartDayTime', isEqualTo: '2021-05-19 - 10:45')
    //     .get()
    //     .then((QuerySnapshot querySnapshot) {
    //   querySnapshot.docs.forEach((doc) {
    //     print("Found");
    //   });
    // });

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String regno;
    await FirebaseFirestore.instance
        .collection('Student')
        .where('Email',
        isEqualTo:
        prefs.getString('email'))
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        regno = doc['Regno'];
      });
    });

    List<String> regslots = [];
    List<TimeSlot> tsl = [];

    List<DashBoardClass> dbc = [];

    await FirebaseFirestore.instance
        .collection('StudentCourses')
        .where('Regno', isEqualTo: regno)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        dbc.add(DashBoardClass(
            facid: doc['FacultyID'],
            courseID: doc['CourseID'],
            courseName: doc['CourseName'],
            classType: doc['Type'] == 'Theory' ? ClassType.Theory : ClassType
                .Lab
        ));
      });
    });

    print("Reg courses");
    dbc.forEach((element) {
      print("${element.courseName} ${element.courseID} with ${element.facid}");
    });

    for (int i = 0; i < dbc.length; i++)
      {
      await FirebaseFirestore.instance
          .collection('CoursesTimeSlot')
          .where('FacultyID', isEqualTo: dbc[i].facid)
         .where('CourseName', isEqualTo: dbc[i].courseName)
      .where('CourseID', isEqualTo: dbc[i].courseID)
      .where('Type', isEqualTo: (dbc[i].classType ==
          ClassType.Theory
          ? 'Theory'
          : 'Lab'))
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          print(doc['FacultyID']);
          tsl.add(TimeSlot(startDayTime: doc['StartDayTime'],
              endDayTime: doc['EndDayTime']));
        });
      });
  }

    print("Found ${tsl.length} timeslots");


    for ( int i=0; i<tsl.length; i++ )
    {
      await FirebaseFirestore.instance
          .collection('TimeSlot')
          .where('EndDayTime', isEqualTo: tsl[i].endDayTime)
          .where('StartDayTime', isEqualTo: tsl[i].startDayTime)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          regslots.add(doc['Slot']);
        });
      });
    }

    print("Already reg slots");
    regslots.forEach((element) { print(element);});

  }

  @override
  Widget build(BuildContext context) {

    return Center(
      child: ElevatedButton(
        onPressed: addUser,
        child: Text(
          "Add",
        ),
      ),
    );
  }
}

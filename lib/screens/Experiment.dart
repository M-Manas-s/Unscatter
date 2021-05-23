import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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

  Future<void> addUser() {
    CollectionReference timeSlots = FirebaseFirestore.instance.collection('Courses');

    // DateFormat("yyyy-MM-dd - kk:mm").format(ad(t1,4))
    // Call the user's CollectionReference to add a new user
    return timeSlots
        .add({
      'Block' : 'AB1',
      'ClassNo' : '209',
      'StartDayTime': DateFormat("yyyy-MM-dd - kk:mm").format(ad(l2,0)),
      'EndDayTime' : DateFormat("yyyy-MM-dd - kk:mm").format(ad(le(l2),0)),
    })
        .then((value) => print("Added"))
        .catchError((error) => print("Failed to add user: $error"));
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

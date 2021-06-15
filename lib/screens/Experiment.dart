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

  Future<void> addUser() async{
    CollectionReference timeSlots = FirebaseFirestore.instance.collection('ClassTimeSlot');

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

    await FirebaseFirestore.instance
        .collection('ClassTimeSlot')
        .where('EndDayTime', isEqualTo: '2021-05-19 - 11:35')
        .where('StartDayTime', isEqualTo: '2021-05-19 - 10:45')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print("Found");
      });
    });

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

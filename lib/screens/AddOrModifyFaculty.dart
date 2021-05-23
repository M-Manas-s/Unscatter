import 'package:flutter/material.dart';
import 'package:unscatter/classes/Lecture.dart';
import 'package:unscatter/components/CustomCard.dart';
import 'package:unscatter/components/ScheduleInfoCard.dart';
import 'package:unscatter/constants/constants.dart';
import 'package:unscatter/screens/Dashboard.dart';
import 'package:weekday_selector/weekday_selector.dart';
import 'package:unscatter/constants/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unscatter/classes/Faculty.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddOrModifyFaculty extends StatefulWidget {
  static String id = 'AddOrModifyFaculty';

  @override
  _AddOrModifyFacultyState createState() => _AddOrModifyFacultyState();
}

class _AddOrModifyFacultyState extends State<AddOrModifyFaculty>
    with TickerProviderStateMixin {
  String name;
  bool collapse;
  ClassType classType;
  String error;
  bool slotsLoaded;
  bool slotsSelected;
  List<String> list = [];
  List<TimeSlot> slotList = [];
  SharedPreferences prefs;
  TimeOfDay lastUsed;

  void sp() async {
    prefs = await SharedPreferences.getInstance();
  }

  void navigateBack(BuildContext context) {
    Size query = MediaQuery.of(context).size;

    // set up the button
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              backgroundColor: Colors.transparent,
              //insetPadding: EdgeInsets.all(10),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color(0xFF0A0E23)),
                    margin: EdgeInsets.fromLTRB(
                        0, query.height * 0.28, 0, query.height * 0.28),
                    padding: EdgeInsets.only(top: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Anim(),Text("Added!",
                              style: TextStyle(
                                  fontSize: 20
                              ),),
                          ],
                        ),

                        GestureDetector(
                            onPanDown: (x) {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Dashboard()
                                  ),
                                  ModalRoute.withName(Dashboard.id)
                              );
                            },
                            child: CustomCard(
                                margin: EdgeInsets.all(0),
                                radius: 10,
                                child: Center(child: Text("Dashboard", style: TextStyle(fontSize: 18))),
                                color: Theme.of(context).accentColor)),
                      ],
                    ),
                  ),
                ],
              ));
        });
  }

  @override
  void initState() {
    sp();
    classType = ClassType.Theory;
    lastUsed = TimeOfDay(hour: 8, minute: 0);
    collapse = false;
    slotsLoaded = false;
    slotsSelected = false;
    name = "";
    super.initState();
  }

  Future<void> loadSlotList(String slot) async {
    await FirebaseFirestore.instance
        .collection('TimeSlot')
        .where('Slot', isEqualTo: slot)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        TimeSlot tts = TimeSlot();
        tts.startDayTime = doc['StartDayTime'];
        tts.endDayTime = doc['EndDayTime'];
        slotList.add(tts);
      });
    });
  }

  void validateName() {
    String pattern = r'^\w{1,5} \w{1,5}$';
    RegExp regExp = new RegExp(pattern);
    if (!regExp.hasMatch(name))
      error = "Please follow \"CourseName CourseCode\"- Max. 5 characters each";
    else
      error = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 8,
        title: Text("Unscatter", style: kAppBarTitleStyle),
        centerTitle: true,
      ),
      body: Center(
        child: Column(children: [
          Expanded(
            flex: 10,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 16),
              child: ListView(
                children: [
                  CustomCard(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: !collapse ? 20 : 10),
                      child: Column(
                        children: [
                          !collapse
                              ? Center(
                                  child: Text("Course",
                                      style: TextStyle(
                                        fontSize: 22,
                                      )),
                                )
                              : Container(),
                          SizedBox(height: !collapse ? 15 : 0),
                          TextField(
                            enabled: !slotsLoaded,
                            onTap: () {
                              setState(() {
                                collapse = false;
                              });
                            },
                            onChanged: (value) {
                              name = value;
                              if (name.length > 0)
                                collapse = true;
                              else
                                collapse = false;
                              validateName();
                            },
                            onSubmitted: (value) => setState(() {
                              if (name.length > 0) collapse = true;
                              validateName();
                            }),
                            textCapitalization: TextCapitalization.characters,
                            textAlign: TextAlign.center,
                            style: !collapse
                                ? TextStyle(
                                    fontSize: 20,
                                    letterSpacing: 1,
                                  )
                                : kAppBarTitleStyle.copyWith(
                                    letterSpacing: 2,
                                    fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              border: !collapse
                                  ? UnderlineInputBorder()
                                  : InputBorder.none,
                              enabledBorder: !collapse
                                  ? null
                                  : UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(
                                              0xFF282B4E)), //Color(0xff4b68ef)),
                                    ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF3edbf0)),
                              ),
                              hintText: collapse ? name : 'CSE 1001',
                              hintStyle: collapse
                                  ? kAppBarTitleStyle.copyWith(
                                      color: Colors.white,
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.bold)
                                  : null,
                              errorText: error,
                              errorMaxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onPanDown: (panDownDetails) {
                            FocusScope.of(context).unfocus();
                            if (!slotsLoaded)
                              setState(() {
                                classType = ClassType.Theory;
                                error = null;
                              });
                          },
                          child: CustomCard(
                            //radius: 20,
                            child: Text(
                              "Theory",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w400),
                            ),
                            color: classType == ClassType.Theory
                                ? Theme.of(context).accentColor
                                : Color(0xFF282B4E),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onPanDown: (panDownDetails) {
                            FocusScope.of(context).unfocus();
                            if (!slotsLoaded)
                              setState(() {
                                classType = ClassType.Lab;
                                error = null;
                              });
                          },
                          child: CustomCard(
                            //radius: 20,
                            child: Text(
                              "Lab",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w400),
                            ),
                            color: classType == ClassType.Lab
                                ? Theme.of(context).accentColor
                                : Color(0xFF282B4E),
                          ),
                        ),
                      ),
                    ],
                  ),
                  !slotsLoaded
                      ? CustomCard(
                          color: Colors.indigo,
                          margin: EdgeInsets.all(0),
                          padding: EdgeInsets.all(0),
                          child: TextButton(
                            child: Text(
                              'CHOOSE SLOT',
                              style: TextStyle(
                                  fontSize: 17,
                                  letterSpacing: 3,
                                  color: Colors.white),
                            ),
                            onPressed: error == null && name != ""
                                ? () async {
                                    bool found = true;

                                    await FirebaseFirestore.instance
                                        .collection('Courses')
                                        .where('CourseName',
                                            isEqualTo: name.split(' ')[0])
                                        .where('CourseID',
                                            isEqualTo: name.split(' ')[1])
                                        .where('Type',
                                            isEqualTo:
                                                (classType == ClassType.Theory
                                                    ? 'Theory'
                                                    : 'Lab'))
                                        .get()
                                        .then((QuerySnapshot querySnapshot) {
                                      if (querySnapshot.size == 0) {
                                        setState(() {
                                          found = false;
                                          error = "Course Not Found";
                                        });
                                      }
                                    });

                                    String facid;
                                    await FirebaseFirestore.instance
                                        .collection('Faculty')
                                        .where('Email',
                                            isEqualTo: prefs.getString('email'))
                                        .get()
                                        .then((QuerySnapshot querySnapshot) {
                                      querySnapshot.docs.forEach((doc) {
                                        facid = doc['FacultyID'];
                                      });
                                    });

                                    await FirebaseFirestore.instance
                                        .collection('FacultyCourses')
                                        .where('CourseName',
                                            isEqualTo: name.split(' ')[0])
                                        .where('CourseID',
                                            isEqualTo: name.split(' ')[1])
                                        .where('Type',
                                            isEqualTo:
                                                (classType == ClassType.Theory
                                                    ? 'Theory'
                                                    : 'Lab'))
                                        .where('FacultyID', isEqualTo: facid)
                                        .get()
                                        .then((QuerySnapshot querySnapshot) {
                                      if (querySnapshot.size != 0) {
                                        setState(() {
                                          found = false;
                                          error = "Already Registered";
                                        });
                                      }
                                    });

                                    if (!found) return;

                                    await FirebaseFirestore.instance
                                        .collection('TimeSlot')
                                        .get()
                                        .then((QuerySnapshot querySnapshot) {
                                      querySnapshot.docs.forEach((doc) {
                                        if (!list.contains(doc['Slot'])) {
                                          if (classType == ClassType.Theory &&
                                              doc['Slot'][0] != 'L')
                                            list.add(doc['Slot']);
                                          else if (classType == ClassType.Lab &&
                                              doc['Slot'][0] == 'L')
                                            list.add(doc['Slot']);
                                        }
                                      });
                                    });

                                    setState(() {
                                      if (list.length == 0)
                                        error = "Course Not Found";
                                      else
                                        slotsLoaded = true;
                                    });
                                  }
                                : () {},
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTapCancel: () async {
                                String slotSel = list[index];
                                if (!slotsSelected) {
                                  list.clear();
                                  list.add("Slot: " + slotSel);
                                  await loadSlotList(slotSel);
                                  setState(() {
                                    slotsSelected = true;
                                  });
                                }
                              },
                              child: CustomCard(
                                color: !slotsSelected
                                    ? Colors.indigo
                                    : Color(0xFF282B4E),
                                margin: EdgeInsets.all(0),
                                child: Text(list[index],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 20)),
                              ),
                            );
                          },
                        ),
                  slotsSelected
                      ? Column(
                          children: slotList
                              .map((e) =>
                                  ScheduleInfoCard(ts: e, type: classType))
                              .toList(),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.07,
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context)
                  .accentColor
                  .withOpacity(slotsSelected ? 1.0 : 0.3),
              child: GestureDetector(
                onPanDown: slotsSelected
                    ? (var x) async {
                        String facid;
                        await FirebaseFirestore.instance
                            .collection('Faculty')
                            .where('Email', isEqualTo: prefs.getString('email'))
                            .get()
                            .then((QuerySnapshot querySnapshot) {
                          querySnapshot.docs.forEach((doc) {
                            facid = doc['FacultyID'];
                          });
                        });

                        await FirebaseFirestore.instance.collection('FacultyCourses')
                            .add({
                          'FacultyID': facid, // John Doe
                          'CourseName': name.split(' ')[0], // Stokes and Sons
                          'CourseID': name.split(' ')[1] ,
                          'Type' : (classType == ClassType.Theory
                              ? 'Theory'
                              : 'Lab'),// 42
                        })
                            .then((value) => print("User Added"))
                            .catchError((error) => print("Failed to add user: $error"));

                        String sdt;
                        String edt;
                        await FirebaseFirestore.instance
                            .collection('CoursesTimeSlot')
                            .where('CourseName', isEqualTo: name.split(' ')[0])
                            .where('CourseID', isEqualTo: name.split(' ')[1])
                            .where('Type', isEqualTo: ( classType== ClassType.Theory ? 'Theory' : 'Lab') )
                            .get()
                            .then((QuerySnapshot querySnapshot) {
                          querySnapshot.docs.forEach((doc) {
                            sdt = doc['StartDayTime'];
                            edt = doc['EndDayTime'];

                          });
                        });

                        String bno;
                        String cno;

                        await FirebaseFirestore.instance
                            .collection('ClassTimeSlot')
                            .where('EndDayTime', isEqualTo: edt)
                            .where('StartDayTime', isEqualTo: sdt)
                            .get()
                            .then((QuerySnapshot querySnapshot) {
                          querySnapshot.docs.forEach((doc) async {
                            cno = doc['ClassNo'];
                            bno = doc['Block'];
                          });
                        });

                        await FirebaseFirestore.instance.collection('FacultyClasses')
                            .add({
                          'FacultyID': facid, // John Doe
                          'ClassNo': cno, // Stokes and Sons
                          'Block': bno ,
                        })
                            .then((value) => print("User Added"))
                            .catchError((error) => print("Failed to add user: $error"));
                        navigateBack(context);
                      }
                    : (var x) {},
                child: Container(
                  child: Center(
                    child: Text(
                      "ADD",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 25,
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}

class Anim extends StatefulWidget {
  const Anim({Key key}) : super(key: key);

  @override
  _AnimState createState() => _AnimState();
}

class _AnimState extends State<Anim> with TickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    _animationController.animateTo(20000.0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedIcon(
            progress: _animationController,
            icon: AnimatedIcons.add_event,
      size: 145,
      );
  }
}


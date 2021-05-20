import 'package:flutter/material.dart';
import 'package:unscatter/classes/Course.dart';
import 'package:unscatter/classes/Lecture.dart';
import 'package:unscatter/components/CustomCard.dart';
import 'package:unscatter/components/ScheduleInfoCard.dart';
import 'package:unscatter/constants/constants.dart';
import 'package:weekday_selector/weekday_selector.dart';
import 'package:unscatter/constants/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unscatter/classes/Faculty.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddOrModify extends StatefulWidget {
  static String id = 'AddOrModify';

  @override
  _AddOrModifyState createState() => _AddOrModifyState();
}

class _AddOrModifyState extends State<AddOrModify> {
  String name;
  bool collapse;
  ClassType classType;
  String error;
  bool facultyLoaded;
  bool facultySelected;
  List<Faculty> list = List.empty(growable: true);
  SharedPreferences prefs;
  TimeOfDay lastUsed;

  void sp() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    sp();
    classType = ClassType.Theory;
    lastUsed = TimeOfDay(hour: 8, minute: 0);
    collapse = false;
    facultyLoaded = false;
    facultySelected = false;
    name = "";
    super.initState();
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
                            enabled: !facultyLoaded,
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
                              border: UnderlineInputBorder(),
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
                              hintText: 'CSE 1001',
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
                            if ( !facultyLoaded )
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
                            color:  classType == ClassType.Theory
                                ? Theme
                                .of(context)
                                .accentColor
                                : Color(0xFF282B4E),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onPanDown: (panDownDetails) {
                            FocusScope.of(context).unfocus();
                            if ( !facultyLoaded )
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
                            color:  classType == ClassType.Lab
                                ? Theme
                                .of(context)
                                .accentColor
                                : Color(0xFF282B4E),
                          ),
                        ),
                      ),
                    ],
                  ),

                  CustomCard(
                    child: Center(
                      child: !facultyLoaded
                          ? TextButton(
                              child: Text(
                                'CHOOSE FACULTY',
                                style: TextStyle(
                                    fontSize: 17,
                                    letterSpacing: 3,
                                    color: Colors.white),
                              ),
                              onPressed: error==null ? () async {
                                await FirebaseFirestore.instance
                                    .collection('FacultyCourses')
                                    .where('CourseName', isEqualTo: name.split(' ')[0])
                                .where('CourseID', isEqualTo: name.split(' ')[1])
                                .where('Type', isEqualTo: ( classType== ClassType.Theory ? 'Theory' : 'Lab') )
                                    .get()
                                    .then((QuerySnapshot querySnapshot) {
                                  querySnapshot.docs.forEach((doc) {
                                    print(doc["FacultyID"]);
                                    Faculty f = Faculty(
                                        name: " ", ID: doc["FacultyID"]);
                                    list.add(f);
                                  });
                                });

                                await FirebaseFirestore.instance
                                    .collection('CoursesTimeSlot')
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
                                  querySnapshot.docs.forEach((doc) async {
                                    print(doc['StartDayTime']);
                                    await FirebaseFirestore.instance
                                        .collection('TimeSlot')
                                        .where('StartDayTime', isEqualTo: doc['StartDayTime'])
                                        .where('EndDayTime', isEqualTo: doc['EndDayTime'])
                                        .get()
                                        .then((QuerySnapshot querySnapshot2) {
                                      querySnapshot2.docs.forEach((doc2) {
                                        list.forEach((element) {
                                          int ind = list.indexWhere(
                                                  (x) => x.ID == element.ID);
                                          list[ind]
                                              .slot = doc2["Slot"];
                                        });
                                      });
                                    });
                                  });
                                });

                                list.forEach((element) async {
                                  await FirebaseFirestore.instance
                                      .collection('Faculty')
                                      .where('FacultyID', isEqualTo: element.ID)
                                      .get()
                                      .then((QuerySnapshot querySnapshot) {
                                    querySnapshot.docs.forEach((doc) {
                                      int ind = list.indexWhere(
                                      (x) => x.ID == element.ID);
                                      list[ind]
                                          .name = doc["Name"];

                                      if ( ind == list.length-1 )
                                        setState(() {
                                          facultyLoaded = true;
                                        });
                                    });
                                  });
                                });

                                if (  list.length == 0 )
                                  setState(() {
                                    error = "No Faculty Found";
                                  });

                              }: (){},
                            )
                          : ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: list.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onPanDown: (x) {
                                    String ID = list[index].ID;
                                    if ( !facultySelected )
                                      {
                                        list.forEach((element) {
                                          if ( element.ID!=ID )
                                            list.remove(element);
                                        });
                                        setState(() {
                                          facultySelected = true;
                                        });
                                      }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                                    child: Text("Prof. " +
                                        list[index].name + "\n${list[index].slot}" ,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20
                                    )),
                                  ),
                                );
                              },
                            ),
                    ),
                    color: facultySelected ? Color(0xFF282B4E) : Colors.indigo,
                    padding: EdgeInsets.symmetric(vertical: 0),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.07,
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).accentColor.withOpacity(facultySelected?1.0:0.3),
              child: GestureDetector(
                onPanDown: facultySelected ? (var x) async{
                  String regno;
                  await FirebaseFirestore.instance
                      .collection('Student')
                      .where('Email', isEqualTo: prefs.getString('email'))
                      .get()
                      .then((QuerySnapshot querySnapshot) {
                    querySnapshot.docs.forEach((doc) {
                      regno = doc['Regno'];
                    });
                  });

                    FirebaseFirestore.instance.collection('StudentCourses')
                        .add({
                      'Regno': regno, // John Doe
                      'CourseName': name.split(' ')[0], // Stokes and Sons
                      'CourseID': name.split(' ')[1] ,
                      'Type' : (classType == ClassType.Theory
                          ? 'Theory'
                          : 'Lab'),// 42
                    })
                        .then((value) => print("User Added"))
                        .catchError((error) => print("Failed to add user: $error"));
                } : (var x){},
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
          )
        ]),
      ),
    );
  }
}

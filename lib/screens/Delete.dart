import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unscatter/classes/DashBoardClass.dart';
import 'package:unscatter/classes/TimeSlot.dart';
import 'package:unscatter/components/CustomCard.dart';
import 'package:unscatter/constants/constants.dart';
import 'package:unscatter/constants/enums.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:unscatter/screens/Dashboard.dart';

class Delete extends StatefulWidget {
  static String id = 'Delete';

  @override
  _DeleteState createState() => _DeleteState();
}

class _DeleteState extends State<Delete> {

  List<DashBoardClass> dispList = [];
  List<int> selInd = [];
  SharedPreferences prefs;
  bool spinner;

  void loadDB() async {
    prefs = await SharedPreferences.getInstance();
    readDB(prefs.getString('user'));
  }

  void navigateBack(BuildContext context) {
    Size query = MediaQuery
        .of(context)
        .size;

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
                            Anim(), Text("Removed!",
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
                                child: Center(child: Text("Dashboard",
                                    style: TextStyle(fontSize: 18))),
                                color: Theme
                                    .of(context)
                                    .accentColor)),
                      ],
                    ),
                  ),
                ],
              ));
        });
  }

  void readDB(String user) async {
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
            .collection('FacultyCourses')
            .where('FacultyID', isEqualTo: facid)
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            dispList.add(new DashBoardClass(
              courseName: doc['CourseName'],
              courseID: doc['CourseID'],
              facultyName: fname,
              facid: facid,
              classType:
                  doc['Type'] == 'Theory' ? ClassType.Theory : ClassType.Lab,
            ));
          });
        });

        for (int i = 0; i < dispList.length; i++) {
          await FirebaseFirestore.instance
              .collection('CoursesTimeSlot')
              .where('FacultyID', isEqualTo: facid)
              .where('CourseName', isEqualTo: dispList[i].courseName)
              .where('CourseID', isEqualTo: dispList[i].courseID)
              .where('Type',
                  isEqualTo: dispList[i].classType.toString().split('.')[1])
              .get()
              .then((QuerySnapshot querySnapshot) {
            querySnapshot.docs.forEach((doc) {
              TimeSlot ts = TimeSlot(
                  startDayTime: doc['StartDayTime'],
                  endDayTime: doc['EndDayTime']);
              dispList[i].ts = ts;
            });
          });

          await FirebaseFirestore.instance
              .collection('TimeSlot')
              .where('StartDayTime', isEqualTo: dispList[i].ts.startDayTime)
              .where('EndDayTime', isEqualTo: dispList[i].ts.endDayTime)
              .get()
              .then((QuerySnapshot querySnapshot) {
            querySnapshot.docs.forEach((doc) {
              dispList[i].time = doc['Slot'];
            });
          });
        }
        break;

      case 'Student' :

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

        await FirebaseFirestore.instance
            .collection('StudentCourses')
            .where('Regno', isEqualTo: regno)
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            dispList.add(new DashBoardClass(
              courseName: doc['CourseName'],
              courseID: doc['CourseID'],
              facid: doc['FacultyID'],
              classType:
              doc['Type'] == 'Theory' ? ClassType.Theory : ClassType.Lab,
            ));
          });
        });

        for (int i = 0; i < dispList.length; i++) {
          await FirebaseFirestore.instance
              .collection('CoursesTimeSlot')
              .where('FacultyID', isEqualTo: dispList[i].facid)
              .where('CourseName', isEqualTo: dispList[i].courseName)
              .where('CourseID', isEqualTo: dispList[i].courseID)
              .where('Type',
              isEqualTo: dispList[i].classType.toString().split('.')[1])
              .get()
              .then((QuerySnapshot querySnapshot) {
            querySnapshot.docs.forEach((doc) {
              TimeSlot ts = TimeSlot(
                  startDayTime: doc['StartDayTime'],
                  endDayTime: doc['EndDayTime']);
              dispList[i].ts = ts;
            });
          });

          await FirebaseFirestore.instance
              .collection('TimeSlot')
              .where('StartDayTime', isEqualTo: dispList[i].ts.startDayTime)
              .where('EndDayTime', isEqualTo: dispList[i].ts.endDayTime)
              .get()
              .then((QuerySnapshot querySnapshot) {
            querySnapshot.docs.forEach((doc) {
              dispList[i].time = doc['Slot'];
            });
          });

          await FirebaseFirestore.instance
              .collection('Faculty')
              .where('FacultyID', isEqualTo: dispList[i].facid)
              .get()
              .then((QuerySnapshot querySnapshot) {
            querySnapshot.docs.forEach((doc) {
              dispList[i].facultyName = doc['Name'];
            });
          });
        }
        break;
    }
    setState(() {
      spinner = false;
    });
  }

  @override
  void initState() {
    spinner = true;
    loadDB();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 8,
        title: Text("Unscatter", style: kAppBarTitleStyle),
        centerTitle: true,
      ),
      body: ModalProgressHUD(
        progressIndicator: SpinKitChasingDots(
          color: Theme.of(context).accentColor,
          size: 30.0,
        ),
        inAsyncCall: spinner,
        child: Column(
          children: [
            Expanded(
              flex: 10,
              child: Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: dispList.length==0 ? MainAxisAlignment.center : MainAxisAlignment.start,
                    children: [
                      dispList.length!=0 ? Text(
                        "Select Courses to delete",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ) : Container(),
                      SizedBox(height: 15),
                      dispList.length != 0 ? ListView.builder(
                        physics: ScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: dispList.length,
                        itemBuilder: (context, i) {
                          return Container(
                            //margin: EdgeInsets.symmetric(vertical: 5),
                            color: selInd.contains(i)
                                ? Colors.blueAccent
                                : Colors.transparent,
                            child: GestureDetector(
                              onPanDown: (var x) {
                                setState(() {
                                  if (!selInd.contains(i))
                                    selInd.add(i);
                                  else
                                    selInd.remove(i);
                                });
                              },
                              child: CustomCard(
                                color: Color(0xFF282B4E),
                                margin: EdgeInsets.all(0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 7,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                              "${dispList[i].courseName} ${dispList[i].courseID}",
                                              style: kCourseNameDB.copyWith(
                                                letterSpacing: 2,
                                              ),
                                            ),
                                              Text(
                                              "   ( ${dispList[i].time} Slot )",
                                              style: TextStyle(fontSize: 17),
                                            ),
                                            ]
                                          ),
                                          SizedBox(height: 2),
                                          Text("Prof. " + dispList[i].facultyName, style: kTimeDB),
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
                                            onPressed: () {},
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty
                                                      .resolveWith<Color>(
                                                (Set<MaterialState> states) {
                                                  if (states.contains(
                                                      MaterialState.pressed))
                                                    return Theme.of(context)
                                                        .accentColor;
                                                  return dispList[i]
                                                              .specialClass !=
                                                          SpecialClass.Extra
                                                      ? Theme.of(context)
                                                          .accentColor
                                                      : Color(
                                                          0xFF282B4E); // Use the component's default.
                                                },
                                              ),
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              18.0),
                                                      side: BorderSide(
                                                          color: Colors.red))),
                                            ),
                                            child: Text(
                                              dispList[i].classType ==
                                                      ClassType.Theory
                                                  ? 'T'
                                                  : 'L',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                              ),
                                            ),
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          );
                          ;
                        },
                      ) : Center(
                          child : Text("No Courses Undertaken!",
                            style: TextStyle(fontSize: 20),)
                      ),
                    ],
                  )),
            ),
            Expanded(
              flex : 1,
              child: GestureDetector(
                onPanDown: selInd.length>0 ? (var x) async{
                  setState(() {
                    spinner=true;
                  });
                  switch(prefs.getString('user')) {

                    case 'Student' :

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

                      for (int i = 0; i < selInd.length; i++) {
                        String cname = dispList[selInd[i]].courseName;
                        String cid = dispList[selInd[i]].courseID;
                        String type = dispList[selInd[i]].classType.toString()
                            .split('.')[1];

                        await FirebaseFirestore.instance
                            .collection("StudentCourses")
                            .where('Regno', isEqualTo: regno)
                            .where('CourseID', isEqualTo: cid)
                            .where('Type', isEqualTo: type)
                            .where('CourseName', isEqualTo: cname)
                            .get().then((value) {
                          value.docs.forEach((element) {
                            FirebaseFirestore.instance.collection("StudentCourses")
                                .doc(element.id)
                                .delete();
                          });
                        });
                      }
                      break;

                  //Student -> StudentCourses
                  //Faculty -> StudentCourses, FacultyCourses, CoursesTimeslot, FacultyClasses

                    case 'Faculty' :

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

                      for (int i = 0; i < selInd.length; i++) {
                        String cname = dispList[selInd[i]].courseName;
                        String cid = dispList[selInd[i]].courseID;
                        String type = dispList[selInd[i]].classType.toString()
                            .split('.')[1];

                        await FirebaseFirestore.instance
                            .collection("StudentCourses")
                            .where('FacultyID', isEqualTo: facid)
                            .where('CourseID', isEqualTo: cid)
                            .where('Type', isEqualTo: type)
                            .where('CourseName', isEqualTo: cname)
                            .get().then((value) {
                          value.docs.forEach((element) {
                            FirebaseFirestore.instance.collection("StudentCourses")
                                .doc(element.id)
                                .delete();
                          });
                        });

                        await FirebaseFirestore.instance
                            .collection("FacultyCourses")
                            .where('FacultyID', isEqualTo: facid)
                            .where('CourseID', isEqualTo: cid)
                            .where('Type', isEqualTo: type)
                            .where('CourseName', isEqualTo: cname)
                            .get().then((value) {
                          value.docs.forEach((element) {
                            FirebaseFirestore.instance.collection("FacultyCourses")
                                .doc(element.id)
                                .delete();
                          });
                        });

                        await FirebaseFirestore.instance
                            .collection("CoursesTimeSlot")
                            .where('FacultyID', isEqualTo: facid)
                            .where('CourseID', isEqualTo: cid)
                            .where('Type', isEqualTo: type)
                            .where('CourseName', isEqualTo: cname)
                            .get().then((QuerySnapshot querySnapshot) {
                          querySnapshot.docs.forEach((doc) {

                            TimeSlot ts = TimeSlot(endDayTime:  doc['EndDayTime'], startDayTime:  doc['StartDayTime']);

                            FirebaseFirestore.instance
                                .collection("ClassTimeSlot")
                                .where('EndDayTime', isEqualTo: ts.endDayTime)
                                .where('StartDayTime', isEqualTo: ts.startDayTime)
                                .get().then((QuerySnapshot querySnapshot2) {
                              querySnapshot2.docs.forEach((doc2) {
                                String block = doc2['Block'];
                                String classno = doc2['ClassNo'];

                                FirebaseFirestore.instance
                                    .collection("FacultyClasses")
                                    .where('FacultyID', isEqualTo: facid)
                                    .where('Block', isEqualTo: block)
                                    .where('ClassNo', isEqualTo: classno)
                                    .get().then((value) {
                                  value.docs.forEach((element) {
                                    print("Found");
                                    FirebaseFirestore.instance.collection("FacultyClasses")
                                        .doc(element.id)
                                        .delete();
                                  });
                                });
                              });
                            });

                            FirebaseFirestore.instance.collection("CoursesTimeSlot")
                                .doc(doc.id)
                                .delete();
                          });
                        });

                      }

                      break;
                }
                setState(() {
                  spinner=false;
                });
                  navigateBack(context);
                      } : (var x){},
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: MediaQuery.of(context).size.width,
                  color: Theme.of(context)
                      .accentColor
                      .withOpacity(selInd.length > 0 ? 1.0 : 0.3),
                  child: Container(
                    child: Center(
                      child: Text(
                        "DELETE",
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
          ],
        ),
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
      icon: AnimatedIcons.event_add,
      size: 145,
    );
  }
}
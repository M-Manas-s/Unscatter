import 'package:flutter/material.dart';
import 'package:unscatter/classes/DashBoardClass.dart';
import 'package:unscatter/classes/TimeSlot.dart';
import 'package:unscatter/components/CustomCard.dart';
import 'package:unscatter/constants/constants.dart';
import 'package:unscatter/screens/Dashboard.dart';
import 'package:unscatter/constants/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unscatter/classes/Faculty.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
  bool spinner;

  void sp() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    sp();
    spinner=false;
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
                            Anim(),
                            Text(
                              "Added!",
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        GestureDetector(
                            onPanDown: (x) {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Dashboard()),
                                  ModalRoute.withName(Dashboard.id));
                            },
                            child: CustomCard(
                                margin: EdgeInsets.all(0),
                                radius: 10,
                                child: Center(
                                    child: Text("Dashboard",
                                        style: TextStyle(fontSize: 18))),
                                color: Theme.of(context).accentColor)),
                      ],
                    ),
                  ),
                ],
              ));
        });
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
        child: Center(
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
                              if (!facultyLoaded)
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
                              if (!facultyLoaded)
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
                    !facultyLoaded
                        ? CustomCard(
                      margin: EdgeInsets.all(0),
                      padding: EdgeInsets.all(0),
                      color: Colors.indigo,
                          child: TextButton(
                              child: Text(
                                'CHOOSE FACULTY',
                                style: TextStyle(
                                    fontSize: 17,
                                    letterSpacing: 3,
                                    color: Colors.white),
                              ),
                              onPressed: error == null && name != null
                                  ? () async {
                                bool proceed;
                                setState(() {
                                  spinner=true;
                                   proceed = true;
                                });
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

                                      await FirebaseFirestore.instance
                                          .collection('StudentCourses')
                                          .where('CourseName',
                                              isEqualTo: name.split(' ')[0])
                                          .where('CourseID',
                                              isEqualTo: name.split(' ')[1])
                                          .where('Type',
                                              isEqualTo:
                                                  (classType == ClassType.Theory
                                                      ? 'Theory'
                                                      : 'Lab'))
                                          .where('Regno', isEqualTo: regno)
                                          .get()
                                          .then((QuerySnapshot querySnapshot) {
                                        if (querySnapshot.size != 0) {
                                          setState(() {
                                            error = "Already Registered";
                                            facultyLoaded = false;
                                            proceed = false;
                                          });
                                        }
                                      });

                                      if (proceed) {

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
                                              classType: doc['Type'] == 'Theory' ? ClassType.Theory : ClassType.Lab
                                            ));
                                          });
                                        });

                                        print("Reg courses");
                                        dbc.forEach((element) { print("${element.courseName} ${element.courseID} with ${element.facid}");});

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

                                        await FirebaseFirestore.instance
                                            .collection('FacultyCourses')
                                            .where('CourseName',
                                                isEqualTo: name.split(' ')[0])
                                            .where('CourseID',
                                                isEqualTo: name.split(' ')[1])
                                            .where('Type',
                                                isEqualTo: (classType ==
                                                        ClassType.Theory
                                                    ? 'Theory'
                                                    : 'Lab'))
                                            .get()
                                            .then(
                                                (QuerySnapshot querySnapshot) {
                                          querySnapshot.docs.forEach((doc) {
                                            Faculty f =
                                                Faculty(ID: doc["FacultyID"]);
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
                                                isEqualTo: (classType ==
                                                        ClassType.Theory
                                                    ? 'Theory'
                                                    : 'Lab'))
                                            .get()
                                            .then(
                                                (QuerySnapshot querySnapshot) {
                                          querySnapshot.docs
                                              .forEach((doc) async {
                                            await FirebaseFirestore.instance
                                                .collection('TimeSlot')
                                                .where('StartDayTime',
                                                    isEqualTo:
                                                        doc['StartDayTime'])
                                                .where('EndDayTime',
                                                    isEqualTo:
                                                        doc['EndDayTime'])
                                                .get()
                                                .then((QuerySnapshot
                                                    querySnapshot2) {
                                              querySnapshot2.docs
                                                  .forEach((doc2) {
                                                list.forEach((element) {
                                                  int ind = list.indexWhere(
                                                      (x) =>
                                                          x.ID == element.ID);
                                                  list[ind].slot = doc2["Slot"];
                                                });
                                              });
                                            });
                                          });
                                        });

                                        list.forEach((element) async {
                                          await FirebaseFirestore.instance
                                              .collection('Faculty')
                                              .where('FacultyID',
                                                  isEqualTo: element.ID)
                                              .get()
                                              .then((QuerySnapshot
                                                  querySnapshot) {
                                            querySnapshot.docs.forEach((doc) {
                                              int ind = list.indexWhere(
                                                  (x) => x.ID == element.ID);
                                              list[ind].name = doc["Name"];

                                              if (ind == list.length - 1)
                                                setState(() {
                                                  facultyLoaded = true;
                                                });
                                            });
                                          });
                                        });

                                        for ( int i=0; i<regslots.length; i++ )
                                          {
                                            for ( int j=0; j<list.length; j++ )
                                                if ( list[j].slot == regslots[i] )
                                                  {
                                                    list.removeAt(j);
                                                    break;
                                                  }
                                          }

                                        if (list.length == 0)
                                          setState(() {
                                            error = "No Faculty Found";
                                          });
                                      }
                                    setState(() {
                                      spinner=false;
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
                                onPanDown: (x) {
                                  Faculty sel = list[index];
                                  if (!facultySelected) {
                                    list.clear();
                                    list.add(sel);
                                    setState(() {
                                      facultySelected = true;
                                    });
                                  }
                                },
                                child: CustomCard(
                                  color: !facultySelected
                                      ? Colors.indigo
                                      : Color(0xFF282B4E),
                                  margin: EdgeInsets.all(0),
                                  child: Text(
                                      "Prof. " +
                                          list[index].name +
                                          "\n${list[index].slot}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 20)),
                                ),
                              );
                            },
                          )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: GestureDetector(
                onPanDown: facultySelected
                    ? (var x) async {
                  String regno;
                  setState(() {
                    spinner=true;
                  });
                  await FirebaseFirestore.instance
                      .collection('Student')
                      .where('Email', isEqualTo: prefs.getString('email'))
                      .get()
                      .then((QuerySnapshot querySnapshot) {
                    querySnapshot.docs.forEach((doc) {
                      regno = doc['Regno'];
                    });
                  });

                  FirebaseFirestore.instance
                      .collection('StudentCourses')
                      .add({
                    'Regno': regno, // John Doe
                    'CourseName':
                    name.split(' ')[0], // Stokes and Sons
                    'CourseID': name.split(' ')[1],
                    'Type': (classType == ClassType.Theory
                        ? 'Theory'
                        : 'Lab'), // 42
                    'FacultyID': list[0].ID,
                  })
                      .then((value) => print("User Added"))
                      .catchError(
                          (error) => print("Failed to add user: $error"));
                  setState(() {
                    spinner=false;
                  });
                  navigateBack(context);
                }
                    : (var x) {},
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: MediaQuery.of(context).size.width,
                  color: Theme.of(context)
                      .accentColor
                      .withOpacity(facultySelected ? 1.0 : 0.3),
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

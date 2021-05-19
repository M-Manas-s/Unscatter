import 'package:flutter/material.dart';
import 'package:unscatter/classes/Course.dart';
import 'package:unscatter/classes/Lecture.dart';
import 'package:unscatter/components/CustomCard.dart';
import 'package:unscatter/components/ScheduleInfoCard.dart';
import 'package:unscatter/constants/constants.dart';
import 'package:weekday_selector/weekday_selector.dart';
import 'package:unscatter/constants/enums.dart';

class AddOrModify extends StatefulWidget {
  static String id = 'AddOrModify';

  @override
  _AddOrModifyState createState() => _AddOrModifyState();
}

class _AddOrModifyState extends State<AddOrModify> {
  String name;
  Frequency frequency;
  bool collapse;
  String error;
  Lecture currentLecture;
  Course _course;
  TimeOfDay lastUsed;
  List<Lecture> leclist = List.empty(growable: true);

  @override
  void initState() {
    _course = Course();
    lastUsed = TimeOfDay(hour: 8, minute: 0);
    collapse = false;
    name = "";
    frequency = Frequency.Weekly;
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
                  CustomCard(
                    child: Center(
                      child: Text(
                        'CHOOSE FACULTY',
                        style: TextStyle(fontSize: 17, letterSpacing: 3),
                      ),
                    ),
                    color: Colors.indigo,
                    padding: EdgeInsets.symmetric(vertical: 10),
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
              color: Theme.of(context).accentColor,
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
          )
        ]),
      ),
    );
  }
}

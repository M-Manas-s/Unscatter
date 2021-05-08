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

  Future<void> _displayWeekDayDialog(BuildContext context) async {
    final values = List.filled(7, true);
    Size query = MediaQuery
        .of(context)
        .size;
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.all(10),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xFF0A0E23)
                    ),
                    margin: EdgeInsets.fromLTRB(
                        0, query.height * 0.35, 0, query.height * 0.35),
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Pick a Day",
                            style: TextStyle(fontSize: 24),
                            textAlign: TextAlign.center
                        ),
                        WeekdaySelector(
                          selectedFillColor: Colors.indigo,
                          onChanged: (v) {
                            print(v);
                            setState(() {
                              switch (v) {
                                case 1 :
                                  currentLecture.weekday = WeekDay.Monday;
                                  break;
                                case 2 :
                                  currentLecture.weekday = WeekDay.Tueday;
                                  break;
                                case 3 :
                                  currentLecture.weekday = WeekDay.Wednesday;
                                  break;
                                case 4 :
                                  currentLecture.weekday = WeekDay.Thursday;
                                  break;
                                case 5 :
                                  currentLecture.weekday = WeekDay.Friday;
                                  break;
                                case 6 :
                                  currentLecture.weekday = WeekDay.Saturday;
                                  break;
                                case 7 :
                                  currentLecture.weekday = WeekDay.Sunday;
                                  break;
                              }
                            });
                            Navigator.of(context).pop();
                          },
                          values: values,
                        )
                      ],
                    ),
                  ),
                ],
              )
          );
        });
  }

  Future<void> _displayClassTypeDialog(BuildContext context) async {
    Size query = MediaQuery
        .of(context)
        .size;
    return showDialog(
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
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xFF0A0E23)
                    ),
                    margin: EdgeInsets.fromLTRB(
                        0, query.height * 0.365, 0, query.height * 0.365),
                    padding: EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Pick a Class Type",
                            style: TextStyle(fontSize: 24),
                            textAlign: TextAlign.center
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: GestureDetector(
                                  onPanDown: (details) {
                                    setState(() {
                                      currentLecture.type = ClassType.Theory;
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: CustomCard(
                                    radius: 15,
                                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                                    margin: EdgeInsets.only(left:10,right: 2),
                                    color: Colors.indigo,
                                    child : Center(
                                      child: Text("Theory",
                                          style: TextStyle(
                                            fontFamily: 'Itim',
                                            fontSize: 20,
                                          )),
                                    ),
                                  ),
                                )
                            ),
                            Expanded(
                                child: GestureDetector(
                                  onPanDown: (details) {
                                    setState(() {
                                      currentLecture.type = ClassType.Lab;
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: CustomCard(
                                    radius: 15,
                                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                                    margin: EdgeInsets.only(left:2,right: 10),
                                    color: Colors.indigo,
                                    child : Center(
                                      child: Text("Lab",
                                          style: TextStyle(
                                            fontFamily: 'Itim',
                                            fontSize: 20,
                                          )),
                                    ),
                                  ),
                                )
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              )
          );
        });
  }

  void scheduleAdder(BuildContext context, {bool edit = false, int index=0} ) async {
    currentLecture = Lecture();
    await _displayWeekDayDialog(context);
    currentLecture.startTime = lastUsed;
    await _selectTime("Select Lecture Start Time",true);
    lastUsed = currentLecture.startTime.replacing(hour: currentLecture.startTime.hour+1);
    currentLecture.endTime = lastUsed;
    await _selectTime("Select Lecture End Time",false);
    await _displayClassTypeDialog(context);
    if ( !edit )
      leclist.add(currentLecture);
    else
      leclist[index] = currentLecture;
  }

  Future<void> _selectTime(String Label, bool start) async {

    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: start ? currentLecture.startTime : currentLecture.endTime,
      helpText: Label,
    );
    if (newTime != null) {
      setState(() {
        start ? currentLecture.startTime = newTime : currentLecture.endTime =
            newTime;
      });
    }
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
    return Center(
      child: Column(
        children: [
          Expanded(
            flex:10,
            child: Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 16),
            child: ListView(
              children: [
                CustomCard(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: !collapse ? 20 : 10),
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
                          onSubmitted: (value) =>
                              setState(() {
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
                              letterSpacing: 2, fontWeight: FontWeight.bold),
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
                              borderSide: BorderSide(color: Color(0xFF3edbf0)),
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
                          setState(() {
                            frequency = Frequency.Once;
                          });
                        },
                        child: CustomCard(
                          //radius: 20,
                          child: Text(
                            "Once",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w400),
                          ),
                          color: frequency == Frequency.Once
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
                          setState(() {
                            frequency = Frequency.Weekly;
                          });
                        },
                        child: CustomCard(
                          //radius: 20,
                          child: Text(
                            "Weekly",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w400),
                          ),
                          color: frequency == Frequency.Weekly
                              ? Theme
                              .of(context)
                              .accentColor
                              : Color(0xFF282B4E),
                        ),
                      ),
                    ),
                  ],
                ),

                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: leclist.length,
                  itemBuilder: (context, index) {
                    return ScheduleInfoCard(lecture: leclist[index],
                    delete: () {
                      setState(() {
                        leclist.removeAt(index);
                      });
                    },
                    edit:() {
                      setState(() {
                        scheduleAdder(context,edit: true, index: index);
                      });
                    } ,);
                  },
                ),

                GestureDetector(
                  onPanDown: (panDownDetails) {
                    scheduleAdder(context);
                  },
                  child: CustomCard(
                    radius: 5,
                    child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Add schedule",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 19),
                        ),
                      ],
                    ),
                    color: Colors.indigo,
                  ),
                ),


              ],
            ),
        ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: MediaQuery.of(context).size.height*0.07,
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).accentColor,
              child: Center(
                child: Text("ADD",
                  textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold
                ),),
              ),
            ),
          )]
      ),
    );
  }
}

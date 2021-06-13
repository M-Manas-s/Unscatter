import 'package:unscatter/classes/TimeSlot.dart';
import 'package:unscatter/constants/enums.dart';

class DashBoardClass{
  String courseName;
  String time;
  String courseID;
  ClassType classType;
  SpecialClass specialClass;
  String facultyName;
  TimeSlot ts;
  String classroom;
  int weekday;
  String facid;

  DashBoardClass(
      {
        this.courseName,
        this.courseID,
        this.time,
        this.ts,
        this.classType,
         this.facultyName,
        this.classroom,
        this.weekday,
        this.specialClass = SpecialClass.Standard,
        this.facid,
      }
        );
}
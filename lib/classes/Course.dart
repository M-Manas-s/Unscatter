import 'Lecture.dart';
import 'package:unscatter/constants/enums.dart';

class Course{
  String name;
  Frequency frequency;//enum
  List<Lecture> lectures;

  Course(){
    lectures = [];
  }
}
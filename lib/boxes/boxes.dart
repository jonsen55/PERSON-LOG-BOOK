import 'package:hive_third/models/person.dart';
import 'package:hive/hive.dart';

class Boxes {
  static Box<Person> getData() => Hive.box<Person>('person_box');
}
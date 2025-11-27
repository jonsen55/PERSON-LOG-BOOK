import 'package:hive/hive.dart';

part 'person.g.dart';
@HiveType(typeId: 1)
class Person extends HiveObject{

  @HiveField(0)
  String name;
  @HiveField(1)
  String email;
  @HiveField(2)
  int phone;
  @HiveField(3)
  String? address;
  @HiveField(4)
  String? description;
  @HiveField(5)
  String? image;


  Person({required this.name, required this.email, required this.phone, this.address, this.description, this.image});

}

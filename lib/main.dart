import 'package:flutter/material.dart';
// import 'package:hive_third/view/home_screen.dart';
// import 'package:hive_third/view/login_page.dart';
import 'package:hive_third/view/register_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import './models/person.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  var directory = await getApplicationDocumentsDirectory();

  Hive.init(directory.path);

  Hive.registerAdapter(PersonAdapter());
  await Hive.openBox<Person>('person_box');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: RegisterPage(),
    );
  }
}

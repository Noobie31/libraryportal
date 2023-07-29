import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:libraryportal/admin.dart';
import 'package:libraryportal/librarian.dart';
import 'package:libraryportal/libstudent.dart';
import 'package:libraryportal/register.dart';
import 'package:libraryportal/student.dart';

import 'login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue[900],
      ),
      home: LoginPage(),
    );
  }
}

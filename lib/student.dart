import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class Student extends StatefulWidget {
  const Student({super.key});

  @override
  State<Student> createState() => _StudentState();
}

class _StudentState extends State<Student> {
  @override
  Widget build(BuildContext context,
      {double fontSize = 20.0, FontWeight fontWeight = FontWeight.normal}) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student"),
        backgroundColor: Color.fromARGB(255, 44, 44, 44),
        actions: [
          IconButton(
            onPressed: () {
              logout(context);
            },
            icon: Icon(
              Icons.logout,
            ),
          )
        ],
      ),
      backgroundColor: Color.fromARGB(255, 32, 32, 32),
      body: Container(
        alignment: Alignment.topLeft, // Aligns the text in the top-left corner
        height: 250,
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Color.fromARGB(255, 1, 77, 87),
          border: Border.all(
            color: Color.fromARGB(255, 130, 197, 206),
            width: 1,
          ),
        ),
        child: Text(
          "WELCOME",
          style: TextStyle(
              fontSize: 40,
              fontFamily: 'Roboto',
              fontWeight: fontWeight,
              color: Colors.white),
        ),
      ),
    );
  }
}

Future<void> logout(BuildContext context) async {
  CircularProgressIndicator();
  await FirebaseAuth.instance.signOut();
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => LoginPage(),
    ),
  );
}

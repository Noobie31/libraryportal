import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login.dart';

class Student extends StatefulWidget {
  const Student({Key? key}) : super(key: key);

  @override
  State<Student> createState() => _StudentState();
}

class _StudentState extends State<Student> {
  String? userName;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  Future<void> getProfile() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    if (user != null) {
      // Assuming you are using Firestore as your database
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final DocumentSnapshot snapshot =
          await firestore.collection('users').doc(user.uid).get();

      // Assuming the username is stored in the 'name' field of the document
      final String? username = snapshot.get('name');

      setState(() {
        userEmail = user.email;
        userName = username;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student"),
        backgroundColor: Color.fromARGB(255, 44, 44, 44),
        actions: [
          IconButton(
            onPressed: () {
              logout(context); // Call logout function on logout button press
            },
            icon: Icon(
              Icons.logout,
            ),
          )
        ],
      ),
      backgroundColor: Color.fromARGB(255, 32, 32, 32),
      body: Container(
        alignment: Alignment.topLeft,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome",
              style: TextStyle(
                fontSize: 40,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
            SizedBox(
                height: 10), // Add some spacing between the two Text widgets
            Text(
              userName ?? 'User Name Not Available',
              style: TextStyle(
                fontSize: 30,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 73),
            Text(
              "The Great Gatsby                        Due 2 days more...",
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "The Catcher in the Rye              Due 4 days more...",
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to handle logout
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }
}

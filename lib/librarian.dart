import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login.dart';
import 'libbook.dart';
import 'libstudent.dart';

class Librarian extends StatefulWidget {
  const Librarian({super.key});

  @override
  State<Librarian> createState() => _Librariantate();
}

class _Librariantate extends State<Librarian> {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(tabs: [
            Tab(icon: Icon(Icons.book)),
            Tab(icon: Icon(Icons.people)),
          ]),
          title: Text('Librarian'),
        ),
        body: const TabBarView(
          children: [
            Libstudent(),
            Libstudent(),
          ],
        ),
      ),
    );
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
}

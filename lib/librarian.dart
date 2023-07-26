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

class _Librariantate extends State<Librarian>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 0, 3, 44),
          bottom: TabBar(
            indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(10), // Creates border
                color: Color.fromARGB(
                    255, 118, 164, 170)), //Change background color from her
            tabs: [
              Tab(icon: Icon(Icons.book)),
              Tab(icon: Icon(Icons.people)),
            ],
          ),
          title: Text('Librarian'),
        ),
        body: TabBarView(
          children: [
            (Libbook()),
            (Libstudent()),
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

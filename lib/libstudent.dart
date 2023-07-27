import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Libstudent extends StatefulWidget {
  const Libstudent({Key? key}) : super(key: key);

  @override
  _LibstudentState createState() => _LibstudentState();
}

class _LibstudentState extends State<Libstudent> {
  final ScrollController listController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Student List')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('rool', isEqualTo: 'Student')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No students found.'));
          }

          // Process the list of documents
          final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

          return ListView.builder(
            controller:
                listController, // Use the single controller for ListView
            itemCount: documents.length,
            itemBuilder: (context, index) {
              // Access fields of the document
              final Map<String, dynamic> data =
                  documents[index].data() as Map<String, dynamic>;
              final String name = data['name'];
              final String roll = data['rool'];

              // Display the student information
              return ListTile(
                title: Text(name),
              );
            },
          );
        },
      ),
    );
  }
}

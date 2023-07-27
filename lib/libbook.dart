import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Libbook extends StatefulWidget {
  const Libbook({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Libbook> {
  final ScrollController list1Controller = ScrollController();
  final ScrollController list2Controller = ScrollController();
  final ScrollController list3Controller = ScrollController();
  final ScrollController list4Controller = ScrollController();
  final ScrollController list5Controller = ScrollController();
  final ScrollController list6Controller = ScrollController();
  final ScrollController list7Controller = ScrollController();
  final ScrollController list8Controller = ScrollController();
  final ScrollController list9Controller = ScrollController();
  final ScrollController list10Controller = ScrollController();
  final ScrollController list11Controller = ScrollController();
  final ScrollController list12Controller = ScrollController();
  final ScrollController list13Controller = ScrollController();

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Book List')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('books').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No books found.'));
          }

          // Process the list of documents
          final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              // Access fields of the document
              final Map<String, dynamic> data =
                  documents[index].data() as Map<String, dynamic>;
              final String name = data['name'];
              // final String author = data['author'];
              // final int year = data['year'];

              // Display the book information
              return ListTile(
                title: Text(name),
                // subtitle: Text('Author: $author, Year: $year'),
              );
            },
          );
        },
      ),
    );
  }
}

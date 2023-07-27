import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Libbook extends StatefulWidget {
  const Libbook({super.key});
  @override
  _LibbookState createState() => _LibbookState();
}

class _LibbookState extends State<Libbook> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _showFloatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: 430, // Set a custom width
            height: 400, // Set a custom height
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: "Book Name",
                  ),
                ),
                SizedBox(
                    height: 16), // Add some spacing between the text fields
                TextField(
                  decoration: InputDecoration(
                    labelText: "Description",
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book List"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFloatingDialog(context);
        },
        child: Icon(Icons.add),
      ),
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

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:google_fonts/google_fonts.dart';

class Libbook extends StatefulWidget {
  const Libbook({super.key});
  @override
  _LibbookState createState() => _LibbookState();
}

class _LibbookState extends State<Libbook> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: GoogleFonts.lato().fontFamily,
      ),
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
  final TextEditingController _bookNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

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
                  controller: _bookNameController,
                  decoration: InputDecoration(
                    labelText: "Book Name",
                  ),
                ),
                SizedBox(
                  height: 16,
                ), // Add some spacing between the text fields
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: "Description",
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                // Save the book name and description to Firestore
                String bookName = _bookNameController.text;
                String description = _descriptionController.text;
                String Nakki =
                    "New Book"; // You can set this to "true" if the book is nakki.

                // Add the data to Firestore
                await FirebaseFirestore.instance.collection('books').add({
                  'name': bookName,
                  'description': description,
                  'nakki': Nakki,
                });

                // Close the dialog
                Navigator.of(context).pop();
              },
              child: Text("ADD"),
            ),
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
        title: Row(children: <Widget>[
          Text(
            'Book List',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w200,
                fontFamily: GoogleFonts.lato().fontFamily,
                fontSize: 20),
          ),
          SizedBox(width: 180),
          Text(
            "Pre owned by",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w200,
                fontFamily: GoogleFonts.lato().fontFamily,
                fontSize: 10),
          ),
        ]),
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
              final String Nakki =
                  data['nakki']; // Get the value of 'nakki' field

              // Display the book information
              return ListTile(
                title: Text(name),
                trailing: Text(Nakki),
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Libstudent extends StatefulWidget {
  const Libstudent({Key? key}) : super(key: key);

  @override
  _LibstudentState createState() => _LibstudentState();
}

class _LibstudentState extends State<Libstudent> {
  final ScrollController listController = ScrollController();

  Future<void> _removeBook(
      String documentId, List<dynamic> booksy, int index) async {
    booksy.removeAt(index);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(documentId)
        .update({
      'booksy': booksy,
    });
  }

  void _showAddBookDialog(
      BuildContext context, String documentId, List<dynamic> booksy) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double dialogWidth = MediaQuery.of(context).size.width - 40;
        double dialogHeight = MediaQuery.of(context).size.height - 40;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          insetPadding: EdgeInsets.zero,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                width: dialogWidth,
                height: dialogHeight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      color: Colors.blue, // Customize the color of the top bar
                      child: Text(
                        'Add Book',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('books')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return Center(child: Text('No books found.'));
                          }

                          final List<QueryDocumentSnapshot> documents =
                              snapshot.data!.docs;

                          return ListView.builder(
                            itemCount: documents.length,
                            itemBuilder: (context, index) {
                              final Map<String, dynamic> data = documents[index]
                                  .data() as Map<String, dynamic>;
                              final String bookName = data['name'];

                              return ListTile(
                                title: Text(bookName),
                                onTap: () {
                                  // Implement the function to add the selected book to the list
                                  booksy.add(bookName);
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(documentId)
                                      .update({
                                    'booksy': booksy,
                                  }).then((_) {
                                    Navigator.of(context).pop();
                                  });
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showStudentDetails(BuildContext context, String name,
      List<dynamic> booksy, String documentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double dialogWidth = MediaQuery.of(context).size.width - 40;
        double dialogHeight = MediaQuery.of(context).size.height - 40;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          insetPadding: EdgeInsets.zero,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(documentId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      width: dialogWidth,
                      height: dialogHeight,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Container(
                      width: dialogWidth,
                      height: dialogHeight,
                      child: Center(
                        child: Text('Error: ${snapshot.error}'),
                      ),
                    );
                  } else if (!snapshot.hasData) {
                    return Container(
                      width: dialogWidth,
                      height: dialogHeight,
                      child: Center(
                        child: Text('No data found.'),
                      ),
                    );
                  }

                  final Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;
                  final List<dynamic> updatedBooksy = data['booksy'];

                  return Container(
                    width: dialogWidth,
                    height: dialogHeight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(16),
                          color:
                              Colors.blue, // Customize the color of the top bar
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                name, // Show the student's name here
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: updatedBooksy.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(updatedBooksy[index].toString()),
                                trailing: IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () {
                                    _removeBook(
                                            documentId, updatedBooksy, index)
                                        .then((_) {
                                      setState(() {
                                        // Update the local list when book is removed
                                        booksy = updatedBooksy;
                                      });
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          color: Colors.black,
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(Icons.add, color: Colors.white),
                                onPressed: () {
                                  _showAddBookDialog(
                                      context, documentId, booksy);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student List'),
        backgroundColor: const Color.fromARGB(255, 87, 87, 87),
        surfaceTintColor: const Color.fromARGB(255, 255, 200, 0),
        elevation: 5,
      ),
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

          final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

          return ListView.builder(
            controller: listController,
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final Map<String, dynamic> data =
                  documents[index].data() as Map<String, dynamic>;
              final String name = data['name'];
              final List<dynamic> booksy = data['booksy'];
              final String documentId = documents[index].id;

              return ListTile(
                title: Text(name),
                onTap: () {
                  _showStudentDetails(context, name, booksy, documentId);
                },
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

class Libbook extends StatefulWidget {
  const Libbook({super.key});

  @override
  State<Libbook> createState() => _Libbooktate();
}

class _Libbooktate extends State<Libbook> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(),
      debugShowCheckedModeBanner: false,
    );
  }
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('FloatingActionButton Sample'),
    ),
    body: const Center(child: Text('Press the button below!')),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        // Add your onPressed code here!
      },
      backgroundColor: Colors.green,
      child: const Icon(Icons.navigation),
    ),
  );
}

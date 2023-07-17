import 'package:flutter/material.dart';
import '../screens/new_connection.dart';

class NewEntry extends StatelessWidget {
  NewEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("New Connection"),
        ),
        body: ConnectionEntryForm());
  }
}

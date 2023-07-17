import 'package:flutter/material.dart';

class Connections extends StatelessWidget {
  late final entries;

  Connections({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(entries['title']),
      subtitle: Text(entries['date']),
    );
  }
}

class ConnectionsList extends StatelessWidget {
  late final entries;

  ConnectionsList({super.key, required this.entries});

  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            itemCount: entries.length,
            itemBuilder: ((context, index) {
              return entries[index];
            })));
  }
}

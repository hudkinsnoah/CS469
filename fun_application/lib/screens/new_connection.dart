import 'package:flutter/material.dart';
import 'package:fun_application/screens/main_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/connection_fields.dart';
import '../database/database.dart';
import 'package:flutter/services.dart' show rootBundle;

class ConnectionEntryForm extends StatelessWidget {
  final formKey = GlobalKey<FormState>();

  ConnectionEntryForm({super.key});

  final ConnectionEntryFields connectionEntry = ConnectionEntryFields();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                autofocus: false,
                decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  connectionEntry.name = value;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter a name";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState?.save();
                        saveEntries(connectionEntry);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MyHomePage()));
                      }
                    },
                    child: const Text("Save"),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void saveEntries(ConnectionEntryFields connectionentry) async {
  await deleteDatabase(join(await getDatabasesPath(), 'connections.db'));
  var db = await openDatabase(join(await getDatabasesPath(), 'connections.db'),
      version: 1, onCreate: (Database db, int version) async {
    loadAsset("lib/database/open_db.txt").then((String create) async {
      await db.execute(create);
    });
  });
  await db.transaction((txn) async {
    loadAsset("lib/database/insert.txt").then((String insert) async {
      ;
      await txn.rawInsert(insert, [
        connectionentry.name,
      ]);
    });
  });

  await db.close();
}

Future<String> loadAsset(String file) async {
  return await rootBundle.loadString(file);
}

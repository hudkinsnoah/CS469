import 'package:flutter/material.dart';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import '../models/list.dart';
import 'package:path/path.dart';
import '../models/devices.dart';
import '../models/connection_entry.dart';
import 'package:flutter/services.dart' show rootBundle;

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});
  late DeviceList devicelist = DeviceList(entries: const []);
  late List<Map> devices;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    loadDevices();
  }

  void loadDevices() async {
    var db = await openDatabase(
        join(await getDatabasesPath(), 'connections.db'),
        version: 1, onCreate: (Database db, int version) {
      loadAsset("lib/database/open_db.txt").then((String create) async {
        await db.execute(create);
      });
    });

    loadAsset("lib/database/get_rows.txt").then((String get) async {
      widget.devices = await db.rawQuery(get);
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      final connectionEntries = widget.devices.map((record) {
        return Device(entries: record);
      }).toList();
      widget.devicelist = DeviceList(entries: connectionEntries);
    });
  }

  final String title = "Bluetooth Speaker Manager";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(title)),
        automaticallyImplyLeading: false,
      ),
      body: Center(child: widget.devicelist),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          toConnectionForm(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

Future<String> loadAsset(String file) async {
  String current = Directory.current.path;
  return await rootBundle.loadString(file);
}

void toConnectionForm(BuildContext context) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => NewEntry()));
}

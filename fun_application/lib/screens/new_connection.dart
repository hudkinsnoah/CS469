import 'package:flutter/material.dart';
import 'package:fun_application/screens/main_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/connection_fields.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/devices_list.dart';
import 'package:bluetooth_connector/bluetooth_connector.dart';

class ConnectionEntryForm extends StatefulWidget {
  ConnectionEntryForm({super.key});
  List<BtDevice> devices = [];
  BluetoothConnector flutterbluetoothadapter = BluetoothConnector();

  @override
  State<ConnectionEntryForm> createState() => _ConnectionEntryFormState();
}

class _ConnectionEntryFormState extends State<ConnectionEntryForm> {
  void initState() {
    super.initState();
    widget.flutterbluetoothadapter
        .initBlutoothConnection("75C276C3-8F97-20BC-A143-B354244886D4");
    widget.flutterbluetoothadapter
        .checkBluetooth()
        .then((value) => print(value.toString()));
    _get_devices();
  }

  final formKey = GlobalKey<FormState>();
  final List<bool> isSelected = List.generate(20, (i) => false);
  final ConnectionEntryFields connectionEntry = ConnectionEntryFields();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
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
                    } else if (isSelected
                        .every((element) => element == false)) {
                      return "Please select a bluetooth device";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 10),
                SizedBox(
                    height: 500,
                    child: DeviceList(
                        isSelected: isSelected,
                        devices: widget.devices,
                        flutterbluetoothadapter:
                            widget.flutterbluetoothadapter)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState?.save();
                          saveEntries();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MyHomePage()));
                        }
                      },
                      child: const Text("Save"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _get_devices() async {
    widget.devices = await widget.flutterbluetoothadapter.getDevices();
    setState(() {});
  }

  void saveEntries() async {
    var device_to_use;
    for (var i = 0; i < isSelected.length; i++) {
      if (isSelected[i] != false) {
        device_to_use = widget.devices[i];
      }
    }

    var device_name = device_to_use.name;
    var device_id = device_to_use.address;

    // await deleteDatabase(join(await getDatabasesPath(), 'connections.db'));
    var db = await openDatabase(
        join(await getDatabasesPath(), 'connections.db'),
        version: 1, onCreate: (Database db, int version) async {
      loadAsset("lib/database/open_db.txt").then((String create) async {
        await db.execute(create);
      });
    });
    await db.transaction((txn) async {
      loadAsset("lib/database/insert.txt").then((String insert) async {
        await txn
            .rawInsert(insert, [connectionEntry.name, device_name, device_id]);
      });
    });

    await db.close();
  }
}

Future<String> loadAsset(String file) async {
  return await rootBundle.loadString(file);
}

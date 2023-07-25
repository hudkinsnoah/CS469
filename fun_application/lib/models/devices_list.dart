import 'package:flutter/material.dart';
import 'package:bluetooth_connector/bluetooth_connector.dart';
import 'package:permission_handler/permission_handler.dart';

class DeviceList extends StatefulWidget {
  @override
  State<DeviceList> createState() => _DeviceListState();
  List<BtDevice> devices = [];
  bool? _serviceEnabled;
}

class _DeviceListState extends State<DeviceList> {
  BluetoothConnector flutterbluetoothadapter = BluetoothConnector();

  @override
  void initState() {
    super.initState();
    flutterbluetoothadapter
        .initBlutoothConnection("20585adb-d260-445e-934b-032a2c8b2e14");
    flutterbluetoothadapter
        .checkBluetooth()
        .then((value) => print(value.toString()));
    _get_devices();
  }

  void get_permission() async {
    await Permission.bluetooth.request();
  }

  void _get_devices() async {
    widget.devices = await flutterbluetoothadapter.getDevices();
  }

  @override
  Widget build(BuildContext build) {
    return Scaffold(
      body: Column(
        children: [
          ListView(
            shrinkWrap: true,
            children: _createDevices(),
          ),
          ElevatedButton(
              child: const Text("Scan"),
              onPressed: () async {
                widget.devices = await flutterbluetoothadapter.getDevices();
                setState(() {});
              }),
        ],
      ),
    );
  }

  _createDevices() {
    if (widget.devices.isEmpty) {
      return [
        const Center(
          child: Text("No Paired Devices listed..."),
        )
      ];
    }
    List<Widget> deviceList = [];
    widget.devices.forEach((element) {
      deviceList.add(
        InkWell(
          key: UniqueKey(),
          onTap: () {
            flutterbluetoothadapter.startClient(
                widget.devices.indexOf(element), true);
          },
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(border: Border.all()),
            child: Text(
              element.name.toString(),
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      );
    });
    return deviceList;
  }
}

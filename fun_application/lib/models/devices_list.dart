import 'package:flutter/material.dart';
import 'package:bluetooth_connector/bluetooth_connector.dart';
import 'package:permission_handler/permission_handler.dart';

class DeviceList extends StatefulWidget {
  DeviceList(
      {super.key, this.isSelected, this.devices, this.flutterbluetoothadapter});
  @override
  State<DeviceList> createState() => _DeviceListState();
  var devices;
  bool? _serviceEnabled;
  Color color = Colors.white;
  final isSelected;
  final flutterbluetoothadapter;
}

class _DeviceListState extends State<DeviceList> {
  @override
  void initState() {
    super.initState();
    widget.flutterbluetoothadapter
        .initBlutoothConnection("75C276C3-8F97-20BC-A143-B354244886D4");
    widget.flutterbluetoothadapter
        .checkBluetooth()
        .then((value) => print(value.toString()));
    _get_devices();
  }

  void get_permission() async {
    await Permission.bluetooth.request();
  }

  void _get_devices() async {
    widget.devices = await widget.flutterbluetoothadapter.getDevices();
    setState(() {});
  }

  @override
  Widget build(BuildContext build) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: _createDevices(),
          ),
          ElevatedButton(
              child: const Text("Scan"),
              onPressed: () async {
                widget.devices =
                    await widget.flutterbluetoothadapter.getDevices();
                setState(() {});
              }),
        ],
      ),
    );
  }

  _createDevices() {
    if (widget.devices.isEmpty) {
      return const Center(
        child: Text("No Paired Devices listed..."),
      );
    }
    return Scaffold(
        body: ListView.builder(
            itemCount: widget.devices.length,
            itemBuilder: ((context, index) {
              return ListTile(
                  title: Text(widget.devices[index].name.toString()),
                  tileColor: widget.isSelected[index] ? Colors.blue : null,
                  onTap: () => setState(() =>
                      widget.isSelected[index] = !widget.isSelected[index]));
            })));
  }
}

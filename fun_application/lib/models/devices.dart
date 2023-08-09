import 'package:flutter/material.dart';
import 'popup_menu.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'dart:async';

enum SampleItem { itemOne, itemTwo, itemThree }

class Device extends StatefulWidget {
  late final entries;

  Device({super.key, required this.entries});

  @override
  State<Device> createState() => _DeviceState();
}

class _DeviceState extends State<Device> {
  @override
  void initState() {
    super.initState();
    set_color(_connected);
  }

  SampleItem? selectedMenu;

  final flutterReactiveBle = FlutterReactiveBle();

  final Uuid serviceUuid = Uuid.parse("75C276C3-8F97-20BC-A143-B354244886D4");
  late QualifiedCharacteristic _rxCharacteristic;
  bool _foundDeviceWaitingToConnect = false;
  bool _scanStarted = false;
  bool _connected = false;
  Color color = Colors.red;

  late StreamSubscription<ConnectionStateUpdate> _connection;

  final Uuid characteristicUuid =
      Uuid.parse("6ACF4F08-CC9D-D495-6B41-AA7E60C4E8A6");

  void set_color(bool connected) {
    color = connected ? Colors.green : Colors.red;
  }

  Widget build(BuildContext context) {
    return ListTile(
        title: Text(
          widget.entries['name'],
          style: const TextStyle(
            fontSize: 25.0,
          ),
        ),
        tileColor: color,
        subtitle: Text(widget.entries['connection']),
        // trailing: PopupMenuButton<SampleItem>(
        //   initialValue: selectedMenu,
        //   // Callback that sets the selected popup menu item.
        //   onSelected: (SampleItem item) {},
        //   itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
        //     const PopupMenuItem<SampleItem>(
        //       value: SampleItem.itemOne,
        //       child: Text('Remove'),
        //     )
        //   ],
        // ),
        onTap: () {
          _connection = flutterReactiveBle
              .connectToDevice(id: widget.entries["connection_id"])
              .listen((event) {
            switch (event.connectionState) {
              case DeviceConnectionState.connected:
                {
                  if (_connected) {
                    _connection.cancel();
                    setState(() {
                      _foundDeviceWaitingToConnect = true;
                      _connected = false;
                      color = Colors.red;
                    });
                  } else {
                    _rxCharacteristic = QualifiedCharacteristic(
                        serviceId: serviceUuid,
                        characteristicId: characteristicUuid,
                        deviceId: event.deviceId);
                    setState(() {
                      _foundDeviceWaitingToConnect = false;
                      _connected = true;
                      color = Colors.green;
                    });
                  }
                  break;
                }
              // Can add various state state updates on disconnect
              case DeviceConnectionState.disconnected:
                {
                  if (_connected) {
                    setState(() {
                      _foundDeviceWaitingToConnect = true;
                      _connected = false;
                      color = Colors.red;
                    });
                  } else {
                    _rxCharacteristic = QualifiedCharacteristic(
                        serviceId: serviceUuid,
                        characteristicId: characteristicUuid,
                        deviceId: event.deviceId);
                    setState(() {
                      _foundDeviceWaitingToConnect = false;
                      _connected = true;
                      color = Colors.green;
                    });
                  }
                }
              default:
            }
          });
        });
  }
}

class DeviceList extends StatelessWidget {
  late final entries;

  DeviceList({super.key, required this.entries});

  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            itemCount: entries.length,
            itemBuilder: ((context, index) {
              return entries[index];
            })));
  }
}

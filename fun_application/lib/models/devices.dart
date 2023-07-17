import 'package:flutter/material.dart';
import 'popup_menu.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class Device extends StatelessWidget {
  late final entries;
  SampleItem? selectedMenu;

  Device({super.key, required this.entries});

  Widget build(BuildContext context) {
    return ListTile(
      title: Text(entries['name']),
      trailing: PopupMenuButton<SampleItem>(
        initialValue: selectedMenu,
        // Callback that sets the selected popup menu item.
        onSelected: (SampleItem item) {},
        itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
          const PopupMenuItem<SampleItem>(
            value: SampleItem.itemOne,
            child: Text('Remove'),
          ),
          const PopupMenuItem<SampleItem>(
            value: SampleItem.itemTwo,
            child: Text('Change Name'),
          ),
          const PopupMenuItem<SampleItem>(
            value: SampleItem.itemThree,
            child: Text('Change Connection'),
          ),
        ],
      ),
      onLongPress: () {
        const PopupMenu();
      },
    );
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

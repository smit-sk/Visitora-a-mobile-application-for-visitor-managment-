import 'package:flutter/material.dart';
import 'package:visitor_tracker/screens/drawer/drawer_item.dart';
import 'package:visitor_tracker/screens/homescreen.dart';

import 'drawer_items.dart';

class DrawerWidget extends StatelessWidget {
  final ValueChanged<DrawerItem>? onSelectedItem;

  const DrawerWidget({Key? key, this.onSelectedItem}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 32, 16, 0),
      child: SingleChildScrollView(
          child: Column(
        children: [
          buildDrawerItems(context),
        ],
      )),
    );
  }

  Widget buildDrawerItems(BuildContext context) {
    return Column(
      children: DrawerItems.all
          .map((item) => ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                leading: Icon(
                  item.icon,
                  color: Colors.white,
                ),
                title: Text(
                  item.title,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                onTap: () => onSelectedItem!(item),
              ))
          .toList(),
    );
  }
}

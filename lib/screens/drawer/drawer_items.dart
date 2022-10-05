import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'drawer_item.dart';

class DrawerItems {
  static const profile = DrawerItem(title: 'Profile', icon: FontAwesomeIcons.userCircle);

  static const home =DrawerItem(title: 'Home', icon: Icons.home);
  static const admin = DrawerItem(title: 'Admin', icon: Icons.admin_panel_settings_outlined);
  static const visitor = DrawerItem(title: 'Visitor', icon: Icons.person);
  static const logout = DrawerItem(title: 'Logout', icon: Icons.logout);


  static final List<DrawerItem> all = [
    profile,
    home,
    admin,
    visitor,
    logout
  ];
}

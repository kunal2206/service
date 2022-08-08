import 'package:flutter/material.dart';

import '../core/constants/palette.dart';

AppBar customAppBar(
    List<Widget> tabIcons, Widget navBarTitle, Widget leadingIcon) {
  return AppBar(
    elevation: 0,
    leading: leadingIcon,
    title: navBarTitle,
    actions: tabIcons,
    backgroundColor: white,
  );
}
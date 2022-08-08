import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/constants/palette.dart';
import '../data/controllers/bottom_navigation_controller.dart';
import '../routes/app_pages.dart';

class BottomNavBar extends GetWidget<BottomNavigationController> {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BottomNavigationBar(
        onTap: (value) {
          controller.currentIndex.value = value;
          controller.navigate(value);
        },
        elevation: 2,
        currentIndex: controller.currentIndex.value,
        unselectedItemColor: white.withAlpha(200),
        selectedItemColor: white,
        showUnselectedLabels: true,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        iconSize: 24,
        items: [
          [Icons.home, "Home"],
          [Icons.book_outlined, "Bookings"],
          [Icons.settings, "Profile"],
          [Icons.notifications, "Notifications"],
        ]
            .map(
              (bottomNavList) => BottomNavigationBarItem(
                backgroundColor: lightOrange,
                icon: Icon(
                  bottomNavList[0] as IconData,
                  color: white.withAlpha(200),
                ),
                activeIcon: Icon(
                  bottomNavList[0] as IconData,
                  color: white,
                ),
                label: bottomNavList[1] as String,
              ),
            )
            .toList(),
      ),
    );
  }
}

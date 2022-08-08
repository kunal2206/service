import 'package:get/get.dart';

import '../../routes/app_pages.dart';

class BottomNavigationController extends GetxController {

  static BottomNavigationController instance = Get.find();
  Rx<int> currentIndex = 0.obs;

  void navigate(value) {
    switch (value) {
      case 0:
        Get.offAllNamed(Routes.HOME);
        break;
      case 1:
        Get.offAllNamed(Routes.BOOKINGS);
        break;
      case 2:
        Get.offAllNamed(Routes.PROFILE);
        break;
      case 3:
        break;
      default:
    }
  }
}

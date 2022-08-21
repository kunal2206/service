import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/controllers.dart';
import '../../../routes/app_pages.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (!authController.isAuth.value) {
      return const RouteSettings(name: Routes.AUTHENTICATION);
    }
    return null;
  }
}

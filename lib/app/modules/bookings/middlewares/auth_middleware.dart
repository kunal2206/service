import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';

import '../../../core/constants/controllers.dart';
import '../../../routes/app_pages.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final service = FlutterBackgroundService();
    if (!authController.isAuth.value) {
      
      return const RouteSettings(name: Routes.AUTHENTICATION);
    } else {
      service.startService();
    }
    return null;
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';

import '../../core/constants/controllers.dart';
import '../../core/constants/palette.dart';
import '../../routes/app_pages.dart';

class AuthenticationButton extends StatelessWidget {
  final BoxConstraints constraints;
  final String displayText;

  final bool logout;

  const AuthenticationButton({
    Key? key,
    this.logout = false,
    required this.constraints,
    required this.displayText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ///logout when the logout button is pressed
        if (logout) {
          authController.logout();
          final service = FlutterBackgroundService();

          service.invoke("stopService");
        }

        ///to close the navigation drawer
        Navigator.of(context).pop();
        Get.toNamed(Routes.AUTHENTICATION);
      },
      child: Container(
        height: constraints.maxHeight * 0.04,
        width: constraints.maxWidth * 0.7,
        decoration: BoxDecoration(
          border: Border.all(color: white),
          borderRadius: BorderRadius.circular(2),
          color: lightOrange,
        ),
        child: Center(
          child: Text(
            displayText,
            style: const TextStyle(color: white),
          ),
        ),
      ),
    );
  }
}

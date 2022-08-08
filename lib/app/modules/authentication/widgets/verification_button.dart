import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/palette.dart';
import '../../../routes/app_pages.dart';
import '../controllers/authentication_controller.dart';

class VerificationButton extends StatelessWidget {
  const VerificationButton({
    required this.controller,
    Key? key,
  }) : super(key: key);

  final AuthenticationController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading.value
          ? CircularProgressIndicator(
              color: controller.getLoginStatus() == LoginStatus.phoneNumberInput
                  ? lightOrange
                  : white,
            )
          : Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 5),
              child: Material(
                color:
                    controller.getLoginStatus() == LoginStatus.phoneNumberInput
                        ? lightOrange
                        : white,
                elevation: 3,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(100),
                    bottomRight: Radius.circular(100),
                    topLeft: Radius.circular(100),
                    topRight: Radius.circular(100),
                  ),
                ),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextButton(
                    onPressed: () {
                      if (controller.getLoginStatus() ==
                          LoginStatus.phoneNumberInput) {
                        controller.submitPhoneNumber().then((value) =>
                            controller.setLoginStatus(value
                                ? LoginStatus.otpInput
                                : LoginStatus.phoneNumberInput));
                        controller.phoneNumberController.text = "";
                      } else {
                        controller.verifyOTP().then((value) {
                          if (value) {
                            controller
                                .setLoginStatus(LoginStatus.phoneNumberInput);
                            Get.offAllNamed(Routes.HOME);
                          }
                        });
                      }
                    },
                    child: Text(
                      controller.getLoginStatus() ==
                              LoginStatus.phoneNumberInput
                          ? 'Login'
                          : 'Verify OTP',
                      style: GoogleFonts.mulish(
                        fontWeight: FontWeight.bold,
                        color: controller.getLoginStatus() ==
                                LoginStatus.phoneNumberInput
                            ? white
                            : lightOrange,
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

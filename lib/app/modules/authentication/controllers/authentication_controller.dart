import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/controllers.dart';
import '../../../data/exceptions.dart';
import '../../../global_widgets/show_error_dialog.dart';

enum LoginStatus { phoneNumberInput, otpInput }

class AuthenticationController extends GetxController {
  //UI will change depending upon the authStatus
  final Rx<LoginStatus> _loginStatus = LoginStatus.phoneNumberInput.obs;

  //this is used to show circular progress indicator while fetching request
  Rx<bool> isLoading = false.obs;

  //getting the value of entered text
  TextEditingController phoneNumberController = TextEditingController();

  //setter and getter for the login status
  void setLoginStatus(LoginStatus status) => _loginStatus.value = status;
  LoginStatus getLoginStatus() => _loginStatus.value;

  //form key for getting the value of either phone number or otp
  final GlobalKey<FormState> formKey = GlobalKey();

  Future<bool> submitPhoneNumber() async {
    formKey.currentState!.save();

    isLoading.value = true;
    update();

    try {
      await authController
          .sendPhoneNumberForVerification(phoneNumberController.text)
          .then((value) {
        if (value == "PHONE_REGISTERED") {
          setLoginStatus(LoginStatus.otpInput);
          update();
        } else {
          throw AuthException(
              message:
                  "The phone number entered by you is not correct. Kindly check your number");
        }
      });
    } on AuthException catch (error) {
      showErrorDialog(error.message, () {
        Get.back();
      });
      isLoading.value = false;
      update();
      return Future.value(false);
    }

    isLoading.value = false;

    return Future.value(true);
  }

  //list of all the text controllers for the pin code
  TextEditingController otpController1 = TextEditingController();
  TextEditingController otpController2 = TextEditingController();
  TextEditingController otpController3 = TextEditingController();
  TextEditingController otpController4 = TextEditingController();
  TextEditingController otpController5 = TextEditingController();
  TextEditingController otpController6 = TextEditingController();

  void resetOTP() {
    otpController1.text = "";
    otpController2.text = "";
    otpController3.text = "";
    otpController4.text = "";
    otpController5.text = "";
    otpController6.text = "";
  }

  Future<bool> verifyOTP() async {
    isLoading.value = true;
    update();

    String otp = otpController1.text +
        otpController2.text +
        otpController3.text +
        otpController4.text +
        otpController5.text +
        otpController6.text;
    try {
      await authController.otpVerification(otp).then((value) {
        if (value == "OTP_VERIFIED") {
          setLoginStatus(LoginStatus.otpInput);
          update();
        } else {
          throw AuthException(
              message:
                  "The otp entered by you has either expired or is invalid.");
        }
      });
    } on AuthException catch (error) {
      showErrorDialog(error.message, () {
        Get.back();
      });
      isLoading.value = false;
      update();
      return Future.value(false);
    }

    isLoading.value = false;

    return Future.value(true);
  }
}

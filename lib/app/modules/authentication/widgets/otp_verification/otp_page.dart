import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/palette.dart';
import '../../controllers/authentication_controller.dart';
import '../verification_button.dart';
import 'widgets/otp_input_field.dart';

class OTPpage extends StatelessWidget {
  const OTPpage({required this.controller, Key? key}) : super(key: key);

  final AuthenticationController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _blankTransparentBlock(context),
          _verificationTextBlock(context),
          _enterTheOTPBlock(),
          _otpInputBlock(context),
          Center(child: VerificationButton(controller: controller)),
          _resendButton()
        ],
      ),
    );
  }

  ///block where actual otp is entered
  Padding _otpInputBlock(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.15,
        decoration: const BoxDecoration(
          color: Color(0x00EEEEEE),
        ),
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OTPInputField(controller: controller.otpController1),
              OTPInputField(controller: controller.otpController2),
              OTPInputField(controller: controller.otpController3),
              OTPInputField(controller: controller.otpController4),
              OTPInputField(controller: controller.otpController5),
              OTPInputField(controller: controller.otpController6)
            ]),
      ),
    );
  }

  // a row containing a resend button
  Widget _resendButton() {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Did not recieve any OTP?',
            style: GoogleFonts.poppins(
              color: white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          InkWell(
            onTap: () {
              controller.setLoginStatus(LoginStatus.phoneNumberInput);
            },
            child: Text(
              'Resend OTP',
              style: GoogleFonts.poppins(
                color: white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // a block containing the text enter the OTP
  Widget _enterTheOTPBlock() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 40),
      child: Text(
        'Enter the OTP below',
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          color: white,
          fontSize: 18,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  //A block to show the text of verification
  Widget _verificationTextBlock(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
      child: Text(
        'Verification',
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          color: white,
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
      ),
    );
  }

  //block created to simply add blank space in the top of the page
  Widget _blankTransparentBlock(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: const BoxDecoration(
        color: Color(0x00FFFFFF),
      ),
    );
  }
}

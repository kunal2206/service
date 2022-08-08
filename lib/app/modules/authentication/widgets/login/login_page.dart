import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/palette.dart';
import '../../../../routes/app_pages.dart';
import '../../controllers/authentication_controller.dart';
import '../verification_button.dart';
import 'widgets/phonenumber_input.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({required this.controller, Key? key}) : super(key: key);

  final AuthenticationController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _companyLogoSection(context),

          _middleEnterNumberTextBlock(context),

          //end section
          _mobileNumberEnterOrSkipSection(context)
        ],
      ),
    );
  }

  //top section containing the fixpals logo
  Widget _companyLogoSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(120, 0, 120, 0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.45,
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: Image.asset(
                  'assets/images/fixpal_logo.png',
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.5,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // middle section containing the text to enter the mobile number
  Widget _middleEnterNumberTextBlock(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.25,
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Let\'s get started',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: midnightGreen,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
            child: Text(
              'Providing quality home services',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontWeight: FontWeight.normal),
            ),
          ),
          Text(
            'Enter your mobile number ',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  //End section to enter the mobile number or the skip login
  Widget _mobileNumberEnterOrSkipSection(BuildContext context) {
    return Container(
        color: Theme.of(context).backgroundColor,
        child: Column(
          children: [
            PhoneNumberInput(controller: controller),
            VerificationButton(controller: controller),
            _skipLoginBlock(context),
          ],
        ));
  }

  //skip login button
  Widget _skipLoginBlock(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.12,
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton(
            
            onPressed: () {
              Get.offAllNamed(Routes.HOME);
            },
            style: const ButtonStyle(
              alignment: Alignment.center,
            ),
            child: Text(
              'Skip the Login',
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
          Align(
            alignment: const AlignmentDirectional(-0.05, -0.05),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_forward_ios_outlined,
                color: midnightGreen,
                size: 30,
              ),
              onPressed: () {
                Get.offAllNamed(Routes.HOME);
              },
            ),
          ),
        ],
      ),
    );
  }
}

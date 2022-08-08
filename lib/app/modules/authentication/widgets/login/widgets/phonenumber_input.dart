import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controllers/authentication_controller.dart';

class PhoneNumberInput extends StatefulWidget {
  const PhoneNumberInput({required this.controller, Key? key})
      : super(key: key);

  final AuthenticationController controller;

  @override
  State<PhoneNumberInput> createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<PhoneNumberInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 30),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _blockToShowCountryCode(context),
          _phoneNumberInputSection(context),
        ],
      ),
    );
  }

  Widget _phoneNumberInputSection(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 3,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(100),
          topLeft: Radius.circular(0),
          topRight: Radius.circular(100),
        ),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.height * 0.08,
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(100),
            topLeft: Radius.circular(0),
            topRight: Radius.circular(100),
          ),
          shape: BoxShape.rectangle,
        ),
        child: Form(
          key: widget.controller.formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
            child: TextFormField(
              controller: widget.controller.phoneNumberController,
              obscureText: false,
              decoration: const InputDecoration(
                errorMaxLines: 1,
                focusedErrorBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                contentPadding: EdgeInsets.all(20),
                hintText: 'phone number',
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              onSaved: (value) {
                if (value != null) {
                  widget.controller.phoneNumberController.text = value;
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _blockToShowCountryCode(BuildContext context) {
    return Material(
      color: Theme.of(context).backgroundColor,
      elevation: 3,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(100),
          bottomRight: Radius.circular(0),
          topLeft: Radius.circular(100),
          topRight: Radius.circular(0),
        ),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.2,
        height: MediaQuery.of(context).size.height * 0.08,
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(100),
            bottomRight: Radius.circular(0),
            topLeft: Radius.circular(100),
            topRight: Radius.circular(0),
          ),
        ),
        alignment: const AlignmentDirectional(0, 0.05),
        child: Text('+91',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.normal,
            )),
      ),
    );
  }
}


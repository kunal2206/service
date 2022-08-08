import 'package:flutter/material.dart';

class OTPInputField extends StatefulWidget {
  const OTPInputField({required this.controller, Key? key}) : super(key: key);

  final TextEditingController controller;

  @override
  State<OTPInputField> createState() => _OTPInputFieldState();
}

class _OTPInputFieldState extends State<OTPInputField> {
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor,
            )
          ],
          borderRadius: BorderRadius.circular(20),
          shape: BoxShape.rectangle,
        ),
        alignment: const AlignmentDirectional(-0.05, -0.05),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
          child: TextFormField(
            controller: widget.controller,
            onChanged: (value) {
              if (value.length == 1) {
                widget.controller.text = value;
                FocusScope.of(context).nextFocus();
              }

              if (value.isEmpty) {
                FocusScope.of(context).previousFocus();
              }
            },
            maxLength: 1,
            obscureText: false,
            decoration: const InputDecoration(
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              counterText: "",
            ),
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            autofocus: true,
          ),
        ),
      ),
    );
  }
}


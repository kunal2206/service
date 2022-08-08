import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showErrorDialog(String message, Function onPressed,
    {String title = "An error occured"}) {
  Get.dialog(AlertDialog(
    title: Text(title),
    content: Text(message),
    actions: [
      TextButton(
        onPressed: () {
          onPressed();
        },
        child: const Text("Okay"),
      ),
    ],
  ));
}

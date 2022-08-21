import 'package:fixpals_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/ongoing_order_details_controller.dart';

class OngoingDynamicContainer extends StatefulWidget {
  const OngoingDynamicContainer({
    required this.controller,
    required this.status,
    Key? key,
  }) : super(key: key);

  final OngoingOrderDetailsController controller;
  final String status;

  @override
  State<OngoingDynamicContainer> createState() =>
      _OngoingDynamicContainerState();
}

class _OngoingDynamicContainerState extends State<OngoingDynamicContainer> {
  bool pay = false;
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (widget.status == "1004") {
        return acceptedBlock(
            "Press the button if serviceman has arrived", "Arrived");
      } else if (widget.status == "1005") {
        return dynamicBlock("Make the payment if order is complete", "Pay", () {
          widget.controller.sendData({}, "1002");
        });
      } else if (widget.status == "1010") {
        widget.controller.sendData({}, "1009");
        return Builder(builder: (context) {
          return Container();
        });
      } else if (widget.status == "1006") {
        if (pay) {
          return dynamicBlock("Make the payment if order is complete", "Pay",
              () {
            widget.controller.sendData({}, "1002");
          });
        } else {
          return dynamicBlock("Extend the 3hrs service to 6hrs", "Extend", () {
            widget.controller.sendData({}, "1007");
            Future.delayed(const Duration(seconds: 1)).then((value) {
              pay = true;
            });
          });
        }
      } else {
        return Container();
      }
    });
  }

  Widget dynamicBlock(
      String textToShow, String buttonText, Function toExecute) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 30,
        ),
        Text(
          textToShow,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
            onPressed: () {
              toExecute();
            },
            child: Text(buttonText)),
      ],
    );
  }

  Widget acceptedBlock(String textToShow, String buttonText) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 30,
        ),
        Text(
          textToShow,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
            onPressed: () {
              widget.controller.sendData({}, "1005");
            },
            child: Text(buttonText)),
        const SizedBox(
          height: 30,
        ),
        const Text(
          "Cancel the order before service man arrives",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
            onPressed: () {
              widget.controller.sendData({}, "1008");
              Get.back();
            },
            child: const Text("Cancel order")),
      ],
    );
  }
}

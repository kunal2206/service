import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/palette.dart';
import '../../../data/models/address.dart';
import '../../../global_widgets/address_dailog.dart';
import '../../../global_widgets/map_container.dart';
import '../../../routes/app_pages.dart';
import '../controllers/address_controller.dart';

class AddressView extends GetView<AddressController> {
  const AddressView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var functionToExecute = Get.arguments.setEnteredAddress;
    BoxConstraints constraints = BoxConstraints(
      maxWidth: MediaQuery.of(context).size.width,
      maxHeight: MediaQuery.of(context).size.height,
    );
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(height: MediaQuery.of(context).padding.top),
                  _nonInputHeadingSection(constraints, context),
                  _mapSection(constraints),
                  _addressSection(constraints, context),
                ],
              ),
            ),
          ),
          Obx(() => controller.submitLoading.value
              ? const CircularProgressIndicator()
              : _submitButton(context, constraints, functionToExecute))
        ],
      ),
    );
  }

  InkWell _submitButton(BuildContext context, BoxConstraints constraints, dynamic functionToExecute) {
    return InkWell(
      onTap: () async {
        Address? savedAddress = await controller.submit();
        if (savedAddress != null && savedAddress.identification == "") {
          Get.dialog(AlertDialog(
            title: const Text("Error"),
            content: const Text("An error occured from our side"),
            actions: [
              TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text("Okay"))
            ],
          ));
        } else if (savedAddress != null) {
          FocusManager.instance.primaryFocus?.unfocus();
          Future.delayed(const Duration(seconds: 1)).then((value) {
            functionToExecute(savedAddress);
            if (Get.arguments.previousRoute == "profile") {
              Get.back();
            } else {
              Get.arguments.submit();
            }
          });
        }
      },
      child: Container(
        height: constraints.maxHeight * 0.08,
        width: constraints.maxWidth,
        decoration: const BoxDecoration(color: blue, boxShadow: [
          BoxShadow(
              color: Colors.grey,
              offset: Offset(-1, -1),
              spreadRadius: 1,
              blurRadius: 5)
        ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Enter your address",
                style: GoogleFonts.aBeeZeeTextTheme()
                    .apply(bodyColor: white)
                    .bodyMedium),
            const SizedBox(
              width: 20,
            ),
            const Icon(
              Icons.map,
              color: white,
            ),
          ],
        ),
      ),
    );
  }

  Form _addressSection(BoxConstraints constraints, BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Container(
        height: constraints.maxHeight * 0.55,
        width: constraints.maxWidth,
        padding: EdgeInsets.symmetric(
            horizontal: constraints.maxWidth * 0.02,
            vertical: constraints.maxHeight * 0.02),
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.streetAddress,
              decoration: const InputDecoration(
                filled: true,
                fillColor: white,
                hintText: "Enter your house no. or locality",
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2.0,
                    color: ultramarineBlue,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Kindly enter the home or street no.";
                }
                return null;
              },
              onSaved: (value) {
                if (value != null) {
                  controller.enteredAddress.value.identification = value;
                }
              },
              onFieldSubmitted: (value) {
                controller.enteredAddress.value.identification = value;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              keyboardType: TextInputType.streetAddress,
              decoration: const InputDecoration(
                filled: true,
                fillColor: white,
                hintText: "Enter nearby landmark",
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2.0,
                    color: ultramarineBlue,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Kindly enter any landmark";
                }
                return null;
              },
              onSaved: (value) {
                if (value != null) {
                  controller.enteredAddress.value.landmark = value;
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              keyboardType: TextInputType.streetAddress,
              decoration: const InputDecoration(
                filled: true,
                fillColor: white,
                hintText: "Enter your city",
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2.0,
                    color: ultramarineBlue,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Kindly enter your city";
                }
                return null;
              },
              onSaved: (value) {
                if (value != null) controller.enteredAddress.value.city = value;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              keyboardType: TextInputType.streetAddress,
              decoration: const InputDecoration(
                filled: true,
                fillColor: white,
                hintText: "Enter your state",
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2.0,
                    color: ultramarineBlue,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Kindly enter your state";
                }
                return null;
              },
              onSaved: (value) {
                if (value != null) {
                  controller.enteredAddress.value.state = value;
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Container _mapSection(BoxConstraints constraints) {
    return Container(
      color: Colors.transparent,
      height: constraints.maxHeight * 0.6,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Obx(
        () => controller.currentLocation.value != null
            ? Stack(
                children: [
                  MapContainer(
                    controller,
                    obtainedHeight: constraints.maxHeight * 0.5,
                  )
                ],
              )
            : const Center(
                child: CircularProgressIndicator(color: lightOrange),
              ),
      ),
    );
  }

  Container _nonInputHeadingSection(
      BoxConstraints constraints, BuildContext context) {
    return Container(
      width: constraints.maxWidth,
      height: constraints.maxHeight * 0.18 - MediaQuery.of(context).padding.top,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: lightOrange,
                    ))
              ],
            ),
          ),
          FittedBox(
            child: Text(
              "Enter Your Address",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: lightOrange,
              ),
            ),
          ),
          FittedBox(
            child: Text(
              "Tap on the screen to change location",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.normal,
                fontSize: 10,
                color: dark,
              ),
            ),
          )
        ],
      ),
    );
  }
}

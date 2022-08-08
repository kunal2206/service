
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../core/constants/palette.dart';
import '../../../data/controllers/bottom_navigation_controller.dart';
import '../../../global_widgets/bottom_navigation_bar.dart';
import '../../../global_widgets/static_widgets/static_page_heading.dart';
import '../../../routes/app_pages.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  void editProfileDialog(BuildContext context) {
    Get.dialog(AlertDialog(
      title: const Text(
        "Edit profile",
        style: TextStyle(color: lightOrange),
      ),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.35,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.name,
                  initialValue: controller.userData.value["Full Name          "],
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: white,
                    hintText: "Enter your Full Name",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2.0,
                        color: lightOrange,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Kindly enter your name";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    if (value != null) controller.editProfileBody["name"] = value;
                  },
                  // onFieldSubmitted: (value) {
                  //   controller.enteredAddress.value.identification = value;
                  // },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  initialValue: controller.userData.value["Email              "],
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: white,
                    hintText: "Enter your email",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2.0,
                        color: ultramarineBlue,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Kindly enter your email";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    if (value != null) {
                      controller.editProfileBody["email"] = value;
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Obx(
                  ()=>controller.submitLoading.value ? const CircularProgressIndicator():   addressSection(BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.9,
                    maxHeight: MediaQuery.of(context).size.height * 0.25,
                  ))
                )
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            controller.submit();
          },
          child: const Text("Okay"),
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  white,
                  Colors.grey,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          const StaticPageHeading(headingName: "Profile"),
          Center(
            child: Obx(
              ()=> controller.submitLoading.value ? const CircularProgressIndicator(): Container(
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: lightOrange,
                  boxShadow: const [
                    BoxShadow(
                        blurRadius: 1,
                        spreadRadius: 1,
                        offset: Offset(1, 1),
                        color: Colors.grey)
                  ],
                ),
                child: LayoutBuilder(
                  builder: (ctx, constraints) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: constraints.maxWidth * 0.1,
                        vertical: constraints.maxHeight * 0.1,
                      ),
                      child: Obx(
                        () => Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: controller.userData.value
                              .map(
                                (key, value) => MapEntry(
                                  key,
                                  profileRow(key, value),
                                ),
                              )
                              .values
                              .toList()
                            ..add(ElevatedButton(
                                onPressed: () => editProfileDialog(context),
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(white)),
                                child: const Text(
                                  "Edit Profile",
                                  style: TextStyle(color: lightOrange),
                                ))),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget profileRow(String item, String itemValue) {
    return Row(
      children: [
        Flexible(
          flex: 3,
          child: Text(
            item,
            textScaleFactor: 1.1,
            style: const TextStyle(
              color: white,
            ),
          ),
        ),
        Expanded(child: Container()),
        const Flexible(
          child: Text(
            ":",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: white,
            ),
            textScaleFactor: 1.1,
          ),
        ),
        const Spacer(),
        Flexible(
          flex: 5,
          child: Text(
            itemValue,
            textScaleFactor: 1.1,
            style: const TextStyle(
              color: white,
            ),
          ),
        )
      ],
    );
  }

  Column addressSection(BoxConstraints constraints) {
    return Column(
      children: [
        InkWell(
          onTap: () => Get.toNamed(Routes.ADDRESS, arguments: controller),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
              width: 2.0,
              color: aliceBlue,
            )),
            height: constraints.maxHeight * 0.25,
            width: constraints.maxWidth,
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: const [
                Icon(
                  Icons.add,
                  color: lightOrange,
                ),
                Text(
                  "Change Address",
                  style: TextStyle(color: lightOrange),
                )
              ],
            ),
          ),
        ),
        
      ],
    );
  }
}


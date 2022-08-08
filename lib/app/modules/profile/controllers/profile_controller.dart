import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '/app/data/models/address.dart';

import '../../../core/config/settings.dart';
import '../../../core/constants/controllers.dart';

class ProfileController extends GetxController {
  String previousRoute = "profile";
  Rx<Map<String, dynamic>> userData = Rx<Map<String, dynamic>>({});
  Rx<bool> userDataLoading = Rx<bool>(false);

  Map<String, dynamic> editProfileBody = {};

  Address? _enteredAddress;

  Rx<Address?> get enteredAddress => Rx<Address?>(_enteredAddress);

  Rx<bool> submitLoading = Rx<bool>(false);

  void setEnteredAddress(Address? givenAddress) {
    _enteredAddress = givenAddress;
    editProfileBody["address"] = [_enteredAddress?.id];
  }

  final GlobalKey<FormState> formKey = GlobalKey();

  String? submit() {
    if (!formKey.currentState!.validate()) {
      return null;
    }
    formKey.currentState!.save();
    Get.back();
    updateProfile(editProfileBody).then((_) {
      userDataLoading.value = true;
    }).catchError((err) {
      userDataLoading.value = true;
      findProfile().then((_) {
        userDataLoading.value = true;
      }).catchError((err) {
        userDataLoading.value = true;
        userData.value = {
          "Address            ": "No address saved yet",
          "Email              ": "No email saved yet",
          "Full Name          ": "Guest",
          "Phone Number       ": (authController.phoneNumber).toString()
        };
      });
    });
    editProfileBody = {};
    return null;
  }

  @override
  void onInit() {
    super.onInit();
    findProfile().then((_) {
      userDataLoading.value = true;
    }).catchError((err) {
      print(err);
      userDataLoading.value = true;
      userData.value = {
        "Address            ": "No address saved yet",
        "Email              ": "No email saved yet",
        "Full Name          ": "Guest",
        "Phone Number       ": (authController.phoneNumber).toString()
      };
    });
  }

  Future<String> findAddress(String addressId) async {
    submitLoading.value = true;
    final url = Uri.parse("$UPDATE_ADDRESS/$addressId");
    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({}),
      );
      final responseData = json.decode(response.body);
      try {
        if (responseData["message"] == "No such address exists with that id") {
          return "";
        }
      } catch (e) {
        rethrow;
      }
      submitLoading.value = false;
      return responseData["data"]["full_address"];
    } catch (error) {
      print(error);
      submitLoading.value = false;
      rethrow;
    }
  }

  Future<void> findProfile() async {
    submitLoading.value = true;
    final url = Uri.parse("$USER_BY_PHONENUMBER/${authController.phoneNumber}");
    userDataLoading.value = true;
    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body);

      List<String> addressIDs = [];
      for (int i = 0; i < responseData["data"]["address"].length; i++) {
        addressIDs.add(await findAddress(responseData["data"]["address"][i]));
      }

      userData.value = {
        "Address            ": responseData["data"]["address"].length > 0
            ? addressIDs[0]
            : "No address saved yet",
        "Email              ": responseData["data"]["email"] ?? "Not yet added",
        "Full Name          ": responseData["data"]["name"] ?? "Not yet added",
        "Phone Number       ": (responseData["data"]["phonenumber"]).toString()
      };
    } catch (error) {
      rethrow;
    }
    submitLoading.value = false;
  }

  Future<void> updateProfile(Map<String, dynamic> editProfileBody) async {
    submitLoading.value = true;
    final url = Uri.parse("$UPDATE_USER/${authController.phoneNumber}");
    userDataLoading.value = true;
    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(editProfileBody),
      );
      final responseData = json.decode(response.body);

      List<String> addressIDs = [];
      for (int i = 0; i < responseData["data"]["address"].length; i++) {
        addressIDs.add(await findAddress(responseData["data"]["address"][i]));
      }

      userData.value = {
        "Address            ": responseData["data"]["address"].length > 0
            ? addressIDs[0]
            : "No address saved yet",
        "Email              ": responseData["data"]["email"] ?? "Not yet added",
        "Full Name          ": responseData["data"]["name"] ?? "Not yet added",
        "Phone Number       ": (responseData["data"]["phonenumber"]).toString()
      };
    } catch (error) {
      rethrow;
    }
    submitLoading.value = false;
  }
}

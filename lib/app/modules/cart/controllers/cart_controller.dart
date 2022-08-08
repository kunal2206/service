import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:get/get.dart';

import '../../../core/config/settings.dart';
import '../../../core/constants/controllers.dart';
import '../../../data/models/address.dart';

class CartController extends GetxController {
  String previousRoute = "cart";
  Rx<Map<String, dynamic>> userAddress = Rx<Map<String, dynamic>>({});

  Map<String, dynamic> editProfileBody = {};

  Address? _enteredAddress;

  Rx<Address?> get enteredAddress => Rx<Address?>(_enteredAddress);

  Rx<bool> submitLoading = Rx<bool>(false);

  void addressPopUp(
    BuildContext context,
    Widget content,
    List<Widget> actions,
  ) {
    Get.dialog(AlertDialog(
        title: const Text("Enter the address"),
        content: content,
        actions: actions));
  }

  void setEnteredAddress(Address? givenAddress) {
    _enteredAddress = givenAddress;
    editProfileBody["address"] = [_enteredAddress?.id];
  }

  String? submit() {
    Get.back();
    submitLoading.value = true;
    updateProfile(editProfileBody).then((_) {
      submitLoading.value = false;
    }).catchError((err) {
      submitLoading.value = false;
      findProfile().then((_) {
        submitLoading.value = false;
      }).catchError((err) {
        submitLoading.value = false;
        userAddress.value = {"address": "No address saved yet", "id": null};
      });
    });
    editProfileBody = {};
    return null;
  }

  @override
  void onInit() {
    super.onInit();
    submitLoading.value = true;
    findProfile().then((_) {
      submitLoading.value = false;
    }).catchError((err) {
      submitLoading.value = false;
      userAddress.value = {"address": "No address saved yet", "id": null};
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
      submitLoading.value = false;
      return responseData["data"]["full_address"];
    } catch (error) {
      submitLoading.value = false;
      rethrow;
    }
  }

  Future<void> findProfile() async {
    submitLoading.value = true;
    final url = Uri.parse("$USER_BY_PHONENUMBER/${authController.phoneNumber}");
    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body);

      List<String> addressIDs = [];
      for (int i = 0; i < responseData["data"]["address"].length; i++) {
        addressIDs.add(await findAddress(responseData["data"]["address"][i]));
      }

      print("response${responseData["data"]}");
      userAddress.value = {
        "address": responseData["data"]["address"].length > 0
            ? addressIDs[0]
            : "No address saved yet",
        "user_id": responseData["data"]["_id"],
        "address_id": responseData["data"]["address"][0]
      };
    } catch (error) {
      rethrow;
    }
    submitLoading.value = false;
  }

  Future<void> updateProfile(Map<String, dynamic> editProfileBody) async {
    submitLoading.value = true;
    final url = Uri.parse("$UPDATE_USER/${authController.phoneNumber}");
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

      userAddress.value = {
        "address": responseData["data"]["address"].length > 0
            ? addressIDs[0]
            : "No address saved yet",
        "user_id": responseData["data"]["_id"],
        "address_id": responseData["data"]["address"][0]
      };
    } catch (error) {
      rethrow;
    }
    submitLoading.value = false;
  }
}

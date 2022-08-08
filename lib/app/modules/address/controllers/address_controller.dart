import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/controllers.dart';
import '../../../data/models/address.dart';
import '../../../data/models/latlong_data.dart';
import '/app/core/config/settings.dart';

class AddressController extends GetxController {
  final Rx<LatLng?> _selectedPoint = Rx<LatLng?>(null);
  final Rx<Address> enteredAddress = Rx<Address>(
      Address(city: "", identification: "", landmark: "", state: ""));
  final Rx<double> zoom = Rx<double>(16);
  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  void onInit() {
    super.onInit();
    startTracking();
  }

  LatLng? get selectedPoint => _selectedPoint.value;

  set selectedPoint(LatLng? point) => _selectedPoint.value = point;

  Address savedAddress =
      Address(city: "", identification: "", landmark: "", state: "");

  Rx<bool> submitLoading = Rx<bool>(false);

  Future<Address?> submit() async {
    submitLoading.value = true;
    if (!formKey.currentState!.validate()) {
      return null;
    }
    formKey.currentState!.save();
    await addAddress();
    submitLoading.value = false;
    return savedAddress;
  }

  void startTracking() async {
    if (await locationController.requestPermissions()) {
      locationController.subscribePosition(LocationAccuracy.best);
    }
  }

  

  Rx<LatlngData?> get currentLocation {
    //all the data of location Controller will be received in this controller
    return locationController.currentLocation;
  }

  @override
  void onClose() {
    //dispose the controller as it will again be created for other controllers
    locationController.unsubscribePosition();
  }

  Future<void> addAddress() async {
    final url = Uri.parse(ADD_ADDRESS);

    savedAddress = enteredAddress.value;

    try {
      Map<String, dynamic>? data;
      if (selectedPoint != null) {
        data = enteredAddress.value.toJson(location: selectedPoint!);
      }
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );
      final responseData = json.decode(response.body);

      var fetchedAddress = responseData["data"];

      savedAddress = Address(
          id: fetchedAddress["_id"],
          city: fetchedAddress["city"],
          identification: fetchedAddress["identification"],
          landmark: fetchedAddress["landmark"],
          state: fetchedAddress["state"]);
    } catch (error) {
      savedAddress =
          Address(city: "", identification: "", landmark: "", state: "");
      rethrow;
    }
  }
}

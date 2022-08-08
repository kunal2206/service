import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/services.dart';

class PrivacyPolicyController extends GetxController {
  Future<List<dynamic>> readFromJsonData() async {
    final jsonData =
        await rootBundle.loadString("assets/json_files/privacy_policy.json");

    return json.decode(jsonData) as List<dynamic>;
  }
}

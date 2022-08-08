import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/services.dart';

class TermsAndConditionsController extends GetxController {
  ///to get the data from a local json files stored in the assets
  Future<List<dynamic>> readFromJsonData() async {
    final jsonData = await rootBundle
        .loadString("assets/json_files/terms_and_conditions.json");

    return json.decode(jsonData) as List<dynamic>;
  }
}

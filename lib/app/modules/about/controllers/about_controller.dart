import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/services.dart';

class AboutController extends GetxController {
  Future<List<dynamic>> readFromJsonData() async {
    final jsonData =
        await rootBundle.loadString("assets/json_files/about_us.json");

    return json.decode(jsonData) as List<dynamic>;
  }
}

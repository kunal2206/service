import 'dart:convert';

import 'package:get/get.dart';

import 'package:flutter/services.dart';

class FaqController extends GetxController {
  Future<List<dynamic>> readFromJsonData() async {
    final jsonData =
        await rootBundle.loadString("assets/json_files/how_to_use.json");

    ///generally the data obtained is of the type List<dynamic>
    return json.decode(jsonData) as List<dynamic>;
  }
}

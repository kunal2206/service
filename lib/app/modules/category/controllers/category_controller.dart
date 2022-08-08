import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../core/config/settings.dart';
import '../../../data/models/service.dart';

class CategoryController extends GetxController {
  final Rx<List<Service>> services = Rx<List<Service>>([]);

  final Rx<bool> _servicesFirstLoad = Rx<bool>(false);

  void fetchServices(String subCategoryId) {
    if (!_servicesFirstLoad.value) {
      getAllProductsBySubCategoryId(subCategoryId).then((value) {
        _servicesFirstLoad.value = true;
        services.value = value;
      });
    }
  }

  Future<List<Service>> getAllProductsBySubCategoryId(
      String subcategoryID) async {
    final url = Uri.parse(SUBCATEGORY_BY_ID + subcategoryID);

    List<Service> servicesByCategoryId = [];

    try {
      final data = {"children": true};
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );
      final responseData = json.decode(response.body);

      for (int i = 0; i < responseData["data"]["children"].length; i++) {
        var fetchedService = responseData["data"]["children"][i];
        servicesByCategoryId.add(
          Service(
            id: fetchedService["_id"],
            serviceName: fetchedService["title"],
            salePrice: fetchedService["sale_price"],
            markedPrice: fetchedService["marked_price"],
            description: fetchedService["description"],
            serviceDiscount: fetchedService["discount"],
            serviceImageUrl: "",
            categoryId: fetchedService["parent_id"],
          ),
        );
      }
    } catch (error) {
      rethrow;
    }
    return servicesByCategoryId;
  }
}

import 'dart:convert';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../core/config/settings.dart';
import '../../../core/constants/controllers.dart';
import '../../../data/models/category.dart';
import '../../../data/models/sub_category.dart';

class HomeController extends GetxController {
  // Rx<int> currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    if (authController.isAuth.value) {
      final service = FlutterBackgroundService();
      service.isRunning().then((value) {
        if (!value) {
          service.startService();
        }
      });
    }
  }

  Future<String> findUserId() async {
    final url = Uri.parse("$USER_BY_PHONENUMBER/${authController.phoneNumber}");
    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body);

      return responseData["data"]["_id"];
    } catch (error) {
      rethrow;
    }
  }

  final Rx<List<String>> _carouselUrl = Rx<List<String>>([]);

  final Rx<bool> _carouselUrlFirstLoad = Rx<bool>(false);

  Rx<List<String>> get carouselUrl {
    if (!_carouselUrlFirstLoad.value) {
      getAllBanners().then((value) {
        _carouselUrlFirstLoad.value = true;
        return _carouselUrl.value = value;
      });
    }
    return _carouselUrl;
  }

  Future<List<String>> getAllBanners() async {
    final url = Uri.parse(ALL_BANNERS);

    try {
      final data = {};
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );
      final responseData = json.decode(response.body);
      final List<String> convertedData = [];
      for (int i = 0; i < responseData["data"].length; i++) {
        convertedData
            .add(flaskBackendURI + responseData["data"][i]["image_path"]);
      }
      return convertedData;
    } catch (error) {
      rethrow;
    }
  }

  final Rx<Map<String, List<Category>>> _categoriesBySection =
      Rx<Map<String, List<Category>>>({});

  final Rx<bool> _categoriesBySectionFirstLoad = Rx<bool>(false);

  Rx<Map<String, List<Category>>> get categoriesBySection {
    if (!_categoriesBySectionFirstLoad.value) {
      getAllCategoriesBySection().then((value) {
        _categoriesBySectionFirstLoad.value = true;
        _categoriesBySection.value = value;
      });
    }
    return _categoriesBySection;
  }

  Future<Map<String, List<Category>>> getAllCategoriesBySection() async {
    final url = Uri.parse(ALL_CATEGORIES);

    final Map<String, List<Category>> sectionMapContainingCategoryList = {};
    try {
      final data = {"children": true};
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );
      final responseData = json.decode(response.body);

      List<String> subCategoryTitleList = [];
      for (int i = 0; i < responseData["data"].length; i++) {
        subCategoryTitleList = [];
        dynamic categoryData = responseData["data"][i];
        final List<SubCategory> subCategoryList = [];
        if (!categoryData["children"].isEmpty) {
          for (int i = 0; i < categoryData["children"].length; i++) {
            dynamic subCategoryData = categoryData["children"][i];

            subCategoryList.add(SubCategory(
                id: subCategoryData["_id"],
                subCategoryName: subCategoryData["title"]));
            subCategoryTitleList.add(subCategoryData["title"]);
          }
        }

        //to check whether subcategory has repair and installation

        Category category = Category(
            id: categoryData["_id"],
            categoryName: categoryData["title"],
            categoryImageUrl: flaskBackendURI + categoryData["image_path"],
            categoryCarouselImageUrl:
                flaskBackendURI + categoryData["carousel_image_path"],
            section: categoryData["section"],
            categoryMaxDiscount: categoryData["max_discount"],
            children: subCategoryList,
            containsType: subCategoryTitleList.contains("Repair Work") &&
                subCategoryTitleList.contains("Installation"));
        if (sectionMapContainingCategoryList.keys
            .contains(categoryData["section"])) {
          sectionMapContainingCategoryList[categoryData["section"]]!
              .add(category);
        } else {
          sectionMapContainingCategoryList[categoryData["section"]] = [
            category,
          ];
        }
      }
    } catch (error) {
      rethrow;
    }

    return sectionMapContainingCategoryList;
  }
}

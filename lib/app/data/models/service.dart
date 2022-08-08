import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../core/config/settings.dart';

class Service {
  final String id;
  final String serviceName;
  final double salePrice;
  final double markedPrice;

  final String description;

  final bool popular;

  final String categoryId;

  final Rx<int> quantity = Rx<int>(0);

  final double? serviceDiscount;
  final String serviceImageUrl;

  Service({
    required this.id,
    required this.serviceName,
    required this.salePrice,
    required this.markedPrice,
    required this.description,
    this.serviceDiscount,
    required this.serviceImageUrl,
    this.popular = false,
    required this.categoryId,
  });
}

final Rx<List<Service>> _popularServices = Rx<List<Service>>([]);

Rx<List<Service>> get popularServices => _popularServices;

Rx<bool> popularSearchesLoaded = Rx<bool>(false);

void fetchPopularServices() {
  popularSearchesLoaded.value = true;
  getPopularServices().then((listOfServices) {
    popularSearchesLoaded.value = false;
    return _popularServices.value = listOfServices;
  });
}

Future<List<Service>> getPopularServices() async {
  final url = Uri.parse(POPULAR_SERVICES);

  List<Service> fetchedPopularServices = [];

  try {
    final response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
    final responseData = json.decode(response.body);

    for (int i = 0; i < responseData["data"].length; i++) {
      dynamic fetchedService = responseData["data"][i];
      fetchedPopularServices.add(Service(
        id: fetchedService["_id"],
        serviceName: fetchedService["title"],
        salePrice: fetchedService["sale_price"],
        markedPrice: fetchedService["marked_price"],
        description: fetchedService["description"],
        serviceDiscount: fetchedService["discount"],
        serviceImageUrl: "",
        categoryId: fetchedService["parent_id"],
      ));
    }
    return fetchedPopularServices;
  } catch (error) {
    return fetchedPopularServices;
  }
}

final Rx<List<Service>> _searchResults = Rx<List<Service>>([]);

final Rx<bool> searching = Rx<bool>(false);

Rx<List<Service>> get searchResults => _searchResults;

void fetchSearchResults(String text) {
  searching.value = true;
  getSearchResults(text).then((listOfServices) {
    _searchResults.value = listOfServices;
    searching.value = false;
  });
}

Future<List<Service>> getSearchResults(String text) async {
  final url = Uri.parse(SEARCH_PRODUCTS);

  List<Service> fetchedSearchResults = [];

  try {
    final data = {"search_text": text};

    final response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: json.encode(data));

    final responseData = json.decode(response.body);

    for (int i = 0; i < responseData["data"].length; i++) {
      dynamic fetchedService = responseData["data"][i];
      fetchedSearchResults.add(Service(
        id: fetchedService["_id"],
        serviceName: fetchedService["title"],
        salePrice: fetchedService["sale_price"],
        markedPrice: fetchedService["marked_price"],
        description: fetchedService["description"],
        serviceDiscount: fetchedService["discount"],
        serviceImageUrl: "",
        categoryId: fetchedService["parent_id"],
      ));
    }
    return fetchedSearchResults;
  } catch (error) {
    return fetchedSearchResults;
  }
}

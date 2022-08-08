import 'dart:convert';

import 'package:get/get.dart';

import 'package:http/http.dart' as http;

import '../../core/config/settings.dart';
import 'service.dart';

class CartItem {
  final String serviceId;
  Service? service;
  Rx<int> quantity = Rx<int>(0);

  CartItem({this.service, required this.serviceId});
}

void addServiceToCart(String serviceId, Service service) {
  Map<String, CartItem> temporaryCart = {};
  for (var serviceId in cart.value.keys) {
    temporaryCart[serviceId] = cart.value[serviceId]!;
  }
  temporaryCart[serviceId] = CartItem(serviceId: serviceId, service: service);
  cart.value = temporaryCart;
}

void removeServiceFromCart(String receivedServiceId) {
  Map<String, CartItem> temporaryCart = {};
  for (var serviceId in cart.value.keys) {
    temporaryCart[serviceId] = cart.value[serviceId]!;
  }
  temporaryCart.remove(receivedServiceId);
  cart.value = temporaryCart;
}

bool serviceIdPresent(String serviceId) {
  return cart.value.keys.contains(serviceId);
}

CartItem? getCartItem(String id) {
  return cart.value[id] != null ? cart.value[id]! : null;
}

Rx<Map<String, CartItem>> cart = Rx<Map<String, CartItem>>({});

List<Service> servicesInCart() {
  return cart.value.keys
      .map((serviceId) => cart.value[serviceId]!.service!)
      .toList();
}

updateCartServices() async {
  for (var serviceId in cart.value.keys) {
    await getServiceById(serviceId).then((value) {
      if (value != null) {
        cart.value[serviceId]!.service = value;
      } else {
        removeServiceFromCart(serviceId);
      }
    });
  }
}

Future<Service?> getServiceById(String serviceId) async {
  final url = Uri.parse(SERVICE_BY_ID + serviceId);

  Service? service;

  try {
    final response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
    final responseData = json.decode(response.body);
    if (responseData["status"] == false) {
      service = null;
    } else {
      var fetchedService = responseData["data"];

      service = Service(
        id: fetchedService["_id"],
        serviceName: fetchedService["title"],
        salePrice: fetchedService["sale_price"],
        markedPrice: fetchedService["marked_price"],
        description: fetchedService["description"],
        serviceDiscount: fetchedService["discount"],
        serviceImageUrl: "",
        categoryId: fetchedService["parent_id"],
      );
    }
  } catch (error) {
    rethrow;
  }
  return service;
}

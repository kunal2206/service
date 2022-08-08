import 'dart:convert';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/config/settings.dart';
import '../../../data/models/order.dart';
import '../../../data/models/service.dart';

class OrderDetailsController extends GetxController {
  Rx<Order?> ongoingOrder = Rx<Order?>(null);

  @override
  void onInit() async {
    super.onInit();
    ongoingOrder.value = null;
  }

  void updateOrder(Order order) async {
    ongoingOrder.value = await findOrderById(order.id);
    if (ongoingOrder.value!.status == "1001") {}
  }

  void sendData(Map<String, dynamic> extra, String statusCode) async {
    final service = FlutterBackgroundService();
    var isRunning = await service.isRunning();

    if (isRunning) {
      service.invoke("sendData", {
        "orderId": ongoingOrder.value!.id,
        "statusCode": statusCode,
        "receivers": [ongoingOrder.value!.serviceMan],
        "extra": extra
      });
    }
  }

  Future<Order> findOrderById(String orderId) async {
    final url = Uri.parse("$ORDER_BY_ID/$orderId");
    try {
      final response =
          await http.get(url, headers: {"Content-Type": "application/json"});
      final responseData = json.decode(response.body);
      List<OrderItem> orderItems = [];
      for (int j = 0; j < responseData["data"]["order_items"].length; j++) {
        orderItems.add(OrderItem(
            id: responseData["data"]["order_items"][j]["_id"],
            productId: responseData["data"]["order_items"][j]["product_id"],
            quantity: responseData["data"]["order_items"][j]["quantity"],
            salePrice: responseData["data"]["order_items"][j]["sale_price"]));
      }
      return Order(
          id: responseData["data"]["_id"],
          addressName: responseData["data"]["address_name"],
          serviceMan: responseData["data"]["serviceperson_id"],
          status: responseData["data"]["status"],
          orderItems: orderItems,
          createdAt: responseData["data"]["created_at"].toString());
    } catch (error) {
      rethrow;
    }
  }

  Future<Service> findServiceById(String serviceId) async {
    final url = Uri.parse("$SERVICE_BY_ID/$serviceId");
    try {
      final response =
          await http.get(url, headers: {"Content-Type": "application/json"});
      final responseData = json.decode(response.body);
      print(responseData);
      return Service(
          id: responseData["data"]["_id"],
          serviceName: responseData["data"]["title"],
          salePrice: responseData["data"]["sale_price"],
          markedPrice: responseData["data"]["marked_price"],
          description: responseData["data"]["description"],
          serviceImageUrl: "",
          categoryId: responseData["data"]["parent_id"]);
    } catch (error) {
      rethrow;
    }
  }

  Future<String> findServiceman(String servicemanId) async {
    final url = Uri.parse("$FIND_SERVICEMAN/$servicemanId");
    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );
      final responseData = json.decode(response.body);
      if (responseData["message"] == "No such service man") {
        return "Can't Load";
      }
      return responseData["data"]["phonenumber"];
    } catch (error) {
      rethrow;
    }
  }
}

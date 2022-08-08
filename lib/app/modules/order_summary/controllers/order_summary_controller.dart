import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../core/config/settings.dart';
import '../../../data/models/order.dart';

class OrderSummaryController extends GetxController {
  final Rx<bool> placeOrderPressed = Rx<bool>(false);

  Rx<bool> submitLoading = Rx<bool>(false);

  Rx<List<Order>> placedOrders = Rx<List<Order>>([]);

  Rx<double> totalAmount = Rx<double>(0);

  String userId = "";

  void deleteOrder(String orderId) async {
    submitLoading.value = true;
    final url = Uri.parse("$DELETE_ORDER/$orderId");
    try {
      await http.delete(url, headers: {"Content-Type": "application/json"});
    } catch (error) {
      rethrow;
    }
    submitLoading.value = false;
  }

  Future<String> findServiceById(String serviceId) async {
    final url = Uri.parse("$SERVICE_BY_ID/$serviceId");
    try {
      final response =
          await http.get(url, headers: {"Content-Type": "application/json"});
      final responseData = json.decode(response.body);
      return responseData["data"]["title"].toString();
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

  void servicesWithNoServiceman(var services) {
    Get.dialog(AlertDialog(
      title: const Text("Alert"),
      content: SizedBox(
        height: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("No serviceman found for the services:"),
            const SizedBox(
              width: 20,
            ),
            ...services.map((service) => Text(service)).toList(),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text("Okay"))
      ],
    ));
  }

  void addOrders(orderBody) async {
    submitLoading.value = true;
    userId = orderBody["user_id"];
    final url = Uri.parse(ADD_ORDER);
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(orderBody),
      );
      final responseData = json.decode(response.body);
      if (responseData["pending_list"].length > 0) {
        List<String> pendingServicesName = [];
        for (int i = 0; i < responseData["pending_list"].length; i++) {
          pendingServicesName
              .add(await findServiceById(responseData["pending_list"][i]));
        }
        servicesWithNoServiceman(pendingServicesName);
      }
      List<Future<Order>> futureResponse =
          await responseData["data"].keys.map<Future<Order>>((key) async {
        List<OrderItem> orderItems = [];
        for (int j = 0;
            j < responseData["data"][key]["order_items"].length;
            j++) {
          var serviceName = await findServiceById(
              responseData["data"][key]["order_items"][j]["product_id"]);
          orderItems.add(OrderItem(
              id: responseData["data"][key]["order_items"][j]["_id"],
              productId: serviceName,
              quantity: responseData["data"][key]["order_items"][j]["quantity"],
              salePrice: responseData["data"][key]["order_items"][j]
                  ["sale_price"]));
        }
        return Order(
            id: responseData["data"][key]["_id"],
            addressName: responseData["data"][key]["address_name"],
            serviceMan: responseData["data"][key]["serviceperson_id"],
            status: responseData["data"][key]["status"],
            createdAt: responseData["data"][key]["created_at"],
            orderItems: orderItems);
      }).toList();

      for (int i = 0; i < futureResponse.length; i++) {
        Order order = await futureResponse[i];
        if (order.orderItems != null) {
          for (int j = 0; j < order.orderItems!.length; j++) {
            totalAmount.value = totalAmount.value +
                order.orderItems![j].quantity * order.orderItems![j].salePrice;
          }
        }
        placedOrders.value.add(order);
      }
      final service = FlutterBackgroundService();
      for (var order in placedOrders.value) {
        service.invoke("ordersList", {
          "orderId": order.id,
          "statusCode": "1001",
          "receivers": [order.serviceMan],
          "extra": {}
        });
      }
    } catch (error) {
      rethrow;
    }
    submitLoading.value = false;
  }

  void changePlaceOrderPressed() async {
    placeOrderPressed.value = true;
    final service = FlutterBackgroundService();
    service.invoke("hitUserId", {"userId": userId});
    await Future.delayed(const Duration(seconds: 1));
    service.invoke("orderPlaced", {});
  }

  @override
  void onClose() {
    super.onClose();
    if (!placeOrderPressed.value) {
      for (var i = 0; i < placedOrders.value.length; i++) {
        deleteOrder(placedOrders.value[i].id);
      }
      Get.back();
    }
    placedOrders.value = [];
  }
}

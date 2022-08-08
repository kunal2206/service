import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../core/config/settings.dart';
import '../../../core/constants/controllers.dart';
import '../../../data/models/order.dart';

class BookingsController extends GetxController {
  Rx<List<Order>> orders = Rx<List<Order>>([]);

  String? userId;

  Rx<bool> allOrdersLoaded = Rx<bool>(false);
  @override
  void onInit() {
    super.onInit();
    orderByUserId().then((value) {
      allOrdersLoaded.value = true;
    }).catchError((_) {});
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

  Future<void> orderByUserId() async {
    final url = Uri.parse("$ORDER_BY_USER_ID/${authController.phoneNumber!}");

    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );
      final responseData = json.decode(response.body);
      List<OrderItem> orderItems = [];

      for (int i = 0; i < responseData["data"].length; i++) {
        orderItems = [];
        for (int j = 0;
            j < responseData["data"][i]["order_items"].length;
            j++) {
          orderItems.add(OrderItem(
              id: responseData["data"][i]["order_items"][j]["_id"],
              productId: responseData["data"][i]["order_items"][j]
                  ["product_id"],
              quantity: responseData["data"][i]["order_items"][j]["quantity"],
              salePrice: double.parse(responseData["data"][i]["order_items"][j]
                      ["sale_price"]
                  .toString())));
        }
        userId =  responseData["data"][i]["user_id"] as String;
        orders.value.add(Order(
            id: responseData["data"][i]["_id"],
            addressName: responseData["data"][i]["address_name"],
            serviceMan: responseData["data"][i]["serviceperson_id"],
            status: responseData["data"][i]["status"],
            orderItems: orderItems,
            createdAt: responseData["data"][i]["created_at"].toString()));
      }
    } catch (error) {
      orders.value = [];
    }
  }
}

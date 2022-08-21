import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/config/settings.dart';
import '../../core/constants/controllers.dart';
import '../controllers/socket_controller.dart';

String? userId;

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: _onStart,

      // auto start service
      autoStart: false,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: false,

      // this will be executed when app is in foreground in separated isolate
      onForeground: _onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
  // service.startService();
}

// to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch
bool onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();
  return true;
}

void _onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  List<Map<String, dynamic>?> placedOrders = [];
  List<Map<String, dynamic>?> temporaryPlacedOrders = [];

  Get.put(SocketController());

  print("started");

  final prefs = await SharedPreferences.getInstance();
  final storedValues = prefs.get("userData");
  final String phoneNumber =
      json.decode(storedValues.toString())!["phonenumber"];

  await findUserId(phoneNumber).then((id) {
    if (id != null) {
      userId = id;
    }
  });

  socketController.openConnection(userId!);

  socketController.channel?.stream.listen((event) async {
    Map<String, dynamic> orderData = json.decode(event);

    print("orderData${orderData.toString()}");

    if (orderData["status"]["statusCode"] == 1004) {
      for (var order in placedOrders) {
        if (order!["orderId"] == orderData["orderId"]) {
          placedOrders.remove(order);
          break;
        }
      }
    }

    service.invoke('receiveOrderStatus', orderData);
  });

  service.on('ordersList').listen((event) {
    temporaryPlacedOrders.add(event);
  });

  service.on('orderPlaced').listen((event) {
    placedOrders = temporaryPlacedOrders;
  });

  service.on('sendData').listen((event) {
    socketController.sendMessage(event!);
    if (event["statusCode"] == "1005") {
      service.invoke('receiveOrderStatus', {
        "orderId": event["orderId"],
        "senderId": event["receivers"][0],
        "status": {"statusCode": 1005, "statusMessage": "STARTED"},
        "extra": {}
      });
    }
  });

  Timer.periodic(const Duration(seconds: 10), (timer) async {
    if (placedOrders.isNotEmpty) {
      for (var event in placedOrders) {
        socketController.sendMessage(event!);
      }
    }
  });

  service.on('stopService').listen((event) async {
    socketController.closeConnection();
    service.stopSelf();
  });
}

Future<String?> findUserId(String phoneNumber) async {
  final url = Uri.parse("$USER_BY_PHONENUMBER/$phoneNumber");
  try {
    final response = await http.get(url);
    final responseData = json.decode(response.body);
    return responseData["data"]["_id"];
  } catch (error) {
    print(error);
  }
  return null;
}

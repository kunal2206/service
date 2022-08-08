import 'dart:convert';

import 'package:get/get.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../core/config/settings.dart';

class SocketController extends GetxController {
  static SocketController instance = Get.find();

  WebSocketChannel? channel;

  openConnection(String servicemanId) async {
    if (channel != null) {
      await channel!.sink.close();
    }

    channel = IOWebSocketChannel.connect("$WEBSOCKETURI=$servicemanId");
  }

  void sendMessage(Map<String, dynamic> data) {
    if (channel != null) {
      channel!.sink.add(json.encode(data));
    }
  }

  closeConnection() {
    if (channel != null) {
      channel!.sink.close();
    }
  }

  // {
  //   "orderId" : "62c99e80c2d8831ddf2bac96",
  //   "statusCode" : "1009",
  //   "receivers" : [
  //     "62c92efb26bc7b45acab794a"
  //   ],
  //   "extra" : {
  //     "name" : "Server"
  //   }
  // }
}

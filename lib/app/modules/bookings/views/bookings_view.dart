import 'package:fixpals_app/app/core/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import 'package:get/get.dart';

import '../../../core/constants/palette.dart';
import '../../../data/models/order.dart';
import '../../../global_widgets/bottom_navigation_bar.dart';
import '../../../global_widgets/custom_app_bar.dart';
import '../controllers/bookings_controller.dart';
import '../widgets/details_button.dart';

class BookingsView extends GetView<BookingsController> {
  const BookingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppBar bookingAppBar = customAppBar(
      [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.2,
        )
      ],
      Container(
        color: white,
        height: MediaQuery.of(context).size.height * 0.045,
        alignment: Alignment.center,
        child: const Text(
          " Bookings ",
          style: TextStyle(color: midnightGreen),
        ),
      ),
      IconButton(
        onPressed: () {
          Get.back();
        },
        icon: const Icon(Icons.arrow_back_ios_new, color: white),
      ),
    );
    return Scaffold(
      appBar: bookingAppBar,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Obx(() => controller.allOrdersLoaded.value
              ? controller.orders.value.isNotEmpty
                  ? Container(
                      height: constraints.maxHeight,
                      width: constraints.maxWidth,
                      margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.03,
                        vertical: MediaQuery.of(context).size.height * 0.01,
                      ),
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return orderBlock(
                              constraints, controller.orders.value.reversed.toList()[index]);
                        },
                        itemCount: controller.orders.value.length,
                      ),
                    )
                  : const Center(
                      child: Text("Order something to see it in Bookings"),
                    )
              : const Center(
                  child: CircularProgressIndicator(),
                ));
        },
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget orderBlock(BoxConstraints constraints, Order order) {
    return Container(
      height: constraints.maxHeight * 0.35,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: cafeAuLait, width: 1),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Column(
            children: [
              Flexible(
                flex: 7,
                child: LayoutBuilder(builder: (context, constraints) {
                  var height = constraints.maxHeight;
                  var width = constraints.maxWidth;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Order Id",
                              style: TextStyle(
                                  color: lightOrange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                            SizedBox(
                              width: width * 0.05,
                            ),
                            Text(
                              "#${order.id.substring(15)}",
                              style: const TextStyle(
                                  color: lightOrange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            )
                          ],
                        ),
                        SizedBox(
                          height: height * 0.05,
                        ),
                        SizedBox(
                          height: height * 0.4,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  const Text(
                                    "Service contact detail",
                                    style: TextStyle(
                                        color: lightOrange,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  FutureBuilder(
                                      future: controller
                                          .findServiceman(order.serviceMan),
                                      builder: ((context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          return Row(
                                            children: [
                                              Text(
                                                snapshot.data.toString(),
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12),
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  await FlutterPhoneDirectCaller
                                                        .callNumber(snapshot
                                                            .data
                                                            .toString());
                                                },
                                                child: const Icon(
                                                  Icons.call, 
                                                  color: lightOrange,
                                                ),
                                              ),
                                            ],
                                          );
                                        } else {
                                          return const Text(
                                            "Loading ...",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          );
                                        }
                                      })),
                                 
                                ],
                              ),
                              Column(
                                children: [
                                  const Text(
                                    "Order Status",
                                    style: TextStyle(
                                        color: lightOrange,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    statusToString(codeToStatus(order.status)),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.pin_drop,
                              color: lightOrange,
                            ),
                            SizedBox(
                              width: width * 0.1,
                            ),
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                height:
                                    MediaQuery.of(context).size.height * 0.03,
                                child: Builder(builder: (context) {
                                  String orderAddress = "";
                                  for (int i = 0;
                                      i <
                                          order.addressName.split(",").length -
                                              2;
                                      i++) {
                                    orderAddress = orderAddress == ""? "$orderAddress${order.addressName.split(",")[i]}":"$orderAddress, ${order.addressName.split(",")[i]}";
                                  }
                                  return Text(orderAddress.capitalize!);
                                })),
                          ],
                        ),
                        
                        Row(
                          children: [
                            const Text(
                              "Date",
                              style: TextStyle(
                                color: lightOrange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: width * 0.1,
                            ),
                            Text(order.createdAt),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ),
              Flexible(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth * 0.1,
                    vertical: constraints.maxHeight * 0.02,
                  ),
                  child: OrderDetailsButton(
                    controller:controller,
                    order: order,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

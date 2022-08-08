import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../core/constants/palette.dart';
import '../../../global_widgets/bottom_cart_total.dart';
import '../../../global_widgets/custom_app_bar.dart';
import '../../../routes/app_pages.dart';
import '../controllers/order_summary_controller.dart';
import '../widgets/order_by_service.dart';

class OrderSummaryView extends GetView<OrderSummaryController> {
  const OrderSummaryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.addOrders(Get.arguments);
    AppBar orderSummaryAppBar = customAppBar(
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
          "   Order Summary",
          style: TextStyle(color: midnightGreen),
        ),
      ),
      IconButton(
        onPressed: () {
          Get.back();
        },
        icon: const Icon(Icons.arrow_back_ios_new, color: lightOrange),
      ),
    );
    return Scaffold(
      appBar: orderSummaryAppBar,
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.9 -
                orderSummaryAppBar.preferredSize.height -
                MediaQuery.of(context).padding.top,
            child: SingleChildScrollView(
              child: Obx(
                () => controller.submitLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: const [
                                  Text(
                                    "Orders",
                                    style: TextStyle(
                                        color: lightOrange, fontSize: 20),
                                  ),
                                  Spacer()
                                ],
                              )),
                          ...controller.placedOrders.value.map((order) {
                            return Column(
                              children: [
                                OrderByService(order: order, controller: controller,),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            );
                          }).toList()
                        ],
                      ),
              ),
            ),
          ),
          Obx(
            ()=> 
              controller.submitLoading.value?Container(): BottomSubTotalBar(
                  navigateToRoute: Routes.BOOKINGS,
                  navigateButtonText: 'Place Order',
                  functionToPlaceOrder: controller.changePlaceOrderPressed,
                  orderAmount: controller.totalAmount.value,
                ),
          )
        ],
      ),
    );
  }

  Widget profileRow(String item, String itemValue) {
    return Row(
      children: [
        Flexible(
          flex: 3,
          child: Text(
            item,
            textScaleFactor: 1.1,
            style: const TextStyle(
              color: white,
            ),
          ),
        ),
        Expanded(child: Container()),
        const Flexible(
          child: Text(
            ":",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: white,
            ),
            textScaleFactor: 1.1,
          ),
        ),
        const Spacer(),
        Flexible(
          flex: 5,
          child: Text(
            itemValue,
            textScaleFactor: 1.1,
            style: const TextStyle(
              color: white,
            ),
          ),
        )
      ],
    );
  }
}

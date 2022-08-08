import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';

import '../../../core/constants/palette.dart';
import '../../../data/models/order.dart';
import '../controllers/order_summary_controller.dart';

class OrderByService extends StatefulWidget {
  const OrderByService({
    required this.order,
    required this.controller,
    Key? key,
  }) : super(key: key);

  final Order order;
  final OrderSummaryController controller;

  @override
  State<OrderByService> createState() => _OrderByServiceState();
}

class _OrderByServiceState extends State<OrderByService>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: aliceBlue,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Order id : ${widget.order.id}",
            style: const TextStyle(color: lightOrange, fontSize: 15),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "date and time -  ${widget.order.createdAt}",
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Items",
            style: TextStyle(color: lightOrange, fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            color: white,
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.all(8.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: widget.order.orderItems != null
                    ? widget.order.orderItems!.map((orderItem) {
                        return Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Text(
                                "${orderItem.productId} x ${orderItem.quantity}",
                                style: const TextStyle(
                                    overflow: TextOverflow.fade),
                              ),
                            ),
                            const Spacer(),
                            Text(orderItem.salePrice.toString())
                          ],
                        );
                      }).toList()
                    : []),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Text(
                "Sub Total",
                style: TextStyle(
                  color: lightOrange,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.1,
                child: Builder(builder: (context) {
                  double totalAmount = 0;
                  if (widget.order.orderItems != null) {
                    for (int i = 0; i < widget.order.orderItems!.length; i++) {
                      totalAmount = totalAmount +
                          widget.order.orderItems![i].quantity *
                              widget.order.orderItems![i].salePrice;
                    }
                  }
                  return widget.order.orderItems != null
                      ? Text(totalAmount.toString())
                      : const Text("0");
                }),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Text(
                "Service contact detail",
              ),
              const Spacer(),
              FutureBuilder(
                  future: widget.controller.findServiceman(widget.order.serviceMan),
                  builder: ((context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Row(
                        children: [
                          Text(
                            snapshot.data.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          IconButton(
                            onPressed: () async{
                              await FlutterPhoneDirectCaller.callNumber(snapshot.data.toString());
                            }, 
                            icon: const Icon(
                              Icons.call,
                              color: lightOrange,
                            )
                          )
                        ],
                      );
                    } else {
                      return const Text(
                        "Loading ...",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      );
                    }
                  }))
            ],
          )
        ],
      ),
    );
  }
}

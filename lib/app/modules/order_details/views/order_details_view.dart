import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import 'package:get/get.dart';

import '../../../core/constants/enums.dart';
import '../../../core/constants/palette.dart';
import '../../../data/models/order.dart';
import '../../../data/models/service.dart';
import '../controllers/order_details_controller.dart';
import '../widgets/dynamic_container.dart';

class OrderDetailsView extends GetView<OrderDetailsController> {
  const OrderDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Order order = Get.arguments;
    controller.updateOrder(order);

    return Scaffold(
        backgroundColor: lightOrange,
        body: OrderDetailSection(
          controller: controller,
        ));
  }
}

class OrderDetailSection extends StatefulWidget {
  const OrderDetailSection({required this.controller, Key? key})
      : super(key: key);

  final OrderDetailsController controller;

  @override
  State<OrderDetailSection> createState() => _OrderDetailSectionState();
}

class _OrderDetailSectionState extends State<OrderDetailSection>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void eventHandler(Map<String, dynamic> data) {
    ///handling the event for order completion 1009
    Future.delayed(const Duration(seconds: 1)).then((value) {
      widget.controller.findOrderById(data['orderId']).then((order) {
        widget.controller.ongoingOrder.value = order;

        ///event to send order has been accepted 1001
        if (data["status"]["statusCode"] == 1004) {
          Future.delayed(const Duration(seconds: 1)).then((_) {
            widget.controller.sendData({}, "1004");
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.1,
                decoration: const BoxDecoration(
                  color: Color(0x00EEEEEE),
                ),
                child: Center(
                  child: StreamBuilder<Map<String, dynamic>?>(
                      stream:
                          FlutterBackgroundService().on("receiveOrderStatus"),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: Text(
                            "Fixpals",
                            style: TextStyle(
                                color: white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ));
                        }
                        final data = snapshot.data!;
                        eventHandler(data);

                        return const Text(
                          "Fixpals",
                          style: TextStyle(
                              color: white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        );
                      }),
                ),
              ),
              Material(
                color: Colors.transparent,
                elevation: 3,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.9 -
                      MediaQuery.of(context).padding.top,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEEEEEE),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0),
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEEEEEE),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Obx(() => widget.controller.ongoingOrder.value !=
                                    null
                                ? Column(
                                    children: [
                                      orderIdSection(widget
                                          .controller.ongoingOrder.value!.id
                                          .substring(15)),
                                      dateAndTimeSection(widget.controller
                                          .ongoingOrder.value!.createdAt),
                                      serviceSection(),
                                      listOfServicesSection(context),
                                      subTotalRow(
                                          context,
                                          widget
                                              .controller.ongoingOrder.value!),
                                      addressSection(widget.controller
                                          .ongoingOrder.value!.addressName),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(10, 10, 10, 20),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            servicePersonSection(widget
                                                .controller
                                                .ongoingOrder
                                                .value!
                                                .serviceMan),

                                            //TODO: this is updating even if the app is closed
                                            orderStatusSection(statusToString(
                                                codeToStatus(widget
                                                    .controller
                                                    .ongoingOrder
                                                    .value!
                                                    .status))),
                                          ],
                                        ),
                                      ),
                                      //TODO: this needs to updated as it shows last event
                                      DynamicContainer(
                                        controller: widget.controller,
                                        status: widget.controller.ongoingOrder
                                            .value!.status,
                                      ),
                                    ],
                                  )
                                : SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.6,
                                    child: const Center(
                                      child: Text("No Order yet"),
                                    ),
                                  )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget listOfServicesSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
      child: Material(
        color: Colors.transparent,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: white,
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: widget.controller.ongoingOrder.value!
                                    .orderItems !=
                                null
                            ? widget.controller.ongoingOrder.value!.orderItems!
                                .map((orderItem) {
                                return Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: FutureBuilder(
                                          future: widget.controller
                                              .findServiceById(
                                                  orderItem.productId),
                                          builder: (context,
                                              AsyncSnapshot<Service> snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.done) {
                                              return Text(
                                                "${snapshot.data?.serviceName} x ${orderItem.quantity}",
                                                style: const TextStyle(
                                                    overflow:
                                                        TextOverflow.fade),
                                              );
                                            } else {
                                              return const Text("Loading");
                                            }
                                          }),
                                    ),
                                    const Spacer(),
                                    Text(
                                        "\u{20B9}${orderItem.salePrice.toString()}")
                                  ],
                                );
                              }).toList()
                            : []),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget orderIdSection(String orderId) {
    return Align(
      alignment: const AlignmentDirectional(-1, 0),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
        child: Text(
          'Order id : # $orderId',
          style: const TextStyle(
              color: lightOrange, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  Widget dateAndTimeSection(String dateAndTime) {
    return Align(
      alignment: const AlignmentDirectional(-1, 0),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
        child: Text('Date and Time : $dateAndTime',
            style:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
      ),
    );
  }

  Widget serviceSection() {
    return const Align(
      alignment: AlignmentDirectional(-1, 0),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
        child: Text(
          'Services',
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w500, color: lightOrange),
        ),
      ),
    );
  }

  Widget subTotalRow(BuildContext context, Order order) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 20),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Sub Total',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.2,
            child: Builder(builder: (context) {
              double totalAmount = 0;
              if (order.orderItems != null) {
                for (int i = 0; i < order.orderItems!.length; i++) {
                  totalAmount = totalAmount +
                      order.orderItems![i].quantity *
                          order.orderItems![i].salePrice;
                }
              }
              return order.orderItems != null
                  ? Text(
                      '\u{20B9} ${totalAmount.toString()}',
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    )
                  : const Text("0");
            }),
          ),
        ],
      ),
    );
  }

  Widget addressSection(String address) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
            child: Icon(
              Icons.location_on,
              color: Color(0xFF0C0CC5),
              size: 24,
            ),
          ),
          Text(
            address,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w500, color: lightOrange),
          ),
        ],
      ),
    );
  }

  Widget orderStatusSection(String orderStatus) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        const Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
          child: Text(
            'Order Status',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, color: lightOrange),
          ),
        ),
        Text(
          orderStatus,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget servicePersonSection(String servicePerson) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        const Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
          child: Text(
            'Service Person',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, color: lightOrange),
          ),
        ),
        Text(
          servicePerson,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }
}

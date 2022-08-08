import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/constants/controllers.dart';
import '../core/constants/palette.dart';
import '../data/models/cart.dart';
import '../modules/cart/controllers/cart_controller.dart';
import '../routes/app_pages.dart';
import 'address_dailog.dart';

class BottomSubTotalBar extends StatelessWidget {
  final String navigateToRoute;
  final String navigateButtonText;
  final CartController? cartController;
  final Function? functionToPlaceOrder;
  final double? orderAmount;
  const BottomSubTotalBar({
    this.cartController,
    this.functionToPlaceOrder,
    this.orderAmount,
    required this.navigateButtonText,
    required this.navigateToRoute,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.1),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          color: lightOrange,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0.5,
              blurRadius: 1,
              offset: const Offset(-1, -1),
            ),
          ]),
      child: LayoutBuilder(
        builder: (ctx, constraints) => Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: constraints.maxHeight * 0.8,
              width: constraints.maxWidth * 0.6,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const FittedBox(
                          child: Text(
                            "Sub Total",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: white),
                            textScaleFactor: 1.2,
                          ),
                        ),
                        Obx(() {
                          Rx<double> totalAmount = Rx<double>(0);
                          if (Get.currentRoute == Routes.ORDER_SUMMARY) {
                            if (orderAmount != null) {
                              totalAmount.value = orderAmount!;
                            } else {
                              totalAmount.value = 0;
                            }
                          } else {
                            if (cart.value.keys.isNotEmpty) {
                              for (var element in cart.value.keys) {
                                if (cart.value[element] != null &&
                                    cart.value[element]!.service != null) {
                                  totalAmount += cart
                                          .value[element]!.quantity.value *
                                      cart.value[element]!.service!.salePrice;
                                }
                              }
                            }
                          }
                          return FittedBox(
                            child: Text(
                              totalAmount.toString(),
                              textScaleFactor: 1,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: white,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ]),
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                if (navigateToRoute == Routes.ADDRESS) {
                  cartController!.addressPopUp(
                    context,
                    AddressDialog(
                        cartController: cartController,
                        constraints: constraints),
                    [
                      TextButton(
                        onPressed: () {
                          var orderBody = {};
                          orderBody["user_id"] =
                              cartController!.userAddress.value["user_id"];
                          orderBody["order_items"] = cart.value.keys
                              .map((serviceId) => cart.value[serviceId] != null
                                  ? {
                                      "product_id":
                                          cart.value[serviceId]!.service!.id,
                                      "quantity":
                                          cart.value[serviceId]!.quantity.value,
                                      "sale_price": cart
                                          .value[serviceId]!.service!.salePrice
                                    }
                                  : null)
                              .toList();
                          orderBody["address_id"] =
                              cartController!.userAddress.value["address_id"];

                          if (cartController!
                                  .userAddress.value["address_id"] !=
                              null) {
                                Get.toNamed(Routes.ORDER_SUMMARY,
                                  arguments: orderBody);
                              } else {
                                if(!authController.isAuth.value){
                                  Get.offAllNamed(Routes.AUTHENTICATION);
                                }
                              }
                        },
                        child: Obx(() {
                          return Text(
                            cartController!.userAddress.value["address_id"] !=
                                    null
                                ? "Continue with the address"
                                : authController.isAuth.value
                                    ? "Add an address first"
                                    : "Login to save the address",
                          );
                        }),
                      )
                    ],
                  );
                } else {
                  if (navigateToRoute == Routes.BOOKINGS) {
                    functionToPlaceOrder!();
                    Get.offAllNamed(navigateToRoute);
                  } else {
                    Get.toNamed(navigateToRoute);
                  }
                }
              },
              child: Container(
                height: constraints.maxHeight * 0.4,
                width: constraints.maxWidth * 0.35,
                padding: EdgeInsets.all(constraints.maxHeight * 0.08),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: white,
                ),
                child: FittedBox(
                  child: Text(
                    navigateButtonText,
                    style: const TextStyle(
                      color: lightOrange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

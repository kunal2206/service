import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/constants/palette.dart';
import '../modules/cart/controllers/cart_controller.dart';
import '../routes/app_pages.dart';

class AddressDialog extends StatelessWidget {
  const AddressDialog({
    Key? key,
    required this.cartController,
    required this.constraints
  }) : super(key: key);

  final CartController? cartController;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.25,
      child: LayoutBuilder(
          builder: (context, constraints) => Column(
      children: [
        InkWell(
          onTap: () => Get.toNamed(Routes.ADDRESS,
              arguments: cartController!),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
              width: 2.0,
              color: aliceBlue,
            )),
            height: constraints.maxHeight * 0.4,
            width: constraints.maxWidth,
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: const [
                Icon(
                  Icons.add,
                  color: lightOrange,
                ),
                Text(
                  "Change Address",
                  style: TextStyle(color: lightOrange),
                )
              ],
            ),
          ),
        ),
        Material(
          elevation: 2,
          child: SizedBox(
            height: constraints.maxHeight * 0.6,
            width: constraints.maxWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Flexible(
                  flex: 1,
                  child: Center(
                      child: Icon(
                    Icons.location_on,
                    color: lightOrange,
                    size: 30,
                  )),
                ),
                Obx(
                  ()=> cartController!.submitLoading.value? const CircularProgressIndicator():  Flexible(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(cartController!.userAddress.value["address"]),
                      )
                    ),
                )
              ],
            ),
          ),
        )
      ],
    )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/palette.dart';
import '../../data/models/cart.dart';
import '../../data/models/service.dart';

class ProductBlock extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  final Service popularService;

  const ProductBlock({
    Key? key,
    required this.screenHeight,
    required this.screenWidth,
    required this.popularService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      child: Container(
        height: screenHeight * 0.14,
        width: screenWidth,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1.0,
            color: aliceBlue,
          ),
        ),
        child: ProductCard(
          service: popularService,
        ),
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  const ProductCard({
    Key? key,
    required this.service,
  }) : super(key: key);

  final Service service;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  void updateUI() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    getServiceById(widget.service.id);
    return LayoutBuilder(builder: (ctx, constraints) {
      return Container(
          height: constraints.maxHeight,
          padding: EdgeInsets.symmetric(
            horizontal: constraints.maxWidth * 0.04,
            vertical: constraints.maxHeight * 0.08,
          ),
          child: Row(
            children: [
              SizedBox(
                width: constraints.maxWidth * 0.6,
                height: constraints.maxHeight * 0.84,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    productTitleWidget(constraints),
                    FittedBox(
                      child: Row(
                        children: [
                          priceRow(constraints),
                          if (widget.service.serviceDiscount != null)
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                color: cafeAuLait,
                              ),
                              padding: const EdgeInsets.all(3),
                              child: FittedBox(
                                child: Text(
                                  "Saved ${widget.service.serviceDiscount!.toInt()}%",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: white,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: constraints.maxWidth * 0.32,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Spacer(),
                    addButton(constraints),
                  ],
                ),
              )
            ],
          ));
    });
  }

  Widget productTitleWidget(BoxConstraints constraints) {
    return Container(
      height: constraints.maxHeight * 0.34,
      width: constraints.maxWidth * 0.7,
      margin: EdgeInsets.only(bottom: constraints.maxHeight * 0.01),
      child: Text(widget.service.serviceName,
          textAlign: TextAlign.left,
          textScaleFactor: 1.2,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  Widget priceRow(BoxConstraints constraints) {
    return Container(
      height: constraints.maxHeight * 0.2,
      //padding: EdgeInsets.symmetric(vertical: constraints.maxHeight * 0.03),
      margin: EdgeInsets.only(right: constraints.maxHeight * 0.1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "Rs. ${widget.service.salePrice}",
            textAlign: TextAlign.left,
            textScaleFactor: 1.2,
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 5,
            ),
            child: Text("Rs. ${widget.service.markedPrice}",
                textAlign: TextAlign.left,
                textScaleFactor: 0.9,
                style: const TextStyle(decoration: TextDecoration.lineThrough)),
          ),
        ],
      ),
    );
  }

  Widget addButton(BoxConstraints constraints) {
    return !serviceIdPresent(widget.service.id) ||
            getCartItem(widget.service.id)!.quantity.value < 1
        ? InkWell(
            onTap: () {
              addServiceToCart(widget.service.id, widget.service);
              getCartItem(widget.service.id)!.quantity.value++;
              updateUI();
            },
            child: Container(
              height: constraints.maxHeight * 0.25,
              width: constraints.maxWidth * 0.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color:lightOrange,
              ),
              padding: EdgeInsets.all(
                constraints.maxHeight * 0.04,
              ),
              child: const FittedBox(
                child: Text(
                  "ADD",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: white,
                  ),
                ),
              ),
            ),
          )
        : Obx(
            () => Container(
              height: constraints.maxHeight * 0.3,
              width: constraints.maxWidth * 0.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: lightOrange,
              ),
              padding: EdgeInsets.all(
                constraints.maxHeight * 0.04,
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      getCartItem(widget.service.id)!.quantity.value++;
                    },
                    child: const FittedBox(
                      child: Icon(
                        Icons.add,
                        color: white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: white,
                      alignment: Alignment.center,
                      child: Text(getCartItem(widget.service.id) != null
                          ? getCartItem(widget.service.id)!
                              .quantity
                              .value
                              .toString()
                          : () {
                              ///CHEATING
                              Future.delayed(const Duration(seconds: 1))
                                  .then((value) => updateUI());
                              return "";
                            }()),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      getCartItem(widget.service.id)!.quantity.value--;
                      if (getCartItem(widget.service.id)!.quantity.value < 1) {
                        removeServiceFromCart(widget.service.id);
                        updateUI();
                      }
                    },
                    child: const FittedBox(
                      child: Icon(
                        Icons.remove,
                        color: white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

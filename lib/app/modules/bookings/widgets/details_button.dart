import 'package:fixpals_app/app/modules/bookings/controllers/bookings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/palette.dart';
import '../../../data/models/order.dart';
import '../../../routes/app_pages.dart';

class OrderDetailsButton extends StatelessWidget {
  const OrderDetailsButton(
      {Key? key, required this.order, required this.controller})
      : super(key: key);

  final Order order;
  final BookingsController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 5),
      child: Material(
        color: ultramarineBlue,
        elevation: 3,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(100),
            bottomRight: Radius.circular(100),
            topLeft: Radius.circular(100),
            topRight: Radius.circular(100),
          ),
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.07,
          width: MediaQuery.of(context).size.width * 0.8,
          child: TextButton(
            onPressed: () {
              Get.toNamed(Routes.ORDER_DETAILS, arguments: order);
            },
            child: Text(
              'View Details',
              style: GoogleFonts.mulish(
                fontWeight: FontWeight.bold,
                color: white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

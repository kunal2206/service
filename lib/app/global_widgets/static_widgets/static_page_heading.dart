import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/palette.dart';

class StaticPageHeading extends StatelessWidget {
  const StaticPageHeading({
    Key? key,
    required this.headingName,
  }) : super(key: key);

  final String headingName;

  @override
  Widget build(BuildContext context) {
    final Widget backButton = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      width: MediaQuery.of(context).size.width * 0.25,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: lightOrange,
          boxShadow: const [
            BoxShadow(
                blurRadius: 1,
                spreadRadius: 1,
                offset: Offset(1, 1),
                color: Colors.grey)
          ]),
      child: InkWell(
        onTap: () {
          Get.back();
        },
        child: Row(
          children: const [
            Icon(
              Icons.arrow_back,
              color: white,
            ),
            SizedBox(width: 5),
            Text(
              "Back",
              style: TextStyle(
                color: white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).padding.top,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.07,
            child: Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    headingName,
                    style: GoogleFonts.poppins(color: dark),
                    textScaleFactor: 1.4,
                  ),
                ),
                Row(
                  children: [backButton, Expanded(child: Container())],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

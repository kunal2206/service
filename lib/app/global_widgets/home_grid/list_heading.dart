import 'package:flutter/material.dart';

import '../../core/constants/palette.dart';

class ListHeading extends StatelessWidget {
  final String listName;
  final Color? color;
  final Color? textColor;
  final double? textFontSize;
  const ListHeading({
    Key? key,
    this.color,
    this.textColor,
    this.textFontSize,
    required this.listName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color ?? cafeAuLait,
      child: Row(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.08,
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.01,
            ),
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.02,
            ),
            width: MediaQuery.of(context).size.width * 0.4,
            child: FittedBox(
              alignment: Alignment.centerLeft,
              child: Text(
                listName,
                style: TextStyle(
                    color: textColor ?? cafeAuLait,
                    fontWeight: FontWeight.w600,
                    fontSize: textFontSize),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/constants/palette.dart';
import '../data/models/service.dart';
import 'home_grid/list_heading.dart';
import 'service_blocks/service_block.dart';

class SearchResults extends StatelessWidget {
  final double? horizontalWidth;
  final double? horizontalHeight;
  const SearchResults({
    Key? key,
    this.horizontalHeight,
    this.horizontalWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => searchResults.value.isEmpty
          ? searching.value
              ? const CircularProgressIndicator(color: white)
              : Container()
          : searching.value
              ? const CircularProgressIndicator(color: white)
              : Container(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
                  margin:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: aliceBlue,
                  ),
                  child: SizedBox(
                    child: SizedBox(
                      width: horizontalWidth,
                      height: horizontalHeight,
                      child: Column(
                        children: [
                          const ListHeading(
                            listName: "Search Results",
                            color: aliceBlue,
                            textColor: dark,
                          ),
                          ...searchResults.value.map((popularSearch) {
                            return Container(
                              color: Colors.white,
                              child: ProductBlock(
                                screenHeight:
                                    MediaQuery.of(context).size.height,
                                screenWidth: MediaQuery.of(context).size.width,
                                popularService: popularSearch,
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}

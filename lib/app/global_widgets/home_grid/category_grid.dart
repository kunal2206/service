import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/palette.dart';
import '../../data/models/category.dart';
import '../../data/models/sub_category.dart';
import '../../routes/app_pages.dart';
import 'list_heading.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid(
      {required this.categories, required this.sectionName, Key? key})
      : super(key: key);

  final String sectionName;
  final List<Category> categories;

  @override
  Widget build(BuildContext context) {
    return categories.isEmpty
        ? const CircularProgressIndicator(color: cafeAuLait)
        : Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
            margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: aliceBlue,
            ),
            child: Column(
              children: [
                ListHeading(
                  listName: sectionName,
                  color: aliceBlue,
                  textColor: midnightGreen,
                ),
                Material(
                  elevation: 4,
                  child: Column(children: [
                    for (int counter = 0;
                        counter <
                            categories.length -
                                categories.length %
                                    (categories.length < 6 ? 2 : 3);
                        counter = counter + (categories.length < 6 ? 2 : 3))
                      rowInGrid(context, counter),
                    categories.length % (categories.length < 6 ? 2 : 3) == 0
                        ? Container()
                        : SizedBox(
                            height: categories.length < 6
                                ? MediaQuery.of(context).size.height * 0.3
                                : MediaQuery.of(context).size.height * 0.2,
                            child: LayoutBuilder(
                              builder: (ctx, constraints) => Row(
                                children: categories
                                    .toList()
                                    .sublist(
                                        categories.length -
                                            categories.length %
                                                (categories.length < 6 ? 2 : 3),
                                        categories.length)
                                    .map(
                                      (e) => Container(
                                        width: categories.length < 6
                                            ? constraints.maxWidth / 2
                                            : constraints.maxWidth / 3,
                                        height: constraints.maxHeight,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1.0,
                                              color: Colors.grey.shade400),
                                        ),
                                        child: categoryCard(constraints, e),
                                      ),
                                    )
                                    .toList()
                                  ..add(
                                    categories.length %
                                                (categories.length < 6
                                                    ? 2
                                                    : 3) !=
                                            0
                                        ? fillGapsInCategory(
                                            context,
                                            "More Services Coming Soon",
                                            constraints)
                                        : Container(),
                                  )
                                  ..add(
                                    categories.length % 3 == 1 &&
                                            categories.length > 6
                                        ? fillGapsInCategory(
                                            context,
                                            "Scroll down to see all Popular Searches",
                                            constraints)
                                        : Container(),
                                  ),
                              ),
                            ),
                          )
                  ]),
                ),
              ],
            ),
          );
  }

  Container fillGapsInCategory(
      BuildContext context, String textToShow, BoxConstraints constraints) {
    return Container(
      width: categories.length < 6
          ? constraints.maxWidth / 2
          : constraints.maxWidth / 3,
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.grey.shade400),
      ),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
              color: lightOrange, borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.all(
            MediaQuery.of(context).size.width * 0.01,
          ),
          height: MediaQuery.of(context).size.width * 0.25,
          width: MediaQuery.of(context).size.width * 0.25,
          child: Center(child: Text(textToShow, textAlign: TextAlign.center, style: TextStyle(color: white),)),
        ),
      ),
    );
  }

  Widget rowInGrid(BuildContext context, int counter) {
    return SizedBox(
      height: categories.length < 6
          ? MediaQuery.of(context).size.height * 0.3
          : MediaQuery.of(context).size.height * 0.2,
      child: LayoutBuilder(
        builder: (ctx, constraints) => Row(
          children: categories
              .toList()
              .sublist(counter, counter + (categories.length < 6 ? 2 : 3))
              .map(
                (e) => Container(
                  width: categories.length < 6
                      ? constraints.maxWidth / 2
                      : constraints.maxWidth / 3,
                  height: constraints.maxHeight,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.0, color: aliceBlue),
                  ),
                  child: categoryCard(
                    constraints,
                    e,
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget categoryCard(BoxConstraints constraints, Category category) {
    return InkWell(
      onTap: () {
        //Get.toNamed(CategoryScreen.routeName, arguments: category);

        if (category.containsType) {
          _chooseSubcategoryType(constraints, category);
        } else {
          SubCategory subCategory = category.children!
              .firstWhere((element) => element.subCategoryName == "no_type");
          Get.toNamed(Routes.CATEGORY,
              arguments: {"category": category, "subCategory": subCategory});
        }
      },
      child: Stack(
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  height: constraints.maxHeight * 0.8 - 2,
                  padding: EdgeInsets.all(constraints.maxHeight * 0.05),
                  child: Image.network(
                    category.categoryImageUrl,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Container(
                  height: constraints.maxHeight * 0.2,
                  padding: EdgeInsets.all(constraints.maxHeight * 0.04),
                  child: FittedBox(
                    child: Text(category.categoryName),
                  ),
                )
              ],
            ),
          ),
          if (category.categoryMaxDiscount != null)
            Positioned(
              top: constraints.maxHeight * 0.03,
              right: constraints.maxHeight * 0.03,
              child: Card(
                elevation: 4,
                child: Container(
                  height: constraints.maxHeight * 0.26,
                  width: constraints.maxHeight * 0.26,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: aliceBlue,
                  ),
                  padding: EdgeInsets.all(constraints.maxHeight * 0.02),
                  child: categoryDiscount(
                      category.categoryMaxDiscount!.toInt().toString()),
                ),
              ),
            )
        ],
      ),
    );
  }

  LayoutBuilder categoryDiscount(String discount) {
    return LayoutBuilder(
      builder: (ctx, discountConstraints) => Column(
        children: [
          SizedBox(
            height: discountConstraints.maxHeight * 0.4,
            child: Row(
              children: [
                SizedBox(
                    width: discountConstraints.maxWidth * 0.5,
                    child: const FittedBox(
                      child: Text(
                        "UP TO",
                        style: TextStyle(
                            color: cafeAuLait, fontWeight: FontWeight.bold),
                      ),
                    )),
                Expanded(
                  child: Container(),
                ),
              ],
            ),
          ),
          SizedBox(
              height: discountConstraints.maxHeight * 0.6,
              child: Row(
                children: [
                  SizedBox(
                    width: discountConstraints.maxWidth * 0.6,
                    child: FittedBox(
                      child: Text(
                        discount,
                        style: const TextStyle(
                            color: cafeAuLait, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: discountConstraints.maxWidth * 0.4,
                    child: Column(
                      children: [
                        SizedBox(
                            height: discountConstraints.maxHeight * 0.3,
                            child: const FittedBox(
                              child: Text(
                                "%",
                                style: TextStyle(color: cafeAuLait),
                              ),
                            )),
                        SizedBox(
                            height: discountConstraints.maxHeight * 0.3,
                            child: const FittedBox(child: Text("OFF"))),
                      ],
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }

  void _chooseSubcategoryType(BoxConstraints constraints, Category category) {
    Get.dialog(AlertDialog(
      title: const Text("Select the type of service"),
      content: SizedBox(
        height: constraints.maxHeight * 0.8,
        width: constraints.maxWidth * 0.5,
        child: ListView(
          children: [
            ListTile(
              title: const Text("Repair Work"),
              onTap: () {
                SubCategory subCategory = category.children!.firstWhere(
                    (element) => element.subCategoryName == "Repair Work");
                Get.back();
                Get.toNamed(Routes.CATEGORY, arguments: {
                  "category": category,
                  "subCategory": subCategory
                });
              },
            ),
            ListTile(
                title: const Text("Installation"),
                onTap: () {
                  SubCategory subCategory = category.children!.firstWhere(
                      (element) => element.subCategoryName == "Installation");

                  Get.back();
                  Get.toNamed(Routes.CATEGORY, arguments: {
                    "category": category,
                    "subCategory": subCategory
                  });
                })
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text("Cancel"),
        ),
      ],
    ));
  }
}

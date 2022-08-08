import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../core/constants/palette.dart';
import '../../../global_widgets/static_widgets/static_page_heading.dart';
import '../controllers/faq_controller.dart';

class FaqView extends GetView<FaqController> {
  const FaqView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const StaticPageHeading(headingName: "FAQs"),
          _content(context),
        ],
      ),
    );
  }

  ///content is obtained from the json file and is shown using this widget
  Widget _content(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      height: MediaQuery.of(context).size.height * 0.76,
      padding: const EdgeInsets.all(20.0),
      child: FutureBuilder(
        future: controller.readFromJsonData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            ///in case it is unable to load the local file
            return const Text("Error in loading the file");
          } else if (snapshot.hasData) {
            ///converting the object into the data type
            var data = snapshot.data as List<dynamic>;
            return ListView(
              children: data.map((value) {
                var onefaq = value as Map<String, dynamic>;

                ///one faq represent one question and answer
                return Column(
                  children: [
                    ExpandableNotifier(
                      initialExpanded: true,
                      child: Expandable(
                        expanded: ExpandableButton(
                          child: Column(
                            children: [
                              mainCategory(
                                  onefaq["question"], context, Icons.remove),
                              subCategory(onefaq["answer"], context)
                            ],
                          ),
                        ),
                        collapsed: ExpandableButton(
                          child: mainCategory(
                              onefaq["question"], context, Icons.add),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10)
                  ],
                );
              }).toList(),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  ///container to show question
  Widget mainCategory(String item, BuildContext context, IconData icon) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: ultramarineBlue,
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                item,
                style: const TextStyle(color: white),
                textScaleFactor: 1.2,
              ),
            ),
            Row(
              children: [
                const Spacer(),
                Icon(
                  icon,
                  color: white,
                )
              ],
            )
          ],
        ));
  }

  ///container to show the answer
  Widget subCategory(String item, BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          color: ultramarineBlue,
          width: 2,
        ),
      ),
      child: Text(
        item,
        style: const TextStyle(color: ultramarineBlue),
        textScaleFactor: 1.2,
      ),
    );
  }
}

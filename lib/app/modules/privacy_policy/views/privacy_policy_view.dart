import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../global_widgets/static_widgets/static_content.dart';
import '../../../global_widgets/static_widgets/static_page_heading.dart';
import '../controllers/privacy_policy_controller.dart';

class PrivacyPolicyView extends GetView<PrivacyPolicyController> {
  const PrivacyPolicyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const StaticPageHeading(headingName: "Privacy Policy"),
          _content(context),
        ],
      ),
    );
  }

  ///content is obtained from the json file and is shown using this widget
  Widget _content(BuildContext context) {
    return StaticContent(
      readData: controller.readFromJsonData,
    );
  }
}

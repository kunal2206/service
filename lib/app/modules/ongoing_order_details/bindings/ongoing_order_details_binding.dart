import 'package:get/get.dart';

import '../controllers/ongoing_order_details_controller.dart';

class OngoingOrderDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OngoingOrderDetailsController>(
      () => OngoingOrderDetailsController(),
    );
  }
}

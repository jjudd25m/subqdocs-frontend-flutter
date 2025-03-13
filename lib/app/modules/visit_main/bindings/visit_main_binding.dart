import 'package:get/get.dart';

import '../controllers/visit_main_controller.dart';

class VisitMainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VisitMainController>(
      () => VisitMainController(),tag: Get.arguments["unique_tag"]
    );
  }
}

import 'package:get/get.dart';

import '../controllers/custom_drawer_controller.dart';

class CustomDrawerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CustomDrawerController());
  }
}

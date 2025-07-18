import 'package:get/get.dart';

import '../../custom_drawer/controllers/custom_drawer_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
    Get.put(CustomDrawerController());
    // Get.put(QuickStartViewController());
  }
}

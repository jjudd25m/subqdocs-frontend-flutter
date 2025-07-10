import 'package:get/get.dart';
import 'package:subqdocs/app/modules/custom_drawer/controllers/custom_drawer_mobile_controller.dart';

import '../controllers/home_view_mobile_controller.dart';

class HomeViewMobileBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeViewMobileController());
    Get.put(CustomDrawerMobileController());
  }
}

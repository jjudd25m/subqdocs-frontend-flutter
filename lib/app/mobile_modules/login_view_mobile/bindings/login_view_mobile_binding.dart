import 'package:get/get.dart';

import '../controllers/login_view_mobile_controller.dart';

class LoginViewMobileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginViewMobileController>(
      () => LoginViewMobileController(),
    );
  }
}

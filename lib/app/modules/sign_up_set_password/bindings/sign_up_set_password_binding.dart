import 'package:get/get.dart';

import '../controllers/sign_up_set_password_controller.dart';

class SignUpSetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignUpSetPasswordController>(
      () => SignUpSetPasswordController(),
    );
  }
}

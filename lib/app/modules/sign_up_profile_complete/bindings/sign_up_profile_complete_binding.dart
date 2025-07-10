import 'package:get/get.dart';

import '../controllers/sign_up_profile_complete_controller.dart';

class SignUpProfileCompleteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignUpProfileCompleteController>(
      () => SignUpProfileCompleteController(),
    );
  }
}

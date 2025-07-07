import 'package:get/get.dart';

import '../controllers/sign_finalize_authenticate_view_controller.dart';

class SignFinalizeAuthenticateViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignFinalizeAuthenticateViewController>(
      () => SignFinalizeAuthenticateViewController(),
    );
  }
}

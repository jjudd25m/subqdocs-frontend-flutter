import 'package:get/get.dart';

import '../controllers/sign_up_set_organization_info_controller.dart';

class SignUpSetOrganizationInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignUpSetOrganizationInfoController>(
      () => SignUpSetOrganizationInfoController(),
    );
  }
}

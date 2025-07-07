import 'package:get/get.dart';

import '../controllers/invited_user_submitted_controller.dart';

class InvitedUserSubmittedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InvitedUserSubmittedController>(
      () => InvitedUserSubmittedController(),
    );
  }
}

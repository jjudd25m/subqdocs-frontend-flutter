import 'package:get/get.dart';

import '../controllers/all_attachment_controller.dart';

class AllAttachmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllAttachmentController>(
      () => AllAttachmentController(),
    );
  }
}

import 'package:get/get.dart';

import '../controllers/edit_patent_details_controller.dart';

class EditPatentDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditPatentDetailsController>(
      () => EditPatentDetailsController(),
    );
  }
}

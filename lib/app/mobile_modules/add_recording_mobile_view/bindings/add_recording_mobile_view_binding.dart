import 'package:get/get.dart';

import '../controllers/add_recording_mobile_view_controller.dart';

class AddRecordingMobileViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddRecordingMobileViewController>(
      () => AddRecordingMobileViewController(),
    );
  }
}

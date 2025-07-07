import 'package:get/get.dart';

import '../controllers/generate_note_mobile_view_controller.dart';

class GenerateNoteMobileViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GenerateNoteMobileViewController>(
      () => GenerateNoteMobileViewController(),
    );
  }
}

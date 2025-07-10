import 'package:get/get.dart';

import '../controllers/quick_start_view_controller.dart';

class QuickStartViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuickStartViewController>(
      () => QuickStartViewController(),
    );
  }
}

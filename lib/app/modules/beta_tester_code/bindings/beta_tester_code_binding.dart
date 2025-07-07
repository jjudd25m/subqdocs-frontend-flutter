import 'package:get/get.dart';

import '../controllers/beta_tester_code_controller.dart';

class BetaTesterCodeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BetaTesterCodeController>(
      () => BetaTesterCodeController(),
    );
  }
}

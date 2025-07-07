import 'package:get/get.dart';

import '../controllers/personal_setting_controller.dart';

class PersonalSettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PersonalSettingController>(
      () => PersonalSettingController(),
    );
  }
}

import 'package:get/get.dart';

import '../controllers/personal_setting_mobile_view_controller.dart';

class PersonalSettingMobileViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PersonalSettingMobileViewController>(
      () => PersonalSettingMobileViewController(),
    );
  }
}

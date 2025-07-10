import 'package:get/get.dart';

import '../controllers/patient_profile_mobile_view_controller.dart';

class PatientProfileMobileViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PatientProfileMobileViewController>(
      () => PatientProfileMobileViewController(),
    );
  }
}

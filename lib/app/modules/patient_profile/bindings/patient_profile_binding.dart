import 'package:get/get.dart';

import '../controllers/patient_profile_controller.dart';

class PatientProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PatientProfileController>(
      () => PatientProfileController(),
    );
  }
}

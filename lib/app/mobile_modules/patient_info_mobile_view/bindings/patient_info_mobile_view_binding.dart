import 'package:get/get.dart';

import '../controllers/patient_info_mobile_view_controller.dart';

class PatientInfoMobileViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PatientInfoMobileViewController>(() => PatientInfoMobileViewController());
  }
}

import 'package:get/get.dart';

import '../controllers/patient_info_controller.dart';

class PatientInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PatientInfoController>(() => PatientInfoController(), tag: Get.arguments["unique_tag"]);
  }
}

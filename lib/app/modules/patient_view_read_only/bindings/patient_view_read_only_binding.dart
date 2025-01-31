import 'package:get/get.dart';

import '../controllers/patient_view_read_only_controller.dart';

class PatientViewReadOnlyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PatientViewReadOnlyController>(
      () => PatientViewReadOnlyController(),
    );
  }
}

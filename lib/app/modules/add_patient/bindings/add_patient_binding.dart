import 'package:get/get.dart';

import '../controllers/add_patient_controller.dart';

class AddPatientBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddPatientController>(
      () => AddPatientController(),
    );
  }
}

import 'package:get/get.dart';

import '../controllers/add_patient_mobile_view_controller.dart';

class AddPatientMobileViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddPatientMobileViewController>(
      () => AddPatientMobileViewController(),
    );
  }
}

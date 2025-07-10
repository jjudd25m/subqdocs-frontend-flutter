import 'package:get/get.dart';

import '../controllers/doctor_to_doctor_sign_finalize_authenticate_view_controller.dart';

class DoctorToDoctorSignFinalizeAuthenticateViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorToDoctorSignFinalizeAuthenticateViewController>(
      () => DoctorToDoctorSignFinalizeAuthenticateViewController(),
    );
  }
}

import 'package:get/get.dart';
import 'package:subqdocs/widgets/custom_toastification.dart';
import 'package:toastification/toastification.dart';

import '../../../utils/app_string.dart';
import '../../modules/login/controllers/login_controller.dart';
import '../../routes/app_pages.dart';
import 'app_preferences.dart';
import 'global_controller.dart';

void customPrint(dynamic message) {
  print(message);
}

void socketCustomPrint(dynamic message) {
  print(message);
}

void unAuthorisedLogOut() async {
  await AppPreference.instance.removeKey(AppString.prefKeyUserLoginData);
  await AppPreference.instance.removeKey(AppString.prefKeyToken);
  await AppPreference.instance.removeKey("homePastPatientListSortingModel");
  await AppPreference.instance.removeKey("homePatientListSortingModel");
  await AppPreference.instance.removeKey("homeScheduleListSortingModel");
  Get.delete<GlobalController>();
  Get.offAllNamed(Routes.LOGIN);
  Get.put(LoginController());
  CustomToastification().showToast("Unauthorized User", type: ToastificationType.error);
}

import 'package:get/get.dart';

import '../../personal_setting/model/get_user_detail_model.dart';

class InvitedUserSubmittedController extends GetxController {
  //TODO: Implement InvitedUserSubmittedController

  Rxn<InvitedUserResponseModel> invitedUserData = Rxn<InvitedUserResponseModel>();

  RxString email = "".obs;
  RxBool isAdmin = false.obs;
  RxString firstName = "".obs;
  RxString lastName = "".obs;
  RxString role = "".obs;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();

    Map<String, dynamic> param = Get.arguments["invited_user_data"];
    email.value = param["email"] ?? ""; // Default to empty string if null
    isAdmin.value = param["is_admin"] ?? false; // Default to false if null
    firstName.value = param["first_name"] ?? "";
    lastName.value = param["last_name"] ?? "";
    role.value = param["role"] ?? "";
  }
}

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

import '../../../../widgets/custom_toastification.dart';
import '../../../core/common/logger.dart';
import '../../../data/provider/api_provider.dart';
import '../../../routes/app_pages.dart';
import '../../personal_setting/model/get_user_detail_model.dart';
import '../../personal_setting/repository/personal_setting_repository.dart';
import '../../sign_up/models/sign_up_models.dart';
import '../models/SignUpOrganizationModel.dart';

class SignUpSetOrganizationInfoController extends GetxController {
  //TODO: Implement SignUpSetOrganizationInfoController

  final PersonalSettingRepository _personalSettingRepository = PersonalSettingRepository();

  TextEditingController organizationNameController = TextEditingController();
  TextEditingController noOfProviderController = TextEditingController();

  Rxn<GetUserRolesModel> userRolesModel = Rxn<GetUserRolesModel>();
  RxnString selectedRoleValue = RxnString("");

  String firstName = '';
  String lastName = '';
  String email = '';
  String password = '';

  SignUpModel signupdata = SignUpModel();

  @override
  void onInit() {
    super.onInit();

    var arguments = Get.arguments;
    signupdata = arguments['signupdata'];

    print("signupdata is:- ${signupdata.toJson()}");

    getUserRole();
  }

  Future<void> getUserRole() async {
    try {
      userRolesModel.value = await _personalSettingRepository.getUserRole();
      selectedRoleValue.value = userRolesModel.value?.responseData?.first;
    } catch (error) {
      customPrint("organizationUpdate catch error is $error");
    }
  }

  Future<void> organizationUpdate() async {
    Map<String, dynamic> param = {};
    param['name'] = organizationNameController.text.trim();
    param['providers_count'] = noOfProviderController.text.trim();
    param['role'] = selectedRoleValue.value;
    param['userId'] = signupdata.responseData?.id.toString().trim();
    try {
      SignUpOrganizationModel signUpOrganizationModel = await _personalSettingRepository.organizationUpdate(param: param, organizationId: signupdata.responseData!.organizationId.toString());
      if (signUpOrganizationModel.responseType == "success") {
        CustomToastification().showToast(signUpOrganizationModel.message ?? "", type: ToastificationType.success);
      } else {
        CustomToastification().showToast(signUpOrganizationModel.message ?? "", type: ToastificationType.error);
      }

      Get.toNamed(Routes.SIGN_UP_PROFILE_COMPLETE);
    } catch (error) {
      // Get.back();
      CustomToastification().showToast("${error}", type: ToastificationType.error);
      customPrint("organizationUpdate catch error is $error");
    }
  }
}

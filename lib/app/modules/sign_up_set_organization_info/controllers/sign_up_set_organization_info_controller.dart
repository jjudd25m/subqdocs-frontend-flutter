import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../core/common/logger.dart';
import '../../../data/provider/api_provider.dart';
import '../../../routes/app_pages.dart';
import '../../personal_setting/model/get_user_detail_model.dart';
import '../../personal_setting/repository/personal_setting_repository.dart';
import '../../sign_up/models/sign_up_models.dart';

class SignUpSetOrganizationInfoController extends GetxController {
  //TODO: Implement SignUpSetOrganizationInfoController

  final PersonalSettingRepository _personalSettingRepository = PersonalSettingRepository();

  TextEditingController organizationNameController = TextEditingController();
  TextEditingController noOfProviderController = TextEditingController();

  // RxnString selectedSexValue = RxnString("Male");
  // List<String> sex = ["Female", "Male"];

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

    // firstName = arguments['first_name'];
    // lastName = arguments['last_name'];
    // email = arguments['email'];
    // password = arguments['password'];

    getUserRole();
  }

  Future<void> getUserRole() async {
    userRolesModel.value = await _personalSettingRepository.getUserRole();
    selectedRoleValue.value = userRolesModel.value?.responseData?.first;
  }

  Future<void> organizationUpdate(Map<String, dynamic> param) async {
    try {
      dynamic response = await _personalSettingRepository.organizationUpdate(param: param, organizationId: signupdata.responseData!.organizationId.toString());
      print("organizationUpdate is $response");

      Get.toNamed(Routes.SIGN_UP_PROFILE_COMPLETE);
    } catch (error) {
      // Get.back();
      customPrint("organizationUpdate catch error is $error");
    }
  }
}

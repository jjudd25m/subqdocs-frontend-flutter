import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../core/common/logger.dart';
import '../../../data/provider/api_provider.dart';
import '../../personal_setting/model/get_user_detail_model.dart';
import '../../personal_setting/repository/personal_setting_repository.dart';

class SignUpSetOrganizationInfoController extends GetxController {
  //TODO: Implement SignUpSetOrganizationInfoController

  final PersonalSettingRepository _personalSettingRepository = PersonalSettingRepository();

  TextEditingController organizationNameController = TextEditingController();
  TextEditingController noOfProviderController = TextEditingController();

  // RxnString selectedSexValue = RxnString("Male");
  // List<String> sex = ["Female", "Male"];

  Rxn<GetUserRolesModel> userRolesModel = Rxn<GetUserRolesModel>();
  RxnString selectedRoleValue = RxnString("");

  @override
  void onInit() {
    super.onInit();

    getUserRole();
  }

  Future<void> getUserRole() async {
    userRolesModel.value = await _personalSettingRepository.getUserRole();
    selectedRoleValue.value = userRolesModel.value?.responseData?.first;
  }
}

import 'dart:convert';

import 'package:get/get.dart';
import 'package:subqdocs/widgets/custom_toastification.dart';
import 'package:toastification/toastification.dart';

import '../../../../utils/app_string.dart';
import '../../../core/common/app_preferences.dart';
import '../../../core/common/logger.dart';
import '../../home/model/patient_list_model.dart';
import '../../login/model/login_model.dart';
import '../model/get_user_detail_model.dart';
import '../repository/personal_setting_repository.dart';

class PersonalSettingController extends GetxController {
  //TODO: Implement PersonalSettingController

  final PersonalSettingRepository _personalSettingRepository = PersonalSettingRepository();
  // RxList<PatientListData> patientList = RxList<PatientListData>();
  Rxn<GetUserDetailModel> getUserDetailModel = Rxn<GetUserDetailModel>();
  Rxn<GetUserOrganizationListModel> getUserOrganizationListModel = Rxn<GetUserOrganizationListModel>();
  Rxn<GetOrganizationDetailModel> getOrganizationDetailModel = Rxn<GetOrganizationDetailModel>();
  Rxn<LoginModel> loginData = Rxn<LoginModel>();

  @override
  void onInit() {
    super.onInit();

    loginData.value = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

    getOrganizationDetail();
    getUserDetail();
    getUserByOrganization();
  }

  Future<void> getOrganizationDetail() async {
    try {
      getOrganizationDetailModel.value = await _personalSettingRepository.getOrganizationDetail();
    } catch (error) {
      customPrint("login catch error is $error");
    }
  }

  Future<void> getUserDetail() async {
    try {
      getUserDetailModel.value = await _personalSettingRepository.getUserDetail(userId: loginData.value?.responseData!.user!.id.toString() ?? "");
    } catch (error) {
      customPrint("login catch error is $error");
    }
  }

  Future<void> getUserByOrganization() async {
    try {
      getUserOrganizationListModel.value = await _personalSettingRepository.getUserByOrganization();
    } catch (error) {
      customPrint("login catch error is $error");
    }
  }

  Future<void> updateRoleAndAdminControll(String userId, String role, bool isAdmin) async {
    Map<String, dynamic> param = {};
    param["user_id"] = userId;
    param["role"] = role;
    param["is_admin"] = isAdmin;

    try {
      UpdateRoleAndAdminResponseModel updateRoleAndAdminResponseData = await _personalSettingRepository.updateRoleAndAdminControl(param: param);

      getUserByOrganization();
      CustomToastification().showToast(updateRoleAndAdminResponseData.message ?? "", type: ToastificationType.success);
    } catch (error) {
      customPrint("login catch error is $error");
    }
  }
}

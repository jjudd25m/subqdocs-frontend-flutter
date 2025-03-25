import 'dart:convert';

import 'package:flutter/cupertino.dart';
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
  Rxn<GetUserRolesModel> userRolesModel = Rxn<GetUserRolesModel>();
  Rxn<GetUserOrganizationListModel> getUserOrganizationListModel = Rxn<GetUserOrganizationListModel>();
  Rxn<GetOrganizationDetailModel> getOrganizationDetailModel = Rxn<GetOrganizationDetailModel>();
  Rxn<LoginModel> loginData = Rxn<LoginModel>();

  TextEditingController emailAddressController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  RxBool isValid = RxBool(true);
  RxnString selectedRoleValue = RxnString("");

  List<String> adminStatus = ["Yes", "No"];
  RxnString selectedAdminValue = RxnString("Yes");
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();

    loginData.value = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

    getOrganizationDetail();
    getUserDetail();
    getUserByOrganization();
    getUserRole();
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

  Future<void> getUserRole() async {
    try {
      userRolesModel.value = await _personalSettingRepository.getUserRole();
      selectedRoleValue.value = userRolesModel.value?.responseData?.first;
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

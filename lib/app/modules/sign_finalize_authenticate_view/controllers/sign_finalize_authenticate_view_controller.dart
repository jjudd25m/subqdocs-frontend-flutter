import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

import '../../../../utils/Loader.dart';
import '../../../../utils/app_string.dart';
import '../../../../widgets/custom_toastification.dart';
import '../../../core/common/app_preferences.dart';
import '../../../core/common/global_controller.dart';
import '../../../models/ChangeModel.dart';
import '../../login/model/login_model.dart';
import '../../patient_info/model/check_doctor_pin_expired_model.dart';
import '../../patient_info/model/get_doctor_list_by_role_model.dart';
import '../../patient_info/repository/patient_info_repository.dart';

class SignFinalizeAuthenticateViewController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Rxn<LoginModel> loginData = Rxn();

  TextEditingController userPINController = TextEditingController();
  RxBool userPinVisibility = RxBool(true);
  final ScrollController scrollController = ScrollController();
  RxnString selectedDoctorValue = RxnString();
  Rxn<GetDoctorListByRoleResponseData> selectedDoctorValueModel = Rxn();
  final PatientInfoRepository _patientInfoRepository = PatientInfoRepository();

  RxList<GetDoctorListByRoleResponseData> doctorList = RxList();
  Rxn<CheckDoctorPinExpiredModel> checkPinResponse = Rxn();
  final GlobalController globalController = Get.find();

  String visitId = "";

  String isThirdParty = "";

  bool isAccessible = true;

  @override
  void onInit() {
    super.onInit();

    isAccessible = (globalController.getEMAOrganizationDetailModel.value?.responseData?.isEmaIntegration ?? false) && (isThirdParty.isNotEmpty);
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    getDoctorList();

    print("visit id:- $visitId");
  }

  void changeUserPinVisiblity() {
    userPinVisibility.value = userPinVisibility == true ? false : true;
    userPinVisibility.refresh();
  }

  void getDoctorList() async {
    GetDoctorListByRoleModel doctorListByRole = await _patientInfoRepository.getDoctorByRole();
    doctorList.value = doctorListByRole.responseData ?? [];
    doctorList.refresh();
  }

  void setDoctor(Rxn<GetDoctorListByRoleResponseData> doctorData) {
    selectedDoctorValueModel = doctorData;

    selectedDoctorValue.value = selectedDoctorValueModel.value?.name;

    print("doctor name:- ${selectedDoctorValue.value}");
  }

  void setThirdParty(String thirdParty) {
    loginData.value = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

    isAccessible = (thirdParty.isNotEmpty);

    print("setThirdParty :- $isAccessible");

    print("login id:- ${loginData.value?.responseData?.user?.id}");
    print("doctor id:- ${selectedDoctorValueModel.value?.id}");

    print("login id same as doctor :- ${selectedDoctorValueModel.value?.id == loginData.value?.responseData?.user?.id}");
  }

  Future<void> checkDoctorPIN(String doctorId) async {
    try {
      checkPinResponse.value = await _patientInfoRepository.checkDoctorPIN(doctorId);
      print("response of checkPinResponse :- ${checkPinResponse.toJson()}");
    } catch (e) {
      print(e);
    }
  }

  Future<void> changeStatus() async {
    Map<String, dynamic> param = {"status": "Finalized", "doctor_id": selectedDoctorValueModel.value?.id, "pin": userPINController.text};

    Loader().showLoadingDialogForSimpleLoader();

    try {
      ChangeStatusModel changeStatusModel = await _patientInfoRepository.changeStatus(id: visitId, params: param);
      if (changeStatusModel.responseType == "success") {
        Loader().stopLoader();
        CustomToastification().showToast("${changeStatusModel.message}", type: ToastificationType.success);
        Get.back();
        // Get.back();
      } else {
        Loader().stopLoader();
        CustomToastification().showToast("${changeStatusModel.message}", type: ToastificationType.error);
      }
    } catch (e) {
      CustomToastification().showToast("$e", type: ToastificationType.error);

      Loader().stopLoader();
    }
  }
}

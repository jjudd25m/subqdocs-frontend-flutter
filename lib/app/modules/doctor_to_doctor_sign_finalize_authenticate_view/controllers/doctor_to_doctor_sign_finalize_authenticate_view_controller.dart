import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

import '../../../../utils/Loader.dart';
import '../../../../utils/app_string.dart';
import '../../../../widgets/custom_toastification.dart';
import '../../../core/common/app_preferences.dart';
import '../../../core/common/global_controller.dart';
import '../../../core/common/logger.dart';
import '../../../models/ChangeModel.dart';
import '../../../models/SelectedDoctorMedicationModel.dart';
import '../../login/model/login_model.dart';
import '../../patient_info/model/check_doctor_pin_expired_model.dart';
import '../../patient_info/repository/patient_info_repository.dart';

class DoctorToDoctorSignFinalizeAuthenticateViewController extends GetxController {
  //TODO: Implement DoctorToDoctorSignFinalizeAuthenticateViewController

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController userPINController = TextEditingController();
  RxBool userPinVisibility = RxBool(true);
  final ScrollController scrollController = ScrollController();
  RxnString selectedDoctorValue = RxnString();
  Rxn<SelectedDoctorModel> selectedDoctorValueModel = Rxn();
  final PatientInfoRepository _patientInfoRepository = PatientInfoRepository();
  Rxn<LoginModel> loginData = Rxn();
  RxList<SelectedDoctorModel> doctorList = RxList();
  Rxn<CheckDoctorPinExpiredModel> checkPinResponse = Rxn();
  final GlobalController globalController = Get.find();

  String isThirdParty = "";
  String visitId = "";

  bool isDisableView = true;

  @override
  void onInit() {
    super.onInit();

    loginData.value = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));
    isDisableView = !(isThirdParty.isNotEmpty);
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  void changeUserPinVisibility() {
    userPinVisibility.value = userPinVisibility == true ? false : true;
    userPinVisibility.refresh();
  }

  Future<void> setDoctor(Rxn<SelectedDoctorModel> doctorData) async {
    selectedDoctorValueModel = doctorData;

    selectedDoctorValue.value = selectedDoctorValueModel.value?.name;

    doctorList = globalController.selectedDoctorModel;
  }

  Future<void> setThirdParty(String thirdParty) async {
    loginData.value = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

    isDisableView = (thirdParty.isNotEmpty);
  }

  Future<void> checkDoctorPIN(String doctorId) async {
    try {
      checkPinResponse.value = await _patientInfoRepository.checkDoctorPIN(doctorId);
    } catch (e) {
      customPrint(e);
    }
  }

  Future<void> changeStatus() async {
    Map<String, dynamic> param = {};

    if (selectedDoctorValueModel.value?.id != loginData.value?.responseData?.user?.id) {
      param = {"status": "Finalized", "doctor_id": selectedDoctorValueModel.value?.id, "pin": userPINController.text};
    } else {
      param['status'] = "Finalized";
    }

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

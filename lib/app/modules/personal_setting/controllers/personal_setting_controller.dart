import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:subqdocs/app/routes/app_pages.dart';
import 'package:subqdocs/utils/Loader.dart';
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

  TextEditingController organizationNameController = TextEditingController();
  TextEditingController organizationEmailController = TextEditingController();
  TextEditingController organizationPhoneNumberController = TextEditingController();
  TextEditingController organizationAddress1Controller = TextEditingController();
  TextEditingController organizationAddress2Controller = TextEditingController();
  TextEditingController organizationStreetNameController = TextEditingController();
  TextEditingController organizationCityController = TextEditingController();
  TextEditingController organizationStateController = TextEditingController();
  TextEditingController organizationPostalCodeController = TextEditingController();
  TextEditingController organizationCountryController = TextEditingController();

  TextEditingController userFirstNameController = TextEditingController();
  TextEditingController userLastNameController = TextEditingController();
  TextEditingController userOrganizationNameNameController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPhoneNumberController = TextEditingController();
  TextEditingController userStreetNameController = TextEditingController();
  TextEditingController userCityController = TextEditingController();
  TextEditingController userStateController = TextEditingController();
  TextEditingController userPostalCodeController = TextEditingController();
  TextEditingController userCountryController = TextEditingController();

  RxBool isValid = RxBool(true);
  RxnString selectedRoleValue = RxnString("");

  List<String> adminStatus = ["Yes", "No"];
  RxnString selectedAdminValue = RxnString("Yes");
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();

    loginData.value = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getOrganizationDetail();
      getUserDetail();
      getUserByOrganization();
      getUserRole();
    });
  }

  Future<void> getOrganizationDetail() async {
    try {
      getOrganizationDetailModel.value = await _personalSettingRepository.getOrganizationDetail();
      setOrganizationData();
    } catch (error) {
      customPrint("login catch error is $error");
    }
  }

  Future<void> setOrganizationData() async {
    organizationNameController.text = getOrganizationDetailModel.value?.responseData?.name ?? "";
    organizationEmailController.text = getOrganizationDetailModel.value?.responseData?.email ?? "";
    organizationPhoneNumberController.text = getOrganizationDetailModel.value?.responseData?.contactNo ?? "";
    organizationAddress1Controller.text = getOrganizationDetailModel.value?.responseData?.address1 ?? "";
    organizationAddress2Controller.text = getOrganizationDetailModel.value?.responseData?.address2 ?? "";
    organizationStreetNameController.text = getOrganizationDetailModel.value?.responseData?.streetName ?? "";
    organizationCityController.text = getOrganizationDetailModel.value?.responseData?.city ?? "";
    organizationStateController.text = getOrganizationDetailModel.value?.responseData?.state ?? "";
    organizationPostalCodeController.text = getOrganizationDetailModel.value?.responseData?.postalCode ?? "";
    organizationCountryController.text = getOrganizationDetailModel.value?.responseData?.country ?? "";
  }

  Future<void> getUserDetail() async {
    try {
      getUserDetailModel.value = await _personalSettingRepository.getUserDetail(userId: loginData.value?.responseData!.user!.id.toString() ?? "");
      setUserDetail();
    } catch (error) {
      customPrint("login catch error is $error");
    }
  }

  Future<void> setUserDetail() async {
    userFirstNameController.text = getUserDetailModel.value?.responseData?.firstName ?? "";
    userLastNameController.text = getUserDetailModel.value?.responseData?.lastName ?? "";
    userEmailController.text = getUserDetailModel.value?.responseData?.email ?? "";
    userPhoneNumberController.text = getUserDetailModel.value?.responseData?.contactNo ?? "";
    userStreetNameController.text = getUserDetailModel.value?.responseData?.streetName ?? "";
    userCityController.text = getUserDetailModel.value?.responseData?.city ?? "";
    userStateController.text = getUserDetailModel.value?.responseData?.state ?? "";
    userPostalCodeController.text = getUserDetailModel.value?.responseData?.postalCode ?? "";
    userCountryController.text = getUserDetailModel.value?.responseData?.country ?? "";
  }

  Future<void> userInvite(Map<String, dynamic> param) async {
    try {
      InvitedUserResponseModel response = await _personalSettingRepository.userInvite(param: param);
      print("response is $response");

      Get.toNamed(Routes.INVITED_USER_SUBMITTED, arguments: {
        "invited_user_data": param,
      });
    } catch (error) {
      customPrint("userInvite catch error is $error");
    }
  }

  Future<void> updateUserDetail(Map<String, dynamic> param) async {
    try {
      dynamic response = await _personalSettingRepository.updateUserDetail(param: param);
      print("response is $response");

      // getOrganizationDetail();
      getUserDetail();
    } catch (error) {
      customPrint("userInvite catch error is $error");
    }
  }

  Future<void> updateOrganization(Map<String, dynamic> param) async {
    try {
      dynamic response = await _personalSettingRepository.updateOrganization(param: param);
      print("response is $response");

      getUserDetail();
      getOrganizationDetail();

      // Get.toNamed(Routes.INVITED_USER_SUBMITTED, arguments: {
      //   "invited_user_data": param,
      // });
    } catch (error) {
      customPrint("userInvite catch error is $error");
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
    Loader().showLoadingDialogForSimpleLoader();

    try {
      getUserOrganizationListModel.value = await _personalSettingRepository.getUserByOrganization();
      Get.back();
    } catch (error) {
      customPrint("login catch error is $error");
    }
  }

  Future<void> updateRoleAndAdminControll(String userId, String role, bool isAdmin, int rowIndex) async {
    Map<String, dynamic> param = {};
    param["user_id"] = userId;
    param["role"] = role;
    param["is_admin"] = isAdmin;

    Loader().showLoadingDialogForSimpleLoader();
    try {
      UpdateRoleAndAdminResponseModel updateRoleAndAdminResponseData = await _personalSettingRepository.updateRoleAndAdminControl(param: param);

      print("UpdateRoleAndAdminResponseModel response:- ${updateRoleAndAdminResponseData.toJson()}");

      if (updateRoleAndAdminResponseData.responseType?.toLowerCase() == "success") {
        getUserOrganizationListModel.value?.responseData?[rowIndex].isAdmin = isAdmin;
        getUserOrganizationListModel.value?.responseData?[rowIndex].role = role;
        getUserOrganizationListModel.refresh();
        CustomToastification().showToast(updateRoleAndAdminResponseData.message ?? "", type: ToastificationType.success);
      } else {
        CustomToastification().showToast(updateRoleAndAdminResponseData.message ?? "", type: ToastificationType.success);
      }
      Get.back();
      // getUserByOrganization();
    } catch (error) {
      Get.back();
      customPrint("login catch error is $error");
    }
  }
}

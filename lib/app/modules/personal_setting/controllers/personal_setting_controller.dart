import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:subqdocs/app/routes/app_pages.dart';
import 'package:subqdocs/utils/Loader.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/widgets/custom_toastification.dart';
import 'package:toastification/toastification.dart';

import '../../../../services/media_picker_services.dart';
import '../../../../utils/app_string.dart';
import '../../../core/common/app_preferences.dart';
import '../../../core/common/global_controller.dart';
import '../../../core/common/logger.dart';
import '../../../data/service/socket_service.dart';
import '../../login/model/login_model.dart';
import '../model/delete_user_model.dart';
import '../model/force_sync_log_model.dart';
import '../model/get_available_visit_types.dart';
import '../model/get_emaconfig_model.dart';
import '../model/get_user_detail_model.dart';
import '../model/update_user_response_model.dart';
import '../model/us_state_city_model.dart';
import '../repository/personal_setting_repository.dart';

class PersonalSettingController extends GetxController {
  //TODO: Implement PersonalSettingController

  Timer? forceSyncTimer;
  Rxn<ForceSyncLogModel> forceSyncLogModel = Rxn();

  // RxBool organizationEmaIntegration = RxBool(false);
  // RxBool organizationHasEmaConfig = RxBool(false);
  RxnString selectedAppointmentTypeValue = RxnString("");
  Rxn<GetAvailableVisitTypes> getAvailableVisitTypes = Rxn<GetAvailableVisitTypes>();

  RxInt tabIndex = RxInt(0);
  final PersonalSettingRepository _personalSettingRepository = PersonalSettingRepository();

  Rxn<GetUserDetailModel> getUserDetailModel = Rxn<GetUserDetailModel>();
  Rxn<GetUserRolesModel> userRolesModel = Rxn<GetUserRolesModel>();
  Rxn<GetUserOrganizationListModel> filterGetUserOrganizationListModel = Rxn<GetUserOrganizationListModel>();
  Rxn<GetUserOrganizationListModel> getUserOrganizationListModel = Rxn<GetUserOrganizationListModel>();
  Rxn<GetOrganizationDetailModel> getOrganizationDetailModel = Rxn<GetOrganizationDetailModel>();
  Rxn<LoginModel> loginData = Rxn<LoginModel>();

  final GlobalController globalController = Get.find();

  TextEditingController emailAddressController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  TextEditingController userInviteSearchController = TextEditingController();

  TextEditingController organizationGooglePickerController = TextEditingController();
  TextEditingController organizationNoOfProvidersController = TextEditingController();
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
  TextEditingController organizationDegreeController = TextEditingController();

  TextEditingController userFirstNameController = TextEditingController();
  TextEditingController userLastNameController = TextEditingController();
  TextEditingController userOrganizationNameNameController = TextEditingController();

  RxnString userRole = RxnString("Doctor");

  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPhoneNumberController = TextEditingController();
  TextEditingController userStreetNameController = TextEditingController();
  TextEditingController userCityController = TextEditingController();
  TextEditingController userStateController = TextEditingController();
  TextEditingController userPostalCodeController = TextEditingController();
  TextEditingController userCountryController = TextEditingController();

  TextEditingController userPractitionerController = TextEditingController();
  TextEditingController userMedicalLicenseNumberController = TextEditingController();
  TextEditingController userLicenseExpiryDateController = TextEditingController();
  TextEditingController userNationalProviderIdentifierController = TextEditingController();
  TextEditingController userTaxonomyCodeController = TextEditingController();
  TextEditingController userSpecializationController = TextEditingController();
  TextEditingController userPINController = TextEditingController();
  RxBool userPinVisibility = RxBool(true);

  RxBool isValid = RxBool(true);
  RxnString selectedRoleValue = RxnString("");

  List<String> adminStatus = ["Yes", "No"];
  RxnString selectedAdminValue = RxnString("Yes");
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Rxn<File> userProfileImage = Rxn();
  Rxn<File> organizationProfileImage = Rxn();

  List<String> countryOption = ["United States"];
  RxnString selectedCountryValue = RxnString("United States");

  List<String> userStateOption = [];
  RxnString userSelectedStateValue = RxnString("");

  RxList<String> userCityOption = RxList();
  RxnString userSelectedCityValue = RxnString("");

  List<String> organizationStateOption = [];
  RxnString organizationSelectedStateValue = RxnString("");

  List<String> organizationCityOption = [];
  RxnString organizationSelectedCityValue = RxnString("");

  RxList<StateCityModel> statesCities = RxList();

  List<String> emaVenderList = ["MODMED"];
  RxnString selectedEmaVender = RxnString("MODMED");
  TextEditingController emaBaseUrlController = TextEditingController();

  // TextEditingController emaFirmURLPrefixController = TextEditingController();
  TextEditingController emaAPIKeyController = TextEditingController();
  TextEditingController emaAPIUsernameController = TextEditingController();
  TextEditingController emaAPIPasswordController = TextEditingController();

  SocketService socketService = SocketService();

  @override
  void onInit() {
    super.onInit();

    customPrint("setting controller called");
    tabIndex.value = 0;

    userInviteSearchController.clear();

    loginData.value = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getOrganizationDetail();
      getUserDetail();
      getUserByOrganization();
      getUserRole();
      getAvailablePatientVisitTypes();
      getEmaConfig();
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the screen is disposed (navigated away)
    customPrint("PersonalSettingController dispose called");
    forceSyncTimer?.cancel();
    forceSyncTimer = null; // Explicitly nullify
    super.dispose();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();

    customPrint("on ready call ");
    _startSyncTimer();
    forceSyncSocketSetup();
    getAvailablePatientVisitTypes();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();

    forceSyncTimer = null;
    if (globalController.getKeyByValue(globalController.breadcrumbHistory.last) == Routes.PERSONAL_SETTING) {
      globalController.popRoute();
    }
  }

  // void initialSetup() {
  //   tabIndex.value = 0;
  //
  //   userInviteSearchController.clear();
  //
  //   loginData.value = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));
  //
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     getOrganizationDetail();
  //     getUserDetail();
  //     getUserByOrganization();
  //     getUserRole();
  //     getAvailablePatientVisitTypes();
  //     getEmaConfig();
  //     //
  //     // _startSyncTimer();
  //     // forceSyncSocketSetup();
  //   });
  // }

  void forceSyncSocketSetup() {
    if (globalController.getEMAOrganizationDetailModel.value?.responseData?.isEmaIntegration ?? false) {
      var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

      socketService.socket.emit("EMA_user_joined", [loginData.responseData?.user?.id]);

      // socketService.socket.off("force_sync_completed");
      // socketService.socket.off("force_sync_started");

      socketService.socket.on("force_sync_completed", (data) {
        var res = data as Map<String, dynamic>;
        // String message = res["message"];
        _fetchSyncLog();
        // CustomToastification().showToast(message, type: ToastificationType.success);
        customPrint("---------------------------------------------");
        customPrint("force_sync_completed status is :- $res");
        // forceSyncLogModel.value?.responseData?.isSyncing = false;
      });

      socketService.socket.on("force_sync_started", (data) {
        var res = data as Map<String, dynamic>;
        // String message = res["message"];
        customPrint("---------------------------------------------");
        customPrint("force_sync_started status is :- $res");
        _fetchSyncLog();
        // CustomToastification().showToast(message, type: ToastificationType.info);
        // forceSyncLogModel.value?.responseData?.isSyncing = true;
      });
    }
  }

  void activeUser(Map<String, dynamic> param) async {
    DefaultResponseModel model = await _personalSettingRepository.activeUser(param);

    if (model.responseType == "success") {
      getUserByOrganization();
    } else {
      CustomToastification().showToast(model.message ?? "", type: ToastificationType.error);
    }
  }

  void _startSyncTimer() {
    // Call immediately first time
    // Then set up periodic timer

    // forceSyncTimer?.cancel();

    // forceSyncTimer = Timer.periodic(const Duration(seconds: 7), (timer) {
    _fetchSyncLog();
    // });
  }

  Future<void> _fetchSyncLog() async {
    customPrint("fetchSyncLog");
    try {
      final response = await _personalSettingRepository.getForceSyncLog();
      // print("foce sync response is :- ${response.toJson()}");
      forceSyncLogModel.value = response;
    } catch (e) {
      customPrint("Error fetching sync log: $e");
    }
  }

  void _cancelTimer() {
    forceSyncTimer?.cancel();
    forceSyncTimer = null;
  }

  Future<void> getAvailablePatientVisitTypes() async {
    getAvailableVisitTypes.value = await _personalSettingRepository.getAvailableVisitTypes();

    // selectedAppointmentTypeValue.value = getAvailableVisitTypes.value?.responseData?.first.display;
  }

  Future<void> forceSyncUpdate() async {
    Loader().showLoadingDialogForSimpleLoader();
    Map<String, dynamic> _ = await _personalSettingRepository.forceSyncUpdate();
    Loader().stopLoader();
    _fetchSyncLog();
    // CustomToastification().showToast(response['message'], type: ToastificationType.success);
  }

  Future<bool> saveEmaConfig(Map<String, dynamic> param) async {
    Loader().showLoadingDialogForSimpleLoader();
    Map<String, dynamic> response = await _personalSettingRepository.saveEmaConfig(param);

    if (response["response_type"] != "Failure") {
      CustomToastification().showToast(response['message'], type: ToastificationType.success);

      getAvailablePatientVisitTypes();
      await getOrganizationDetail();

      Loader().stopLoader();
      return true;
    } else {
      Loader().stopLoader();
      CustomToastification().showToast(response['message'], type: ToastificationType.error);
      return false;
    }

    // Loader().stopLoader();
    // getEmaConfig();
  }

  Future<void> getEmaConfig() async {
    GetEmaConfigModel response = await _personalSettingRepository.getEmaConfig();

    if (response.responseType?.toLowerCase() != "failure") {
      for (GetEmaConfigResponseData data in response.responseData ?? []) {
        if (data.key == "base_url") {
          emaBaseUrlController.text = data.value ?? "";
        } else if (data.key == "api_key") {
          emaAPIKeyController.text = data.value ?? "";
        } else if (data.key == "api_username") {
          emaAPIUsernameController.text = data.value ?? "";
        } else if (data.key == "api_password") {
          emaAPIPasswordController.text = data.value ?? "";
        }
      }
    }
  }

  void changeUserPinVisiblity() {
    userPinVisibility.value = userPinVisibility == true ? false : true;
    userPinVisibility.refresh();
  }

  Future<List<StateCityModel>> loadStateCityData() async {
    // Load the JSON file from assets
    String jsonString = await rootBundle.loadString('assets/states_cities.json');

    // Decode the JSON data
    Map<String, dynamic> jsonData = json.decode(jsonString);

    // print("json data is :- $jsonData");

    // Parse the JSON data into a list of StateCityModel objects
    return StateCityModel.fromJson(jsonData);
  }

  Future<void> getOrganizationDetail() async {
    // try {
    getOrganizationDetailModel.value = await _personalSettingRepository.getOrganizationDetail();
    globalController.getEMAOrganizationDetailModel.value = getOrganizationDetailModel.value;

    setOrganizationData();
    // } catch (error) {
    //   customPrint("login catch error is $error");
    // }
  }

  String formatPhoneNumber(String rawNumber) {
    // Ensure the number is exactly 10 digits (US phone number format)
    if (rawNumber.length == 11) {
      return '+1 (${rawNumber.substring(1, 4)}) ${rawNumber.substring(4, 7)}-${rawNumber.substring(7)}';
    } else {
      // Handle invalid number length (you can customize this behavior)
      return '+1 ';
    }
  }

  String extractDigits(String input) {
    // Use a regular expression to extract digits only
    return input.replaceAll(RegExp(r'\D'), '');
  }

  Future<void> setOrganizationData() async {
    organizationNameController.text = getOrganizationDetailModel.value?.responseData?.name ?? "";
    organizationEmailController.text = getOrganizationDetailModel.value?.responseData?.email ?? "";

    organizationPhoneNumberController.text = formatPhoneNumber(getOrganizationDetailModel.value?.responseData?.contactNo ?? "");
    selectedAppointmentTypeValue.value = getOrganizationDetailModel.value?.responseData?.appointmentType?.label;

    organizationAddress1Controller.text = getOrganizationDetailModel.value?.responseData?.address1 ?? "";
    organizationAddress2Controller.text = getOrganizationDetailModel.value?.responseData?.address2 ?? "";
    organizationStreetNameController.text = getOrganizationDetailModel.value?.responseData?.streetName ?? "";
    organizationCityController.text = getOrganizationDetailModel.value?.responseData?.city ?? "";
    organizationStateController.text = getOrganizationDetailModel.value?.responseData?.state ?? "";
    organizationPostalCodeController.text = getOrganizationDetailModel.value?.responseData?.postalCode ?? "";
    organizationCountryController.text = getOrganizationDetailModel.value?.responseData?.country ?? "";
  }

  Future<void> getUserDetail() async {
    // try {
    getUserDetailModel.value = await _personalSettingRepository.getUserDetail(userId: loginData.value?.responseData?.user?.id.toString() ?? "");

    // getUserDetailModel.value?.responseData?.isAdmin = true;

    setUserDetail();
    // } catch (error) {
    //   customPrint("login catch error is $error");
    // }
  }

  Future<void> setUserDetail() async {
    customPrint("user data:- ${getUserDetailModel.value?.responseData?.toJson()}");

    userRole.value = getUserDetailModel.value?.responseData?.role;
    userRole.refresh();
    userOrganizationNameNameController.text = getUserDetailModel.value?.responseData?.organizationName ?? "";
    userFirstNameController.text = getUserDetailModel.value?.responseData?.firstName ?? "";
    userLastNameController.text = getUserDetailModel.value?.responseData?.lastName ?? "";
    userEmailController.text = getUserDetailModel.value?.responseData?.email ?? "";
    userPhoneNumberController.text = formatPhoneNumber(getUserDetailModel.value?.responseData?.contactNo ?? "");
    userStreetNameController.text = getUserDetailModel.value?.responseData?.streetName ?? "";
    userCityController.text = getUserDetailModel.value?.responseData?.city ?? "";
    userStateController.text = getUserDetailModel.value?.responseData?.state ?? "";

    userPINController.text = getUserDetailModel.value?.responseData?.pin ?? "";
    userPostalCodeController.text = getUserDetailModel.value?.responseData?.postalCode ?? "";
    userCountryController.text = getUserDetailModel.value?.responseData?.country ?? "";

    userPractitionerController.text = getUserDetailModel.value?.responseData?.title ?? "";
    organizationDegreeController.text = getUserDetailModel.value?.responseData?.degree ?? "";
    userMedicalLicenseNumberController.text = getUserDetailModel.value?.responseData?.medicalLicenseNumber ?? "";

    if (getUserDetailModel.value?.responseData?.licenseExpiryDate != null) {
      // userLicenseExpiryDateController.text = getUserDetailModel.value?.responseData?.licenseExpiryDate ?? "";
      userLicenseExpiryDateController.text = DateFormat('MM/dd/yyyy').format(DateTime.parse(getUserDetailModel.value?.responseData?.licenseExpiryDate ?? ""));
    }

    userNationalProviderIdentifierController.text = getUserDetailModel.value?.responseData?.nationalProviderIdentifier?.toString() ?? "";
    userTaxonomyCodeController.text = getUserDetailModel.value?.responseData?.taxonomyCode ?? "";
    userSpecializationController.text = getUserDetailModel.value?.responseData?.specialization ?? "";
  }

  Future<void> userInvite(Map<String, dynamic> param) async {
    try {
      InvitedUserResponseModel _ = await _personalSettingRepository.userInvite(param: param);

      emailAddressController.text = "";
      firstNameController.text = "";
      lastNameController.text = "";
      selectedRoleValue.value = "";

      getOrganizationDetail();
      getUserDetail();
      getUserByOrganization();
      getUserRole();

      globalController.getDoctorsFilter();
      globalController.getMedicalAssistance();
    } catch (error) {
      customPrint("userInvite catch error is $error");
    }
  }

  Future<void> updateUserDetail(Map<String, dynamic> param) async {
    Map<String, List<File>> profileParams = {};
    var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

    if (userProfileImage.value != null) {
      profileParams['user_image'] = [userProfileImage.value!];
    } else {
      if (getUserDetailModel.value?.responseData?.profileImage == null) {
        param['isDeleteProfileImage'] = true;
      }
    }
    customPrint("user loader start");
    Loader().showLoadingDialogForSimpleLoader();

    try {
      dynamic response = await _personalSettingRepository.updateUserDetail(param: param, files: profileParams, token: loginData.responseData?.token ?? "");

      Loader().stopLoader();

      customPrint("updateUserDetail is $response");

      if (userProfileImage.value != null) {
        globalController.getDoctorsFilter();
        globalController.getMedicalAssistance();
      }

      UpdateUserResponseModel updateUserResponseModel = UpdateUserResponseModel.fromJson(response);

      CustomToastification().showToast(updateUserResponseModel.message ?? "", type: ToastificationType.success);

      getUserDetail();
      globalController.getUserDetail();

      if (updateUserResponseModel.responseData?.token != null) {
        String loginKey = AppPreference.instance.getString(AppString.prefKeyUserLoginData);
        if (loginKey.isNotEmpty) {
          LoginModel loginModel = LoginModel.fromJson(jsonDecode(loginKey));
          loginModel.responseData?.token = updateUserResponseModel.responseData?.token;

          AppPreference.instance.setString(loginModel.responseData?.token ?? "", AppString.prefKeyToken);
          await AppPreference.instance.setString(AppString.prefKeyUserLoginData, json.encode(loginModel.toJson()));
        }
      }
    } catch (e) {
      Loader().stopLoader();
      CustomToastification().showToast(e.toString() ?? "", type: ToastificationType.error);
    }
  }

  Future<void> updateOrganization(Map<String, dynamic> param) async {
    Loader().showLoadingDialogForSimpleLoader();

    Map<String, List<File>> profileParams = {};
    var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

    if (organizationProfileImage.value != null) {
      customPrint("profile is   available");
      profileParams['org_image'] = [organizationProfileImage.value!];
    } else {
      if (getOrganizationDetailModel.value?.responseData?.profileImage == null) {
        param['isDeleteProfileImage'] = true;
      }
    }

    customPrint("param is :- $param");

    try {
      Map<String, dynamic> res = await _personalSettingRepository.updateOrganization(param: param, files: profileParams, token: loginData.responseData?.token ?? "");

      DefaultResponseModel response = DefaultResponseModel.fromJson(res);
      customPrint("updateOrganization is $response");

      if (response.responseType == "error") {
        Loader().stopLoader();
        CustomToastification().showToast(response.message ?? "", type: ToastificationType.error);
      } else {
        Loader().stopLoader();
        getUserDetail();
        getOrganizationDetail();
      }

      // Get.back();
    } catch (e) {
      // Get.back();
      Loader().stopLoader();
      CustomToastification().showToast(e.toString() ?? "", type: ToastificationType.error);
      customPrint("userInvite catch error is ${e.toString()}");
    }
  }

  Future<void> getUserRole() async {
    // try {
    userRolesModel.value = await _personalSettingRepository.getUserRole();
    selectedRoleValue.value = userRolesModel.value?.responseData?.first;
    // } catch (error) {
    //   customPrint("login catch error is $error");
    // }
  }

  Future<void> getUserByOrganization() async {
    Loader().showLoadingDialogForSimpleLoader();

    try {
      getUserOrganizationListModel.value = await _personalSettingRepository.getUserByOrganization();
      filterGetUserOrganizationListModel.value = GetUserOrganizationListModel.fromJson(getUserOrganizationListModel.toJson());
      // customPrint("getUserOrganizationListModel is ${getUserOrganizationListModel.value?.responseData?.first.toJson()}");
      Loader().stopLoader();
    } catch (error) {
      Loader().stopLoader();
      customPrint("login catch error is $error");
    }
  }

  Future<void> deleteUserManagementMember(String userId) async {
    DeleteUserModel response = await _personalSettingRepository.deleteUserManagementMember(userId: userId);

    if (response.responseType == "success") {
      getUserByOrganization();
    } else {
      CustomToastification().showToast(response.message ?? "", type: ToastificationType.error);
    }
  }

  Future<void> deleteAccount() async {
    try {
      Loader().showLoadingDialogForSimpleLoader();

      DeleteUserModel response = await _personalSettingRepository.deleteUserAccount(userId: globalController.getUserDetailModel.value?.responseData?.id.toString() ?? "");
      if (response.responseType == "success") {
        await AppPreference.instance.removeKey(AppString.prefKeyUserLoginData);
        await AppPreference.instance.removeKey(AppString.prefKeyToken);
        await AppPreference.instance.removeKey("homePastPatientListSortingModel");
        await AppPreference.instance.removeKey("homePatientListSortingModel");
        await AppPreference.instance.removeKey("homeScheduleListSortingModel");
        Get.delete<GlobalController>();
        Get.offAllNamed(Routes.LOGIN);
      } else {
        CustomToastification().showToast(response.message ?? "", type: ToastificationType.error);
      }

      Loader().stopLoader();
    } catch (e) {
      Loader().stopLoader();
      CustomToastification().showToast(e.toString(), type: ToastificationType.error);
    }
  }

  Future<void> updateRoleAndAdminControll(String userId, String role, bool isAdmin, int rowIndex) async {
    Map<String, dynamic> param = {};
    param["user_id"] = userId;
    param["role"] = role;
    param["is_admin"] = isAdmin;

    // Loader().showLoadingDialogForSimpleLoader();
    // try {
    UpdateRoleAndAdminResponseModel updateRoleAndAdminResponseData = await _personalSettingRepository.updateRoleAndAdminControl(param: param);

    customPrint("UpdateRoleAndAdminResponseModel response:- ${updateRoleAndAdminResponseData.toJson()}");

    if (updateRoleAndAdminResponseData.responseType?.toLowerCase() == "success") {
      getUserOrganizationListModel.value?.responseData?[rowIndex].isAdmin = isAdmin;
      getUserOrganizationListModel.value?.responseData?[rowIndex].role = role;

      filterGetUserOrganizationListModel.value = GetUserOrganizationListModel.fromJson(getUserOrganizationListModel.toJson());
      filterGetUserOrganizationListModel.refresh();

      getUserOrganizationListModel.refresh();
      globalController.getDoctorsFilter();
      globalController.getMedicalAssistance();

      CustomToastification().showToast(updateRoleAndAdminResponseData.message ?? "", type: ToastificationType.success);
    } else {
      CustomToastification().showToast(updateRoleAndAdminResponseData.message ?? "", type: ToastificationType.error);
    }
  }

  Future<void> captureProfileImage(bool isUserProfile) async {
    XFile? pickedImage = await MediaPickerServices().pickImage();
    customPrint("picked image is  $pickedImage");

    if (isUserProfile) {
      if (pickedImage != null) {
        userProfileImage.value = File(pickedImage.path);
        updateUserDetail({});
      }
    } else {
      if (pickedImage != null) {
        organizationProfileImage.value = File(pickedImage.path);
        updateOrganization({});
      }
    }
  }

  Future<void> pickProfileImage(bool isUserProfile) async {
    XFile? pickedImage = await MediaPickerServices().pickImage(fromCamera: false);

    if (isUserProfile) {
      if (pickedImage != null) {
        userProfileImage.value = File(pickedImage.path);
        updateUserDetail({});
      }
    } else {
      if (pickedImage != null) {
        organizationProfileImage.value = File(pickedImage.path);
        updateOrganization({});
      }
    }
  }

  void showImagePickerDialog(BuildContext context, bool isUserProfile) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          title: const Text('Pick an Image'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Pick from Camera'),
                onTap: () {
                  captureProfileImage(isUserProfile);
                  Navigator.pop(context);
                  // Add your camera picking logic here
                  customPrint('Camera selected');
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pick from Gallery'),
                onTap: () {
                  pickProfileImage(isUserProfile);
                  Navigator.pop(context);
                  // Add your gallery picking logic here
                  customPrint('Gallery selected');
                },
              ),
              if (isUserProfile) ...[
                if (getUserDetailModel.value?.responseData?.profileImage != null) ...[
                  ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text('Remove Profile Image'),
                    onTap: () {
                      if (isUserProfile) {
                        userProfileImage.value = null;
                        getUserDetailModel.value?.responseData?.profileImage = null;

                        updateUserDetail({});
                      } else {
                        organizationProfileImage.value = null;
                        getOrganizationDetailModel.value?.responseData?.profileImage = null;

                        updateOrganization({});
                      }
                      // pickProfileImage(isUserProfile);
                      Navigator.pop(context);
                      // Add your gallery picking logic here
                      customPrint('Gallery selected');
                    },
                  ),
                ],
              ] else ...[
                if (getOrganizationDetailModel.value?.responseData?.profileImage != null) ...[
                  ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text('Remove Profile Image'),
                    onTap: () {
                      if (isUserProfile) {
                        userProfileImage.value = null;
                        getUserDetailModel.value?.responseData?.profileImage = null;

                        updateUserDetail({});
                      } else {
                        organizationProfileImage.value = null;
                        getOrganizationDetailModel.value?.responseData?.profileImage = null;

                        updateOrganization({});
                      }
                      // pickProfileImage(isUserProfile);
                      Navigator.pop(context);
                      // Add your gallery picking logic here
                      customPrint('Gallery selected');
                    },
                  ),
                ],
              ],
            ],
          ),
        );
      },
    );
  }

  void resetUserManagementFilters() {
    userInviteSearchController.text = "";
    // Reset to original data
    filterGetUserOrganizationListModel.value?.responseData = List.from(getUserOrganizationListModel.value?.responseData ?? []);

    if (filterGetUserOrganizationListModel.value?.responseData != getUserOrganizationListModel.value?.responseData) {
      filterGetUserOrganizationListModel.refresh();
    }
  }

  void filterUsers(String value) {
    if (value.isNotEmpty) {
      filterGetUserOrganizationListModel.value?.responseData =
          getUserOrganizationListModel.value?.responseData?.where((element) {
            String userName = (element.name?.trim().toLowerCase() ?? "").trim().toLowerCase();
            String userEmail = (element.email?.trim().toLowerCase() ?? "").trim().toLowerCase();
            return (userName.contains(value) || userEmail.contains(value));
          }).toList();

      filterGetUserOrganizationListModel.refresh();
    } else {
      // Reset to original data when no filter value
      filterGetUserOrganizationListModel.value?.responseData = List.from(getUserOrganizationListModel.value?.responseData ?? []);

      if (filterGetUserOrganizationListModel.value?.responseData != getUserOrganizationListModel.value?.responseData) {
        filterGetUserOrganizationListModel.refresh();
      }
    }
  }
}

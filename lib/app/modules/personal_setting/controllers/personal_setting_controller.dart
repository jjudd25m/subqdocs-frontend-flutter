import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
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
import '../../home/model/patient_list_model.dart';
import '../../login/model/login_model.dart';
import '../model/get_user_detail_model.dart';
import '../model/us_state_city_model.dart';
import '../repository/personal_setting_repository.dart';

class PersonalSettingController extends GetxController {
  //TODO: Implement PersonalSettingController

  RxInt tabIndex = RxInt(0);
  final PersonalSettingRepository _personalSettingRepository = PersonalSettingRepository();
  // RxList<PatientListData> patientList = RxList<PatientListData>();
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

  TextEditingController userPractitionerController = TextEditingController();
  TextEditingController userMedicalLicenseNumberController = TextEditingController();
  TextEditingController userLicenseExpiryDateController = TextEditingController();
  TextEditingController userNationalProviderIdentifierController = TextEditingController();
  TextEditingController userTaxonomyCodeController = TextEditingController();
  TextEditingController userSpecializationController = TextEditingController();

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

  List<String> userCityOption = [];
  RxnString userSelectedCityValue = RxnString("");

  List<String> organizationStateOption = [];
  RxnString organizationSelectedStateValue = RxnString("");

  List<String> organizationCityOption = [];
  RxnString organizationSelectedCityValue = RxnString("");

  RxList<StateCityModel> statesCities = RxList();

  @override
  void onInit() {
    super.onInit();

    loginData.value = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      globalController.addRouteInit(Routes.PERSONAL_SETTING);

      loadStateCityData().then((data) {
        statesCities.value = data;
        userStateOption = statesCities.map((state) => state.state).toList();
        userSelectedStateValue.value = userStateOption.first;

        organizationStateOption = statesCities.map((state) => state.state).toList();
        organizationSelectedStateValue.value = organizationStateOption.first;
      });

      getOrganizationDetail();
      getUserDetail();
      getUserByOrganization();
      getUserRole();
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();

    if (globalController.getKeyByValue(globalController.breadcrumbHistory.last) == Routes.PERSONAL_SETTING) {
      globalController.popRoute();
    }
  }

  Future<List<StateCityModel>> loadStateCityData() async {
    // Load the JSON file from assets
    String jsonString = await rootBundle.loadString('assets/states_cities.json');

    // Decode the JSON data
    Map<String, dynamic> jsonData = json.decode(jsonString);

    // Parse the JSON data into a list of StateCityModel objects
    return StateCityModel.fromJson(jsonData);
  }

  Future<void> getOrganizationDetail() async {
    // try {
    getOrganizationDetailModel.value = await _personalSettingRepository.getOrganizationDetail();
    setOrganizationData();
    // } catch (error) {
    //   customPrint("login catch error is $error");
    // }
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
    // try {
    getUserDetailModel.value = await _personalSettingRepository.getUserDetail(userId: loginData.value?.responseData!.user!.id.toString() ?? "");
    print("getUserDetailModel :- ${getUserDetailModel.value?.toJson()}");
    setUserDetail();
    // } catch (error) {
    //   customPrint("login catch error is $error");
    // }
  }

  Future<void> setUserDetail() async {
    userOrganizationNameNameController.text = getUserDetailModel.value?.responseData?.organizationName ?? "";
    userFirstNameController.text = getUserDetailModel.value?.responseData?.firstName ?? "";
    userLastNameController.text = getUserDetailModel.value?.responseData?.lastName ?? "";
    userEmailController.text = getUserDetailModel.value?.responseData?.email ?? "";
    userPhoneNumberController.text = getUserDetailModel.value?.responseData?.contactNo ?? "";
    userStreetNameController.text = getUserDetailModel.value?.responseData?.streetName ?? "";
    userCityController.text = getUserDetailModel.value?.responseData?.city ?? "";
    userStateController.text = getUserDetailModel.value?.responseData?.state ?? "";
    userPostalCodeController.text = getUserDetailModel.value?.responseData?.postalCode ?? "";
    userCountryController.text = getUserDetailModel.value?.responseData?.country ?? "";

    userPractitionerController.text = getUserDetailModel.value?.responseData?.title ?? "";
    userMedicalLicenseNumberController.text = getUserDetailModel.value?.responseData?.medicalLicenseNumber ?? "";
    userLicenseExpiryDateController.text = getUserDetailModel.value?.responseData?.licenseExpiryDate ?? "";
    userNationalProviderIdentifierController.text = getUserDetailModel.value?.responseData?.nationalProviderIdentifier.toString() ?? "";
    userTaxonomyCodeController.text = getUserDetailModel.value?.responseData?.taxonomyCode ?? "";
    userSpecializationController.text = getUserDetailModel.value?.responseData?.specialization ?? "";
  }

  Future<void> userInvite(Map<String, dynamic> param) async {
    try {
      InvitedUserResponseModel response = await _personalSettingRepository.userInvite(param: param);
      print("response is $response");

      // await Get.toNamed(Routes.INVITED_USER_SUBMITTED, arguments: {
      //   "invited_user_data": param,
      // });

      getOrganizationDetail();
      getUserDetail();
      getUserByOrganization();
      getUserRole();
    } catch (error) {
      customPrint("userInvite catch error is $error");
    }
  }

  Future<void> updateUserDetail(Map<String, dynamic> param) async {
    Map<String, List<File>> profileParams = {};
    var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

    if (userProfileImage.value != null) {
      // customPrint("profile is   available");
      // param['profile_image'] = profileImage.value;
      profileParams['user_image'] = [userProfileImage.value!];
    }

    try {
      dynamic response = await _personalSettingRepository.updateUserDetail(param: param, files: profileParams, token: loginData.responseData?.token ?? "");
      print("updateUserDetail is $response");

      // getOrganizationDetail();
      getUserDetail();
    } catch (error) {
      // customPrint("userInvite catch error is $error");
    }
  }

  Future<void> updateOrganization(Map<String, dynamic> param) async {
    Map<String, List<File>> profileParams = {};
    var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

    if (userProfileImage.value != null) {
      customPrint("profile is   available");
      // param['profile_image'] = profileImage.value;
      profileParams['org_image'] = [organizationProfileImage.value!];
    }

    try {
      dynamic response = await _personalSettingRepository.updateOrganization(param: param, files: profileParams, token: loginData.responseData?.token ?? "");
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
    // try {
    userRolesModel.value = await _personalSettingRepository.getUserRole();
    selectedRoleValue.value = userRolesModel.value?.responseData?.first;
    // } catch (error) {
    //   customPrint("login catch error is $error");
    // }
  }

  Future<void> getUserByOrganization() async {
    Loader().showLoadingDialogForSimpleLoader();

    // try {
    getUserOrganizationListModel.value = await _personalSettingRepository.getUserByOrganization();
    filterGetUserOrganizationListModel.value = GetUserOrganizationListModel.fromJson(getUserOrganizationListModel.toJson());

    Get.back();
    // } catch (error) {
    //   customPrint("login catch error is $error");
    // }
  }

  Future<void> updateRoleAndAdminControll(String userId, String role, bool isAdmin, int rowIndex) async {
    Map<String, dynamic> param = {};
    param["user_id"] = userId;
    param["role"] = role;
    param["is_admin"] = isAdmin;

    Loader().showLoadingDialogForSimpleLoader();
    // try {
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
    // } catch (error) {
    //   Get.back();
    //   customPrint("login catch error is $error");
    // }
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
          title: Text('Pick an Image'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Pick from Camera'),
                onTap: () {
                  captureProfileImage(isUserProfile);
                  Navigator.pop(context);
                  // Add your camera picking logic here
                  customPrint('Camera selected');
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Pick from Gallery'),
                onTap: () {
                  pickProfileImage(isUserProfile);
                  Navigator.pop(context);
                  // Add your gallery picking logic here
                  customPrint('Gallery selected');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

import '../../../../services/media_picker_services.dart';
import '../../../../utils/Loader.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_string.dart';
import '../../../../widgets/custom_toastification.dart';
import '../../../core/common/app_preferences.dart';
import '../../../core/common/global_controller.dart';
import '../../../core/common/global_mobile_controller.dart';
import '../../../core/common/logger.dart';
import '../../../modules/login/model/login_model.dart';
import '../../../modules/personal_setting/model/delete_user_model.dart';
import '../../../modules/personal_setting/model/get_user_detail_model.dart';
import '../../../modules/personal_setting/model/update_user_response_model.dart';
import '../../../modules/personal_setting/repository/personal_setting_repository.dart';
import '../../../routes/app_pages.dart';

class PersonalSettingMobileViewController extends GetxController {
  //TODO: Implement PersonalSettingMobileViewController

  final ScrollController scrollController = ScrollController();
  final List<GlobalKey> tabKeys = [
    GlobalKey(), // Personal Setting (index 0)
    // GlobalKey(), // Organization Management (index 1)
    GlobalKey(), // More document (index 2)
    // GlobalKey(), // User Management (index 2)
    // GlobalKey(), // Change Password (index 3)
  ];

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Rxn<GetUserDetailModel> getUserDetailModel = Rxn<GetUserDetailModel>();
  final PersonalSettingRepository _personalSettingRepository = PersonalSettingRepository();
  RxInt tabIndex = RxInt(0);

  // User detail
  RxnString userRole = RxnString("Doctor");
  Rxn<File> userProfileImage = Rxn();

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

  TextEditingController userPINController = TextEditingController();
  RxBool userPinVisibility = RxBool(true);

  TextEditingController organizationDegreeController = TextEditingController();

  Rxn<LoginModel> loginData = Rxn<LoginModel>();

  final GlobalController globalController = Get.find();

  // Change password
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final RxBool isPasswordVisible = true.obs;
  final RxBool isConfirmPasswordVisible = true.obs;

  @override
  void onInit() {
    super.onInit();

    loginData.value = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

    getUserDetail();
  }

  Future<void> getUserDetail() async {
    getUserDetailModel.value = await _personalSettingRepository.getUserDetail(userId: loginData.value?.responseData?.user?.id.toString() ?? "");
    setUserDetail();
  }

  Future<void> setUserDetail() async {
    print("user data:- ${getUserDetailModel.value?.responseData?.toJson()}");

    userRole.value = getUserDetailModel.value?.responseData?.role;
    userRole.refresh();
    userOrganizationNameNameController.text = getUserDetailModel.value?.responseData?.organizationName ?? "";
    userFirstNameController.text = getUserDetailModel.value?.responseData?.firstName ?? "";
    userLastNameController.text = getUserDetailModel.value?.responseData?.lastName ?? "";
    userEmailController.text = getUserDetailModel.value?.responseData?.email ?? "";
    userPhoneNumberController.text = formatPhoneNumber(getUserDetailModel.value?.responseData?.contactNo ?? "");
    userStreetNameController.text = getUserDetailModel.value?.responseData?.streetName ?? "";
    userPINController.text = getUserDetailModel.value?.responseData?.pin ?? "";
    userCityController.text = getUserDetailModel.value?.responseData?.city ?? "";
    userStateController.text = getUserDetailModel.value?.responseData?.state ?? "";
    userPostalCodeController.text = getUserDetailModel.value?.responseData?.postalCode ?? "";
    userCountryController.text = getUserDetailModel.value?.responseData?.country ?? "";

    userPractitionerController.text = getUserDetailModel.value?.responseData?.title ?? "";
    userMedicalLicenseNumberController.text = getUserDetailModel.value?.responseData?.medicalLicenseNumber ?? "";

    if (getUserDetailModel.value?.responseData?.licenseExpiryDate != null) {
      // userLicenseExpiryDateController.text = getUserDetailModel.value?.responseData?.licenseExpiryDate ?? "";
      userLicenseExpiryDateController.text = DateFormat('MM/dd/yyyy').format(DateTime.parse(getUserDetailModel.value?.responseData?.licenseExpiryDate ?? ""));
    }

    userNationalProviderIdentifierController.text = getUserDetailModel.value?.responseData?.nationalProviderIdentifier?.toString() ?? "";
    userTaxonomyCodeController.text = getUserDetailModel.value?.responseData?.taxonomyCode ?? "";
    userSpecializationController.text = getUserDetailModel.value?.responseData?.specialization ?? "";
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

  void changeUserPinVisiblity() {
    userPinVisibility.value = userPinVisibility == true ? false : true;
    userPinVisibility.refresh();
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
                  // customPrint('Camera selected');
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pick from Gallery'),
                onTap: () {
                  pickProfileImage(isUserProfile);
                  Navigator.pop(context);
                  // Add your gallery picking logic here
                  // customPrint('Gallery selected');
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
                        // organizationProfileImage.value = null;
                        // getOrganizationDetailModel.value?.responseData?.profileImage = null;

                        // updateOrganization({});
                      }
                      // pickProfileImage(isUserProfile);
                      Navigator.pop(context);
                      // Add your gallery picking logic here
                      // customPrint('Gallery selected');
                    },
                  ),
                ],
              ] else ...[
                // if (getOrganizationDetailModel.value?.responseData?.profileImage != null) ...[
                //   ListTile(
                //     leading: Icon(Icons.delete),
                //     title: Text('Remove Profile Image'),
                //     onTap: () {
                //       if (isUserProfile) {
                //         userProfileImage.value = null;
                //         getUserDetailModel.value?.responseData?.profileImage = null;
                //
                //         updateUserDetail({});
                //       } else {
                //         organizationProfileImage.value = null;
                //         getOrganizationDetailModel.value?.responseData?.profileImage = null;
                //
                //         updateOrganization({});
                //       }
                //       // pickProfileImage(isUserProfile);
                //       Navigator.pop(context);
                //       // Add your gallery picking logic here
                //       customPrint('Gallery selected');
                //     },
                //   ),
                // ],
              ],
            ],
          ),
        );
      },
    );
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
        // organizationProfileImage.value = File(pickedImage.path);
        // updateOrganization({});
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
      // if (pickedImage != null) {
      //   organizationProfileImage.value = File(pickedImage.path);
      //   updateOrganization({});
      // }
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
    print("user loader start");
    Loader().showLoadingDialogForSimpleLoader();
    try {
      dynamic response = await _personalSettingRepository.updateUserDetail(param: param, files: profileParams, token: loginData.responseData?.token ?? "");

      Loader().stopLoader();
      print("updateUserDetail is $response");
      UpdateUserResponseModel updateUserResponseModel = UpdateUserResponseModel.fromJson(response);

      CustomToastification().showToast(updateUserResponseModel.message ?? "", type: ToastificationType.success);
      getUserDetail();
      // globalController.getUserDetail();

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
      CustomToastification().showToast(e.toString(), type: ToastificationType.error);
    }
  }

  /// Toggles password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// Toggles password visibility
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  String extractDigits(String input) {
    // Use a regular expression to extract digits only
    return input.replaceAll(RegExp(r'\D'), '');
  }

  Future<void> deleteAccount() async {
    try {
      Loader().showLoadingDialogForSimpleLoader();

      DeleteUserModel response = await _personalSettingRepository.deleteUserAccount(userId: globalController.getUserDetailModel.value?.responseData?.id.toString() ?? "");
      if (response.responseType == "success") {
        await AppPreference.instance.removeKey(AppString.prefKeyUserLoginData);
        await AppPreference.instance.removeKey(AppString.prefKeyToken);

        Get.delete<GlobalMobileController>();
        Get.offAllNamed(Routes.LOGIN_VIEW_MOBILE);
      } else {
        CustomToastification().showToast(response.message ?? "", type: ToastificationType.error);
      }

      Loader().stopLoader();
    } catch (e) {
      Loader().stopLoader();
      CustomToastification().showToast(e.toString(), type: ToastificationType.error);
    }
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;
// import 'package:intl/intl.dart';
import 'package:subqdocs/app/mobile_modules/personal_setting_mobile_view/views/user_edit_dialog_mobile_view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/app_string.dart';
import '../../../../utils/imagepath.dart';
import '../../../../utils/validation_service.dart';
import '../../../../widget/appbar.dart';
import '../../../../widget/base_image_view.dart';
import '../../../../widget/custom_animated_button.dart';
import '../../../../widget/fileImage.dart';
import '../../../../widgets/base_screen_mobile.dart';
import '../../../../widgets/custom_tab_button.dart';
import '../../../../widgets/custom_textfiled.dart';
import '../../../core/common/app_preferences.dart';
import '../../../core/common/global_mobile_controller.dart';
import '../../../modules/patient_profile/widgets/common_patient_data.dart';
import '../../../modules/visit_main/views/delete_image_dialog.dart';
import '../../../routes/app_pages.dart';
import '../controllers/personal_setting_mobile_view_controller.dart';

class PersonalSettingMobileViewView extends GetView<PersonalSettingMobileViewController> {
  PersonalSettingMobileViewView({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BaseScreenMobile(
      onPopCallBack: () {
        // Get.until((route) => Get.currentRoute == Routes.HOME_VIEW_MOBILE);
      },
      onItemSelected: (index) async {
        if (index == 0) {
          Get.until((route) => Get.currentRoute == Routes.HOME_VIEW_MOBILE);
        } else if (index == 1) {
          Get.until((route) => Get.currentRoute == Routes.HOME_VIEW_MOBILE);
        } else if (index == 2) {
          Get.until((route) => Get.currentRoute == Routes.HOME_VIEW_MOBILE);
        } else if (index == 3) {}
      },
      body: _buildBody(context),
      globalKey: _scaffoldKey,
    );
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            _buildAppBar(),
            _buildTabBar(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  controller.getUserDetail();
                },
                child: Container(color: AppColors.backgroundMobileAppbar, child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Obx(() => _buildCurrentTabView())]))),
              ),
            ),
          ],
        ),
        if (controller.globalController.getEMAOrganizationDetailModel.value?.responseData?.isEmaIntegration == false) ...[_buildQuickStartButton()],
      ],
    );
  }

  Widget _buildAppBar() {
    return CustomMobileAppBar(drawerKey: _scaffoldKey, titleWidget: Text("Settings", style: AppFonts.medium(15.0, AppColors.textBlackDark)), actions: const [SizedBox()]);
  }

  Widget _buildTabBar() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.clear),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.clear),
        height: 70,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 24,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTab(key: controller.tabKeys[0], text: 'Personal Setting', index: 0, controller: controller),
                  // _buildTab(key: controller.tabKeys[1], text: 'Change Password', index: 1, controller: controller),
                  _buildTab(key: controller.tabKeys[1], text: 'More Documents', index: 2, controller: controller),
                ],
              ),
            ),
            Container(height: 2.0, width: double.infinity, decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.0), color: AppColors.backgroundPurple.withOpacity(0.1))),
          ],
        ),
      ),
    );
  }

  // void scrollToSelectedTab(int index) {
  //   final keyContext = tabKeys[index].currentContext;
  //   if (keyContext != null) {
  //     final box = keyContext.findRenderObject() as RenderBox;
  //     final position = box.localToGlobal(Offset.zero);
  //     final viewportWidth = MediaQuery.of(keyContext).size.width;
  //     final tabWidth = box.size.width;
  //
  //     double offset = position.dx - (viewportWidth / 2) + (tabWidth / 2);
  //     offset = offset.clamp(0.0, scrollController.position.maxScrollExtent);
  //
  //     scrollController.animateTo(offset, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  //   }
  // }

  // Helper method to build each tab
  // Widget _buildTab({required Key key, required String text, required int index, required PersonalSettingMobileViewController controller}) {
  //   return GestureDetector(
  //     key: key,
  //     onTap: () {
  //       controller.tabIndex.value = index;
  //       // Scroll to make the tab visible
  //       WidgetsBinding.instance.addPostFrameCallback((_) {
  //         Scrollable.ensureVisible(
  //           key.currentContext!,
  //           duration: const Duration(milliseconds: 300),
  //           alignment: 0.5, // 0.5 centers the tab
  //         );
  //       });
  //     },
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Padding(padding: const EdgeInsets.only(bottom: 12.0), child: Text(text, style: TextStyle(color: controller.tabIndex.value == index ? AppColors.textPurple : AppColors.textDarkGrey, fontWeight: FontWeight.w500))),
  //         Container(height: 3.0, width: _getTextWidth(text, const TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0)), decoration: BoxDecoration(color: controller.tabIndex.value == index ? AppColors.textPurple : Colors.transparent, borderRadius: BorderRadius.circular(1.5))),
  //       ],
  //     ),
  //   );
  // }

  // Update the _buildTab method to accept GlobalKey
  Widget _buildTab({required GlobalKey key, required String text, required int index, required PersonalSettingMobileViewController controller}) {
    return GestureDetector(
      key: key,
      onTap: () {
        controller.tabIndex.value = index;
        // Scroll to make the tab visible
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Scrollable.ensureVisible(
            key.currentContext!,
            duration: const Duration(milliseconds: 300),
            alignment: 0.5, // 0.5 centers the tab
          );
        });
      },
      child: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(padding: const EdgeInsets.only(bottom: 12.0), child: Text(text, style: TextStyle(color: controller.tabIndex.value == index ? AppColors.textPurple : AppColors.textDarkGrey, fontWeight: FontWeight.w500))),
            Container(height: 3.0, width: _getTextWidth(text, const TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0)), decoration: BoxDecoration(color: controller.tabIndex.value == index ? AppColors.textPurple : Colors.transparent, borderRadius: BorderRadius.circular(1.5))),
          ],
        ),
      ),
    );
  }

  double _getTextWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(text: TextSpan(text: text, style: style), maxLines: 1, textDirection: TextDirection.ltr)..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.width;
  }

  Widget _buildTabButton({required int index, required String label}) {
    final isSelected = controller.tabIndex.value == index;

    return IntrinsicWidth(
      child: CustomTabButton(
        onPressed: () => controller.tabIndex.value = index,
        text: label,
        isOutline: true,
        paddingText: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        fontSize: 14,
        enabledTextColor: isSelected ? AppColors.textWhite : AppColors.textGrey,
        enabledColor: isSelected ? AppColors.backgroundPurple : AppColors.buttonPurpleLight,
        outLineEnabledColor: AppColors.textGrey,
        outlineColor: isSelected ? AppColors.backgroundPurple : AppColors.clear,
      ),
    );
  }

  Widget _buildQuickStartButton() {
    return Positioned(
      right: 30,
      bottom: 20,
      child: GestureDetector(
        onTap: () async {
          await Get.toNamed(Routes.ADD_PATIENT_MOBILE_VIEW);
        },
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColors.backgroundPurple, boxShadow: [BoxShadow(color: AppColors.backgroundPurple.withValues(alpha: 0.2), spreadRadius: 5, blurRadius: 9, offset: const Offset(0, 3))]),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(children: [SvgPicture.asset(ImagePath.quick_start, height: 20, width: 20), const SizedBox(width: 5), Text("Quick Start", softWrap: true, style: AppFonts.medium(16, AppColors.white))]),
        ),
      ),
    );
  }

  Widget _buildCurrentTabView() {
    switch (controller.tabIndex.value) {
      case 0:
        return _buildPersonalSettingView();
      case 1:
        return _buildChangePasswordView();
      case 2:
        return buildMoreDocumentView();
      case 3:
        return _buildOrganizationManagementView();
      default:
        return _buildPersonalSettingView();
    }
  }

  Widget _buildPersonalSettingView() {
    return SingleChildScrollView(
      child: Container(
        width: double.maxFinite,
        color: AppColors.white,
        // padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   "Personal Settings",
            //   style: AppFonts.bold(18, AppColors.textBlackDark),
            // ),
            const SizedBox(height: 20),
            Obx(() {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  // Takes all available width
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          controller.showImagePickerDialog(Get.context!, true);
                        },
                        child: Obx(() {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child:
                                (controller.getUserDetailModel.value?.responseData?.profileImage != null && (controller.getUserDetailModel.value?.responseData?.profileImage != ""))
                                    ? CachedNetworkImage(imageUrl: controller.getUserDetailModel.value?.responseData?.profileImage ?? "", width: 60, height: 60, fit: BoxFit.cover)
                                    : controller.userProfileImage.value?.path != null
                                    ? RoundedImageFileWidget(size: 60, imagePath: controller.userProfileImage.value)
                                    : BaseImageView(imageUrl: "", width: 60, height: 60, fontSize: 14, nameLetters: "${controller.getUserDetailModel.value?.responseData?.firstName ?? ""} ${controller.getUserDetailModel.value?.responseData?.lastName ?? ""}"),
                          );
                        }),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Text("${controller.getUserDetailModel.value?.responseData?.firstName ?? ""} ${controller.getUserDetailModel.value?.responseData?.lastName ?? ""}", style: AppFonts.medium(16, AppColors.textBlack), overflow: TextOverflow.ellipsis, maxLines: 1)),
                      GestureDetector(
                        onTap: () async {
                          controller.setUserDetail();
                          controller.setUserDetail();

                          showDialog(
                            context: Get.context!,
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              return UserEditDialogMobileView(
                                receiveParam: (p0) {
                                  Future.delayed(const Duration(milliseconds: 200)).then((value) {
                                    controller.updateUserDetail(p0);
                                  });
                                },
                              );
                            },
                          );

                          // showDialog(
                          //   context: context,
                          //   barrierDismissible: true,
                          //   builder: (BuildContext context) {
                          //     return OrganizationUseEditDialog(
                          //       receiveParam: (p0) {
                          //         Future.delayed(const Duration(milliseconds: 200)).then((value) {
                          //           controller.updateUserDetail(p0);
                          //         });
                          //       },
                          //     );
                          //   },
                          // );
                        },
                        child: SvgPicture.asset(ImagePath.edit, width: 26, height: 26),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Row(children: [Text(textAlign: TextAlign.center, "Personal Information", style: AppFonts.medium(16, AppColors.backgroundPurple)), const Spacer()])),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [Expanded(child: CommonPatientData(label: "First Name", data: controller.getUserDetailModel.value?.responseData?.firstName ?? "-")), Expanded(child: CommonPatientData(label: "Last Name", data: controller.getUserDetailModel.value?.responseData?.lastName ?? "-"))],
              ),
            ),
            //------------------ Contact
            const SizedBox(height: 20),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Row(children: [Text(textAlign: TextAlign.center, "Contact", style: AppFonts.medium(16, AppColors.backgroundPurple)), const Spacer()])),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: CommonPatientData(label: "Email ID", data: controller.getUserDetailModel.value?.responseData?.email ?? "-")),
                  const Expanded(child: SizedBox()),
                  // Expanded(child: CommonPatientData(label: "Phone Number", data: controller.getUserDetailModel.value?.responseData?.contactNo ?? "-")),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Expanded(child: CommonPatientData(label: "Email ID", data: controller.getUserDetailModel.value?.responseData?.email ?? "-")),
                  Expanded(child: CommonPatientData(label: "Phone Number", data: controller.getUserDetailModel.value?.responseData?.contactNo ?? "-")),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ),
            if (controller.userRole.value == "Doctor") ...[
              const SizedBox(height: 20),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Row(children: [Text(textAlign: TextAlign.center, "Practitioner Details", style: AppFonts.medium(16, AppColors.backgroundPurple)), const Spacer()])),
              const SizedBox(height: 20),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Row(spacing: 10, crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child: CommonPatientData(label: "Title", data: controller.getUserDetailModel.value?.responseData?.title ?? "-")), const Expanded(child: SizedBox())])),
              const SizedBox(height: 20),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Row(spacing: 10, crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child: CommonPatientData(label: "Degree", data: controller.getUserDetailModel.value?.responseData?.degree ?? "-"))])),
              const SizedBox(height: 20),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Row(spacing: 10, crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child: CommonPatientData(label: "Medical License Number", data: controller.getUserDetailModel.value?.responseData?.medicalLicenseNumber ?? "-"))])),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Expanded(child: CommonPatientData(label: "License Expiry Date", data: (controller.getUserDetailModel.value?.responseData?.licenseExpiryDate?.isNotEmpty ?? false) ? DateFormat('MM/dd/yyyy').format(DateTime.parse(controller.getUserDetailModel.value?.responseData?.licenseExpiryDate ?? "")) : "-"))],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Expanded(child: CommonPatientData(label: "National Provider Identifier", data: controller.getUserDetailModel.value?.responseData?.nationalProviderIdentifier != null ? controller.getUserDetailModel.value?.responseData?.nationalProviderIdentifier.toString() : "-"))],
                ),
              ),
              const SizedBox(height: 20),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Row(spacing: 10, crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child: CommonPatientData(label: "Taxonomy Code", data: controller.getUserDetailModel.value?.responseData?.taxonomyCode ?? "-"))])),
              const SizedBox(height: 20),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Row(spacing: 10, crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child: CommonPatientData(label: "Specialization", data: controller.getUserDetailModel.value?.responseData?.specialization ?? "-"))])),
              const SizedBox(height: 20),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Row(spacing: 10, crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child: CommonPatientData(label: "Sign and Finalize PIN", data: controller.getUserDetailModel.value?.responseData?.pin?.replaceAll(RegExp('.'), '*') ?? "-"))])),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.maxFinite,
                  height: 45,
                  child: CustomAnimatedButton(
                    text: "Logout",
                    onPressed: () async {
                      showDialog(
                        context: Get.context!,
                        barrierDismissible: true, // Allows dismissing the dialog by tapping outside
                        builder: (BuildContext context) {
                          return LogoutDialog(
                            title: "Are you sure want to logout?",
                            onDelete: () async {
                              await AppPreference.instance.removeKey(AppString.prefKeyUserLoginData);
                              await AppPreference.instance.removeKey(AppString.prefKeyToken);

                              Get.delete<GlobalMobileController>();
                              Get.offAllNamed(Routes.LOGIN_VIEW_MOBILE);
                            },
                            header: "Alert!",
                          ); // Our custom dialog
                        },
                      );
                    },
                    height: 35,
                    isOutline: true,
                    enabledColor: AppColors.white,
                    outlineColor: AppColors.redText,
                    enabledTextColor: AppColors.redText,
                    outLineEnabledColor: AppColors.redText,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.maxFinite,
                  height: 45,
                  child: CustomAnimatedButton(
                    text: "Delete Account",
                    onPressed: () async {
                      showDialog(
                        context: Get.context!,
                        barrierDismissible: true,
                        // Allows dismissing the dialog by tapping outside
                        builder: (BuildContext context) {
                          return DeletePatientDialog(
                            title: "Are you sure want to delete account",
                            onDelete: () {
                              controller.deleteAccount();
                            },
                            header: "Delete account",
                          ); // Our custom dialog
                        },
                      );
                    },
                    height: 35,
                    isOutline: true,
                    enabledColor: AppColors.redText,
                    outlineColor: AppColors.redText,
                    enabledTextColor: AppColors.white,
                    outLineEnabledColor: AppColors.redText,
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
            // Add your personal setting form fields here
          ],
        ),
      ),
    );
  }

  Widget _buildOrganizationManagementView() {
    return Container(
      width: double.maxFinite,
      color: AppColors.clear,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Centers vertically
        crossAxisAlignment: CrossAxisAlignment.center, // Centers horizontally
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 50),
                SvgPicture.asset(ImagePath.no_data_power_view, width: MediaQuery.of(Get.context!).size.width * 0.5),
                const SizedBox(height: 10),
                SvgPicture.asset(ImagePath.divider_medical_note, width: MediaQuery.of(Get.context!).size.width * 0.6),
                const SizedBox(height: 10),
                Center(child: Text("This functionality is only available on the iPad or Web App versions.", textAlign: TextAlign.center, style: AppFonts.regular(16.0, AppColors.black))),
                const SizedBox(height: 10),
                const Center(child: SizedBox(width: 150, child: CustomTabButton(text: "Email links", height: 45, isOutline: true, outlineColor: AppColors.backgroundPurple, enabledColor: AppColors.clear, enabledTextColor: AppColors.backgroundPurple, outlineWidth: 1))),
              ],
              // ... your existing column children
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMoreDocumentView() {
    return Container(
      width: double.maxFinite,
      color: AppColors.clear,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Center(child: Text("These are the more features that will be available on the iPad or the web:", textAlign: TextAlign.center, style: AppFonts.regular(14.0, AppColors.textDarkGrey))),
                  const SizedBox(height: 20),
                  Center(child: Text(" Organization setting and User management ", textAlign: TextAlign.center, style: AppFonts.regular(16.0, AppColors.textPurple))),
                  const SizedBox(height: 20),
                  Center(
                    child: SizedBox(
                      width: 150,
                      child: CustomTabButton(
                        onPressed: () async {
                          if (!await launchUrl(Uri.https("app.subqdocs.ai"), mode: LaunchMode.externalApplication)) {
                            throw Exception('Could not launch');
                          }
                        },
                        borderRadius: 10,
                        text: "Email links",
                        height: 45,
                        isOutline: true,
                        outlineColor: AppColors.backgroundPurple,
                        enabledColor: AppColors.clear,
                        enabledTextColor: AppColors.backgroundPurple,
                        outlineWidth: 1,
                      ),
                    ),
                  ),
                ],
                // ... your existing column children
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserManagementView() {
    return Container(
      width: double.maxFinite,
      color: AppColors.clear,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Centers vertically
        crossAxisAlignment: CrossAxisAlignment.center, // Centers horizontally
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 50),
                SvgPicture.asset(ImagePath.no_data_power_view, width: MediaQuery.of(Get.context!).size.width * 0.5),
                const SizedBox(height: 10),
                SvgPicture.asset(ImagePath.divider_medical_note, width: MediaQuery.of(Get.context!).size.width * 0.6),
                const SizedBox(height: 10),
                Center(child: Text("This functionality is only available on the iPad or Web App versions.", textAlign: TextAlign.center, style: AppFonts.regular(16.0, AppColors.black))),
                const SizedBox(height: 10),
                const Center(child: SizedBox(width: 150, child: CustomTabButton(text: "Email links", height: 45, isOutline: true, outlineColor: AppColors.backgroundPurple, enabledColor: AppColors.clear, enabledTextColor: AppColors.backgroundPurple, outlineWidth: 1))),
              ],
              // ... your existing column children
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChangePasswordView() {
    return Container(
      width: double.maxFinite,
      color: AppColors.clear,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Obx(() {
              return TextFormFiledWidget(fillColor: AppColors.clear, label: AppString.password, hint: AppString.passwordHint, visibility: controller.isPasswordVisible.value, controller: controller.passwordController, suffixIcon: _buildPasswordVisibilityToggle(), checkValidation: (value) => Validation.passwordValidate(value));
            }),
            const SizedBox(height: 20),
            Obx(() {
              return TextFormFiledWidget(fillColor: AppColors.clear, label: AppString.confimPassword, hint: AppString.passwordHint, visibility: controller.isConfirmPasswordVisible.value, controller: controller.confirmPasswordController, suffixIcon: _buildConfirmPasswordVisibilityToggle(), checkValidation: (value) => Validation.passwordValidate(value));
            }),
            // Add password change form here
            const SizedBox(height: 30),
            SizedBox(width: double.maxFinite, height: 45, child: CustomAnimatedButton(text: "Save", onPressed: () async {}, height: 35, isOutline: true, enabledColor: AppColors.backgroundPurple, outlineColor: AppColors.backgroundPurple, enabledTextColor: AppColors.white, outLineEnabledColor: AppColors.backgroundPurple)),
            const SizedBox(width: 15),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordVisibilityToggle() {
    return controller.isPasswordVisible.value ? GestureDetector(onTap: () => controller.togglePasswordVisibility(), child: const Icon(CupertinoIcons.eye_slash_fill, color: AppColors.textDarkGrey)) : GestureDetector(onTap: () => controller.togglePasswordVisibility(), child: SvgPicture.asset(ImagePath.eyeLogoOpen, height: 5, width: 5));
  }

  Widget _buildConfirmPasswordVisibilityToggle() {
    return controller.isConfirmPasswordVisible.value ? GestureDetector(onTap: () => controller.toggleConfirmPasswordVisibility(), child: const Icon(CupertinoIcons.eye_slash_fill, color: AppColors.textDarkGrey)) : GestureDetector(onTap: () => controller.toggleConfirmPasswordVisibility(), child: SvgPicture.asset(ImagePath.eyeLogoOpen, height: 5, width: 5));
  }
}

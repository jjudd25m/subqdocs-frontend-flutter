import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:subqdocs/app/modules/personal_setting/views/personal_info_tab.dart';
import 'package:subqdocs/app/modules/personal_setting/views/user_management_tab.dart';
import 'package:subqdocs/widgets/base_screen.dart';
import 'package:subqdocs/widgets/custom_animated_button.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/app_string.dart';
import '../../../../utils/imagepath.dart';
import '../../../../utils/no_space_lowercase.dart';
import '../../../../utils/validation_service.dart';
import '../../../../widget/appbar.dart';
import '../../../../widget/base_image_view.dart';
import '../../../../widget/fileImage.dart';
import '../../../../widgets/base_dropdown.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_table.dart';
import '../../../../widgets/custom_textfiled.dart';
import '../../../core/common/app_preferences.dart';
import '../../../core/common/common_service.dart';
import '../../../core/common/global_controller.dart';
import '../../../core/common/logger.dart';
import '../../../routes/app_pages.dart';
import '../../patient_info/views/home_custom_search_bar.dart';
import '../../patient_profile/widgets/common_patient_data.dart';
import '../../visit_main/views/delete_image_dialog.dart';
import '../controllers/personal_setting_controller.dart';
import '../model/get_user_detail_model.dart';
import 'integrate_ema_dialog.dart';
import 'invite_user_dialog.dart';
import 'organization_edit_dialog.dart';
import 'organization_management_tab.dart';
import 'organization_use_edit_dialog.dart';

class PersonalSettingView extends GetView<PersonalSettingController> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  PersonalSettingView({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.globalController.breadcrumbHistory.last != controller.globalController.breadcrumbs[Routes.PERSONAL_SETTING]) {
        controller.globalController.addRouteInit(Routes.PERSONAL_SETTING);
      }
    });
    return BaseScreen(
      // onPopCallBack: () {
      //   controller.forceSyncTimer?.cancel();
      // },
      onItemSelected: (index) async {
        if (index == 0) {
          final result = await Get.toNamed(Routes.ADD_PATIENT);

          _key.currentState!.closeDrawer();
        } else if (index == 1) {
          Get.offAllNamed(Routes.HOME, arguments: {"tabIndex": 1});

          _key.currentState!.closeDrawer();
        } else if (index == 2) {
          Get.toNamed(Routes.HOME, arguments: {"tabIndex": 2});
          _key.currentState!.closeDrawer();
        } else if (index == 3) {
          Get.toNamed(Routes.HOME, arguments: {"tabIndex": 0});
          _key.currentState!.closeDrawer();
        } else if (index == 4) {
          _key.currentState!.closeDrawer();
        }
      },
      body: PopScope(
        canPop: true, // Set to false if you want to prevent the swipe
        onPopInvokedWithResult: (didPop, result) {
          print("onPopInvokedWithResult"); // Explicitly nullify
          if (controller.globalController.getKeyByValue(controller.globalController.breadcrumbHistory.last) == Routes.PERSONAL_SETTING) {
            controller.globalController.popRoute();
          }
        },
        child: GestureDetector(
          onTap: removeFocus,
          child: SafeArea(
            child: Container(
              color: AppColors.ScreenBackGround,
              child: Obx(() {
                return Column(
                  children: [
                    CustomAppBar(drawerkey: _key),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        color: AppColors.ScreenBackGround,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Container(
                                  width: double.infinity,
                                  decoration: const BoxDecoration(color: Colors.transparent),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // BreadcrumbWidget(
                                      //   breadcrumbHistory: controller.globalController.breadcrumbHistory.value,
                                      //   onBack: (breadcrumb) {
                                      //     controller.globalController.popUntilRoute(breadcrumb);

                                      //     while (Get.currentRoute != controller.globalController.getKeyByValue(breadcrumb)) {
                                      //       Get.back(); // Pop the current screen
                                      //     }
                                      //   },
                                      // ),
                                      const SizedBox(height: 10),
                                      Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.backgroundWhite),
                                        child: Obx(() {
                                          return Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.white),
                                            height: 70,
                                            child: SingleChildScrollView(
                                              physics: const BouncingScrollPhysics(),
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: [
                                                  IntrinsicWidth(
                                                    child: CustomAnimatedButton(
                                                      onPressed: () {
                                                        controller.tabIndex.value = 0;
                                                      },
                                                      text: "Personal Settings",
                                                      isOutline: true,
                                                      paddingText: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                                      fontSize: 14,
                                                      enabledTextColor: controller.tabIndex.value == 0 ? AppColors.backgroundPurple : AppColors.textGrey,
                                                      enabledColor: controller.tabIndex.value == 0 ? AppColors.buttonPurpleLight : AppColors.clear,
                                                      outLineEnabledColor: AppColors.textGrey,
                                                      outlineColor: controller.tabIndex.value == 0 ? AppColors.backgroundPurple : AppColors.clear,
                                                    ),
                                                  ),
                                                  if (controller.getUserDetailModel.value?.responseData?.isAdmin ?? false)
                                                    IntrinsicWidth(
                                                      child: CustomAnimatedButton(
                                                        onPressed: () {
                                                          controller.tabIndex.value = 1;
                                                        },
                                                        text: "Organization Management",
                                                        isOutline: true,
                                                        paddingText: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                                        fontSize: 14,
                                                        enabledTextColor: controller.tabIndex.value == 1 ? AppColors.backgroundPurple : AppColors.textGrey,
                                                        enabledColor: controller.tabIndex.value == 1 ? AppColors.buttonPurpleLight : AppColors.clear,
                                                        outLineEnabledColor: AppColors.textGrey,
                                                        outlineColor: controller.tabIndex.value == 1 ? AppColors.backgroundPurple : AppColors.clear,
                                                      ),
                                                    ),
                                                  if (controller.getUserDetailModel.value?.responseData?.isAdmin ?? false)
                                                    IntrinsicWidth(
                                                      child: CustomAnimatedButton(
                                                        onPressed: () {
                                                          controller.tabIndex.value = 2;

                                                          controller.userInviteSearchController.text = "";
                                                          // When no filter value, reset to the original data (no filter applied)
                                                          controller.filterGetUserOrganizationListModel.value?.responseData = List.from(controller.getUserOrganizationListModel.value?.responseData ?? []);

                                                          // Refresh if the data has changed
                                                          if (controller.filterGetUserOrganizationListModel.value?.responseData != controller.getUserOrganizationListModel.value?.responseData) {
                                                            controller.filterGetUserOrganizationListModel.refresh();
                                                          }
                                                        },
                                                        text: "User Management",
                                                        isOutline: true,
                                                        paddingText: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                                        fontSize: 14,
                                                        enabledTextColor: controller.tabIndex.value == 2 ? AppColors.backgroundPurple : AppColors.textGrey,
                                                        enabledColor: controller.tabIndex.value == 2 ? AppColors.buttonPurpleLight : AppColors.clear,
                                                        outLineEnabledColor: AppColors.textGrey,
                                                        outlineColor: controller.tabIndex.value == 2 ? AppColors.backgroundPurple : AppColors.clear,
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                      const SizedBox(height: 20),
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.white),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                controller.tabIndex.value == 0
                                                    ? Theme(
                                                      data: ThemeData(
                                                        splashColor: Colors.transparent,
                                                        // Remove splash color
                                                        highlightColor: Colors.transparent, // Remove highlight color
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          const SizedBox(height: 10),
                                                          Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Row(children: [const SizedBox(width: 10), Text(textAlign: TextAlign.center, "Personal Settings", style: AppFonts.medium(16, AppColors.textBlack)), const Spacer()])),
                                                          const SizedBox(height: 10),
                                                          Divider(height: 1, color: AppColors.textGrey.withValues(alpha: 0.3)),
                                                          const SizedBox(height: 20),
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                                            child: Container(
                                                              width: double.infinity,
                                                              // Takes all available width
                                                              child: Row(
                                                                children: [
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      controller.showImagePickerDialog(context, true);
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
                                                                        context: context,
                                                                        barrierDismissible: true,
                                                                        builder: (BuildContext context) {
                                                                          return OrganizationUseEditDialog(
                                                                            receiveParam: (p0) {
                                                                              Future.delayed(const Duration(milliseconds: 200)).then((value) {
                                                                                controller.updateUserDetail(p0);
                                                                              });
                                                                            },
                                                                          );
                                                                        },
                                                                      );
                                                                    },
                                                                    child: SvgPicture.asset(ImagePath.edit, width: 26, height: 26),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(height: 20),
                                                          Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Row(children: [Text(textAlign: TextAlign.center, "Personal Information", style: AppFonts.medium(16, AppColors.backgroundPurple)), const Spacer()])),
                                                          const SizedBox(height: 20),
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                                            child: Row(
                                                              spacing: 10,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                              children: [
                                                                Expanded(child: CommonPatientData(label: "First Name", data: controller.getUserDetailModel.value?.responseData?.firstName ?? "-")),
                                                                Expanded(child: CommonPatientData(label: "Last Name", data: controller.getUserDetailModel.value?.responseData?.lastName ?? "-")),
                                                                const Expanded(child: SizedBox()),
                                                                const Expanded(child: SizedBox()),
                                                              ],
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
                                                                Expanded(child: CommonPatientData(label: "Phone Number", data: controller.getUserDetailModel.value?.responseData?.contactNo ?? "-")),
                                                                const Expanded(child: SizedBox()),
                                                                const Expanded(child: SizedBox()),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(height: 20),
                                                          // -- Practitioner Details
                                                          if (controller.userRole.value == "Doctor") ...[
                                                            Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Row(children: [Text(textAlign: TextAlign.center, "Practitioner Details", style: AppFonts.medium(16, AppColors.backgroundPurple)), const Spacer()])),
                                                            const SizedBox(height: 20),
                                                            Padding(
                                                              padding: const EdgeInsets.symmetric(horizontal: 20),
                                                              child: Row(
                                                                spacing: 10,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Expanded(child: CommonPatientData(label: "Title", data: controller.getUserDetailModel.value?.responseData?.title ?? "-")),
                                                                  Expanded(child: CommonPatientData(label: "Degree", data: controller.getUserDetailModel.value?.responseData?.degree ?? "-")),
                                                                  Expanded(child: CommonPatientData(label: "Medical License Number", data: controller.getUserDetailModel.value?.responseData?.medicalLicenseNumber ?? "-")),

                                                                  const Expanded(child: SizedBox()),
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
                                                                  Expanded(child: CommonPatientData(label: "License Expiry Date", data: (controller.getUserDetailModel.value?.responseData?.licenseExpiryDate?.isNotEmpty ?? false) ? DateFormat('MM/dd/yyyy').format(DateTime.parse(controller.getUserDetailModel.value?.responseData?.licenseExpiryDate ?? "")) : "-")),
                                                                  Expanded(child: CommonPatientData(label: "National Provider Identifier", data: controller.getUserDetailModel.value?.responseData?.nationalProviderIdentifier != null ? controller.getUserDetailModel.value?.responseData?.nationalProviderIdentifier.toString() : "-")),
                                                                  Expanded(child: CommonPatientData(label: "Taxonomy Code", data: controller.getUserDetailModel.value?.responseData?.taxonomyCode ?? "-")),

                                                                  const Expanded(child: SizedBox()),
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
                                                                  Expanded(child: CommonPatientData(label: "Specialization", data: controller.getUserDetailModel.value?.responseData?.specialization ?? "-")),
                                                                  Expanded(child: CommonPatientData(label: "Sign and Finalize PIN", data: controller.getUserDetailModel.value?.responseData?.pin?.replaceAll(RegExp('.'), '*') ?? "-")),
                                                                  const Expanded(child: SizedBox()),
                                                                  const Expanded(child: SizedBox()),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                          const SizedBox(height: 20),
                                                          Row(
                                                            children: [
                                                              const SizedBox(width: 20),
                                                              SizedBox(
                                                                width: 120,
                                                                height: 45,
                                                                child: CustomAnimatedButton(
                                                                  text: "Logout",
                                                                  onPressed: () async {
                                                                    showDialog(
                                                                      context: context,
                                                                      barrierDismissible: true,
                                                                      // Allows dismissing the dialog by tapping outside
                                                                      builder: (BuildContext context) {
                                                                        return LogoutDialog(
                                                                          title: "Are you sure want to logout?",
                                                                          onDelete: () async {
                                                                            await AppPreference.instance.removeKey(AppString.prefKeyUserLoginData);
                                                                            await AppPreference.instance.removeKey(AppString.prefKeyToken);
                                                                            await AppPreference.instance.removeKey("homePastPatientListSortingModel");
                                                                            await AppPreference.instance.removeKey("homePatientListSortingModel");
                                                                            await AppPreference.instance.removeKey("homeScheduleListSortingModel");
                                                                            Get.delete<GlobalController>();
                                                                            Get.offAllNamed(Routes.LOGIN);
                                                                          },
                                                                          header: "Alert!",
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
                                                              const SizedBox(width: 15),
                                                              SizedBox(
                                                                width: 170,
                                                                height: 45,
                                                                child: CustomAnimatedButton(
                                                                  text: "Delete Account",
                                                                  onPressed: () async {
                                                                    showDialog(
                                                                      context: context,
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
                                                                  enabledColor: AppColors.white,
                                                                  outlineColor: AppColors.redText,
                                                                  enabledTextColor: AppColors.redText,
                                                                  outLineEnabledColor: AppColors.redText,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                    : controller.tabIndex.value == 1
                                                    ? Theme(
                                                      data: ThemeData(
                                                        splashColor: Colors.transparent,
                                                        // Remove splash color
                                                        highlightColor: Colors.transparent, // Remove highlight color
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          const SizedBox(height: 10),
                                                          Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Row(children: [const SizedBox(width: 10), Text(textAlign: TextAlign.center, "Organization Management", style: AppFonts.medium(16, AppColors.textBlack)), const Spacer()])),
                                                          const SizedBox(height: 10),
                                                          Divider(height: 1, color: AppColors.textGrey.withValues(alpha: 0.3)),
                                                          const SizedBox(height: 20),
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                                            child: Row(
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    controller.showImagePickerDialog(context, false);
                                                                  },
                                                                  child: Obx(() {
                                                                    return ClipRRect(
                                                                      borderRadius: BorderRadius.circular(100),
                                                                      child:
                                                                          controller.getOrganizationDetailModel.value?.responseData?.profileImage != null
                                                                              ? CachedNetworkImage(imageUrl: controller.getOrganizationDetailModel.value?.responseData?.profileImage ?? "", width: 60, height: 60, fit: BoxFit.cover)
                                                                              : controller.organizationProfileImage.value?.path != null
                                                                              ? RoundedImageFileWidget(size: 60, imagePath: controller.organizationProfileImage.value)
                                                                              : BaseImageView(imageUrl: "", width: 60, height: 60, fontSize: 14, nameLetters: "${controller.getOrganizationDetailModel.value?.responseData?.name}"),
                                                                    );
                                                                  }),
                                                                ),
                                                                const SizedBox(width: 10),
                                                                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(textAlign: TextAlign.center, controller.getOrganizationDetailModel.value?.responseData?.name ?? "-", style: AppFonts.medium(16, AppColors.textBlack)), const SizedBox(width: 15)]),
                                                                const Spacer(),
                                                                GestureDetector(
                                                                  onTap: () async {
                                                                    controller.setOrganizationData();

                                                                    showDialog(
                                                                      context: context,
                                                                      barrierDismissible: true,
                                                                      // Allows dismissing the dialog by tapping outside
                                                                      builder: (BuildContext context) {
                                                                        return OrganizationEditDialog(
                                                                          receiveParam: (p0) {
                                                                            Future.delayed(const Duration(milliseconds: 200)).then((value) {
                                                                              controller.updateOrganization(p0);
                                                                            });
                                                                            // controller.userInvite(p0);
                                                                          },
                                                                        ); // Our custom dialog
                                                                      },
                                                                    );
                                                                  },
                                                                  child: SvgPicture.asset(ImagePath.edit, width: 26, height: 26, fit: BoxFit.cover),
                                                                ),
                                                                const SizedBox(width: 10),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(height: 20),
                                                          Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Row(children: [Text(textAlign: TextAlign.center, "Organization Information", style: AppFonts.medium(16, AppColors.backgroundPurple)), const Spacer()])),
                                                          const SizedBox(height: 20),
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                                            child: Row(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [Expanded(child: CommonPatientData(label: "Name", data: controller.getOrganizationDetailModel.value?.responseData?.name ?? "-")), const Expanded(child: SizedBox()), const Expanded(child: SizedBox()), const Expanded(child: SizedBox())],
                                                            ),
                                                          ),
                                                          const SizedBox(height: 20),
                                                          //------------------ Contact
                                                          const SizedBox(height: 20),
                                                          Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Row(children: [Text(textAlign: TextAlign.center, "Contact", style: AppFonts.medium(16, AppColors.backgroundPurple)), const Spacer()])),
                                                          const SizedBox(height: 20),
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                                            child: Row(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Expanded(child: CommonPatientData(label: "Email ID", data: controller.getOrganizationDetailModel.value?.responseData?.email ?? "-")),
                                                                Expanded(child: CommonPatientData(label: "Phone Number", data: controller.getOrganizationDetailModel.value?.responseData?.contactNo ?? "-")),
                                                                const Expanded(child: SizedBox()),
                                                                const Expanded(child: SizedBox()),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(height: 20),
                                                          //------------------ Address
                                                          const SizedBox(height: 20),
                                                          Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Row(children: [Text(textAlign: TextAlign.center, "Address", style: AppFonts.medium(16, AppColors.backgroundPurple)), const Spacer()])),
                                                          const SizedBox(height: 20),
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                                            child: Row(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Expanded(child: CommonPatientData(label: "Street Name", data: controller.getOrganizationDetailModel.value?.responseData?.streetName ?? "-")),
                                                                // Expanded(child: CommonPatientData(label: "Address 1", data: controller.getOrganizationDetailModel.value?.responseData?.address1 ?? "-")),
                                                                // Expanded(child: CommonPatientData(label: "Address 2", data: controller.getOrganizationDetailModel.value?.responseData?.address2 ?? "-")),
                                                                Expanded(child: CommonPatientData(label: "City", data: controller.getOrganizationDetailModel.value?.responseData?.city ?? "-")),
                                                                const Expanded(child: SizedBox()),
                                                                const Expanded(child: SizedBox()),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(height: 20),
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                                            child: Row(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Expanded(child: CommonPatientData(label: "State", data: controller.getOrganizationDetailModel.value?.responseData?.state ?? "-")),
                                                                Expanded(child: CommonPatientData(label: "Postal Code", data: controller.getOrganizationDetailModel.value?.responseData?.postalCode ?? "-")),
                                                                Expanded(child: CommonPatientData(label: "Country", data: controller.getOrganizationDetailModel.value?.responseData?.country ?? "-")),
                                                                const Expanded(child: SizedBox()),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(height: 20),
                                                          // if (controller.getOrganizationDetailModel.value?.responseData?.has_ema_configs ?? false) ...[
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                                            child: Row(
                                                              children: [
                                                                Text(textAlign: TextAlign.center, "EMA", style: AppFonts.medium(16, AppColors.backgroundPurple)),
                                                                const Spacer(),

                                                                if (controller.globalController.getEMAOrganizationDetailModel.value?.responseData?.isEmaIntegration == true) ...[
                                                                  IgnorePointer(
                                                                    ignoring: (controller.forceSyncLogModel.value?.responseData?.isSyncing ?? false),
                                                                    child: SizedBox(
                                                                      width: (controller.forceSyncLogModel.value?.responseData?.isSyncing ?? false) ? 120 : 80,
                                                                      height: 40,
                                                                      child: CustomAnimatedButton(
                                                                        onPressed: () {
                                                                          controller.forceSyncUpdate();
                                                                        },
                                                                        text: (controller.forceSyncLogModel.value?.responseData?.isSyncing ?? false) ? "Syncing..." : "Sync",
                                                                        height: 40,
                                                                        isOutline: true,
                                                                        enabledColor: AppColors.white,
                                                                        enabledTextColor: AppColors.textPurple,
                                                                        outlineColor: AppColors.textPurple,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                                const SizedBox(width: 10),
                                                                if (controller.globalController.getEMAOrganizationDetailModel.value?.responseData?.has_ema_configs ?? false) ...[
                                                                  GestureDetector(
                                                                    onTap: () async {
                                                                      showDialog(
                                                                        context: context,
                                                                        barrierDismissible: true, // Allows dismissing the dialog by tapping outside
                                                                        builder: (BuildContext context) {
                                                                          return IntegrateEmaDialog(
                                                                            receiveParam: (param) async {
                                                                              // controller.saveEmaConfig(param);

                                                                              // WidgetsBinding.instance.addPostFrameCallback((_) {
                                                                              //   Navigator.of(context).pop();
                                                                              // });
                                                                              //
                                                                              // // Navigator.of(context).pop(); // Close the dialog
                                                                              //
                                                                              // if (response) {
                                                                              //   final model = controller.globalController.getEMAOrganizationDetailModel.value?.responseData;
                                                                              //   if (model?.has_ema_configs == true && model?.appointmentType == null) {
                                                                              //     showAppointmentTypeDialog(context);
                                                                              //   }
                                                                              // }
                                                                            },
                                                                          );
                                                                        },
                                                                      );
                                                                    },
                                                                    child: SvgPicture.asset(ImagePath.edit, width: 26, height: 26),
                                                                  ),
                                                                ],
                                                              ],
                                                            ),
                                                          ),
                                                          if ((controller.globalController.getEMAOrganizationDetailModel.value?.responseData?.isEmaIntegration == false) && (controller.globalController.getEMAOrganizationDetailModel.value?.responseData?.has_ema_configs == false)) ...[
                                                            const SizedBox(height: 20),
                                                            Padding(
                                                              padding: const EdgeInsets.symmetric(horizontal: 20),
                                                              child: Row(
                                                                children: [
                                                                  SizedBox(
                                                                    width: 180,
                                                                    child: CustomAnimatedButton(
                                                                      onPressed: () {
                                                                        showDialog(
                                                                          context: context,
                                                                          barrierDismissible: true, // Allows dismissing the dialog by tapping outside
                                                                          builder: (BuildContext ctx) {
                                                                            return IntegrateEmaDialog(
                                                                              receiveParam: (param) async {
                                                                                if (param) {
                                                                                  showAppointmentTypeDialog(ctx);
                                                                                }

                                                                                // bool response = await controller.saveEmaConfig(param);

                                                                                // Navigator.of(context).pop();

                                                                                // Navigator.of(context).pop(); // Close the dialog

                                                                                // if (response) {
                                                                                //   final model = controller.globalController.getEMAOrganizationDetailModel.value?.responseData;
                                                                                //   if (model?.has_ema_configs == true && model?.appointmentType == null) {
                                                                                //     showAppointmentTypeDialog(context);
                                                                                //   }
                                                                                // }
                                                                              },
                                                                            );
                                                                          },
                                                                        );
                                                                      },
                                                                      text: "Integrate EMA",
                                                                      height: 40,
                                                                      isOutline: true,
                                                                      enabledColor: AppColors.white,
                                                                      enabledTextColor: AppColors.textPurple,
                                                                      outlineColor: AppColors.textPurple,
                                                                    ),
                                                                  ),
                                                                  const Spacer(),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                          const SizedBox(height: 20),
                                                          if (controller.globalController.getEMAOrganizationDetailModel.value?.responseData?.has_ema_configs ?? false) ...[
                                                            Padding(
                                                              padding: const EdgeInsets.symmetric(horizontal: 20),
                                                              child: Row(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Expanded(
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text("EMA Integration", style: AppFonts.regular(12, AppColors.textBlack)),
                                                                        const SizedBox(height: 6),
                                                                        CupertinoSwitch(
                                                                          value: controller.getOrganizationDetailModel.value?.responseData?.isEmaIntegration ?? false,
                                                                          onChanged: (bool value) {
                                                                            controller.getOrganizationDetailModel.value?.responseData?.isEmaIntegration = !(controller.getOrganizationDetailModel.value?.responseData?.isEmaIntegration ?? false);
                                                                            // controller.selectedAppointmentTypeValue.value,

                                                                            if (controller.getOrganizationDetailModel.value?.responseData?.appointmentType?.label != null) {
                                                                              print("-------fbdesfjudgsf");
                                                                              controller.updateOrganization({
                                                                                "is_ema_integration": controller.getOrganizationDetailModel.value?.responseData?.isEmaIntegration,
                                                                                "appointment_type": {"label": controller.getOrganizationDetailModel.value?.responseData?.appointmentType?.label ?? "", "value": controller.getOrganizationDetailModel.value?.responseData?.appointmentType?.value ?? ""},
                                                                              });
                                                                            } else {
                                                                              controller.updateOrganization({
                                                                                "is_ema_integration": controller.getOrganizationDetailModel.value?.responseData?.isEmaIntegration,
                                                                                // "appointment_type": {"label": controller.getOrganizationDetailModel.value?.responseData?.appointmentType?.label ?? "", "value": controller.getOrganizationDetailModel.value?.responseData?.appointmentType?.value ?? ""},
                                                                              });
                                                                            }
                                                                          },
                                                                          activeTrackColor: AppColors.textPurple,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(child: CommonPatientData(label: "Appointment Type", data: controller.getOrganizationDetailModel.value?.responseData?.appointmentType?.label ?? "-")),
                                                                  Expanded(child: CommonPatientData(label: "Base url", data: controller.emaBaseUrlController.text)),
                                                                ],
                                                              ),
                                                            ),
                                                            const SizedBox(height: 20),
                                                            Padding(
                                                              padding: const EdgeInsets.symmetric(horizontal: 20),
                                                              child: Row(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [Expanded(child: CommonPatientData(label: "Api key", data: controller.emaAPIKeyController.text)), Expanded(child: CommonPatientData(label: "Api username", data: controller.emaAPIUsernameController.text)), Expanded(child: CommonPatientData(label: "Api password", data: controller.emaAPIPasswordController.text))],
                                                              ),
                                                            ),
                                                            const SizedBox(height: 20),
                                                          ],
                                                          // ],
                                                        ],
                                                      ),
                                                    )
                                                    : Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.white),
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                                                            child: Row(
                                                              children: [
                                                                Expanded(child: Text("User Management", style: AppFonts.medium(16, AppColors.black))),
                                                                const SizedBox(width: 5),
                                                                const SizedBox(width: 10),
                                                                SizedBox(
                                                                  height: 42,
                                                                  width: 180,
                                                                  child: HomeCustomSearchBar(
                                                                    showClearButton: controller.userInviteSearchController.text.isNotEmpty ? true : false,
                                                                    controller: controller.userInviteSearchController,
                                                                    hintText: 'Search ',
                                                                    onChanged: (value) {
                                                                      if (value.isNotEmpty) {
                                                                        // Create a copy of the responseData to ensure we're not modifying the original list

                                                                        controller.filterGetUserOrganizationListModel.value?.responseData =
                                                                            controller.getUserOrganizationListModel.value?.responseData?.where((element) {
                                                                              String userName = (element.name?.trim().toLowerCase() ?? "").trim().toLowerCase();
                                                                              String userEmail = (element.email?.trim().toLowerCase() ?? "").trim().toLowerCase();

                                                                              return (userName.contains(value) || userEmail.contains(value));
                                                                            }).toList();

                                                                        controller.filterGetUserOrganizationListModel.refresh();

                                                                        customPrint("filteredData ${controller.filterGetUserOrganizationListModel.value?.responseData?.length}");
                                                                        customPrint("getUserOrganizationListModel ${controller.getUserOrganizationListModel.value?.responseData?.length}");
                                                                      } else {
                                                                        customPrint("getUserOrganizationListModel ${controller.getUserOrganizationListModel.value?.responseData?.length}");

                                                                        // When no filter value, reset to the original data (no filter applied)
                                                                        controller.filterGetUserOrganizationListModel.value?.responseData = List.from(controller.getUserOrganizationListModel.value?.responseData ?? []);

                                                                        // Refresh if the data has changed
                                                                        if (controller.filterGetUserOrganizationListModel.value?.responseData != controller.getUserOrganizationListModel.value?.responseData) {
                                                                          controller.filterGetUserOrganizationListModel.refresh();
                                                                        }
                                                                      }
                                                                    },
                                                                    onSubmit: (text) {
                                                                      customPrint('Submitted search: $text');
                                                                    },
                                                                  ),
                                                                ),
                                                                const SizedBox(width: 10),
                                                                Container(
                                                                  width: 140,
                                                                  child: CustomButton(
                                                                    hight: 40,
                                                                    navigate: () async {
                                                                      showDialog(
                                                                        context: context,
                                                                        barrierDismissible: false,
                                                                        // Allows dismissing the dialog by tapping outside
                                                                        builder: (BuildContext context) {
                                                                          return InviteUserDialog(
                                                                            receiveParam: (p0) {
                                                                              controller.userInvite(p0);
                                                                            },
                                                                          ); // Our custom dialog
                                                                        },
                                                                      );
                                                                    },
                                                                    label: "Invite User",
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                                                            child: SizedBox(
                                                              height: (controller.filterGetUserOrganizationListModel.value?.responseData?.isEmpty ?? false) ? 300 : ((controller.filterGetUserOrganizationListModel.value?.responseData?.length ?? 0) + 1) * 68,
                                                              child: Column(
                                                                children: [
                                                                  controller.filterGetUserOrganizationListModel.value?.responseData?.isEmpty ?? false
                                                                      ? Padding(
                                                                        padding: const EdgeInsets.all(10),
                                                                        child: Center(
                                                                          child: Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [SvgPicture.asset(ImagePath.patient_no_data, width: 260), const SizedBox(height: 10), Text(textAlign: TextAlign.center, "No data found", style: AppFonts.medium(20, AppColors.textDarkGrey)), const SizedBox(height: 20)],
                                                                          ),
                                                                        ),
                                                                      )
                                                                      : Obx(() {
                                                                        return Expanded(
                                                                          child: CustomTable(
                                                                            // scrollController: controller.scrollControllerPatientList,
                                                                            physics: const NeverScrollableScrollPhysics(),
                                                                            onRefresh: () async {},
                                                                            rows: _getTableRows(controller.filterGetUserOrganizationListModel.value?.responseData ?? []),
                                                                            columnCount: 7,
                                                                            cellBuilder: _buildTableCell,
                                                                            context: context,
                                                                            onRowSelected: (rowIndex, rowData) {},
                                                                            onLoadMore: () async {},
                                                                            columnWidths: const [0.16, 0.21, 0.20, 0.12, 0.12, 0.12, 0.08],
                                                                            headerBuilder: (context, colIndex) {
                                                                              List<String> headers = ['First Name', 'Email Address', 'Role', 'Admin', 'Status', 'Last Login Date', 'Action'];
                                                                              return GestureDetector(
                                                                                onTap: () {
                                                                                  if (colIndex != 5) {
                                                                                    // controller.patientSorting(colIndex: colIndex, cellData: headers[colIndex]);
                                                                                  }
                                                                                  // customPrint(cellData);
                                                                                },
                                                                                child: Container(
                                                                                  color: AppColors.backgroundWhite,
                                                                                  height: 40,
                                                                                  child: Row(
                                                                                    mainAxisAlignment: colIndex == 0 ? MainAxisAlignment.start : MainAxisAlignment.center,
                                                                                    children: [
                                                                                      Text(
                                                                                        headers[colIndex],
                                                                                        textAlign: colIndex == 0 ? TextAlign.start : TextAlign.center,
                                                                                        style: AppFonts.medium(12, AppColors.black),
                                                                                        softWrap: true,
                                                                                        // Allows text to wrap
                                                                                        overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            },
                                                                            isLoading: false,
                                                                          ),
                                                                        );
                                                                      }),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(height: 10),
                                                        ],
                                                      ),
                                                    ),
                                                const SizedBox(height: 10),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
      globalKey: _key,
    );
  }

  // This function creates rows from the API model
  List<List<String>> _getTableRows(List<GetUserOrganizationListResponseData> patients) {
    List<List<String>> rows = [];

    // Add header row first
    // rows.add(['Patient Name', 'Age', 'Gender', 'Last Visit Date', 'Previous Visits', 'Action']);

    // Iterate over each patient and extract data for each row
    for (var patient in patients) {
      rows.add([
        "${patient.name}",
        // Patient Name
        patient.email ?? "N/A",
        // Gender
        patient.role ?? "",
        // Gender
        patient.isAdmin == true ? "Yes" : "No",

        patient.role ?? "",
        // Last Visit Date
        patient.lastLoginDate != null ? DateFormat('MM/dd/yyyy').format(DateTime.parse(patient.lastLoginDate.toString())) : "-",
        // Previous Visits
        "Action",
      ]);
    }
    return rows;
  }

  // This is the cell builder function where you can customize how each cell is built.
  Widget _buildTableCell(BuildContext context, int rowIndex, int colIndex, String cellData, String profileImage) {
    return colIndex == 0
        ? GestureDetector(
          onTap: () {},
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {},
                  child: Text(
                    cellData,
                    maxLines: 2,
                    textAlign: TextAlign.start,
                    style: AppFonts.regular(14, AppColors.textDarkGrey),
                    softWrap: true,
                    // Allows text to wrap
                    overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
                  ),
                ),
              ),
            ],
          ),
        )
        : colIndex == 6
        ? GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              barrierDismissible: true,
              // Allows dismissing the dialog by tapping outside
              builder: (BuildContext context) {
                return DeletePatientDialog(
                  title: "Are you sure want to delete user?",
                  onDelete: () {
                    Get.back();
                    controller.deleteUserManagementMember(controller.getUserOrganizationListModel.value?.responseData?[rowIndex].inviteId.toString() ?? "");
                  },
                  header: "Delete user",
                ); // Our custom dialog
              },
            );
          },
          child: SvgPicture.asset(ImagePath.user_trash, height: 25, width: 25),
        )
        : colIndex == 3
        ? IgnorePointer(
          ignoring: (controller.getUserOrganizationListModel.value?.responseData?[rowIndex].suspended ?? false),
          child: SizedBox(
            height: 30,
            child: Transform.scale(
              scale: 0.7,
              child: Switch(
                padding: EdgeInsets.zero,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                splashRadius: 0,
                // This bool value toggles the switch.
                value: cellData == "Yes" ? true : false,
                activeColor: AppColors.backgroundPurple,
                onChanged: (bool value) {
                  controller.updateRoleAndAdminControll(controller.getUserOrganizationListModel.value?.responseData?[rowIndex].id.toString() ?? "", controller.getUserOrganizationListModel.value?.responseData?[rowIndex].role ?? "", value, rowIndex);
                },
              ),
            ),
          ),
        )
        : colIndex == 2
        ? IgnorePointer(
          ignoring: (controller.getUserOrganizationListModel.value?.responseData?[rowIndex].suspended ?? false),
          child: PopupMenuButton<String>(
            offset: const Offset(0, 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            color: AppColors.white,
            position: PopupMenuPosition.under,
            padding: EdgeInsetsDirectional.zero,
            menuPadding: EdgeInsetsDirectional.zero,
            onSelected: (value) {},
            style: const ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsetsDirectional.zero), tapTargetSize: MaterialTapTargetSize.shrinkWrap, maximumSize: WidgetStatePropertyAll(Size.zero), visualDensity: VisualDensity(horizontal: 0, vertical: 0)),
            itemBuilder:
                (context) => [
                  for (var item in controller.userRolesModel.value?.responseData ?? [])
                    PopupMenuItem(
                      padding: EdgeInsets.zero,
                      onTap: () async {
                        controller.updateRoleAndAdminControll(controller.getUserOrganizationListModel.value?.responseData?[rowIndex].id.toString() ?? "", item, controller.getUserOrganizationListModel.value?.responseData?[rowIndex].isAdmin ?? false, rowIndex);
                      },
                      // value: "",
                      child: Padding(padding: const EdgeInsets.all(8.0), child: Text(item, style: AppFonts.regular(14, AppColors.textBlack))),
                    ),
                ],
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.dropdownBackgroundColor,
                border: Border.all(color: AppColors.dropdownBorderColor, width: 2),
                borderRadius: const BorderRadius.all(
                  Radius.circular(23.0), //                 <--- border radius here
                ),
              ),
              width: 100,
              height: 38,
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Text(
                    cellData,
                    textAlign: TextAlign.start,
                    style: AppFonts.regular(14, AppColors.textDarkGrey),
                    softWrap: true, // Allows text to wrap
                    overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
                  ),
                  const Spacer(),
                  SvgPicture.asset(ImagePath.down_arrow, width: 20, height: 20),
                  const SizedBox(width: 10),
                ],
              ),
            ),
          ),
        )
        : colIndex == 4
        ? Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Container(
            decoration: BoxDecoration(color: (controller.getUserOrganizationListModel.value?.responseData?[rowIndex].suspended == true) ? AppColors.redText.withValues(alpha: 0.2) : AppColors.textPurple.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Text((controller.getUserOrganizationListModel.value?.responseData?[rowIndex].suspended == true) ? "Suspended" : "Active", maxLines: 2, overflow: TextOverflow.visible, textAlign: TextAlign.center, style: AppFonts.medium(13, (controller.getUserOrganizationListModel.value?.responseData?[rowIndex].suspended == true) ? AppColors.redText : AppColors.textPurple)),
            ),
          ),
        )
        : colIndex == 1
        ? cellData == "N/A"
            ? GestureDetector(
              onTap: () {
                showEmailDialog(controller.getUserOrganizationListModel.value?.responseData?[rowIndex].id ?? 0, context, controller);
              },
              child: Text(
                "+ Provide Email",
                textAlign: colIndex == 0 ? TextAlign.start : TextAlign.center,
                style: AppFonts.regular(14, AppColors.textPurple),
                softWrap: true, // Allows text to wrap
                overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
              ),
            )
            : Text(
              cellData,
              textAlign: colIndex == 0 ? TextAlign.start : TextAlign.center,
              style: AppFonts.regular(14, AppColors.textDarkGrey),
              softWrap: true, // Allows text to wrap
              overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
            )
        : Text(
          cellData,
          textAlign: colIndex == 0 ? TextAlign.start : TextAlign.center,
          style: AppFonts.regular(14, AppColors.textDarkGrey),
          softWrap: true, // Allows text to wrap
          overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
        );
  }

  void showAppointmentTypeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 16,
          child: Container(
            constraints: BoxConstraints(maxHeight: Get.height * .80, maxWidth: Get.width * .50),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(color: AppColors.backgroundPurple, borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), child: Text("Select Appointment Type", style: AppFonts.medium(14, Colors.white))),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(padding: const EdgeInsets.all(15), color: AppColors.clear, child: SvgPicture.asset("assets/images/cross_white.svg", width: 15)),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [Text("Appointment Type", style: AppFonts.regular(14, AppColors.textBlack)), Text("*", style: AppFonts.regular(14, AppColors.redText))]),
                                const SizedBox(height: 8),
                                Obx(() {
                                  return BaseDropdown<String>(
                                    valueAsString: (value) => value ?? "",
                                    items: controller.getAvailableVisitTypes.value?.responseData?.map((e) => e.display ?? "").toList() ?? [],
                                    selectedValue: controller.selectedAppointmentTypeValue.value,
                                    onChanged: (value) {
                                      controller.selectedAppointmentTypeValue.value = value;
                                    },
                                    selectText: controller.selectedAppointmentTypeValue.value,
                                  );
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 100,
                            child: CustomButton(
                              navigate: () {
                                Navigator.pop(context);
                              },
                              label: "Cancel",
                              backGround: Colors.white,
                              isTrue: false,
                              textColor: AppColors.backgroundPurple,
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 100,
                            child: CustomButton(
                              navigate: () {
                                String appointmentValue = controller.getAvailableVisitTypes.value?.responseData?.firstWhere((element) => element.display == controller.selectedAppointmentTypeValue.value).code ?? "";

                                Navigator.of(context).pop();

                                controller.updateOrganization({
                                  "is_ema_integration": true,
                                  "appointment_type": {"label": controller.selectedAppointmentTypeValue.value ?? "", "value": appointmentValue},
                                });
                              },
                              label: "OK",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
// class PersonalSettingView extends GetView<PersonalSettingController> {
//   final GlobalKey<ScaffoldState> _key = GlobalKey();
//
//   PersonalSettingView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     _handleRouteInit();
//
//     return BaseScreen(onItemSelected: _handleDrawerItemSelected, body: _buildMainContent(), globalKey: _key);
//   }
//
//   void _handleRouteInit() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (controller.globalController.breadcrumbHistory.last != controller.globalController.breadcrumbs[Routes.PERSONAL_SETTING]) {
//         controller.globalController.addRouteInit(Routes.PERSONAL_SETTING);
//       }
//     });
//   }
//
//   Future<void> _handleDrawerItemSelected(int index) async {
//     _key.currentState?.closeDrawer();
//     switch (index) {
//       case 0:
//         await Get.toNamed(Routes.ADD_PATIENT);
//         break;
//       case 1:
//         Get.offAllNamed(Routes.HOME, arguments: {"tabIndex": 1});
//         break;
//       case 2:
//         Get.toNamed(Routes.HOME, arguments: {"tabIndex": 2});
//         break;
//       case 3:
//         Get.toNamed(Routes.HOME, arguments: {"tabIndex": 0});
//         break;
//     }
//   }
//
//   Widget _buildMainContent() {
//     return PopScope(
//       canPop: true,
//       onPopInvokedWithResult: (didPop, result) {
//         if (controller.globalController.getKeyByValue(controller.globalController.breadcrumbHistory.last) == Routes.PERSONAL_SETTING) {
//           controller.globalController.popRoute();
//         }
//       },
//       child: GestureDetector(
//         onTap: removeFocus,
//         child: SafeArea(
//           child: Container(
//             color: AppColors.ScreenBackGround,
//             child: Obx(() {
//               return Column(children: [CustomAppBar(drawerkey: _key), Expanded(child: _buildContentBody())]);
//             }),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildContentBody() {
//     return Container(
//       width: double.infinity,
//       color: AppColors.ScreenBackGround,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(child: Padding(padding: const EdgeInsets.all(15), child: Container(width: double.infinity, decoration: const BoxDecoration(color: Colors.transparent), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const SizedBox(height: 10), _buildTabSelector(), const SizedBox(height: 20), Expanded(child: _buildSelectedTabContent())])))),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTabSelector() {
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.backgroundWhite),
//       child: Obx(() {
//         return Container(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//           decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.white),
//           height: 70,
//           child: SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             scrollDirection: Axis.horizontal,
//             child: Row(
//               children: [
//                 _buildTabButton(text: "Personal Settings", index: 0),
//                 if (controller.getUserDetailModel.value?.responseData?.isAdmin ?? false) _buildTabButton(text: "Organization Management", index: 1),
//                 if (controller.getUserDetailModel.value?.responseData?.isAdmin ?? false)
//                   _buildTabButton(
//                     text: "User Management",
//                     index: 2,
//                     onPressed: () {
//                       controller.resetUserManagementFilters();
//                     },
//                   ),
//               ],
//             ),
//           ),
//         );
//       }),
//     );
//   }
//
//   Widget _buildTabButton({required String text, required int index, VoidCallback? onPressed}) {
//     final isSelected = controller.tabIndex.value == index;
//     return IntrinsicWidth(
//       child: CustomAnimatedButton(
//         onPressed: onPressed ?? () => controller.tabIndex.value = index,
//         text: text,
//         isOutline: true,
//         paddingText: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//         fontSize: 14,
//         enabledTextColor: isSelected ? AppColors.backgroundPurple : AppColors.textGrey,
//         enabledColor: isSelected ? AppColors.buttonPurpleLight : AppColors.clear,
//         outLineEnabledColor: AppColors.textGrey,
//         outlineColor: isSelected ? AppColors.backgroundPurple : AppColors.clear,
//       ),
//     );
//   }
//
//   Widget _buildSelectedTabContent() {
//     return Obx(() {
//       switch (controller.tabIndex.value) {
//         case 0:
//           return PersonalInfoTab(controller: controller);
//         case 1:
//           return OrganizationManagementTab(controller: controller);
//         case 2:
//           return UserManagementTab(controller: controller);
//         default:
//           return const SizedBox();
//       }
//     });
//   }
// }

void showEmailDialog(int userId, BuildContext context, PersonalSettingController controller) {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 16,
        child: Container(
          constraints: BoxConstraints(maxHeight: Get.height * .80, maxWidth: Get.width * .50),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(color: AppColors.backgroundPurple, borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), child: Text("Send user invitation", style: AppFonts.medium(14, Colors.white))),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(padding: const EdgeInsets.all(15), color: AppColors.clear, child: SvgPicture.asset("assets/images/cross_white.svg", width: 15)),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormFiledWidget(
                              format: [NoSpaceLowercaseTextFormatter()],
                              label: AppString.emailAddress,
                              controller: emailController,
                              isValid: controller.isValid.value,
                              isSuffixIconVisible: false,
                              isFirst: true,
                              hint: AppString.emailPlaceHolder,
                              onTap: () {
                                emailController.clear();
                              },
                              suffixIcon: const Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                              checkValidation: (value) {
                                return Validation.emailValidateRequired(value);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 100,
                            child: CustomButton(
                              navigate: () {
                                Navigator.pop(context);
                              },
                              label: "Cancel",
                              backGround: Colors.white,
                              isTrue: false,
                              textColor: AppColors.backgroundPurple,
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 100,
                            child: CustomButton(
                              navigate: () {
                                if (formKey.currentState?.validate() ?? false) {
                                  controller.activeUser({"user_id": userId, "email": emailController.text});
                                  Navigator.of(context).pop();
                                }
                              },
                              label: "OK",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

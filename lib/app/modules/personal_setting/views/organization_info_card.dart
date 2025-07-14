import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../../../../widget/base_image_view.dart';
import '../../../../widget/custom_animated_button.dart';
import '../../../../widget/fileImage.dart';
import '../../../../widgets/base_dropdown.dart';
import '../../../../widgets/custom_button.dart';
import '../../patient_profile/widgets/common_patient_data.dart';
import '../controllers/personal_setting_controller.dart';
import 'integrate_ema_dialog.dart';
import 'organization_edit_dialog.dart';

class OrganizationInfoCard extends StatelessWidget {
  final PersonalSettingController controller;

  const OrganizationInfoCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: Column(children: [_buildProfileSection(context), const SizedBox(height: 20), _buildOrganizationInfoSection(), const SizedBox(height: 20), _buildContactInfoSection(), const SizedBox(height: 20), _buildAddressSection(), const SizedBox(height: 20), _buildEMASection(context)]));
  }

  Widget _buildProfileSection(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Row(children: [_buildOrganizationImage(), const SizedBox(width: 10), _buildOrganizationName(), const Spacer(), _buildEditButton(context)]));
  }

  Widget _buildOrganizationImage() {
    return GestureDetector(
      onTap: () => controller.showImagePickerDialog(Get.context!, false),
      child: Obx(() {
        final org = controller.getOrganizationDetailModel.value?.responseData;
        return ClipRRect(borderRadius: BorderRadius.circular(100), child: _getOrganizationImageWidget(org));
      }),
    );
  }

  Widget _getOrganizationImageWidget(org) {
    if (org?.profileImage != null) {
      return CachedNetworkImage(imageUrl: org.profileImage ?? "", width: 60, height: 60, fit: BoxFit.cover);
    } else if (controller.organizationProfileImage.value?.path != null) {
      return RoundedImageFileWidget(size: 60, imagePath: controller.organizationProfileImage.value);
    } else {
      return BaseImageView(imageUrl: "", width: 60, height: 60, fontSize: 14, nameLetters: org?.name ?? "");
    }
  }

  Widget _buildOrganizationName() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(controller.getOrganizationDetailModel.value?.responseData?.name ?? "-", style: AppFonts.medium(16, AppColors.textBlack)), const SizedBox(width: 15)]);
  }

  Widget _buildEditButton(BuildContext context) {
    return GestureDetector(onTap: () => _showOrganizationEditDialog(context), child: SvgPicture.asset(ImagePath.edit, width: 26, height: 26, fit: BoxFit.cover));
  }

  void _showOrganizationEditDialog(BuildContext context) async {
    controller.setOrganizationData();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return OrganizationEditDialog(
          receiveParam: (p0) {
            Future.delayed(const Duration(milliseconds: 200)).then((_) {
              controller.updateOrganization(p0);
            });
          },
        );
      },
    );
  }

  Widget _buildOrganizationInfoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildSectionHeader("Organization Information"),
          const SizedBox(height: 20),
          Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child: CommonPatientData(label: "Name", data: controller.getOrganizationDetailModel.value?.responseData?.name ?? "-")), const Expanded(child: SizedBox()), const Expanded(child: SizedBox()), const Expanded(child: SizedBox())]),
        ],
      ),
    );
  }

  Widget _buildContactInfoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildSectionHeader("Contact"),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Expanded(child: CommonPatientData(label: "Email ID", data: controller.getOrganizationDetailModel.value?.responseData?.email ?? "-")), Expanded(child: CommonPatientData(label: "Phone Number", data: controller.getOrganizationDetailModel.value?.responseData?.contactNo ?? "-")), const Expanded(child: SizedBox()), const Expanded(child: SizedBox())],
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildSectionHeader("Address"),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Expanded(child: CommonPatientData(label: "Street Name", data: controller.getOrganizationDetailModel.value?.responseData?.streetName ?? "-")), Expanded(child: CommonPatientData(label: "City", data: controller.getOrganizationDetailModel.value?.responseData?.city ?? "-")), const Expanded(child: SizedBox()), const Expanded(child: SizedBox())],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: CommonPatientData(label: "State", data: controller.getOrganizationDetailModel.value?.responseData?.state ?? "-")),
              Expanded(child: CommonPatientData(label: "Postal Code", data: controller.getOrganizationDetailModel.value?.responseData?.postalCode ?? "-")),
              Expanded(child: CommonPatientData(label: "Country", data: controller.getOrganizationDetailModel.value?.responseData?.country ?? "-")),
              const Expanded(child: SizedBox()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEMASection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildEMAHeader(context),
          if ((controller.globalController.getEMAOrganizationDetailModel.value?.responseData?.isEmaIntegration == false) && (controller.globalController.getEMAOrganizationDetailModel.value?.responseData?.has_ema_configs == false)) _buildIntegrateEMAButton(context),
          if (controller.globalController.getEMAOrganizationDetailModel.value?.responseData?.has_ema_configs ?? false) _buildEMAConfigDetails(),
        ],
      ),
    );
  }

  Widget _buildEMAHeader(BuildContext context) {
    return Row(
      children: [Text("EMA", style: AppFonts.medium(16, AppColors.backgroundPurple)), const Spacer(), if (controller.globalController.getEMAOrganizationDetailModel.value?.responseData?.isEmaIntegration == true) _buildSyncButton(), const SizedBox(width: 10), if (controller.globalController.getEMAOrganizationDetailModel.value?.responseData?.has_ema_configs ?? false) _buildEMAEditButton(context)],
    );
  }

  Widget _buildSyncButton() {
    return IgnorePointer(
      ignoring: (controller.forceSyncLogModel.value?.responseData?.isSyncing ?? false),
      child: SizedBox(
        width: (controller.forceSyncLogModel.value?.responseData?.isSyncing ?? false) ? 120 : 80,
        height: 40,
        child: CustomAnimatedButton(onPressed: controller.forceSyncUpdate, text: (controller.forceSyncLogModel.value?.responseData?.isSyncing ?? false) ? "Syncing..." : "Sync", height: 40, isOutline: true, enabledColor: AppColors.white, enabledTextColor: AppColors.textPurple, outlineColor: AppColors.textPurple),
      ),
    );
  }

  Widget _buildEMAEditButton(BuildContext context) {
    return GestureDetector(onTap: () => _showIntegrateEMADialog(context), child: SvgPicture.asset(ImagePath.edit, width: 26, height: 26));
  }

  Widget _buildIntegrateEMAButton(BuildContext context) {
    return Row(children: [SizedBox(width: 180, child: CustomAnimatedButton(onPressed: () => _showIntegrateEMADialog(context), text: "Integrate EMA", height: 40, isOutline: true, enabledColor: AppColors.white, enabledTextColor: AppColors.textPurple, outlineColor: AppColors.textPurple)), const Spacer()]);
  }

  void _showIntegrateEMADialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return IntegrateEmaDialog(
          receiveParam: (param) async {
            if (param) {
              _showAppointmentTypeDialog(context);
            }
          },
        );
      },
    );
  }

  Widget _buildEMAConfigDetails() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("EMA Integration", style: AppFonts.regular(12, AppColors.textBlack)), const SizedBox(height: 6), CupertinoSwitch(value: controller.getOrganizationDetailModel.value?.responseData?.isEmaIntegration ?? false, onChanged: _handleEMAIntegrationToggle, activeTrackColor: AppColors.textPurple)])),
            Expanded(child: CommonPatientData(label: "Appointment Type", data: controller.getOrganizationDetailModel.value?.responseData?.appointmentType?.label ?? "-")),
            Expanded(child: CommonPatientData(label: "Base url", data: controller.emaBaseUrlController.text)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Expanded(child: CommonPatientData(label: "Api key", data: controller.emaAPIKeyController.text)), Expanded(child: CommonPatientData(label: "Api username", data: controller.emaAPIUsernameController.text)), Expanded(child: CommonPatientData(label: "Api password", data: controller.emaAPIPasswordController.text))],
        ),
      ],
    );
  }

  void _handleEMAIntegrationToggle(bool value) {
    controller.getOrganizationDetailModel.value?.responseData?.isEmaIntegration = !(controller.getOrganizationDetailModel.value?.responseData?.isEmaIntegration ?? false);

    final appointmentType = controller.getOrganizationDetailModel.value?.responseData?.appointmentType;

    if (appointmentType?.label != null) {
      controller.updateOrganization({
        "is_ema_integration": controller.getOrganizationDetailModel.value?.responseData?.isEmaIntegration,
        "appointment_type": {"label": appointmentType?.label ?? "", "value": appointmentType?.value ?? ""},
      });
    } else {
      controller.updateOrganization({"is_ema_integration": controller.getOrganizationDetailModel.value?.responseData?.isEmaIntegration});
    }
  }

  void _showAppointmentTypeDialog(BuildContext context) {
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
                _buildAppointmentTypeDialogHeader(),
                Padding(padding: const EdgeInsets.all(16), child: Column(children: [_buildAppointmentTypeDropdown(), const SizedBox(height: 20), _buildDialogButtons(context)])),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppointmentTypeDialogHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: AppColors.backgroundPurple, borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), child: Text("Select Appointment Type", style: AppFonts.medium(14, Colors.white))), const Spacer(), GestureDetector(onTap: () => Navigator.pop(Get.context!), child: Container(padding: const EdgeInsets.all(15), color: AppColors.clear, child: SvgPicture.asset("assets/images/cross_white.svg", width: 15)))],
        ),
      ),
    );
  }

  Widget _buildAppointmentTypeDropdown() {
    return Row(
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
    );
  }

  Widget _buildDialogButtons(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [SizedBox(width: 100, child: CustomButton(navigate: () => Navigator.pop(context), label: "Cancel", backGround: Colors.white, isTrue: false, textColor: AppColors.backgroundPurple)), const SizedBox(width: 12), SizedBox(width: 100, child: CustomButton(navigate: () => _saveAppointmentType(context), label: "OK"))]);
  }

  void _saveAppointmentType(BuildContext context) {
    final appointmentValue = controller.getAvailableVisitTypes.value?.responseData?.firstWhere((element) => element.display == controller.selectedAppointmentTypeValue.value).code ?? "";

    Navigator.of(context).pop();

    controller.updateOrganization({
      "is_ema_integration": true,
      "appointment_type": {"label": controller.selectedAppointmentTypeValue.value ?? "", "value": appointmentValue},
    });
  }

  Widget _buildSectionHeader(String title) {
    return Row(children: [Text(textAlign: TextAlign.center, title, style: AppFonts.medium(16, AppColors.backgroundPurple)), const Spacer()]);
  }
}

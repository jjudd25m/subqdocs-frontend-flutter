import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subqdocs/app/modules/personal_setting/views/personal_info_card.dart';
import 'package:subqdocs/app/modules/personal_setting/views/practitioner_details_card.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/app_string.dart';
import '../../../../widget/custom_animated_button.dart';
import '../../../core/common/app_preferences.dart';
import '../../../core/common/global_controller.dart';
import '../../../routes/app_pages.dart';
import '../../visit_main/views/delete_image_dialog.dart';
import '../controllers/personal_setting_controller.dart';
import 'contact_info_card.dart';

class PersonalInfoTab extends StatelessWidget {
  final PersonalSettingController controller;

  const PersonalInfoTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(splashColor: Colors.transparent, highlightColor: Colors.transparent),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildHeader("Personal Settings"),
            const SizedBox(height: 10),
            Divider(height: 1, color: AppColors.textGrey.withValues(alpha: 0.3)),
            const SizedBox(height: 20),
            PersonalInfoCard(controller: controller),
            const SizedBox(height: 20),
            ContactInfoCard(controller: controller),
            if (controller.userRole.value == "Doctor") ...[const SizedBox(height: 20), PractitionerDetailsCard(controller: controller)],
            const SizedBox(height: 20),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Row(children: [const SizedBox(width: 10), Text(textAlign: TextAlign.center, title, style: AppFonts.medium(16, AppColors.textBlack)), const Spacer()]));
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        const SizedBox(width: 20),
        SizedBox(width: 120, height: 45, child: CustomAnimatedButton(text: "Logout", onPressed: _showLogoutDialog, height: 35, isOutline: true, enabledColor: AppColors.redText, outlineColor: AppColors.redText, enabledTextColor: AppColors.white, outLineEnabledColor: AppColors.redText)),
        const SizedBox(width: 15),
        SizedBox(width: 170, height: 45, child: CustomAnimatedButton(text: "Delete Account", onPressed: _showDeleteAccountDialog, height: 35, isOutline: true, enabledColor: AppColors.white, outlineColor: AppColors.redText, enabledTextColor: AppColors.redText, outLineEnabledColor: AppColors.redText)),
      ],
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: Get.context!,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return LogoutDialog(title: "Are you sure want to logout?", onDelete: _performLogout, header: "Alert!");
      },
    );
  }

  Future<void> _performLogout() async {
    await AppPreference.instance.removeKey(AppString.prefKeyUserLoginData);
    await AppPreference.instance.removeKey(AppString.prefKeyToken);
    await AppPreference.instance.removeKey("homePastPatientListSortingModel");
    await AppPreference.instance.removeKey("homePatientListSortingModel");
    await AppPreference.instance.removeKey("homeScheduleListSortingModel");
    Get.delete<GlobalController>();
    Get.offAllNamed(Routes.LOGIN);
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: Get.context!,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DeletePatientDialog(title: "Are you sure want to delete account", onDelete: () => controller.deleteAccount(), header: "Delete account");
      },
    );
  }
}

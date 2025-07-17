import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subqdocs/app/modules/personal_setting/views/user_management_table.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../widgets/custom_button.dart';
import '../../patient_info/views/home_custom_search_bar.dart';
import '../controllers/personal_setting_controller.dart';
import 'invite_user_dialog.dart';

class UserManagementTab extends StatelessWidget {
  final PersonalSettingController controller;

  const UserManagementTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.white), child: Column(children: [_buildHeader(), const SizedBox(height: 10), UserManagementTable(controller: controller)]));
  }

  Widget _buildHeader() {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15), child: Row(children: [Expanded(child: Text("User Management", style: AppFonts.medium(16, AppColors.black))), const SizedBox(width: 5), const SizedBox(width: 10), _buildSearchBar(), const SizedBox(width: 10), _buildInviteUserButton()]));
  }

  Widget _buildSearchBar() {
    return SizedBox(height: 42, width: 180, child: HomeCustomSearchBar(showClearButton: controller.userInviteSearchController.text.isNotEmpty, controller: controller.userInviteSearchController, hintText: 'Search', onChanged: (value) => controller.filterUsers(value)));
  }

  Widget _buildInviteUserButton() {
    return SizedBox(width: 140, child: CustomButton(hight: 40, navigate: _showInviteUserDialog, label: "Invite User"));
  }

  void _showInviteUserDialog() {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return InviteUserDialog(receiveParam: (p0) => controller.userInvite(p0));
      },
    );
  }
}

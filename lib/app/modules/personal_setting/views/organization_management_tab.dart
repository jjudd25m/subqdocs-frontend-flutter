import 'package:flutter/material.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../controllers/personal_setting_controller.dart';

class OrganizationManagementTab extends StatelessWidget {
  final PersonalSettingController controller;

  const OrganizationManagementTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(splashColor: Colors.transparent, highlightColor: Colors.transparent),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10), _buildHeader("Organization Management"), const SizedBox(height: 10), Divider(height: 1, color: AppColors.textGrey.withValues(alpha: 0.3)), const SizedBox(height: 20),
            // OrganizationInfoCard(controller: controller)
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Row(children: [const SizedBox(width: 10), Text(textAlign: TextAlign.center, title, style: AppFonts.medium(16, AppColors.textBlack)), const Spacer()]));
  }
}

import 'package:flutter/material.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../patient_profile/widgets/common_patient_data.dart';
import '../controllers/personal_setting_controller.dart';

class ContactInfoCard extends StatelessWidget {
  final PersonalSettingController controller;

  const ContactInfoCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Column(children: [_buildSectionHeader("Contact"), const SizedBox(height: 20), _buildContactInfoFields()]));
  }

  Widget _buildSectionHeader(String title) {
    return Row(children: [Text(textAlign: TextAlign.center, title, style: AppFonts.medium(16, AppColors.backgroundPurple)), const Spacer()]);
  }

  Widget _buildContactInfoFields() {
    return Row(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Expanded(child: CommonPatientData(label: "Email ID", data: controller.getUserDetailModel.value?.responseData?.email ?? "-")), Expanded(child: CommonPatientData(label: "Phone Number", data: controller.getUserDetailModel.value?.responseData?.contactNo ?? "-")), const Expanded(child: SizedBox()), const Expanded(child: SizedBox())],
    );
  }
}

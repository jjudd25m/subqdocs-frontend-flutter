import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../patient_profile/widgets/common_patient_data.dart';
import '../controllers/personal_setting_controller.dart';

class PractitionerDetailsCard extends StatelessWidget {
  final PersonalSettingController controller;

  const PractitionerDetailsCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Column(children: [_buildSectionHeader("Practitioner Details"), const SizedBox(height: 20), _buildPractitionerDetailsRow1(), const SizedBox(height: 20), _buildPractitionerDetailsRow2(), const SizedBox(height: 20), _buildPractitionerDetailsRow3()]));
  }

  Widget _buildSectionHeader(String title) {
    return Row(children: [Text(textAlign: TextAlign.center, title, style: AppFonts.medium(16, AppColors.backgroundPurple)), const Spacer()]);
  }

  Widget _buildPractitionerDetailsRow1() {
    return Row(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: CommonPatientData(label: "Title", data: controller.getUserDetailModel.value?.responseData?.title ?? "-")),
        Expanded(child: CommonPatientData(label: "Degree", data: controller.getUserDetailModel.value?.responseData?.degree ?? "-")),
        Expanded(child: CommonPatientData(label: "Medical License Number", data: controller.getUserDetailModel.value?.responseData?.medicalLicenseNumber ?? "-")),
        const Expanded(child: SizedBox()),
      ],
    );
  }

  Widget _buildPractitionerDetailsRow2() {
    return Row(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: CommonPatientData(label: "License Expiry Date", data: _getFormattedDate(controller.getUserDetailModel.value?.responseData?.licenseExpiryDate))),
        Expanded(child: CommonPatientData(label: "National Provider Identifier", data: controller.getUserDetailModel.value?.responseData?.nationalProviderIdentifier?.toString() ?? "-")),
        Expanded(child: CommonPatientData(label: "Taxonomy Code", data: controller.getUserDetailModel.value?.responseData?.taxonomyCode ?? "-")),
        const Expanded(child: SizedBox()),
      ],
    );
  }

  Widget _buildPractitionerDetailsRow3() {
    return Row(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Expanded(child: CommonPatientData(label: "Specialization", data: controller.getUserDetailModel.value?.responseData?.specialization ?? "-")), Expanded(child: CommonPatientData(label: "Sign and Finalize PIN", data: controller.getUserDetailModel.value?.responseData?.pin?.replaceAll(RegExp('.'), '*') ?? "-")), const Expanded(child: SizedBox()), const Expanded(child: SizedBox())],
    );
  }

  String _getFormattedDate(String? dateString) {
    if (dateString?.isNotEmpty ?? false) {
      try {
        return DateFormat('MM/dd/yyyy').format(DateTime.parse(dateString!));
      } catch (e) {
        return "-";
      }
    }
    return "-";
  }
}

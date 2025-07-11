import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../../../../widget/base_image_view.dart';
import '../../../../widget/fileImage.dart';
import '../../patient_profile/widgets/common_patient_data.dart';
import '../controllers/personal_setting_controller.dart';
import 'organization_use_edit_dialog.dart';

class PersonalInfoCard extends StatelessWidget {
  final PersonalSettingController controller;

  const PersonalInfoCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Column(children: [_buildProfileSection(), const SizedBox(height: 20), _buildSectionHeader("Personal Information"), const SizedBox(height: 20), _buildPersonalInfoFields()]));
  }

  Widget _buildProfileSection() {
    return Row(children: [_buildProfileImage(), const SizedBox(width: 10), _buildUserName(), const Spacer(), _buildEditButton()]);
  }

  Widget _buildProfileImage() {
    return GestureDetector(
      onTap: () => controller.showImagePickerDialog(Get.context!, true),
      child: Obx(() {
        final user = controller.getUserDetailModel.value?.responseData;
        return ClipRRect(borderRadius: BorderRadius.circular(100), child: _getProfileImageWidget(user));
      }),
    );
  }

  Widget _getProfileImageWidget(user) {
    if (user?.profileImage?.isNotEmpty == true) {
      return CachedNetworkImage(imageUrl: user.profileImage ?? "", width: 60, height: 60, fit: BoxFit.cover);
    } else if (controller.userProfileImage.value?.path != null) {
      return RoundedImageFileWidget(size: 60, imagePath: controller.userProfileImage.value);
    } else {
      return BaseImageView(imageUrl: "", width: 60, height: 60, fontSize: 14, nameLetters: "${user?.firstName ?? ""} ${user?.lastName ?? ""}");
    }
  }

  Widget _buildUserName() {
    return Expanded(
      child: Text(
        "${controller.getUserDetailModel.value?.responseData?.firstName ?? ""} "
        "${controller.getUserDetailModel.value?.responseData?.lastName ?? ""}",
        style: AppFonts.medium(16, AppColors.textBlack),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  Widget _buildEditButton() {
    return GestureDetector(onTap: _showEditDialog, child: SvgPicture.asset(ImagePath.edit, width: 26, height: 26));
  }

  void _showEditDialog() async {
    controller.setUserDetail();
    showDialog(
      context: Get.context!,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return OrganizationUseEditDialog(
          receiveParam: (p0) {
            Future.delayed(const Duration(milliseconds: 200)).then((_) => controller.updateUserDetail(p0));
          },
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(children: [Text(textAlign: TextAlign.center, title, style: AppFonts.medium(16, AppColors.backgroundPurple)), const Spacer()]);
  }

  Widget _buildPersonalInfoFields() {
    return Row(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [Expanded(child: CommonPatientData(label: "First Name", data: controller.getUserDetailModel.value?.responseData?.firstName ?? "-")), Expanded(child: CommonPatientData(label: "Last Name", data: controller.getUserDetailModel.value?.responseData?.lastName ?? "-")), const Expanded(child: SizedBox()), const Expanded(child: SizedBox())],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../../../../widget/custom_animated_button.dart';
import '../../../core/common/common_service.dart';
import '../../patient_profile/widgets/common_patient_data.dart';
import '../controllers/invited_user_submitted_controller.dart';

class InvitedUserSubmittedView extends GetView<InvitedUserSubmittedController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isWidthLessThan428(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return width < 428;
  }

  InvitedUserSubmittedView({super.key});
  @override
  Widget build(BuildContext context) {
    bool isPortrait = MediaQuery.orientationOf(context) == Orientation.portrait;
    bool isSmallScreen = isWidthLessThan428(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: removeFocus,
        child: Form(
          key: _formKey,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: isSmallScreen ? 130 : 300,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      top: isPortrait ? 0 : -80,
                      child: Image.asset(ImagePath.loginHeader),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: isPortrait ? null : 30),
                  Text(
                    "Lets Get Started",
                    style: AppFonts.medium(24, AppColors.backgroundPurple),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Set up your subQdocs profile",
                    style: AppFonts.medium(20, AppColors.textBlack),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: isSmallScreen ? Get.width - 30 : 416,
                    child: Text(
                      "Provide details about your organization and we’ll customize your subQdocs just for you!",
                      style: AppFonts.regular(14, AppColors.textDarkGrey),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: isSmallScreen ? Get.width - 30 : 416,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonPatientData(
                          label: "First Name",
                          data: controller.firstName.value,
                        ),
                        CommonPatientData(
                          label: "Last Name",
                          data: controller.lastName.value,
                        ),
                        CommonPatientData(
                          label: "Email Address",
                          data: controller.email.value,
                        ),
                        const SizedBox(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: isSmallScreen ? Get.width - 30 : 416,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonPatientData(
                          label: "Role",
                          data: controller.role.value,
                        ),
                        CommonPatientData(
                          label: "Admin",
                          data: controller.isAdmin.value ? "Yes" : "No",
                        ),
                        const SizedBox(),
                        const SizedBox(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: isSmallScreen ? Get.width - 30 : 416,
                    child: CustomAnimatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      height: 45,
                      text: "Continue",
                      // isLoading: controller.isLoading.value,
                      enabledTextColor: AppColors.white,
                      enabledColor: AppColors.backgroundPurple,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

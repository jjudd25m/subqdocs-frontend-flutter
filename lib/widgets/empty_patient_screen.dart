import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../app/core/common/global_controller.dart';
import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';
import '../utils/imagepath.dart';
import 'custom_animated_button.dart';

class EmptyPatientScreen extends StatelessWidget {
  final String? title;
  final String? description;
  final String? buttonTitle;
  final GlobalController globalController = Get.find();
  final void Function()? onBtnPress;

  EmptyPatientScreen({super.key, this.title, this.description, this.onBtnPress, this.buttonTitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(ImagePath.patient_no_data, width: 260),
            const SizedBox(height: 10),
            Text(textAlign: TextAlign.center, title ?? " ", style: AppFonts.medium(20, AppColors.textDarkGrey)),
            const SizedBox(height: 15),
            Text(description ?? "", style: AppFonts.regular(14, AppColors.textDarkGrey.withValues(alpha: 0.6)), textAlign: TextAlign.center),
            const SizedBox(height: 20),
            if (globalController.getEMAOrganizationDetailModel.value?.responseData?.isEmaIntegration == false) ...[Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0), child: SizedBox(width: 250, child: CustomAnimatedButton(fontSize: 15, onPressed: onBtnPress, enabledTextColor: AppColors.textWhite, enabledColor: AppColors.textPurple, text: "$buttonTitle", height: 45)))],
          ],
        ),
      ),
    );
  }
}

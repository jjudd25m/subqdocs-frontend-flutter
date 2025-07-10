import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:subqdocs/app/routes/app_pages.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/utils/app_fonts.dart';
import 'package:subqdocs/utils/imagepath.dart';

import '../../../../widget/custom_animated_button.dart';
import '../../../core/common/global_controller.dart';

class ConfirmFinalizeDialog extends StatelessWidget {
  final VoidCallback? onDelete;

  const ConfirmFinalizeDialog({super.key, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 16,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 50,
              width: double.infinity,
              decoration: const BoxDecoration(color: AppColors.backgroundPurple, borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Confirm", style: AppFonts.medium(15, Colors.white)),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: SvgPicture.asset(ImagePath.logo_cross, width: 20, height: 20, colorFilter: const ColorFilter.mode(AppColors.backgroundWhite, BlendMode.srcIn)),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
            ),
            Container(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  SvgPicture.asset(ImagePath.confirm_check, width: 100, height: 100),
                  const SizedBox(height: 20),
                  Row(children: [Expanded(child: Text("Are you sure you want to finalize?", textAlign: TextAlign.center, style: AppFonts.medium(17, AppColors.textBlack)))]),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      spacing: 20,
                      children: [
                        Expanded(
                          child: CustomAnimatedButton(
                            text: " Cancel ",
                            onPressed: () {
                              Get.back();
                            },
                            isOutline: true,
                            enabledTextColor: AppColors.backgroundPurple,
                            enabledColor: AppColors.white,
                            outLineEnabledColor: AppColors.textGrey,
                            outlineColor: AppColors.backgroundPurple,
                          ),
                        ),
                        Expanded(child: CustomAnimatedButton(onPressed: onDelete, text: " Finalize ", isOutline: true, enabledTextColor: AppColors.textWhite, enabledColor: AppColors.backgroundPurple, outLineEnabledColor: AppColors.textGrey, outlineColor: AppColors.backgroundPurple)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class PrompErrorDialog extends StatelessWidget {
  final String errorMessage;

  const PrompErrorDialog(this.errorMessage, {super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 16,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 50,
              width: double.infinity,
              decoration: const BoxDecoration(color: AppColors.backgroundPurple, borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
              child: Padding(padding: const EdgeInsets.all(10), child: Row(mainAxisSize: MainAxisSize.min, children: [Text("", style: AppFonts.medium(15, Colors.white)), const Spacer(), const SizedBox(width: 10)])),
            ),
            Container(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const Icon(Icons.info_outline, color: AppColors.redText, size: 100),
                  const SizedBox(height: 20),
                  Text(errorMessage, style: AppFonts.medium(17, AppColors.textBlack)),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      spacing: 20,
                      children: [
                        Expanded(
                          child: CustomAnimatedButton(
                            onPressed: () {
                              // Get.put(GlobalController());
                              // Get.until(Routes.HOME);

                              Get.until((route) => Get.currentRoute == Routes.HOME);
                              final GlobalController globalController = Get.find();
                              globalController.breadcrumbHistory.clear();
                              globalController.addRoute(Routes.HOME);
                            },
                            text: " Okay ",
                            isOutline: true,
                            enabledTextColor: AppColors.textWhite,
                            enabledColor: AppColors.backgroundPurple,
                            outLineEnabledColor: AppColors.textGrey,
                            outlineColor: AppColors.backgroundPurple,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class HasEncounterDialog extends StatelessWidget {
  final VoidCallback? onCounter;

  HasEncounterDialog({this.onCounter});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 16,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(color: AppColors.backgroundPurple, borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
              child: Padding(padding: const EdgeInsets.all(10), child: Row(mainAxisSize: MainAxisSize.min, children: [Text("Cannot Proceed with Sign and Finalize", style: AppFonts.medium(15, Colors.white)), Spacer(), SizedBox(width: 10)])),
            ),
            Container(
              child: Column(
                children: [
                  SizedBox(height: 40),
                  Icon(Icons.info_outline, color: AppColors.redText, size: 100),
                  SizedBox(height: 20),
                  Text("This action requires an encounter to be created in EMA.", textAlign: TextAlign.center, style: AppFonts.medium(17, AppColors.textBlack)),
                  SizedBox(height: 40),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Row(spacing: 20, children: [Expanded(child: CustomAnimatedButton(onPressed: onCounter, text: " Create Encounter ", isOutline: true, enabledTextColor: AppColors.textWhite, enabledColor: AppColors.backgroundPurple, outLineEnabledColor: AppColors.textGrey, outlineColor: AppColors.backgroundPurple))])),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:subqdocs/app/routes/app_pages.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/utils/app_fonts.dart';
import 'package:subqdocs/utils/imagepath.dart';
import 'package:zoom_widget/zoom_widget.dart';

import '../../../../widget/custom_animated_button.dart';

class ConfirmFinalizeDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 16,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.backgroundPurple,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Confirm",
                      style: AppFonts.medium(15, Colors.white),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: SvgPicture.asset(
                        ImagePath.logo_cross,
                        width: 20,
                        height: 20,
                        colorFilter: ColorFilter.mode(AppColors.backgroundWhite, BlendMode.srcIn),
                      ),
                    ),
                    SizedBox(width: 10)
                  ],
                ),
              ),
            ),
            Container(
                child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                SvgPicture.asset(
                  ImagePath.confirm_check,
                  width: 100,
                  height: 100,
                ),
                SizedBox(height: 20),
                Text(
                  "Are you sure you want to finalize?",
                  style: AppFonts.medium(17, AppColors.textBlack),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    spacing: 20,
                    children: [
                      Expanded(
                        child: CustomAnimatedButton(
                          text: " Cancel ",
                          isOutline: true,
                          enabledTextColor: AppColors.backgroundPurple,
                          enabledColor: AppColors.white,
                          outLineEnabledColor: AppColors.textGrey,
                          outlineColor: AppColors.backgroundPurple,
                        ),
                      ),
                      Expanded(
                        child: CustomAnimatedButton(
                          onPressed: () {
                            Get.toNamed(Routes.PATIENT_VIEW_READ_ONLY);
                          },
                          text: " Finalize ",
                          isOutline: true,
                          enabledTextColor: AppColors.textWhite,
                          enabledColor: AppColors.backgroundPurple,
                          outLineEnabledColor: AppColors.textGrey,
                          outlineColor: AppColors.backgroundPurple,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}

class PrompErrorDialog extends StatelessWidget {
  final String errorMessage;

  PrompErrorDialog(this.errorMessage);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 16,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.backgroundPurple,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "",
                      style: AppFonts.medium(15, Colors.white),
                    ),
                    Spacer(),
                    // GestureDetector(
                    //   onTap: () {
                    //     Get.back();
                    //   },
                    //   child: Icon(Icons.info_outline, color: AppColors.redText, size: 20),
                    // ),
                    SizedBox(width: 10)
                  ],
                ),
              ),
            ),
            Container(
                child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Icon(
                  Icons.info_outline,
                  color: AppColors.redText,
                  size: 100,
                ),
                // SvgPicture.asset(
                //   ImagePath.confirm_check,
                //   width: 100,
                //   height: 100,
                // ),
                SizedBox(height: 20),
                Text(
                  errorMessage,
                  style: AppFonts.medium(17, AppColors.textBlack),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    spacing: 20,
                    children: [
                      // xpanded(
                      //   child: CustomAnimatedButton(
                      //     text: " Cancel ",
                      //     isOutline: true,
                      //     enabledTextColor: AppColors.backgroundPurple,
                      //     enabledColor: AppColors.white,
                      //     outLineEnabledColor: AppColors.textGrey,
                      //     outlineColor: AppColors.backgroundPurple,
                      //   ),
                      // ),
                      Expanded(
                        child: CustomAnimatedButton(
                          onPressed: () {
                            Get.offAllNamed(Routes.HOME);
                            // Get.toNamed(Routes.PATIENT_VIEW_READ_ONLY);
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
                )
              ],
            )),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}

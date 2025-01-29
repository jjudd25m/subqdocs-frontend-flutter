import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/utils/app_fonts.dart';
import 'package:subqdocs/utils/imagepath.dart';
import 'package:zoom_widget/zoom_widget.dart';

import '../../../../widget/custom_animated_button.dart';

class DeleteImageDialog extends StatelessWidget {
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
                      "Delete Image",
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
                  ImagePath.delete_popup,
                  width: 100,
                  height: 100,
                ),
                SizedBox(height: 20),
                Text(
                  "Are you sure you want to Delete this image?",
                  style: AppFonts.medium(17, AppColors.textBlack),
                ),
                SizedBox(height: 20),
                Text(
                  "Right Cheek - 01/23/2025",
                  style: AppFonts.medium(15, AppColors.textGrey),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      SizedBox(
                          width: 150,
                          height: 40,
                          child: CustomAnimatedButton(
                            text: " Retake Image ",
                            isOutline: true,
                            enabledTextColor: AppColors.backgroundPurple,
                            enabledColor: AppColors.white,
                            outLineEnabledColor: AppColors.textGrey,
                            outlineColor: AppColors.backgroundPurple,
                          )),
                      Spacer(),
                      SizedBox(
                          width: 90,
                          height: 40,
                          child: CustomAnimatedButton(
                            text: "Cancel",
                            isOutline: true,
                            enabledTextColor: AppColors.backgroundPurple,
                            enabledColor: AppColors.white,
                            outLineEnabledColor: AppColors.textGrey,
                            outlineColor: AppColors.backgroundPurple,
                          )),
                      SizedBox(width: 10),
                      SizedBox(
                          width: 90,
                          height: 40,
                          child: CustomAnimatedButton(
                            text: " Delete ",
                            isOutline: true,
                            enabledTextColor: AppColors.textWhite,
                            enabledColor: AppColors.buttonBackgroundred,
                            outLineEnabledColor: AppColors.textGrey,
                            outlineColor: AppColors.buttonBackgroundred,
                          ))
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

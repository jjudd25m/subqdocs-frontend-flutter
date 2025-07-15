import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/utils/app_fonts.dart';
import 'package:subqdocs/utils/imagepath.dart';

import '../../../../widget/custom_animated_button.dart';

class DeleteImageDialog extends StatelessWidget {
  final VoidCallback? onDelete;
  String? extension;

  DeleteImageDialog({super.key, required this.onDelete, this.extension});

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
                    Text("Delete Image", style: AppFonts.medium(15, Colors.white)),
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
            Column(
              children: [
                const SizedBox(height: 40),
                SvgPicture.asset(ImagePath.delete_popup, width: 70, height: 70),
                const SizedBox(height: 20),
                SizedBox(width: 280, child: Text(textAlign: TextAlign.center, "Are you sure you want to Delete this $extension?", style: AppFonts.medium(17, AppColors.textBlack))),
                const SizedBox(height: 20),
                Text("", style: AppFonts.medium(15, AppColors.textGrey)),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 90,
                        height: 40,
                        child: CustomAnimatedButton(
                          onPressed: () {
                            navigator?.pop();
                          },
                          text: "Cancel",
                          isOutline: true,
                          enabledTextColor: AppColors.backgroundPurple,
                          enabledColor: AppColors.white,
                          outLineEnabledColor: AppColors.textGrey,
                          outlineColor: AppColors.backgroundPurple,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(width: 90, height: 40, child: CustomAnimatedButton(onPressed: onDelete, text: " Delete ", isOutline: true, enabledTextColor: AppColors.textWhite, enabledColor: AppColors.buttonBackgroundred, outLineEnabledColor: AppColors.textGrey, outlineColor: AppColors.buttonBackgroundred)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class LogoutDialog extends StatelessWidget {
  String header;
  String? title;
  final VoidCallback? onDelete;

  LogoutDialog({super.key, required this.header, required this.onDelete, required this.title});

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
                    Text(header, style: AppFonts.medium(15, Colors.white)),
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
            Column(
              children: [
                const SizedBox(height: 40),
                SvgPicture.asset(ImagePath.delete_popup, width: 70, height: 70),
                const SizedBox(height: 20),
                SizedBox(width: 280, child: Text(textAlign: TextAlign.center, title ?? "", style: AppFonts.medium(17, AppColors.textBlack))),
                const SizedBox(height: 20),
                Text("", style: AppFonts.medium(15, AppColors.textGrey)),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 90,
                        height: 40,
                        child: CustomAnimatedButton(
                          onPressed: () {
                            navigator?.pop();
                          },
                          text: "Cancel",
                          isOutline: true,
                          enabledTextColor: AppColors.backgroundPurple,
                          enabledColor: AppColors.white,
                          outLineEnabledColor: AppColors.textGrey,
                          outlineColor: AppColors.backgroundPurple,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(width: 90, height: 40, child: CustomAnimatedButton(onPressed: onDelete, text: " Logout ", isOutline: true, enabledTextColor: AppColors.textWhite, enabledColor: AppColors.buttonBackgroundred, outLineEnabledColor: AppColors.textGrey, outlineColor: AppColors.buttonBackgroundred)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class DeletePatientDialog extends StatelessWidget {
  String header;
  String? title;
  final VoidCallback? onDelete;
  bool isLoading;

  DeletePatientDialog({super.key, required this.header, required this.onDelete, required this.title, this.isLoading = false});

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
                    Text(header, style: AppFonts.medium(15, Colors.white)),
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
            Column(
              children: [
                const SizedBox(height: 40),
                SvgPicture.asset(ImagePath.delete_popup, width: 70, height: 70),
                const SizedBox(height: 20),
                SizedBox(width: 280, child: Text(textAlign: TextAlign.center, title ?? "", style: AppFonts.medium(17, AppColors.textBlack))),
                const SizedBox(height: 20),
                Text("", style: AppFonts.medium(15, AppColors.textGrey)),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 90,
                        height: 40,
                        child: CustomAnimatedButton(
                          onPressed: () {
                            navigator?.pop();
                          },
                          text: "Cancel",
                          isOutline: true,
                          enabledTextColor: AppColors.backgroundPurple,
                          enabledColor: AppColors.white,
                          outLineEnabledColor: AppColors.textGrey,
                          outlineColor: AppColors.backgroundPurple,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(width: 90, height: 40, child: CustomAnimatedButton(isLoading: isLoading, onPressed: onDelete, text: " Delete ", isOutline: true, enabledTextColor: AppColors.textWhite, enabledColor: AppColors.buttonBackgroundred, outLineEnabledColor: AppColors.textGrey, outlineColor: AppColors.buttonBackgroundred)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class ConfirmModel extends StatelessWidget {
  String header;
  String? title;
  final VoidCallback? onOk;

  ConfirmModel({super.key, required this.header, required this.onOk, required this.title});

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
                    Text(header, style: AppFonts.medium(15, Colors.white)),
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
            Column(
              children: [
                const SizedBox(height: 40),
                SvgPicture.asset(ImagePath.delete_popup, width: 70, height: 70),
                const SizedBox(height: 20),
                SizedBox(width: 280, child: Text(textAlign: TextAlign.center, title ?? "", style: AppFonts.medium(17, AppColors.textBlack))),
                const SizedBox(height: 20),
                Text("", style: AppFonts.medium(15, AppColors.textGrey)),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 90,
                        height: 40,
                        child: CustomAnimatedButton(
                          onPressed: () {
                            navigator?.pop();
                          },
                          text: "Cancel",
                          isOutline: true,
                          enabledTextColor: AppColors.backgroundPurple,
                          enabledColor: AppColors.white,
                          outLineEnabledColor: AppColors.textGrey,
                          outlineColor: AppColors.backgroundPurple,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(width: 90, height: 40, child: CustomAnimatedButton(onPressed: onOk, text: "Ok", isOutline: true, enabledTextColor: AppColors.textWhite, enabledColor: AppColors.buttonBackgroundred, outLineEnabledColor: AppColors.textGrey, outlineColor: AppColors.buttonBackgroundred)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

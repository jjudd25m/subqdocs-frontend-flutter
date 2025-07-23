import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:subqdocs/app/modules/personal_setting/controllers/personal_setting_controller.dart';
import 'package:subqdocs/widget/base_image_view.dart';

import '../app/core/common/global_controller.dart';
import '../app/core/common/global_mobile_controller.dart';
import '../app/core/common/logger.dart';
import '../app/routes/app_pages.dart';
import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';
import '../utils/imagepath.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({super.key, required this.drawerkey, this.leadingImage, this.titleText, this.backgroundColor, this.titleWidget, this.titleAlign = TextAlign.center, this.onTapBack, this.leadingWidget, this.actions = const [], this.actionRightPadding = 20, this.leadingWidth, this.elevation = 0, this.centerTitle = false});

  final GlobalKey<ScaffoldState> drawerkey;
  final String? leadingImage;
  final String? titleText;
  final TextAlign? titleAlign;
  final VoidCallback? onTapBack;
  final List<Widget> actions;
  final Widget? titleWidget;
  final Widget? leadingWidget;
  final double? actionRightPadding;
  final Color? backgroundColor;
  final double? leadingWidth;
  final double? elevation;
  final bool? centerTitle;

  final GlobalController globalController = Get.find();

  @override
  Widget build(BuildContext context) {
    print("CustomAppBar called ");
    return Container(
      height: 64,
      decoration: const BoxDecoration(color: AppColors.backgroundWhite),
      child: Row(
        children: [
          // Drawer icon
          InkWell(onTap: () => drawerkey.currentState!.openDrawer(), child: Container(color: AppColors.white, padding: const EdgeInsets.only(left: 16.0, top: 17.0, bottom: 17.0, right: 12), child: SvgPicture.asset(ImagePath.drawer, height: 17, width: 23))),

          // Logo
          GestureDetector(
            onTap: () {
              if (Get.currentRoute == Routes.HOME) {
                customPrint("It's home screen");
              } else {
                final GlobalController globalController = Get.find();
                Get.until((route) => Get.currentRoute == Routes.HOME);
                globalController.breadcrumbHistory.clear();
                Get.toNamed(Routes.HOME, arguments: {"tabIndex": globalController.tabIndex.value});
              }
            },
            child: Container(margin: const EdgeInsets.only(right: 16), child: SvgPicture.asset(ImagePath.subqdocs_app_bar_logo)),
          ),

          // Spacer to push profile section to the right
          Expanded(child: Container()),

          // Profile section
          Obx(() {
            final user = globalController.getUserDetailModel.value?.responseData;
            final firstName = user?.firstName ?? "";
            final lastName = user?.lastName ?? "";
            final fullName = "$firstName $lastName".trim();
            final degree = user?.title ?? "";

            customPrint("side menu ${user?.toJson()}");

            return Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.4, // Limit maximum width
              ),
              child: GestureDetector(
                onTap: () async {
                  if (Get.currentRoute != Routes.PERSONAL_SETTING) {
                    // Get.offNamedUntil(Routes.HOME, (route) => false);
                    Get.until((route) => Get.currentRoute == Routes.HOME);

                    globalController.breadcrumbHistory.clear();

                    await Future.delayed(const Duration(milliseconds: 100));

                    PersonalSettingController personalSettingController = Get.put(PersonalSettingController());
                    personalSettingController.onInit();

                    globalController.addRoute(Routes.HOME);
                    globalController.addRoute(Routes.PERSONAL_SETTING);
                    Get.toNamed(Routes.PERSONAL_SETTING);
                  }
                  // globalKey.currentState!.closeDrawer();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Profile image
                    ClipRRect(borderRadius: BorderRadius.circular(20), child: user?.id == -1 ? Image.asset(fit: BoxFit.cover, ImagePath.user, height: 40, width: 40) : BaseImageView(imageUrl: user?.profileImage ?? "", width: 40, height: 40, nameLetters: fullName)),
                    const SizedBox(width: 8),

                    // Name and degree
                    Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text(fullName, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppFonts.medium(14, AppColors.textBlack)), if (degree.isNotEmpty) Text(degree, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppFonts.regular(12, AppColors.textGrey))],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          // Right padding
          SizedBox(width: actionRightPadding ?? 20),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomMobileAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomMobileAppBar({super.key, required this.drawerKey, this.leadingImage, this.titleText, this.backgroundColor, this.titleWidget, this.titleAlign = TextAlign.center, this.onTapBack, this.leadingWidget, this.actions = const [], this.actionRightPadding = 20, this.leadingWidth, this.elevation = 0, this.centerTitle = true});

  final GlobalKey<ScaffoldState> drawerKey;
  final String? leadingImage;
  final String? titleText;
  final TextAlign? titleAlign;
  final VoidCallback? onTapBack;
  final List<Widget> actions;
  final Widget? titleWidget;
  final Widget? leadingWidget;
  final double? actionRightPadding;
  final Color? backgroundColor;
  final double? leadingWidth;
  final double? elevation;
  final bool? centerTitle;

  final GlobalMobileController globalController = Get.find();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? AppColors.backgroundMobileAppbar,
      elevation: elevation,
      centerTitle: centerTitle ?? true,
      automaticallyImplyLeading: false,
      // Add these properties to prevent color change on scroll
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      // This prevents elevation change on scroll
      title: titleWidget ?? (titleText != null ? Text(titleText!, textAlign: titleAlign) : null),
      leading: leadingWidget ?? Padding(padding: const EdgeInsets.only(left: 16), child: IconButton(icon: SvgPicture.asset(ImagePath.drawer, height: 20, width: 20), onPressed: () => drawerKey.currentState!.openDrawer())),
      leadingWidth: leadingWidth,
      actions:
          actions.isNotEmpty
              ? [Padding(padding: EdgeInsets.only(right: actionRightPadding ?? 20), child: Row(children: actions))]
              : [
                Padding(
                  padding: EdgeInsets.only(right: actionRightPadding ?? 20),
                  child: Obx(() {
                    final user = globalController.getUserDetailModel.value?.responseData;
                    final firstName = user?.firstName ?? "";
                    final lastName = user?.lastName ?? "";
                    final fullName = "$firstName $lastName".trim();
                    return GestureDetector(onTap: () async {}, child: ClipRRect(borderRadius: BorderRadius.circular(20), child: BaseImageView(imageUrl: user?.profileImage ?? "", width: 35, height: 35, nameLetters: fullName)));
                  }),
                ),
              ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

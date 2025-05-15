import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:subqdocs/widget/base_image_view.dart';

import '../app/core/common/global_controller.dart';
import '../app/routes/app_pages.dart';
import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';
import '../utils/imagepath.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({
    super.key,
    required this.drawerkey,
    this.leadingImage,
    this.titleText,
    this.backgroundColor,
    this.titleWidget,
    this.titleAlign = TextAlign.center,
    this.onTapBack,
    this.leadingWidget,
    this.actions = const [],
    this.actionRightPadding = 20,
    this.leadingWidth,
    this.elevation = 0,
    this.centerTitle = false,
  });

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

  // var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));
  final GlobalController globalController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,

      decoration: BoxDecoration(color: AppColors.backgroundWhite),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              drawerkey.currentState!.openDrawer();
            },
            child: Container(color: AppColors.white, padding: const EdgeInsets.only(left: 16.0, top: 17.0, bottom: 17.0, right: 12), child: SvgPicture.asset(ImagePath.drawer, height: 17, width: 23)),
          ),
          SizedBox(width: 0),
          GestureDetector(
            onTap: () {
              if (Get.currentRoute == Routes.HOME) {
                print("It's home screen");
              } else {
                print("current route is :- ${Get.currentRoute}");
                // Get.offAllNamed(Routes.HOME);

                final GlobalController globalController = Get.find();

                Get.until((route) => Get.currentRoute == Routes.HOME);
                globalController.breadcrumbHistory.clear();

                Get.toNamed(Routes.HOME, arguments: {"tabIndex": globalController.tabIndex.value});
              }
            },
            child: Container(child: SvgPicture.asset(ImagePath.subqdocs_app_bar_logo)),
          ),
          Spacer(),
          Obx(() {
            return SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Row(
                children: [
                  Spacer(),
                  Spacer(),
                  Spacer(),
                  globalController.getUserDetailModel.value?.responseData?.id == -1
                      ? ClipRRect(borderRadius: BorderRadius.circular(20), child: Image.asset(fit: BoxFit.cover, ImagePath.user, height: 40, width: 40))
                      : ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BaseImageView(
                          imageUrl: globalController.getUserDetailModel.value?.responseData?.profileImage ?? "",
                          width: 40,
                          height: 40,
                          nameLetters: "${globalController.getUserDetailModel.value?.responseData?.firstName ?? ""} ${globalController.getUserDetailModel.value?.responseData?.lastName ?? ""}",
                        ),
                      ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          textAlign: TextAlign.left,
                          // maxLines: 1,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          // overflow: TextOverflow.ellipsis,
                          "${globalController.getUserDetailModel.value?.responseData?.firstName ?? ""} ${globalController.getUserDetailModel.value?.responseData?.lastName ?? ""}",
                          style: AppFonts.medium(14, AppColors.textBlack),
                        ),

                        Text(textAlign: TextAlign.center, globalController.getUserDetailModel.value?.responseData?.degree ?? "", style: AppFonts.regular(12, AppColors.textGrey)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),

          SizedBox(width: 24),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:subqdocs/widget/base_image_view.dart';

import '../app/core/common/app_preferences.dart';
import '../app/core/common/global_controller.dart';
import '../app/modules/login/model/login_model.dart';
import '../app/routes/app_pages.dart';
import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';
import '../utils/app_string.dart';
import '../utils/imagepath.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar(
      {super.key,
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
      this.centerTitle = false});

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

  var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundWhite,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    drawerkey.currentState!.openDrawer();
                  },
                  child: Container(
                    color: AppColors.white,
                    padding: const EdgeInsets.only(left: 15.0, top: 20.0, bottom: 20.0, right: 30.0),
                    child: SvgPicture.asset(
                      ImagePath.drawer,
                      height: 25,
                      width: 25,
                    ),
                  ),
                ),
                SizedBox(
                  width: 0,
                ),
                GestureDetector(
                  onTap: () {
                    if (Get.currentRoute == Routes.HOME) {
                      print("It's home screen");
                    } else {
                      print("current route is :- ${Get.currentRoute}");
                      // Get.offAllNamed(Routes.HOME);

                      final GlobalController globalController = Get.find();

                      Get.toNamed(Routes.HOME, arguments: {
                        "tabIndex": globalController.homeTabIndex.value,
                      });

                    }
                  },
                  child: Image.asset(
                    ImagePath.subqdocs_text_logo,
                    width: 180,
                    height: 55,
                  ),
                ),
                Spacer(),
                Row(
                  children: [
                    loginData.responseData?.user?.id == 49
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(25.0),
                            child: Image.asset(
                              fit: BoxFit.cover,
                              ImagePath.user,
                              height: 50,
                              width: 50,
                            ),
                          )
                        : BaseImageView(
                            imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ4YreOWfDX3kK-QLAbAL4ufCPc84ol2MA8Xg&s",
                            width: 50,
                            height: 50,
                          ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          textAlign: TextAlign.center,
                          "${loginData.responseData?.user?.firstName} ${loginData.responseData?.user?.lastName}",
                          style: AppFonts.medium(15, AppColors.textBlack),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          textAlign: TextAlign.center,
                          "DO, FAAD",
                          style: AppFonts.regular(13, AppColors.textGrey),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(width: 20),
                // GestureDetector(
                //   onTap: () async {
                //     await AppPreference.instance.removeKey(AppString.prefKeyUserLoginData);
                //     await AppPreference.instance.removeKey(AppString.prefKeyToken);
                //     Get.offAllNamed(Routes.LOGIN);
                //   },
                //   child: SvgPicture.asset(
                //     ImagePath.logo_signout,
                //     height: 30,
                //     width: 30,
                //   ),
                // ),
              ],
            ),
          ),
          SizedBox(height: 5),
          Container(width: double.infinity, height: 1, color: AppColors.buttonBackgroundGrey)
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

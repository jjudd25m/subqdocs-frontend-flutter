import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:subqdocs/widget/base_image_view.dart';

import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';
import '../utils/imagepath.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar(
      {super.key,
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundWhite,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  ImagePath.drawer,
                  height: 20,
                  width: 20,
                ),
                SizedBox(
                  width: 10,
                ),
                Image.asset(
                  ImagePath.subqdocs_text_logo,
                  width: 200,
                  height: 50,
                ),
                Spacer(),
                Row(
                  children: [
                    BaseImageView(
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
                          "Adrian Tinajero",
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
                SvgPicture.asset(
                  ImagePath.logo_signout,
                  height: 30,
                  width: 30,
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          Container(width: double.infinity, height: 1, color: AppColors.buttonBackgroundGrey)
        ],
      ),
    );

    AppBar(
      surfaceTintColor: AppColors.textWhite,
      backgroundColor: backgroundColor ?? AppColors.textWhite,
      scrolledUnderElevation: elevation, // This will fix the problem
      elevation: elevation,
      leadingWidth: leadingWidth,
      leading: Container(
        margin: const EdgeInsets.only(left: 10, right: 20),
        child: leadingWidget ??
            InkWell(
              onTap: () {
                // leadingImage == null ? Navigator.of(context).pop() : onTapBack?.call();
              },
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: SvgPicture.asset(
                leadingImage ?? ImagePath.drawer,
                height: 44,
                width: 44,
              ),
            ),
      ),
      actions: [...actions, SizedBox(width: actionRightPadding)],
      centerTitle: centerTitle,
      title: (titleText ?? "").isNotEmpty
          ? Text(
              titleText!,
              textAlign: titleAlign,
              style: AppFonts.bold(18, AppColors.textBlack),
            )
          : titleWidget ?? Container(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

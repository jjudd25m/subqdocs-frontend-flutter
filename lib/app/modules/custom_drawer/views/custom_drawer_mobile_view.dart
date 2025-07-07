import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:subqdocs/app/core/common/global_mobile_controller.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/app_string.dart';
import '../../../../utils/imagepath.dart';
import '../../../../widget/base_image_view.dart';
import '../../../../widgets/drawer_item.dart';
import '../../../core/common/app_preferences.dart';
import '../../../routes/app_pages.dart';
import '../../visit_main/views/delete_image_dialog.dart';
import '../controllers/custom_drawer_mobile_controller.dart';

class CustomDrawerMobileView extends GetView<CustomDrawerMobileController> {
  final Function(int index)? onItemSelected;

  const CustomDrawerMobileView({super.key, this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.setSelectedIndexByTheScreen();
    });

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.80,
      backgroundColor: Colors.white,
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 0, right: 0),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top),
                  Row(
                    children: [
                      const SizedBox(width: 20),
                      SvgPicture.asset(ImagePath.subqdocs_app_bar_logo, width: MediaQuery.of(context).size.width * 0.40),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(color: AppColors.white, padding: const EdgeInsets.all(15), child: SvgPicture.asset(ImagePath.black_left_arrow, height: 35, width: 35)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Obx(() {
                    return Row(
                      children: [
                        const SizedBox(width: 20),
                        controller.globalController.getUserDetailModel.value?.responseData?.id == -1
                            ? ClipRRect(borderRadius: BorderRadius.circular(20.0), child: Image.asset(fit: BoxFit.cover, ImagePath.user, height: 40, width: 40))
                            : GestureDetector(
                              onTap: () async {},
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30.0),
                                child: BaseImageView(imageUrl: controller.globalController.getUserDetailModel.value?.responseData?.profileImage ?? "", width: 60, height: 60, nameLetters: "${controller.globalController.getUserDetailModel.value?.responseData?.firstName?.trim() ?? ""} ${controller.globalController.getUserDetailModel.value?.responseData?.lastName?.trim() ?? ""}"),
                              ),
                            ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                // maxLines: 2,
                                "${controller.globalController.getUserDetailModel.value?.responseData?.firstName ?? ""} ${controller.globalController.getUserDetailModel.value?.responseData?.lastName ?? ""}",
                                style: AppFonts.medium(16, AppColors.backgroundPurple),
                              ),
                              const SizedBox(height: 4),
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Text(
                                  controller.globalController.getUserDetailModel.value?.responseData?.email ?? "",
                                  // Dummy email
                                  style: AppFonts.medium(12, AppColors.textDarkGrey),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Spacer(),
                      ],
                    );
                  }),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Divider(thickness: 1, height: 1, color: AppColors.imageBannerGrayBorder)),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "General", // Dummy string
                style: AppFonts.regular(14, AppColors.textGrey),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Obx(() {
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () async {
                                controller.changeSelected(index);
                                await onItemSelected!(index);
                              },
                              child: DrawerMobileItem(
                                isSelected: controller.drawerItemModelList[index].isSelected ?? false,
                                itemName: controller.drawerItemModelList[index].drawerItemTitle ?? "",
                                iconPath: controller.drawerItemModelList[index].drawerIconPath ?? "", // Add any dummy icon path here
                              ),
                            );
                          },
                          itemCount: controller.drawerItemModelList.length,
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 34),
            // const Divider(thickness: 1, height: 1, color: AppColors.appbarBorder),
            const SizedBox(height: 18.5),
            GestureDetector(
              onTap: () async {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  // Allows dismissing the dialog by tapping outside
                  builder: (BuildContext context) {
                    return LogoutDialog(
                      title: "Are you sure want to logout?",
                      onDelete: () async {
                        await AppPreference.instance.removeKey(AppString.prefKeyUserLoginData);
                        await AppPreference.instance.removeKey(AppString.prefKeyToken);

                        Get.delete<GlobalMobileController>();
                        Get.offAllNamed(Routes.LOGIN_VIEW_MOBILE);
                      },
                      header: "Alert!",
                    ); // Our custom dialog
                  },
                );
              },
              child: Row(
                children: [
                  const SizedBox(width: 35),
                  const Icon(Icons.logout, color: AppColors.textPurple),
                  // Dummy logout icon
                  const SizedBox(width: 10.5),
                  Text(
                    "Logout", // Dummy string
                    style: AppFonts.medium(16, AppColors.textPurple),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text('Version: ${controller.version} (${controller.buildNumber})', style: AppFonts.medium(12, AppColors.textDarkGrey))]),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}

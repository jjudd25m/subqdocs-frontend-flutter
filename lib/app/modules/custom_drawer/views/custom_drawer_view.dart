import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../../../../widget/base_image_view.dart';
import '../../../../widgets/drawer_item.dart';
import '../../../core/common/logger.dart';
import '../../../routes/app_pages.dart';
import '../../personal_setting/controllers/personal_setting_controller.dart';
import '../controllers/custom_drawer_controller.dart';

class CustomDrawerView extends GetView<CustomDrawerController> {
  final Function(int index)? onItemSelected;

  const CustomDrawerView({super.key, this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.setSelectedIndexByTheScreen();
    });

    customPrint("hello is the model called its the time");
    return Drawer(
      width: 321,
      backgroundColor: Colors.white,
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 0, right: 0),
              // padding: EdgeInsets.only(left: 19, right: 19),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Obx(() {
                    return InkWell(
                      onTap: () async {
                        if (Get.currentRoute != Routes.PERSONAL_SETTING) {
                          // Get.offNamedUntil(Routes.HOME, (route) => false);
                          Get.back();
                          Get.until((route) => Get.currentRoute == Routes.HOME);



                          await Future.delayed(const Duration(milliseconds: 100));

                          PersonalSettingController personalSettingController = Get.put(PersonalSettingController());
                          personalSettingController.onInit();
                          controller.globalController.breadcrumbHistory.clear();
                          // controller.globalController.addRoute(Routes.HOME);
                          controller.globalController.addRoute(Routes.PERSONAL_SETTING);
                          Get.toNamed(Routes.PERSONAL_SETTING);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          children: [
                            const SizedBox(width: 20),
                            controller.globalController.getUserDetailModel.value?.responseData?.id == -1
                                ? ClipRRect(borderRadius: BorderRadius.circular(20.0), child: Image.asset(fit: BoxFit.cover, ImagePath.user, height: 40, width: 40))
                                : ClipRRect(
                                  borderRadius: BorderRadius.circular(25.0),
                                  child: BaseImageView(
                                    imageUrl: controller.globalController.getUserDetailModel.value?.responseData?.profileImage ?? "",
                                    width: 40,
                                    height: 40,
                                    nameLetters: "${controller.globalController.getUserDetailModel.value?.responseData?.firstName?.trim() ?? ""} ${controller.globalController.getUserDetailModel.value?.responseData?.lastName?.trim() ?? ""}",
                                  ),
                                ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    // maxLines: 2,
                                    "${controller.globalController.getUserDetailModel.value?.responseData?.firstName ?? ""} ${controller.globalController.getUserDetailModel.value?.responseData?.lastName ?? ""}",
                                    style: AppFonts.medium(14, AppColors.textBlackDark),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    controller.globalController.getUserDetailModel.value?.responseData?.title ?? "",
                                    // Dummy email
                                    style: AppFonts.medium(12, AppColors.textDarkGrey),
                                  ),
                                ],
                              ),
                            ),
                            // Spacer(),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(color: AppColors.white, padding: const EdgeInsets.all(15), child: SvgPicture.asset(ImagePath.crossWithContainer, height: 30, width: 30)),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const Divider(thickness: 1, height: 1, color: AppColors.appbarBorder),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 19, right: 19),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Obx(() {
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return const SizedBox.shrink();
                            }

                            return InkWell(
                              onTap: () async {
                                controller.changeSelected(index);
                                await onItemSelected!(index);
                              },
                              child: DrawerItem(
                                isSelected: controller.drawerItemModelList.value[index].isSelected ?? false,
                                itemName: controller.drawerItemModelList.value[index].drawerItemTitle ?? "",
                                iconPath: controller.drawerItemModelList.value[index].drawerIconPath ?? "", // Add any dummy icon path here
                              ),
                            );
                          },
                          itemCount: controller.drawerItemModelList.value.length,
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 34),
            const SizedBox(height: 18.5),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Version: ${controller.version} (${controller.buildNumber})',
                  // Dummy email
                  style: AppFonts.medium(12, AppColors.textDarkGrey),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

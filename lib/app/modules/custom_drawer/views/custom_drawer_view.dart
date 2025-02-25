import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/app_string.dart';
import '../../../../utils/imagepath.dart';
import '../../../../widgets/drawer_item.dart';
import '../../../../widgets/rounded_image_widget.dart';
import '../../../core/common/app_preferences.dart';
import '../../../routes/app_pages.dart';
import '../../login/model/login_model.dart';
import '../controllers/custom_drawer_controller.dart';

class CustomDrawerView extends GetView<CustomDrawerController> {
  final Function(int index)? onItemSelected;

  var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

  CustomDrawerView({Key? key, this.onItemSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.only(
      //         topLeft: Radius.circular(0),
      //         topRight: Radius.circular(50),
      //         bottomLeft: Radius.circular(0),
      //         bottomRight: Radius.circular(50))),
      width: 321,
      backgroundColor: Colors.white,
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 19, right: 19),
              child: Column(
                children: [
                  SizedBox(
                    height: 45,
                  ),
                  Row(
                    children: [
                      RoundedImageWidget(
                        size: 40,
                        imagePath: ImagePath.user,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${loginData.responseData?.user?.firstName} ${loginData.responseData?.user?.lastName}",
                            style: AppFonts.medium(14, AppColors.textBlackDark),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            "DO, FAAD", // Dummy email
                            style: AppFonts.medium(12, AppColors.textDarkGrey),
                          ),
                        ],
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset(
                          ImagePath.crossWithContainer,
                          height: 24,
                          width: 24,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1,
              height: 1,
              color: AppColors.appbarBorder,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(left: 19, right: 19),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      Obx(
                        () {
                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return InkWell(
                                  onTap: () async {
                                    await onItemSelected!(index);
                                    // if (index == 0) {
                                    //   Get.toNamed(Routes.HOME, arguments: {
                                    //     "tabIndex": 0,
                                    //   });
                                    // } else if (index == 1) {
                                    //   Get.toNamed(Routes.HOME, arguments: {
                                    //     "tabIndex": 1,
                                    //   });
                                    // } else if (index == 2) {
                                    //   Get.toNamed(Routes.HOME, arguments: {
                                    //     "tabIndex": 2,
                                    //   });
                                    // } else if (index == 3) {
                                    // } else if (index == 4) {
                                    //   // Get.toNamed(Routes.VISIT_MAIN);
                                    // }

                                    controller.changeSelected(index);
                                  },
                                  child: DrawerItem(
                                    isSelected: controller.drawerItemModelList.value[index].isSelected ?? false,
                                    itemName: controller.drawerItemModelList.value[index].drawerItemTitle ?? "",
                                    iconPath: controller.drawerItemModelList.value[index].drawerIconPath ?? "", // Add any dummy icon path here
                                  ));
                            },
                            itemCount: controller.drawerItemModelList.value.length,
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 34,
            ),
            Divider(
              thickness: 1,
              height: 1,
              color: AppColors.appbarBorder,
            ),
            SizedBox(
              height: 18.5,
            ),
            GestureDetector(
              onTap: () async {
                await AppPreference.instance.removeKey(AppString.prefKeyUserLoginData);
                await AppPreference.instance.removeKey(AppString.prefKeyToken);
                Get.offAllNamed(Routes.LOGIN);
              },
              child: Row(
                children: [
                  SizedBox(
                    width: 35,
                  ),
                  Icon(
                    Icons.logout,
                    color: AppColors.textDarkGrey,
                  ), // Dummy logout icon
                  SizedBox(
                    width: 10.5,
                  ),
                  Text(
                    "Logout", // Dummy string
                    style: AppFonts.medium(16, AppColors.textDarkGrey),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}

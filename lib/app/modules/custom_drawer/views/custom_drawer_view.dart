import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/app_string.dart';
import '../../../../utils/imagepath.dart';
import '../../../../widget/base_image_view.dart';
import '../../../../widgets/drawer_item.dart';
import '../../../../widgets/rounded_image_widget.dart';
import '../../../core/common/app_preferences.dart';
import '../../../core/common/global_controller.dart';
import '../../../routes/app_pages.dart';
import '../../home/model/home_past_patient_list_sorting_model.dart';
import '../../home/model/home_patient_list_sorting_model.dart';
import '../../home/model/home_schedule_list_sorting_model.dart';
import '../../login/model/login_model.dart';
import '../controllers/custom_drawer_controller.dart';

class CustomDrawerView extends GetView<CustomDrawerController> {
  final Function(int index)? onItemSelected;

  var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

  CustomDrawerView({Key? key, this.onItemSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 321,
      backgroundColor: Colors.white,
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 0, right: 0),
              // padding: EdgeInsets.only(left: 19, right: 19),
              child: Column(
                children: [
                  SizedBox(
                    height: 45,
                  ),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      loginData.responseData?.user?.id == 49
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image.asset(
                                fit: BoxFit.cover,
                                ImagePath.user,
                                height: 40,
                                width: 40,
                              ),
                            )
                          : BaseImageView(
                              imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ4YreOWfDX3kK-QLAbAL4ufCPc84ol2MA8Xg&s",
                              width: 40,
                              height: 40,
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
                        child: Container(
                          color: AppColors.white,
                          padding: EdgeInsets.all(15),
                          child: SvgPicture.asset(
                            ImagePath.crossWithContainer,
                            height: 30,
                            width: 30,
                          ),
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
                                    controller.changeSelected(index);
                                    await onItemSelected!(index);
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

                await AppPreference.instance.removeKey("homePastPatientListSortingModel");
                await AppPreference.instance.removeKey("homePatientListSortingModel");
                await AppPreference.instance.removeKey("homeScheduleListSortingModel");

                HomePatientListSortingModel? homePatientListData = await AppPreference.instance.getHomePatientListSortingModel();
                HomeScheduleListSortingModel? homeScheduleListData = await AppPreference.instance.getHomeScheduleListSortingModel();
                HomePastPatientListSortingModel? homePastPatientData = await AppPreference.instance.getHomePastPatientListSortingModel();

                print(homePatientListData);
                print(homeScheduleListData);
                print(homePastPatientData);

                Get.delete<GlobalController>();

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

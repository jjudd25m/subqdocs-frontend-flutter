import 'dart:ui';
import 'package:awesome_side_sheet/Enums/sheet_position.dart';
import 'package:awesome_side_sheet/side_sheet.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:subqdocs/app/modules/home/views/home_past_visits_list.dart';
import 'package:subqdocs/app/modules/home/views/home_schedule_list_view.dart';
import 'package:subqdocs/app/modules/home/views/past_patient_list_filter_bottom_sheet.dart';
import 'package:subqdocs/app/modules/home/views/patient_list_filter_bottom_sheet.dart';
import 'package:subqdocs/app/modules/home/views/schedule_list_filter_bottom_sheet.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/utils/app_fonts.dart';
import 'package:subqdocs/widget/appbar.dart';
import 'package:subqdocs/widgets/ContainerButton.dart';
import 'package:subqdocs/widgets/base_screen.dart';
import 'package:subqdocs/widgets/custom_button.dart';
import '../../../../utils/imagepath.dart';
import '../../../../utils/validation_service.dart';
import '../../../../widget/bredcums.dart';
import '../../../../widgets/custom_animated_button.dart';
import '../../../../widgets/custom_textfiled.dart';
import '../../../core/common/common_service.dart';
import '../../../core/common/logger.dart';
import '../../../routes/app_pages.dart';
import '../../custom_drawer/views/custom_drawer_view.dart';
import '../controllers/home_controller.dart';
import 'home_patient_list_view.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  bool isPast = true;
  bool temp = false;

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  GlobalKey<FormState> formKeyFrom = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyTo = GlobalKey<FormState>();

  DateTimeRange? selectedDateRange;

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
        onItemSelected: (index) async {
          if (index == 0) {
            final result = await Get.toNamed(Routes.ADD_PATIENT);

            if (result == 1) {
              controller.getPastVisitList();
              controller.getScheduleVisitList();
              controller.getPatientList();
            }
            _key.currentState!.closeDrawer();
          } else if (index == 1) {
            controller.globalController.tabIndex.value = 1;
            _key.currentState!.closeDrawer();
          } else if (index == 2) {
            controller.globalController.tabIndex.value = 2;
            _key.currentState!.closeDrawer();
          } else if (index == 3) {
            controller.globalController.tabIndex.value = 0;
            _key.currentState!.closeDrawer();
          } else if (index == 4) {
            _key.currentState!.closeDrawer();
            final result = await Get.toNamed(Routes.PERSONAL_SETTING);
          }
        },
        body: Column(
          children: [
            CustomAppBar(drawerkey: _key),
            Expanded(
                child: Container(
              width: double.infinity,
              color: AppColors.ScreenBackGround,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SizedBox(
                  //   height: 5,
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 15, right: 15),
                  //   child: Container(
                  //     width: double.infinity,
                  //     decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(14),
                  //       child: Text(
                  //         "Scheduling view",
                  //         style: AppFonts.regular(17, AppColors.textBlack),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 16,
                  // ),
                  // SizedBox(
                  //   width: 20,
                  // ),
                  Obx(() {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BreadcrumbWidget(
                                breadcrumbHistory: controller.globalController.breadcrumbHistory.value,
                                onBack: (breadcrumb) {
                                  controller.globalController.popUntilRoute(breadcrumb);
                                  // Get.offAllNamed(globalController.getKeyByValue(breadcrumb));

                                  while (Get.currentRoute != controller.globalController.getKeyByValue(breadcrumb)) {
                                    Get.back(); // Pop the current screen
                                  }
                                },
                              ),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.backgroundWhite),
                                child: Obx(
                                  () {
                                    return Container(
                                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.white),
                                        height: 70,
                                        child: SingleChildScrollView(
                                          physics: BouncingScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              IntrinsicWidth(
                                                child: CustomAnimatedButton(
                                                  onPressed: () {
                                                    controller.searchController.clear();
                                                    controller.globalController.tabIndex.value = 0;

                                                    controller.clearFilter(isRefresh: false);
                                                    controller.getPatientList();
                                                  },
                                                  text: "Patient List",
                                                  isOutline: true,
                                                  paddingText: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                                  fontSize: 14,
                                                  enabledTextColor: controller.globalController.tabIndex.value == 0 ? AppColors.backgroundPurple : AppColors.textGrey,
                                                  enabledColor: controller.globalController.tabIndex.value == 0 ? AppColors.buttonPurpleLight : AppColors.clear,
                                                  outLineEnabledColor: AppColors.textGrey,
                                                  outlineColor: controller.globalController.tabIndex.value == 0 ? AppColors.backgroundPurple : AppColors.clear,
                                                ),
                                              ),
                                              IntrinsicWidth(
                                                  child: CustomAnimatedButton(
                                                onPressed: () {
                                                  controller.globalController.tabIndex.value = 1;

                                                  controller.clearFilter(isRefresh: false);
                                                  controller.getScheduleVisitList(isFist: true);
                                                },
                                                text: "Scheduled Visits",
                                                isOutline: true,
                                                paddingText: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                                fontSize: 14,
                                                enabledTextColor: controller.globalController.tabIndex.value == 1 ? AppColors.backgroundPurple : AppColors.textGrey,
                                                enabledColor: controller.globalController.tabIndex.value == 1 ? AppColors.buttonPurpleLight : AppColors.clear,
                                                outLineEnabledColor: AppColors.textGrey,
                                                outlineColor: controller.globalController.tabIndex.value == 1 ? AppColors.backgroundPurple : AppColors.clear,
                                              )),
                                              IntrinsicWidth(
                                                  child: CustomAnimatedButton(
                                                onPressed: () {
                                                  controller.globalController.tabIndex.value = 2;

                                                  // controller.scheduleSorting(cellData: "Visit Date", colIndex: 1);
                                                  controller.clearFilter(isRefresh: false);
                                                  controller.getPastVisitList(isFist: true);
                                                },
                                                text: "Past Visits",
                                                isOutline: true,
                                                paddingText: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                                fontSize: 14,
                                                enabledTextColor: controller.globalController.tabIndex.value == 2 ? AppColors.backgroundPurple : AppColors.textGrey,
                                                enabledColor: controller.globalController.tabIndex.value == 2 ? AppColors.buttonPurpleLight : AppColors.clear,
                                                outLineEnabledColor: AppColors.textGrey,
                                                outlineColor: controller.globalController.tabIndex.value == 2 ? AppColors.backgroundPurple : AppColors.clear,
                                              )),
                                            ],
                                          ),
                                        ));
                                  },
                                ),
                              ),
                              SizedBox(height: 20),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.white),
                                  child: Column(
                                    children: [
                                      Obx(
                                        () {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    controller.globalController.tabIndex.value != 1 ? "" : "",
                                                    style: AppFonts.medium(16, AppColors.black),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                if (controller.globalController.tabIndex.value != 0) ...[
                                                  GestureDetector(
                                                    onTap: () {
                                                      if (controller.globalController.tabIndex.value == 1) {
                                                        aweSideSheet(
                                                          header: SizedBox(),
                                                          footer: SizedBox(),
                                                          showActions: false,
                                                          backgroundColor: AppColors.white,
                                                          barrierDismissible: true,
                                                          showCloseButton: false,
                                                          showBackButton: true,
                                                          context: context,
                                                          body: ScheduleListFilterBottomSheet(
                                                            onTap: () {
                                                              controller.getScheduleVisitList();
                                                            },
                                                          ),
                                                          sheetPosition: SheetPosition.right,
                                                        ).then(
                                                          (value) {
                                                            controller.getScheduleVisitList();
                                                            print("value");
                                                          },
                                                        );

                                                        // showMaterialModalBottomSheet(
                                                        //   context: context,
                                                        //   builder: (context) {
                                                        //     return ScheduleListFilterBottomSheet(
                                                        //       onTap: () {
                                                        //         controller.getScheduleVisitList();
                                                        //       },
                                                        //     );
                                                        //   },
                                                        // ).then(
                                                        //   (value) {
                                                        //     controller.getScheduleVisitList();
                                                        //     print("value");
                                                        //   },
                                                        // );
                                                      } else if (controller.globalController.tabIndex.value == 2) {
                                                        aweSideSheet(
                                                          header: SizedBox(),
                                                          footer: SizedBox(),
                                                          showActions: false,
                                                          backgroundColor: AppColors.white,
                                                          barrierDismissible: true,
                                                          showCloseButton: false,
                                                          showBackButton: true,
                                                          context: context,
                                                          body: PastPatientListFilterBottomSheet(
                                                            onTap: () {
                                                              controller.getPastVisitList(isFist: true);
                                                            },
                                                          ),
                                                          sheetPosition: SheetPosition.right,
                                                        ).then(
                                                          (value) {
                                                            controller.getPastVisitList(isFist: true);
                                                            print("value");
                                                          },
                                                        );

                                                        // showMaterialModalBottomSheet(
                                                        //   context: context,
                                                        //   builder: (context) {
                                                        //     return PastPatientListFilterBottomSheet(
                                                        //       onTap: () {
                                                        //         controller.getPastVisitList(isFist: true);
                                                        //       },
                                                        //     );
                                                        //   },
                                                        // ).then(
                                                        //   (value) {
                                                        //     controller.getPastVisitList(isFist: true);
                                                        //     print("value");
                                                        //   },
                                                        // );
                                                      }
                                                    },
                                                    child: Container(
                                                      height: 40,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        border: Border.all(
                                                          color: AppColors.textDarkGrey, // Border color
                                                          width: 0.5,
                                                        ),

                                                        borderRadius: BorderRadius.circular(10), // Optional: to make the corners rounded
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(10),
                                                        child: SvgPicture.asset(
                                                          "assets/images/filter_logo.svg",
                                                          width: 40,
                                                          height: 40,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: AppColors.textGrey.withValues(alpha: 0.5)),
                                                    // color: AppColors.backgroundWhite,
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      SvgPicture.asset(
                                                        ImagePath.search,
                                                        height: 25,
                                                        width: 25,
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      SizedBox(
                                                        width: 130,
                                                        child: TextFormField(
                                                          controller: controller.searchController,
                                                          onChanged: (value) {
                                                            controller.globalController.tabIndex.value == 0
                                                                ? controller.getPatientList()
                                                                : controller.globalController.tabIndex.value == 1
                                                                    ? controller.getScheduleVisitList()
                                                                    : controller.getPastVisitList();
                                                          },
                                                          maxLines: 1, //or null

                                                          decoration: InputDecoration.collapsed(hintText: "Search", hintStyle: AppFonts.regular(14, AppColors.textGrey)).copyWith(),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  width: 140,
                                                  child: CustomButton(
                                                    hight: 40,
                                                    navigate: () async {
                                                      var result;
                                                      if (controller.globalController.tabIndex.value == 0) {
                                                        await Get.toNamed(Routes.ADD_PATIENT);
                                                        controller.getPastVisitList(isFist: true);
                                                        controller.getScheduleVisitList(isFist: true);
                                                        controller.getPatientList();
                                                      } else {
                                                        final result = await Get.toNamed(Routes.SCHEDULE_PATIENT);
                                                      }

                                                      if (result >= 0) {
                                                        controller.globalController.tabIndex.value = result;
                                                        controller.globalController.tabIndex.refresh();
                                                      }

                                                      print("----- called before Add_patient back");
                                                      controller.getPastVisitList(isFist: true);
                                                      controller.getScheduleVisitList(isFist: true);
                                                      controller.getPatientList();
                                                    },
                                                    label: controller.globalController.tabIndex.value == 0 ? "Add Patient" : "Schedule Visit",
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                      Expanded(
                                        child: controller.globalController.tabIndex.value == 0
                                            ? HomePatientListView()
                                            : controller.globalController.tabIndex.value == 1
                                                ? HomeScheduleListView()
                                                : HomePastVisitsList(),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ))
          ],
        ),
        globalKey: _key);
  }

  Future<void> _onRefresh() async {
    // Call the methods to fetch data when pull-to-refresh is triggered
    if (controller.globalController.tabIndex.value == 0) {
      await controller.getPatientList();
    } else if (controller.globalController.tabIndex.value == 1) {
      await controller.getScheduleVisitList(isFist: true);
    } else if (controller.globalController.tabIndex.value == 2) {
      await controller.getPastVisitList(isFist: true);
    }
  }
}

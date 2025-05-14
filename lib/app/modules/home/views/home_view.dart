import 'package:awesome_side_sheet/Enums/sheet_position.dart';
import 'package:awesome_side_sheet/side_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:subqdocs/app/modules/home/views/home_past_visits_list.dart';
import 'package:subqdocs/app/modules/home/views/home_schedule_list_view.dart';
import 'package:subqdocs/app/modules/home/views/past_patient_list_filter_bottom_sheet.dart';
import 'package:subqdocs/app/modules/home/views/schedule_list_filter_bottom_sheet.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/utils/app_fonts.dart';
import 'package:subqdocs/widget/appbar.dart';
import 'package:subqdocs/widgets/base_screen.dart';
import 'package:subqdocs/widgets/custom_button.dart';

import '../../../../widget/bredcums.dart';
import '../../../../widgets/custom_animated_button.dart';
import '../../../routes/app_pages.dart';
import '../../patient_info/views/home_custom_search_bar.dart';
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
                  Obx(() {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(color: Colors.transparent),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BreadcrumbWidget(
                                breadcrumbHistory: controller.globalController.breadcrumbHistory.value,
                                onBack: (breadcrumb) {
                                  controller.globalController.popUntilRoute(breadcrumb);

                                  while (Get.currentRoute != controller.globalController.getKeyByValue(breadcrumb)) {
                                    Get.back(); // Pop the current screen
                                  }
                                },
                              ),
                              SizedBox(height: 10),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.backgroundWhite),
                                child: Obx(() {
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
                                            ),
                                          ),
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
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ),
                              SizedBox(height: 20),

                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.white),
                                  child: Column(
                                    children: [
                                      Obx(() {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  controller.globalController.tabIndex.value == 0
                                                      ? "Patient List (${controller.patientListModel.value?.responseData?.totalCount ?? 0})"
                                                      : controller.globalController.tabIndex.value == 1
                                                      ? "Scheduled List (${controller.scheduleVisitListModel.value?.responseData?.totalCount ?? 0})"
                                                      : "Past Visits List (${controller.pastVisitListModel.value?.responseData?.totalCount ?? 0})",
                                                  style: AppFonts.medium(16, AppColors.black),
                                                ),
                                              ),
                                              SizedBox(width: 5),
                                              if (controller.globalController.tabIndex.value != 0) ...[
                                                if (controller.globalController.tabIndex.value == 1 && controller.scheduleVisitList.isNotEmpty) ...[
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
                                                        ).then((value) {
                                                          controller.getScheduleVisitList();
                                                          print("value");
                                                        });
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
                                                        ).then((value) {
                                                          controller.getPastVisitList(isFist: true);
                                                          print("value");
                                                        });
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
                                                      child: Padding(padding: const EdgeInsets.all(10), child: SvgPicture.asset("assets/images/filter_logo.svg", width: 40, height: 40)),
                                                    ),
                                                  ),
                                                ] else if (controller.globalController.tabIndex.value == 2 && controller.pastVisitList.isNotEmpty) ...[
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
                                                        ).then((value) {
                                                          controller.getScheduleVisitList();
                                                          print("value");
                                                        });
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
                                                        ).then((value) {
                                                          controller.getPastVisitList(isFist: true);
                                                          print("value");
                                                        });
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
                                                      child: Padding(padding: const EdgeInsets.all(10), child: SvgPicture.asset("assets/images/filter_logo.svg", width: 40, height: 40)),
                                                    ),
                                                  ),
                                                ],
                                              ],
                                              SizedBox(width: 10),
                                              if (controller.globalController.tabIndex.value == 1 && controller.scheduleVisitList.isNotEmpty) ...[
                                                SizedBox(
                                                  height: 42,
                                                  width: 180,
                                                  child: HomeCustomSearchBar(
                                                    controller: controller.searchController,
                                                    hintText: 'Search',
                                                    onChanged: (text) {
                                                      controller.globalController.tabIndex.value == 0
                                                          ? controller.getPatientList()
                                                          : controller.globalController.tabIndex.value == 1
                                                          ? controller.getScheduleVisitList()
                                                          : controller.getPastVisitList();
                                                    },
                                                    onSubmit: (text) {
                                                      print('Submitted search: $text');
                                                    },
                                                  ),
                                                ),
                                              ] else if (controller.globalController.tabIndex.value == 2 && controller.pastVisitList.isNotEmpty) ...[
                                                SizedBox(
                                                  height: 42,
                                                  width: 180,
                                                  child: HomeCustomSearchBar(
                                                    controller: controller.searchController,
                                                    hintText: 'Search',
                                                    onChanged: (text) {
                                                      controller.globalController.tabIndex.value == 0
                                                          ? controller.getPatientList()
                                                          : controller.globalController.tabIndex.value == 1
                                                          ? controller.getScheduleVisitList()
                                                          : controller.getPastVisitList();
                                                    },
                                                    onSubmit: (text) {
                                                      print('Submitted search: $text');
                                                    },
                                                  ),
                                                ),
                                              ] else if (controller.globalController.tabIndex.value == 0) ...[
                                                SizedBox(
                                                  height: 42,
                                                  width: 180,
                                                  child: HomeCustomSearchBar(
                                                    controller: controller.searchController,
                                                    hintText: 'Search',
                                                    onChanged: (text) {
                                                      controller.globalController.tabIndex.value == 0
                                                          ? controller.getPatientList()
                                                          : controller.globalController.tabIndex.value == 1
                                                          ? controller.getScheduleVisitList()
                                                          : controller.getPastVisitList();
                                                    },
                                                    onSubmit: (text) {
                                                      print('Submitted search: $text');
                                                    },
                                                  ),
                                                ),
                                              ],
                                              SizedBox(width: 10),
                                              SizedBox(width: 10),
                                              if (controller.globalController.tabIndex.value == 1 && controller.scheduleVisitList.isNotEmpty) ...[
                                                Container(
                                                  width: 140,
                                                  child: CustomButton(
                                                    hight: 40,
                                                    navigate: () async {
                                                      if (controller.globalController.tabIndex.value == 0) {
                                                        await Get.toNamed(Routes.ADD_PATIENT);
                                                        controller.patientList.clear();
                                                        controller.getPatientList(isLoading: true);
                                                        controller.getPastVisitList(isFist: true);
                                                        controller.getScheduleVisitList(isFist: true);
                                                      } else {
                                                        await Get.toNamed(Routes.SCHEDULE_PATIENT);

                                                        controller.getPatientList();
                                                        controller.getPastVisitList(isFist: true);
                                                        controller.getScheduleVisitList(isFist: true);
                                                      }
                                                    },
                                                    label: controller.globalController.tabIndex.value == 0 ? "Add Patient" : "Schedule Visit",
                                                  ),
                                                ),
                                              ] else if (controller.globalController.tabIndex.value == 2 && controller.pastVisitList.isNotEmpty) ...[
                                                Container(
                                                  width: 140,
                                                  child: CustomButton(
                                                    hight: 40,
                                                    navigate: () async {
                                                      if (controller.globalController.tabIndex.value == 0) {
                                                        await Get.toNamed(Routes.ADD_PATIENT);
                                                        controller.patientList.clear();
                                                        controller.getPatientList(isLoading: true);
                                                        controller.getPastVisitList(isFist: true);
                                                        controller.getScheduleVisitList(isFist: true);
                                                      } else {
                                                        await Get.toNamed(Routes.SCHEDULE_PATIENT);

                                                        controller.getPatientList();
                                                        controller.getPastVisitList(isFist: true);
                                                        controller.getScheduleVisitList(isFist: true);
                                                      }
                                                    },
                                                    label: controller.globalController.tabIndex.value == 0 ? "Add Patient" : "Schedule Visit",
                                                  ),
                                                ),
                                              ] else if (controller.globalController.tabIndex.value == 0) ...[
                                                Container(
                                                  width: 140,
                                                  child: CustomButton(
                                                    hight: 40,
                                                    navigate: () async {
                                                      if (controller.globalController.tabIndex.value == 0) {
                                                        await Get.toNamed(Routes.ADD_PATIENT);
                                                        controller.patientList.clear();
                                                        controller.getPatientList(isLoading: true);
                                                        controller.getPastVisitList(isFist: true);
                                                        controller.getScheduleVisitList(isFist: true);
                                                      } else {
                                                        await Get.toNamed(Routes.SCHEDULE_PATIENT);

                                                        controller.getPatientList();
                                                        controller.getPastVisitList(isFist: true);
                                                        controller.getScheduleVisitList(isFist: true);
                                                      }
                                                    },
                                                    label: controller.globalController.tabIndex.value == 0 ? "Add Patient" : "Schedule Visit",
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        );
                                      }),
                                      Expanded(
                                        child:
                                            controller.globalController.tabIndex.value == 0
                                                ? HomePatientListView()
                                                : controller.globalController.tabIndex.value == 1
                                                ? HomeScheduleListView()
                                                : HomePastVisitsList(),
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
      globalKey: _key,
    );
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

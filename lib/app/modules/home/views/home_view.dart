import 'dart:async';
import 'dart:ui';

import 'package:awesome_side_sheet/Enums/sheet_position.dart';
import 'package:awesome_side_sheet/side_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:subqdocs/app/modules/home/views/home_past_visits_list.dart';
import 'package:subqdocs/app/modules/home/views/home_schedule_list_view.dart';
import 'package:subqdocs/app/modules/home/views/past_patient_list_filter_bottom_sheet.dart';
import 'package:subqdocs/app/modules/home/views/schedule_list_filter_bottom_sheet.dart';
import 'package:subqdocs/app/modules/quick_start_view/views/quick_start_view_view.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/utils/app_fonts.dart';
import 'package:subqdocs/widget/appbar.dart';
import 'package:subqdocs/widgets/base_screen.dart';
import 'package:subqdocs/widgets/custom_button.dart';

import '../../../../utils/imagepath.dart';
import '../../../../widget/bredcums.dart';
import '../../../../widget/schedule_patient_globle_dialog.dart';
import '../../../../widgets/custom_animated_button.dart';
import '../../../core/common/logger.dart';
import '../../../routes/app_pages.dart';
import '../../patient_info/views/home_custom_search_bar.dart';
import '../../quick_start_view/controllers/quick_start_view_controller.dart';
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

  Timer? timer;

  @override
  Widget build(BuildContext context) {
    print("HomeView called------------------------------------");

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
          final _ = await Get.toNamed(Routes.PERSONAL_SETTING);
        }
      },
      body: Stack(
        children: [
          Column(
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
                              decoration: const BoxDecoration(color: Colors.transparent),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BreadcrumbWidget(
                                    breadcrumbHistory: controller.globalController.breadcrumbHistory.value,
                                    onBack: (breadcrumb) {
                                      controller.globalController.popUntilRoute(breadcrumb);

                                      while (Get.currentRoute != controller.globalController.getKeyByValue(breadcrumb)) {
                                        Get.back();
                                        // Pop the current screen
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.backgroundWhite),
                                    child: Obx(() {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.white),
                                        height: 70,
                                        child: SingleChildScrollView(
                                          physics: const BouncingScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              IntrinsicWidth(
                                                child: CustomAnimatedButton(
                                                  onPressed: () {
                                                    controller.globalController.tabIndex.value = 1;

                                                    controller.searchController.clear();
                                                    controller.showClearButton.value = false;
                                                    controller.clearFilter(isRefresh: false);
                                                    controller.getScheduleVisitList(isFist: true);
                                                  },

                                                  text: "Scheduled Visits",
                                                  isOutline: true,
                                                  paddingText: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
                                                    controller.searchController.clear();
                                                    controller.showClearButton.value = false;
                                                    controller.clearFilter(isRefresh: false);
                                                    controller.getPastVisitList(isFist: true);
                                                  },
                                                  text: "Past Patients Visits",
                                                  isOutline: true,
                                                  paddingText: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                                  fontSize: 14,
                                                  enabledTextColor: controller.globalController.tabIndex.value == 2 ? AppColors.backgroundPurple : AppColors.textGrey,
                                                  enabledColor: controller.globalController.tabIndex.value == 2 ? AppColors.buttonPurpleLight : AppColors.clear,
                                                  outLineEnabledColor: AppColors.textGrey,
                                                  outlineColor: controller.globalController.tabIndex.value == 2 ? AppColors.backgroundPurple : AppColors.clear,
                                                ),
                                              ),
                                              IntrinsicWidth(
                                                child: CustomAnimatedButton(
                                                  onPressed: () {
                                                    controller.searchController.clear();
                                                    controller.showClearButton.value = false;
                                                    controller.globalController.tabIndex.value = 0;
                                                    controller.clearFilter(isRefresh: false);
                                                    controller.getPatientList();
                                                  },
                                                  text: "Patients",
                                                  isOutline: true,
                                                  paddingText: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                                  fontSize: 14,
                                                  enabledTextColor: controller.globalController.tabIndex.value == 0 ? AppColors.backgroundPurple : AppColors.textGrey,
                                                  enabledColor: controller.globalController.tabIndex.value == 0 ? AppColors.buttonPurpleLight : AppColors.clear,
                                                  outLineEnabledColor: AppColors.textGrey,
                                                  outlineColor: controller.globalController.tabIndex.value == 0 ? AppColors.backgroundPurple : AppColors.clear,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                  const SizedBox(height: 20),

                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                                                          ? ((controller.patientListModel.value?.responseData!.totalCount ?? 0) != 0 ? "Patient List (${controller.patientListModel.value!.responseData!.totalCount ?? 0})" : "")
                                                          : controller.globalController.tabIndex.value == 1
                                                          ? ((controller.scheduleVisitListModel.value?.responseData?.totalCount ?? 0) != 0 ? "Scheduled List (${controller.scheduleVisitListModel.value!.responseData!.totalCount ?? 0})" : "")
                                                          : ((controller.pastVisitListModel.value?.responseData?.totalCount ?? 0) != 0 ? "Past Visits List (${controller.pastVisitListModel.value!.responseData!.totalCount ?? 0})" : ""),
                                                      style: AppFonts.medium(16, AppColors.black),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  if (controller.globalController.tabIndex.value != 0) ...[
                                                    if ((controller.globalController.tabIndex.value == 1 && controller.scheduleVisitList.isNotEmpty) || (controller.globalController.scheduleFilterListingModel.isNotEmpty)) ...[
                                                      GestureDetector(
                                                        onTap: () {
                                                          if (controller.globalController.tabIndex.value == 1) {
                                                            aweSideSheet(
                                                              header: const SizedBox(),
                                                              footer: const SizedBox(),
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
                                                              customPrint("value");
                                                            });
                                                          } else if (controller.globalController.tabIndex.value == 2) {
                                                            aweSideSheet(
                                                              header: const SizedBox(),
                                                              footer: const SizedBox(),
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
                                                              customPrint("value");
                                                            });
                                                          }
                                                        },
                                                        child: Container(
                                                          height: 40,
                                                          width: 40,
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            border: Border.all(
                                                              color: AppColors.textDarkGrey,
                                                              // Border color
                                                              width: 0.5,
                                                            ),
                                                            borderRadius: BorderRadius.circular(10), // Optional: to make the corners rounded
                                                          ),
                                                          child: Padding(padding: const EdgeInsets.all(10), child: SvgPicture.asset("assets/images/filter_logo.svg", width: 40, height: 40)),
                                                        ),
                                                      ),
                                                      // const SizedBox(width: 10),
                                                    ] else if ((controller.globalController.tabIndex.value == 2 && controller.pastVisitList.isNotEmpty) || (controller.globalController.pastFilterListingModel.isNotEmpty)) ...[
                                                      GestureDetector(
                                                        onTap: () {
                                                          if (controller.globalController.tabIndex.value == 1) {
                                                            aweSideSheet(
                                                              header: const SizedBox(),
                                                              footer: const SizedBox(),
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
                                                              customPrint("value");
                                                            });
                                                          } else if (controller.globalController.tabIndex.value == 2) {
                                                            aweSideSheet(
                                                              header: const SizedBox(),
                                                              footer: const SizedBox(),
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
                                                              customPrint("value");
                                                            });
                                                          }
                                                        },
                                                        child: Container(
                                                          height: 40,
                                                          width: 40,
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            border: Border.all(
                                                              color: AppColors.textDarkGrey,
                                                              // Border color
                                                              width: 0.5,
                                                            ),
                                                            borderRadius: BorderRadius.circular(10), // Optional: to make the corners rounded
                                                          ),
                                                          child: Padding(padding: const EdgeInsets.all(10), child: SvgPicture.asset("assets/images/filter_logo.svg", width: 40, height: 40)),
                                                        ),
                                                      ),
                                                      // const SizedBox(width: 10),
                                                    ],
                                                  ],
                                                  if (controller.globalController.tabIndex.value != 0) ...[
                                                    if (controller.globalController.tabIndex.value == 1 && (controller.searchController.text.isNotEmpty || controller.scheduleVisitListModel.value?.responseData?.totalCount != 0)) ...[
                                                      const SizedBox(width: 10),
                                                    ] else if (controller.globalController.tabIndex.value == 2 && (controller.searchController.text.isNotEmpty || controller.pastVisitListModel.value?.responseData?.totalCount != 0)) ...[
                                                      const SizedBox(width: 10),
                                                    ],
                                                  ],
                                                  if (controller.globalController.tabIndex.value == 1 && (controller.searchController.text.isNotEmpty || controller.scheduleVisitListModel.value?.responseData?.totalCount != 0)) ...[
                                                    SizedBox(
                                                      height: 42,
                                                      width: 180,
                                                      child: Obx(() {
                                                        return HomeCustomSearchBar(
                                                          showClearButton: controller.showClearButton.value,
                                                          controller: controller.searchController,
                                                          hintText: 'Search ',
                                                          onChanged: (text) {
                                                            controller.showClearButton.value = controller.searchController.text.isNotEmpty ? true : false;

                                                            controller.globalController.tabIndex.value == 0
                                                                ? controller.getPatientList()
                                                                : controller.globalController.tabIndex.value == 1
                                                                ? controller.getScheduleVisitList()
                                                                : controller.getPastVisitList();
                                                          },
                                                          onSubmit: (text) {
                                                            customPrint('Submitted search: $text');
                                                          },
                                                        );
                                                      }),
                                                    ),
                                                  ] else if (controller.globalController.tabIndex.value == 2 && (controller.searchController.text.isNotEmpty || controller.pastVisitListModel.value?.responseData?.totalCount != 0)) ...[
                                                    SizedBox(
                                                      height: 42,
                                                      width: 180,
                                                      child: Obx(() {
                                                        return HomeCustomSearchBar(
                                                          showClearButton: controller.showClearButton.value,
                                                          controller: controller.searchController,
                                                          hintText: 'Search',
                                                          onChanged: (text) {
                                                            controller.showClearButton.value = controller.searchController.text.isNotEmpty ? true : false;

                                                            controller.globalController.tabIndex.value == 0
                                                                ? controller.getPatientList()
                                                                : controller.globalController.tabIndex.value == 1
                                                                ? controller.getScheduleVisitList()
                                                                : controller.getPastVisitList();
                                                          },
                                                          onSubmit: (text) {
                                                            customPrint('Submitted search: $text');
                                                          },
                                                        );
                                                      }),
                                                    ),
                                                  ] else if (controller.globalController.tabIndex.value == 0) ...[
                                                    SizedBox(
                                                      height: 42,
                                                      width: 180,
                                                      child: Obx(() {
                                                        return HomeCustomSearchBar(
                                                          controller: controller.searchController,
                                                          showClearButton: controller.showClearButton.value,
                                                          hintText: 'Search',
                                                          onChanged: (text) {
                                                            controller.showClearButton.value = controller.searchController.text.isNotEmpty ? true : false;
                                                            controller.globalController.tabIndex.value == 0
                                                                ? controller.getPatientList()
                                                                : controller.globalController.tabIndex.value == 1
                                                                ? controller.getScheduleVisitList()
                                                                : controller.getPastVisitList();
                                                          },
                                                          onSubmit: (text) {
                                                            customPrint('Submitted search: $text');
                                                          },
                                                        );
                                                      }),
                                                    ),
                                                  ],
                                                  const SizedBox(width: 10),
                                                  const SizedBox(width: 10),
                                                  IgnorePointer(
                                                    ignoring: (controller.globalController.getEMAOrganizationDetailModel.value?.responseData?.isEmaIntegration == true) && (controller.globalController.tabIndex.value != 0),
                                                    child: Opacity(
                                                      opacity: (controller.globalController.getEMAOrganizationDetailModel.value?.responseData?.isEmaIntegration == true) && (controller.globalController.tabIndex.value != 0) ? 0.5 : 1,
                                                      child: SizedBox(
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
                                                              showDialog(
                                                                context: context,
                                                                barrierDismissible: true,
                                                                // Allows dismissing the dialog by tapping outside
                                                                builder: (BuildContext context) {
                                                                  return Dialog(
                                                                    backgroundColor: AppColors.backgroundMobileAppbar,
                                                                    surfaceTintColor: AppColors.backgroundMobileAppbar,
                                                                    insetPadding: const EdgeInsets.all(20),
                                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                                                                    child: ClipRRect(
                                                                      // Additional clipping for safety
                                                                      borderRadius: BorderRadius.circular(16.0),
                                                                      child: IntrinsicHeight(child: SchedulePatientGlobleDialog(receiveParam: (p0, p1) {})),
                                                                    ),
                                                                  );

                                                                  // return Padding(
                                                                  //   padding: const EdgeInsets.all(8.0),
                                                                  //   child: SchedulePatientGlobleDialog(
                                                                  //     receiveParam: (p0, p1) {
                                                                  //       // customPrint(
                                                                  //       //   "p0 is $p0 p1 is $p1",
                                                                  //       // );
                                                                  //       // controller.patientReScheduleCreate(
                                                                  //       //   param: {
                                                                  //       //     "visit_date": p1,
                                                                  //       //     "visit_time": p0,
                                                                  //       //   },
                                                                  //       //   // visitId:
                                                                  //       //   // controller
                                                                  //       //   //     .scheduleVisitList[rowIndex]
                                                                  //       //   //     .visitId
                                                                  //       //   //     .toString(),
                                                                  //       // );
                                                                  //     },
                                                                  //   ),
                                                                  // ); // Our custom dialog
                                                                },
                                                              );
                                                            }
                                                          },
                                                          label: controller.globalController.tabIndex.value == 0 ? "Add Patient" : "Schedule Visit",
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  // if (controller.globalController.tabIndex.value == 1 && controller.scheduleVisitListModel.value?.responseData?.totalCount != 0) ...[
                                                  //   Container(
                                                  //     width: 140,
                                                  //     child: CustomButton(
                                                  //       hight: 40,
                                                  //       navigate: () async {
                                                  //         if (controller.globalController.tabIndex.value == 0) {
                                                  //           await Get.toNamed(Routes.ADD_PATIENT);
                                                  //           controller.patientList.clear();
                                                  //           controller.getPatientList(isLoading: true);
                                                  //           controller.getPastVisitList(isFist: true);
                                                  //           controller.getScheduleVisitList(isFist: true);
                                                  //         } else {
                                                  //           await Get.toNamed(Routes.SCHEDULE_PATIENT);
                                                  //
                                                  //           controller.getPatientList();
                                                  //           controller.getPastVisitList(isFist: true);
                                                  //           controller.getScheduleVisitList(isFist: true);
                                                  //         }
                                                  //       },
                                                  //       label: controller.globalController.tabIndex.value == 0 ? "Add Patient" : "Schedule Visit",
                                                  //     ),
                                                  //   ),
                                                  // ] else if (controller.globalController.tabIndex.value == 2 && controller.pastVisitListModel.value?.responseData?.totalCount != 0) ...[
                                                  //   Container(
                                                  //     width: 140,
                                                  //     child: CustomButton(
                                                  //       hight: 40,
                                                  //       navigate: () async {
                                                  //         if (controller.globalController.tabIndex.value == 0) {
                                                  //           await Get.toNamed(Routes.ADD_PATIENT);
                                                  //           controller.patientList.clear();
                                                  //           controller.getPatientList(isLoading: true);
                                                  //           controller.getPastVisitList(isFist: true);
                                                  //           controller.getScheduleVisitList(isFist: true);
                                                  //         } else {
                                                  //           await Get.toNamed(Routes.SCHEDULE_PATIENT);
                                                  //
                                                  //           controller.getPatientList();
                                                  //           controller.getPastVisitList(isFist: true);
                                                  //           controller.getScheduleVisitList(isFist: true);
                                                  //         }
                                                  //       },
                                                  //       label: controller.globalController.tabIndex.value == 0 ? "Add Patient" : "Schedule Visit",
                                                  //     ),
                                                  //   ),
                                                  // ] else if (controller.globalController.tabIndex.value == 0) ...[
                                                  //   Container(
                                                  //     width: 140,
                                                  //     child: CustomButton(
                                                  //       hight: 40,
                                                  //       navigate: () async {
                                                  //         if (controller.globalController.tabIndex.value == 0) {
                                                  //           await Get.toNamed(Routes.ADD_PATIENT);
                                                  //           controller.patientList.clear();
                                                  //           controller.getPatientList(isLoading: true);
                                                  //           controller.getPastVisitList(isFist: true);
                                                  //           controller.getScheduleVisitList(isFist: true);
                                                  //         } else {
                                                  //           await Get.toNamed(Routes.SCHEDULE_PATIENT);
                                                  //
                                                  //           controller.getPatientList();
                                                  //           controller.getPastVisitList(isFist: true);
                                                  //           controller.getScheduleVisitList(isFist: true);
                                                  //         }
                                                  //       },
                                                  //       label: controller.globalController.tabIndex.value == 0 ? "Add Patient" : "Schedule Visit",
                                                  //     ),
                                                  //   ),
                                                  // ],
                                                ],
                                              ),
                                            );
                                          }),
                                          Expanded(
                                            child:
                                                controller.globalController.tabIndex.value == 0
                                                    ? const HomePatientListView()
                                                    : controller.globalController.tabIndex.value == 1
                                                    ? const HomeScheduleListView()
                                                    : const HomePastVisitsList(),
                                          ),
                                          const SizedBox(height: 10),
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

          if (controller.isEMAFetching.value) ...[
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6), // Subtle translucent white
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade300, width: 1),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CupertinoActivityIndicator(radius: 10),
                          SizedBox(width: 12),
                          Text(
                            'Fetching new record...',
                            style: TextStyle(
                              color: Colors.black87, // Dark readable text
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Positioned(
            //   bottom: 40,
            //   left: 0,
            //   right: 0,
            //   child: Center(
            //     child: ClipRRect(
            //       borderRadius: BorderRadius.circular(20),
            //       child: BackdropFilter(
            //         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            //         child: Container(
            //           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            //           decoration: BoxDecoration(color: Colors.grey.withOpacity(0.02), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.withOpacity(0.3))),
            //           child: const Row(mainAxisSize: MainAxisSize.min, children: [CupertinoActivityIndicator(radius: 10), SizedBox(width: 12), Text('Fetching new record', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500))]),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
          if (controller.globalController.getEMAOrganizationDetailModel.value?.responseData?.isEmaIntegration == false) ...[
            if (controller.globalController.visitId.isEmpty) ...[
              Positioned(
                right: 30, // 20 padding from right
                bottom: 20, // 20 padding from bottom
                child: GestureDetector(
                  onTap: () async {
                    showQuickStartViewDialog();
                    // await Get.toNamed(Routes.ADD_PATIENT_MOBILE_VIEW);
                    // controller.updateTabbar();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.backgroundPurple,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                          spreadRadius: 5,
                          blurRadius: 9,
                          offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Row(children: [SvgPicture.asset(ImagePath.quick_start, height: 20, width: 20), const SizedBox(width: 5), Text("Quick Start", softWrap: true, style: AppFonts.medium(16, AppColors.white))]),
                  ),
                ),
              ),
            ],
          ],
          // if (controller.globalController.visitId.isEmpty) ...[
          //   Positioned(
          //     right: 30, // 20 padding from right
          //     bottom: 20, // 20 padding from bottom
          //     child: GestureDetector(
          //       onTap: () async {
          //         showQuickStartViewDialog();
          //         // await Get.toNamed(Routes.ADD_PATIENT_MOBILE_VIEW);
          //         // controller.updateTabbar();
          //       },
          //       child: Container(
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(10),
          //           color: AppColors.backgroundPurple,
          //           boxShadow: [
          //             BoxShadow(
          //               color: AppColors.backgroundPurple.withValues(alpha: 0.2),
          //               spreadRadius: 5,
          //               blurRadius: 9,
          //               offset: Offset(0, 3), // changes position of shadow
          //             ),
          //           ],
          //         ),
          //         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          //         child: Row(children: [SvgPicture.asset(ImagePath.quick_start, height: 20, width: 20), const SizedBox(width: 5), Text("Quick Start", softWrap: true, style: AppFonts.medium(16, AppColors.white))]),
          //         // You can customize the button further
          //         // backgroundColor: Colors.blue,
          //         // elevation: 5,
          //       ),
          //     ),
          //   ),
          // ],
        ],
      ),
      globalKey: _key,
    );
  }

  void showQuickStartViewDialog() {
    showGeneralDialog(
      context: Get.context!,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation1, animation2) {
        final controller = Get.put(QuickStartViewController());

        return ScaleTransition(
          scale: CurvedAnimation(parent: animation1, curve: Curves.fastOutSlowIn),
          child: FadeTransition(
            opacity: animation1,
            child: Dialog(
              backgroundColor: AppColors.backgroundMobileAppbar,
              surfaceTintColor: AppColors.backgroundMobileAppbar,
              insetPadding: const EdgeInsets.all(20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
                child: ClipRRect(
                  // Additional clipping for safety
                  borderRadius: BorderRadius.circular(16.0),
                  child: const IntrinsicHeight(child: QuickStartViewView()),
                ),
              ),
            ),
          ),
        );
      },
    ).then((value) async {
      await Get.delete<QuickStartViewController>();
      controller.globalController.visitId.refresh();

      // controller.update();
    });
  }

  // Get.dialog(
  //   ScaleTransition(
  //     scale: CurvedAnimation(parent: ModalRoute.of(Get.overlayContext!)!.animation!, curve: Curves.fastOutSlowIn),
  //     child: FadeTransition(opacity: ModalRoute.of(Get.overlayContext!)!.animation!, child: Center(child: ConstrainedBox(constraints: BoxConstraints(maxWidth: Get.width * 0.9, maxHeight: Get.height * 0.8), child: QuickStartViewView()))),
  //   ),
  //   transitionDuration: Duration(milliseconds: 600),
  //   barrierDismissible: true,
  //   barrierColor: Colors.black.withOpacity(0.5),
  // );
  // child: ConstrainedBox(
  //   constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.5, maxHeight: MediaQuery.of(context).size.height * 0.8),
  //   child: ClipRRect(
  //     // Additional clipping for safety
  //     borderRadius: BorderRadius.circular(16.0),
  //     child: ConstrainedBox(constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.9, maxHeight: MediaQuery.of(context).size.height * 0.8), child: const QuickStartViewView()),
  //   ),
  // ),

  // void showQuickStartViewDialog() {
  //   Get.dialog(
  //     // Wrap your dialog with animation widgets
  //     ScaleTransition(scale: CurvedAnimation(parent: ModalRoute.of(Get.context!)!.animation!, curve: Curves.fastOutSlowIn), child: FadeTransition(opacity: ModalRoute.of(Get.context!)!.animation!, child: QuickStartViewView())),
  //     // Custom transition settings
  //     transitionDuration: Duration(milliseconds: 600),
  //     barrierDismissible: true,
  //     barrierColor: Colors.black.withOpacity(0.5),
  //   );
  // }

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

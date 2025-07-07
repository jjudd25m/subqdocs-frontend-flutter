import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:subqdocs/utils/imagepath.dart';
import 'package:subqdocs/widgets/base_screen_mobile.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../widget/appbar.dart';
import '../../../core/common/logger.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_view_mobile_controller.dart';
import 'custom_mobile_search_bar.dart';
import 'mobile_past_patient_list_view.dart';
import 'mobile_patient_list_view.dart';
import 'mobile_schedule_list_view.dart';

class HomeViewMobileView extends GetView<HomeViewMobileController> {
  HomeViewMobileView({super.key});

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
    return BaseScreenMobile(
      resizeToAvoidBottomInset: false,
      onItemSelected: (index) async {
        customPrint("index is :- $index");
        if (index == 0) {
          controller.searchController.clear();
          controller.showClearButton.value = false;
          controller.globalController.tabIndex.value = 0;
          controller.clearFilter(isRefresh: false);
          controller.getPatientList();
        } else if (index == 1) {
          controller.globalController.tabIndex.value = 1;
          controller.searchController.clear();
          controller.showClearButton.value = false;
          controller.clearFilter(isRefresh: false);
          controller.getScheduleVisitList(isFist: true);
        } else if (index == 2) {
          controller.globalController.tabIndex.value = 2;
          controller.searchController.clear();
          controller.showClearButton.value = false;
          controller.clearFilter(isRefresh: false);
          controller.getPastVisitList(isFist: true);
        } else if (index == 3) {
        } else if (index == 4) {}
      },
      body: Stack(
        children: [
          Column(
            children: [
              CustomMobileAppBar(drawerKey: _key),
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: AppColors.backgroundMobileAppbar,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.clear),
                        child: Obx(() {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.clear),
                            height: 70,
                            child: Column(
                              children: [
                                SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    spacing: 24,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          controller.globalController.tabIndex.value = 1;
                                          // controller.searchController.clear();
                                          // controller.showClearButton.value = false;
                                          // controller.clearFilter(isRefresh: false);
                                          // controller.getScheduleVisitList(isFist: true);
                                        },
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(padding: const EdgeInsets.only(bottom: 12.0), child: Text('Scheduled Visits', style: TextStyle(color: controller.globalController.tabIndex.value == 1 ? AppColors.textPurple : AppColors.textDarkGrey, fontWeight: FontWeight.w500))),
                                            Container(height: 3.0, width: _getTextWidth(' Scheduled Visits ', const TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0)), decoration: BoxDecoration(color: controller.globalController.tabIndex.value == 1 ? AppColors.textPurple : Colors.transparent, borderRadius: BorderRadius.circular(1.5))),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          controller.globalController.tabIndex.value = 2;

                                          // controller.searchController.clear();
                                          // controller.showClearButton.value = false;
                                          // controller.clearFilter(isRefresh: false);
                                          // controller.getPastVisitList(isFist: true);
                                        },
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(padding: const EdgeInsets.only(bottom: 12.0), child: Text(' Past Visits ', style: TextStyle(color: controller.globalController.tabIndex.value == 2 ? AppColors.textPurple : AppColors.textDarkGrey, fontWeight: FontWeight.w500))),
                                            Container(height: 3.0, width: _getTextWidth(' Past Visits ', const TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0)), decoration: BoxDecoration(color: controller.globalController.tabIndex.value == 2 ? AppColors.textPurple : Colors.transparent, borderRadius: BorderRadius.circular(1.5))),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          // controller.searchController.clear();
                                          // controller.showClearButton.value = false;
                                          controller.globalController.tabIndex.value = 0;
                                          // controller.clearFilter(isRefresh: false);
                                          // controller.getPatientList();
                                        },
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(padding: const EdgeInsets.only(bottom: 12.0), child: Text('Patients', style: TextStyle(color: controller.globalController.tabIndex.value == 0 ? AppColors.textPurple : AppColors.textDarkGrey, fontWeight: FontWeight.w500))),
                                            Container(height: 3.0, width: _getTextWidth(' Patients ', const TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0)), decoration: BoxDecoration(color: controller.globalController.tabIndex.value == 0 ? AppColors.textPurple : Colors.transparent, borderRadius: BorderRadius.circular(1.5))),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(height: 2.0, width: double.infinity, decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.0), color: AppColors.backgroundPurple.withValues(alpha: 0.1))),
                              ],
                            ),

                            // SingleChildScrollView(
                            //   physics: const BouncingScrollPhysics(),
                            //   scrollDirection: Axis.horizontal,
                            //   child: Row(
                            //     spacing: 10,
                            //     children: [
                            //       IntrinsicWidth(
                            //         child: CustomTabButton(
                            //           onPressed: () {
                            //             controller.globalController.tabIndex.value = 1;
                            //
                            //             controller.searchController.clear();
                            //             controller.showClearButton.value = false;
                            //             controller.clearFilter(isRefresh: false);
                            //             controller.getScheduleVisitList(isFist: true);
                            //           },
                            //           text: "Scheduled Visits",
                            //           isOutline: true,
                            //           paddingText: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            //           fontSize: 14,
                            //           enabledTextColor: controller.globalController.tabIndex.value == 1 ? AppColors.textWhite : AppColors.textGrey,
                            //           enabledColor: controller.globalController.tabIndex.value == 1 ? AppColors.backgroundPurple : AppColors.buttonPurpleLight,
                            //           outLineEnabledColor: AppColors.textGrey,
                            //           outlineColor: controller.globalController.tabIndex.value == 1 ? AppColors.backgroundPurple : AppColors.clear,
                            //         ),
                            //       ),
                            //       IntrinsicWidth(
                            //         child: CustomTabButton(
                            //           onPressed: () {
                            //             controller.globalController.tabIndex.value = 2;
                            //
                            //             // controller.scheduleSorting(cellData: "Visit Date", colIndex: 1);
                            //             controller.searchController.clear();
                            //             controller.showClearButton.value = false;
                            //             controller.clearFilter(isRefresh: false);
                            //             controller.getPastVisitList(isFist: true);
                            //           },
                            //           text: "Past Patients Visits",
                            //           isOutline: true,
                            //           paddingText: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            //           fontSize: 14,
                            //           enabledTextColor: controller.globalController.tabIndex.value == 2 ? AppColors.textWhite : AppColors.textGrey,
                            //           enabledColor: controller.globalController.tabIndex.value == 2 ? AppColors.backgroundPurple : AppColors.buttonPurpleLight,
                            //           outLineEnabledColor: AppColors.textGrey,
                            //           outlineColor: controller.globalController.tabIndex.value == 2 ? AppColors.backgroundPurple : AppColors.clear,
                            //         ),
                            //       ),
                            //       IntrinsicWidth(
                            //         child: CustomTabButton(
                            //           onPressed: () {
                            //             controller.searchController.clear();
                            //             controller.showClearButton.value = false;
                            //             controller.globalController.tabIndex.value = 0;
                            //             controller.clearFilter(isRefresh: false);
                            //             controller.getPatientList();
                            //           },
                            //           text: "Patients",
                            //           isOutline: true,
                            //           paddingText: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            //           fontSize: 14,
                            //           enabledTextColor: controller.globalController.tabIndex.value == 0 ? AppColors.textWhite : AppColors.textGrey,
                            //           enabledColor: controller.globalController.tabIndex.value == 0 ? AppColors.backgroundPurple : AppColors.buttonPurpleLight,
                            //           outLineEnabledColor: AppColors.textGrey,
                            //           outlineColor: controller.globalController.tabIndex.value == 0 ? AppColors.backgroundPurple : AppColors.clear,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          );
                        }),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Obx(() {
                          return SizedBox(
                            height: 45,
                            child: CustomMobileSearchBar(
                              showClearButton: controller.showClearButton.value,
                              controller: controller.searchController,
                              hintText: 'Search ',
                              onChanged: (text) async {
                                controller.showClearButton.value = controller.searchController.text.isNotEmpty ? true : false;

                                await Future.wait([controller.getPatientList(), controller.getScheduleVisitList(), controller.getPastVisitList()]);

                                // controller.globalController.tabIndex.value == 0
                                //     ? controller.getPatientList()
                                //     : controller.globalController.tabIndex.value == 1
                                //     ? controller.getScheduleVisitList()
                                //     : controller.getPastVisitList();
                              },
                              onSubmit: (text) {
                                customPrint('Submitted search: $text');
                              },
                            ),
                          );
                        }),
                      ),
                      // Obx(() {
                      //   return Column(children: [
                      //     Text("schedule count:- ${controller.scheduleVisitList
                      //         .length}"),
                      //     Text("past count:- ${controller.pastVisitList
                      //         .length}"),
                      //     Text("patient count:- ${controller.patientList
                      //         .length}"),
                      //   ],);
                      // }),
                      const SizedBox(height: 10),
                      Obx(() {
                        return Expanded(
                          child:
                              controller.globalController.tabIndex.value == 0
                                  ? const MobilePatientListView()
                                  : controller.globalController.tabIndex.value == 1
                                  ? const MobileScheduleListView()
                                  : const MobilePastPatientListView(),
                        );
                      }),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (controller.globalController.getEMAOrganizationDetailModel.value?.responseData?.isEmaIntegration == false) ...[
            Positioned(
              right: 30, // 20 padding from right
              bottom: 20, // 20 padding from bottom
              child: GestureDetector(
                onTap: () async {
                  await Get.toNamed(Routes.ADD_PATIENT_MOBILE_VIEW);
                  controller.updateTabbar();
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
                  // You can customize the button further
                  // backgroundColor: Colors.blue,
                  // elevation: 5,
                ),
              ),
            ),
          ],
        ],
      ),
      globalKey: _key,
    );
  }

  double _getTextWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(text: TextSpan(text: text, style: style), maxLines: 1, textDirection: TextDirection.ltr)..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.width;
  }
}

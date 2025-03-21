import 'dart:ui';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_diamentions.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../../../../widget/custom_animated_button.dart';
import '../../../core/common/app_preferences.dart';
import '../controllers/home_controller.dart';
import '../model/home_past_patient_list_sorting_model.dart';

class PastPatientListFilterBottomSheet extends GetView<HomeController> {
  final VoidCallback onTap;

  RxList<DateTime>? selectedDate = RxList([DateTime.now()]);
  RxList<String> selectedStatusIndex = RxList();

  PageController pageController = PageController();
  PastPatientListFilterBottomSheet({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    print("arr count:- ${controller.globalController.homePastPatientListSortingModel.value?.selectedStatusIndex ?? []}");
    selectedDate?.value = controller.globalController.homePastPatientListSortingModel.value?.selectedDateValue ?? RxList([DateTime.now()]);
    pageController = PageController(initialPage: DateUtils.monthDelta(DateTime(2000, 01, 01), selectedDate?.firstOrNull ?? DateTime.now()));
    selectedStatusIndex.value = controller.globalController.homePastPatientListSortingModel.value?.selectedStatusIndex ?? [];
    return SizedBox(
      width: double.infinity, // Ensures full width
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          color: AppColors.backgroundWhite,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimen.margin20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 80,
                height: 5,
                margin: const EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                  color: AppColors.textDarkGrey.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    "Filter",
                    style: AppFonts.medium(16, AppColors.textBlack),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      selectedStatusIndex.clear();
                      controller.globalController.homePastPatientListSortingModel.value?.selectedDateValue?.clear();
                      controller.globalController.homePastPatientListSortingModel.value?.startDate = "";
                      controller.globalController.homePastPatientListSortingModel.value?.endDate = "";
                      controller.globalController.saveHomePastPatientData();
                      Get.back();
                      onTap();
                    },
                    child: Text(
                      "Clear",
                      style: AppFonts.medium(14, AppColors.backgroundPurple).copyWith(decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Obx(() {
                return Column(
                    children: List.generate(controller.statusModel.length, (index) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
                      child: GestureDetector(
                        onTap: () {
                          if (selectedStatusIndex.contains(controller.statusModel[index].status)) {
                            print("contain val");
                            selectedStatusIndex.remove(controller.statusModel[index].status);
                          } else {
                            print("add val");
                            selectedStatusIndex.add(controller.statusModel[index].status ?? "");
                          }

                          if (selectedStatusIndex.isNotEmpty) {
                            // List<String>? statusList = selectedStatusIndex!.map((e) => controller.statusModel[e].status.toString()).toList();
                            controller.globalController.homePastPatientListSortingModel.value?.selectedStatusIndex = selectedStatusIndex;
                          }

                          print("selectedStatusIndex :- ${selectedStatusIndex}");
                        },
                        child: Row(
                          children: [
                            selectedStatusIndex.contains(controller.statusModel[index].status)
                                ? SvgPicture.asset(
                                    ImagePath.checkedBox,
                                    width: 25,
                                    height: 25,
                                  )
                                : SvgPicture.asset(
                                    ImagePath.unCheckedBox,
                                    width: 25,
                                    height: 25,
                                  ),
                            SizedBox(
                              width: 9,
                            ),
                            Expanded(
                              child: Text(
                                controller.statusModel[index].status ?? "",
                                style: AppFonts.regular(14, AppColors.textBlack),
                              ),
                            ),
                            Spacer()
                          ],
                        ),
                      ));
                }));
              }),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    "Visit Date",
                    style: AppFonts.regular(14, AppColors.textBlack),
                  ),
                  Spacer(),
                ],
              ),
              const SizedBox(height: 10),
              Obx(() {
                return PopupMenuButton<String>(
                  offset: const Offset(0, 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  color: AppColors.white,
                  position: PopupMenuPosition.under,
                  padding: EdgeInsetsDirectional.zero,
                  menuPadding: EdgeInsetsDirectional.zero,
                  onSelected: (value) {},
                  style: const ButtonStyle(
                      padding: WidgetStatePropertyAll(EdgeInsetsDirectional.zero),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      maximumSize: WidgetStatePropertyAll(Size.infinite),
                      visualDensity: VisualDensity(horizontal: 0, vertical: 0)),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                        padding: EdgeInsets.zero,
                        onTap: () {
                          selectedDate?.value = [DateTime.now(), DateTime.now()];
                          updateSelectedDate();
                          controller.globalController.homePastPatientListSortingModel.value?.selectedDateValue = selectedDate;
                          pageController.animateToPage(DateUtils.monthDelta(DateTime(2000, 01, 01), selectedDate?.first ?? DateTime.now()),
                              duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                "Today",
                                style: AppFonts.regular(14, AppColors.textBlack),
                              ),
                            ),
                          ],
                        )),
                    PopupMenuItem(
                        padding: EdgeInsets.zero,
                        onTap: () {
                          selectedDate?.value = [DateTime.now().subtract(Duration(days: 1)), DateTime.now().subtract(Duration(days: 1))];
                          updateSelectedDate();
                          controller.globalController.homePastPatientListSortingModel.value?.selectedDateValue = selectedDate;
                          pageController.animateToPage(DateUtils.monthDelta(DateTime(2000, 01, 01), selectedDate?.first ?? DateTime.now()),
                              duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 1,
                              color: AppColors.appbarBorder,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Yesterday",
                                style: AppFonts.regular(14, AppColors.textBlack),
                              ),
                            ),
                          ],
                        )),
                    PopupMenuItem(
                        padding: EdgeInsets.zero,
                        onTap: () {
                          selectedDate?.value = [DateTime.now().subtract(Duration(days: 7)), DateTime.now()];
                          updateSelectedDate();
                          controller.globalController.homePastPatientListSortingModel.value?.selectedDateValue = selectedDate;
                          pageController.animateToPage(DateUtils.monthDelta(DateTime(2000, 01, 01), selectedDate?.first ?? DateTime.now()),
                              duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 1,
                              color: AppColors.appbarBorder,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Past 7 Days",
                                style: AppFonts.regular(14, AppColors.textBlack),
                              ),
                            ),
                          ],
                        )),
                    PopupMenuItem(
                        padding: EdgeInsets.zero,
                        onTap: () {
                          DateTime now = DateTime.now();
                          selectedDate?.value = [DateTime(now.year, now.month - 1, 1), DateTime(now.year, now.month, 0)];
                          updateSelectedDate();
                          controller.globalController.homePastPatientListSortingModel.value?.selectedDateValue = selectedDate;
                          // pageController.previousPage(duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                          pageController.animateToPage(DateUtils.monthDelta(DateTime(2000, 01, 01), selectedDate?.first ?? DateTime.now()),
                              duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 1,
                              color: AppColors.appbarBorder,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Previous Month",
                                style: AppFonts.regular(14, AppColors.textBlack),
                              ),
                            ),
                          ],
                        )),
                  ],
                  child: Container(
                      height: 45,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey.shade300, width: 1),
                      ),
                      child: Row(
                        children: [
                          Text(
                            controller.getCustomDateRange(selectedDate ?? []).length == 2
                                ? "${controller.getCustomDateRange(selectedDate ?? [])[0]}-${controller.getCustomDateRange(selectedDate ?? [])[1]}"
                                : "Select",
                            style: AppFonts.regular(14, AppColors.textBlack),
                          ),
                          Spacer(),
                          SvgPicture.asset(
                            ImagePath.down_arrow,
                            width: 25,
                            height: 25,
                          )
                        ],
                      )),
                );
              }),
              Obx(() {
                return SizedBox(
                  width: Get.width,
                  child: CalendarDatePicker2(
                    config: CalendarDatePicker2Config(
                      dayViewController: pageController,
                      weekdayLabelTextStyle: AppFonts.regular(14, AppColors.textGrey),
                      weekdayLabels: ["Mo", "Tu", "We", "Th", "Fr", "Sa", "su"],
                      daySplashColor: AppColors.clear,
                      calendarViewMode: CalendarDatePicker2Mode.day,
                      selectedDayHighlightColor: AppColors.backgroundPurple,
                      dayMaxWidth: 30,
                      allowSameValueSelection: true,
                      firstDayOfWeek: 6,
                      rangeBidirectional: true,
                      animateToDisplayedMonthDate: true,
                      dayTextStyle: AppFonts.regular(14, AppColors.textBlack),
                      disableMonthPicker: true,
                      dayBorderRadius: BorderRadius.all(Radius.circular(6)),
                      scrollViewTopHeaderTextStyle: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                      controlsTextStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      centerAlignModePicker: true,
                      customModePickerIcon: const SizedBox(),
                      calendarViewScrollPhysics: RangeMaintainingScrollPhysics(),
                      calendarType: CalendarDatePicker2Type.range,
                      firstDate: DateTime(2000, 01, 01),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                    ),
                    onValueChanged: (value) {
                      selectedDate?.value = value;

                      if (selectedStatusIndex.isNotEmpty) {
                        controller.globalController.homePastPatientListSortingModel.value?.selectedStatusIndex = selectedStatusIndex;
                      }

                      controller.globalController.homePastPatientListSortingModel.value?.selectedDateValue = selectedDate;
                      List<String> dates = controller.getCustomDateRange(selectedDate ?? []);
                      if (dates.length == 2) {
                        controller.globalController.homePastPatientListSortingModel.value?.startDate = dates[0];
                        controller.globalController.homePastPatientListSortingModel.value?.endDate = dates[1];
                        controller.globalController.saveHomePastPatientData();
                      }
                    },
                    value: selectedDate ?? [DateTime.now()],
                  ),
                );
              }),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateSelectedDate() async {
    if (selectedStatusIndex.isNotEmpty) {
      controller.globalController.homePastPatientListSortingModel.value?.selectedStatusIndex = selectedStatusIndex;
    }
    controller.globalController.homePastPatientListSortingModel.value?.selectedDateValue = selectedDate;
    List<String> dates = controller.getCustomDateRange(selectedDate ?? []);
    if (dates.length == 2) {
      controller.globalController.homePastPatientListSortingModel.value?.startDate = dates[0];
      controller.globalController.homePastPatientListSortingModel.value?.endDate = dates[1];
      controller.globalController.saveHomePastPatientData();
    }
  }
}

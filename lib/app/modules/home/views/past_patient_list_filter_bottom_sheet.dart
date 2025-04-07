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
import '../../../../widget/base_image_view.dart';
import '../controllers/home_controller.dart';
import 'container_dropdown_view.dart';
import 'drop_down_with_search.dart';

class PastPatientListFilterBottomSheet extends GetView<HomeController> {
  final VoidCallback onTap;

  RxList<DateTime>? selectedDate = RxList([DateTime.now()]);
  RxList<String> selectedStatusIndex = RxList();

  RxBool isExpandedDoctor = RxBool(false);
  RxBool isExpandedMedicalAssistant = RxBool(false);

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
          padding: const EdgeInsets.symmetric(horizontal: Dimen.margin0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // Container(
              //   width: 80,
              //   height: 5,
              //   margin: const EdgeInsets.only(top: 15),
              //   decoration: BoxDecoration(
              //     color: AppColors.textDarkGrey.withOpacity(0.4),
              //     borderRadius: BorderRadius.circular(8),
              //   ),
              // ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimen.margin20),
                child: Row(
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
                        controller.pastTriggeredIndexes.clear();

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
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimen.margin20),
                        child: Row(
                          children: [
                            Text(
                              "Visit Date",
                              style: AppFonts.regular(14, AppColors.textBlack),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimen.margin20),
                        child: Obx(() {
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
                                    pageController.animateToPage(DateUtils.monthDelta(DateTime(2000, 01, 01), selectedDate?.first ?? DateTime.now()), duration: Duration(milliseconds: 200), curve: Curves.easeIn);
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
                                    pageController.animateToPage(DateUtils.monthDelta(DateTime(2000, 01, 01), selectedDate?.first ?? DateTime.now()), duration: Duration(milliseconds: 200), curve: Curves.easeIn);
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
                                    pageController.animateToPage(DateUtils.monthDelta(DateTime(2000, 01, 01), selectedDate?.first ?? DateTime.now()), duration: Duration(milliseconds: 200), curve: Curves.easeIn);
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
                                    pageController.animateToPage(DateUtils.monthDelta(DateTime(2000, 01, 01), selectedDate?.first ?? DateTime.now()), duration: Duration(milliseconds: 200), curve: Curves.easeIn);
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
                                      controller.getCustomDateRange(selectedDate ?? []).length == 2 ? "${controller.getCustomDateRange(selectedDate ?? [])[0]}-${controller.getCustomDateRange(selectedDate ?? [])[1]}" : "Select",
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
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimen.margin20),
                        child: Obx(() {
                          return SizedBox(
                            width: Get.width,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.grey.shade300, width: 1),
                              ),
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
                                    controller.pastTriggeredIndexes.clear();
                                  }
                                },
                                value: selectedDate ?? [DateTime.now()],
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 10),
                      Obx(() {
                        return Column(
                            children: List.generate(controller.filterPastVisitStatusCategoryData.length, (index) {
                          return Column(
                            children: [
                              if (index != 0) ...[
                                Divider(),
                              ],
                              SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: Dimen.margin20),
                                child: Row(
                                  children: [
                                    Text(
                                      controller.filterPastVisitStatusCategoryData[index].category,
                                      style: AppFonts.medium(14, AppColors.textDarkGrey),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: Dimen.margin20),
                                child: Column(
                                    children: List.generate(controller.filterPastVisitStatusCategoryData[index].subcategories.length, (subIndex) {
                                  return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
                                      child: GestureDetector(
                                        onTap: () {
                                          if (selectedStatusIndex.contains(controller.filterPastVisitStatusCategoryData[index].subcategories[subIndex])) {
                                            print("contain val");
                                            selectedStatusIndex.remove(controller.filterPastVisitStatusCategoryData[index].subcategories[subIndex]);
                                          } else {
                                            print("add val");
                                            selectedStatusIndex.add(controller.filterPastVisitStatusCategoryData[index].subcategories[subIndex]);
                                          }

                                          if (selectedStatusIndex.isNotEmpty) {
                                            // List<String>? statusList = selectedStatusIndex!.map((e) => controller.statusModel[e].status.toString()).toList();
                                            controller.globalController.homePastPatientListSortingModel.value?.selectedStatusIndex = selectedStatusIndex;
                                          }

                                          print("selectedStatusIndex :- ${selectedStatusIndex}");
                                        },
                                        child: Row(
                                          children: [
                                            selectedStatusIndex.contains(controller.filterPastVisitStatusCategoryData[index].subcategories[subIndex])
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
                                            ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child: Container(width: 20, height: 20, color: controller.getStatusColor(controller.filterPastVisitStatusCategoryData[index].subcategories[subIndex].replaceAll(" ", "-")))),
                                            SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                controller.filterPastVisitStatusCategoryData[index].subcategories[subIndex],
                                                style: AppFonts.regular(14, AppColors.textDarkGrey),
                                              ),
                                            ),
                                            Spacer()
                                          ],
                                        ),
                                      ));
                                })),
                              )
                            ],
                          );
                        }));
                      }),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimen.margin20),
                        child: Row(
                          children: [
                            Text(
                              "Doctor",
                              style: AppFonts.regular(14, AppColors.textBlack),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                      SizedBox(height: 17.5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimen.margin20),
                        child: ContainerDropdownView(
                          receiveParam: (isExpand) {
                            isExpandedDoctor.value = isExpand;
                          },
                          name: "Select Doctor",
                        ),
                      ),
                      SizedBox(height: 10),
                      Obx(() {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimen.margin20),
                          child: isExpandedDoctor.value
                              ? DropDownWithSearch(
                                  receiveParam: (id) {},
                                  list: controller.doctorListModel.value,
                                )
                              : SizedBox(),
                        );
                      }),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimen.margin20),
                        child: Row(
                          children: [
                            Text(
                              "Medical Assistant",
                              style: AppFonts.regular(14, AppColors.textBlack),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                      SizedBox(height: 17.5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimen.margin20),
                        child: ContainerDropdownView(
                          receiveParam: (isExpand) {
                            isExpandedMedicalAssistant.value = isExpand;
                          },
                          name: "Select Medical Assistant",
                        ),
                      ),
                      SizedBox(height: 10),
                      Obx(() {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimen.margin20),
                          child: isExpandedMedicalAssistant.value
                              ? DropDownWithSearch(
                                  list: controller.medicalListModel.value,
                                )
                              : SizedBox(),
                        );
                      }),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              )
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
      controller.pastTriggeredIndexes.clear();
    }
  }
}

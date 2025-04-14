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
import '../controllers/home_controller.dart';
import 'container_dropdown_view.dart';
import 'drop_down_with_search.dart';

class ScheduleListFilterBottomSheet extends GetView<HomeController> {
  final VoidCallback onTap;

  RxList<DateTime>? selectedDate = RxList([DateTime.now()]);

  ScheduleListFilterBottomSheet({super.key, required this.onTap});

  RxBool isExpandedDoctor = RxBool(false);
  RxBool isExpandedMedicalAssistant = RxBool(false);

  @override
  Widget build(BuildContext context) {
    selectedDate?.value = controller.globalController.homeScheduleListSortingModel.value?.selectedDateValue ?? RxList([DateTime.now()]);
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
              Row(
                children: [
                  Text(
                    "Filter",
                    style: AppFonts.medium(16, AppColors.textBlack),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      controller.globalController.homeScheduleListSortingModel.value?.selectedDateValue?.clear();
                      controller.globalController.homeScheduleListSortingModel.value?.startDate = "";
                      controller.globalController.homeScheduleListSortingModel.value?.endDate = "";
                      controller.globalController.saveHomeScheduleListData();
                      controller.scheduleTriggeredIndexes.clear();
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
                                // controller.globalController.homeScheduleListSortingModel.value?.selectedDateValue = selectedDate;
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
                                selectedDate?.value = [DateTime.now().add(Duration(days: 1)), DateTime.now().add(Duration(days: 1))];
                                updateSelectedDate();
                                // controller.globalController.homeScheduleListSortingModel.value?.selectedDateValue = selectedDate;
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
                                      "Tomorrow",
                                      style: AppFonts.regular(14, AppColors.textBlack),
                                    ),
                                  ),
                                ],
                              )),
                          PopupMenuItem(
                              padding: EdgeInsets.zero,
                              onTap: () {
                                selectedDate?.value = [DateTime.now(), DateTime.now().add(Duration(days: 7))];
                                updateSelectedDate();
                                // controller.globalController.homeScheduleListSortingModel.value?.selectedDateValue = selectedDate;
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
                                      "Next 7 Days",
                                      style: AppFonts.regular(14, AppColors.textBlack),
                                    ),
                                  ),
                                ],
                              )),
                          PopupMenuItem(
                              padding: EdgeInsets.zero,
                              onTap: () {
                                DateTime now = DateTime.now();
                                selectedDate?.value = [DateTime(now.year, now.month, 1), DateTime(now.year, now.month + 1, 0)];
                                updateSelectedDate();
                                // controller.globalController.homeScheduleListSortingModel.value?.selectedDateValue = selectedDate;
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
                                      "This Month",
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
                        )));
              }),
              SizedBox(height: 20),
              Obx(() {
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
                        weekdayLabelTextStyle: AppFonts.regular(14, AppColors.textGrey),
                        weekdayLabels: ["sun", "Mon", "Tu", "We", "Th", "Fri", "Sat"],
                        daySplashColor: AppColors.clear,
                        calendarViewMode: CalendarDatePicker2Mode.day,
                        selectedDayHighlightColor: AppColors.backgroundPurple,
                        dayMaxWidth: 30,
                        allowSameValueSelection: true,
                        firstDayOfWeek: 0,
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
                        calendarViewScrollPhysics: const NeverScrollableScrollPhysics(),
                        calendarType: CalendarDatePicker2Type.range,
                      ),
                      onValueChanged: (value) {
                        selectedDate?.value = value;

                        controller.globalController.homeScheduleListSortingModel.value?.selectedDateValue = selectedDate;
                        List<String> dates = controller.getCustomDateRange(selectedDate ?? []);
                        if (dates.length == 2) {
                          controller.globalController.homeScheduleListSortingModel.value?.startDate = dates[0];
                          controller.globalController.homeScheduleListSortingModel.value?.endDate = dates[1];
                          controller.globalController.saveHomeScheduleListData();
                          controller.scheduleTriggeredIndexes.clear();
                        }
                      },
                      value: selectedDate ?? [DateTime.now()],
                      // value: controller.globalController.homeScheduleListSortingModel.value?.selectedDateValue ?? [DateTime.now()],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    "Doctor",
                    style: AppFonts.regular(14, AppColors.textBlack),
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(height: 17.5),
              Obx(() {
                return ContainerDropdownView(
                  key: UniqueKey(),
                  onRemove: (name, index) {
                    controller.globalController.removeDoctorFilterByIndexSchedule(index: index);
                    controller.globalController.setDoctorModelSchedule();
                  },
                  selectedItem: controller.globalController.homeScheduleListSortingModel.value?.selectedDoctorNames ?? [],
                  receiveParam: (isExpand) {
                    isExpandedDoctor.value = isExpand;
                  },
                  name: "Select Doctor",
                );
              }),
              SizedBox(height: 10),
              Obx(() {
                return isExpandedDoctor.value
                    ? DropDownWithSearch(
                        key: UniqueKey(),
                        onChanged: (value, index, selectedId, name) {
                          controller.globalController.selectedDoctorModelSchedule[index].isSelected = !value;
                          controller.globalController.selectedDoctorModelSchedule.refresh();

                          if (!value) {
                            controller.globalController.saveDoctorFilterSchedule(selectedId: selectedId, name: name);
                          } else {
                            controller.globalController.removeDoctorFilterSchedule(selectedId: selectedId, name: name);
                          }
                          controller.globalController.homeScheduleListSortingModel.refresh();

                          controller.getScheduleVisitList();
                        },
                        receiveParam: (id) {},
                        list: controller.globalController.selectedDoctorModelSchedule.value,
                        selectedId: 1,
                      )
                    : SizedBox();
              }),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    "Medical Assistant",
                    style: AppFonts.regular(14, AppColors.textBlack),
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(height: 17.5),
              Obx(() {
                return ContainerDropdownView(
                  onRemove: (name, index) {
                    controller.globalController.removeMedicalFilterByIndexSchedule(index: index);

                    controller.globalController.setMedicalModelSchedule();
                  },
                  selectedItem: controller.globalController.homeScheduleListSortingModel.value?.selectedMedicationNames ?? [],
                  receiveParam: (isExpand) {
                    isExpandedMedicalAssistant.value = isExpand;
                  },
                  name: "Select Medical Assistant",
                );
              }),
              SizedBox(height: 10),
              Obx(() {
                return isExpandedMedicalAssistant.value
                    ? DropDownWithSearch(
                        key: UniqueKey(),
                        onChanged: (value, index, selectedId, name) {
                          controller.globalController.selectedMedicalModelSchedule[index].isSelected = !value;
                          controller.globalController.selectedMedicalModelSchedule.refresh();

                          if (!value) {
                            controller.globalController.saveMedicalFilterSchedule(selectedId: selectedId, name: name);
                          } else {
                            controller.globalController.removeMedicalFilterSchedule(selectedId: selectedId, name: name);
                          }
                          controller.globalController.homeScheduleListSortingModel.refresh();

                          controller.getScheduleVisitList();
                        },
                        list: controller.globalController.selectedMedicalModelSchedule.value,
                        receiveParam: (int id) {},
                        selectedId: 1,
                      )
                    : SizedBox();
              }),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateSelectedDate() async {
    controller.globalController.homeScheduleListSortingModel.value?.selectedDateValue = selectedDate;
    List<String> dates = controller.getCustomDateRange(selectedDate ?? []);
    if (dates.length == 2) {
      controller.globalController.homeScheduleListSortingModel.value?.startDate = dates[0];
      controller.globalController.homeScheduleListSortingModel.value?.endDate = dates[1];
      controller.globalController.saveHomeScheduleListData();
      controller.scheduleTriggeredIndexes.clear();
    }
  }
}

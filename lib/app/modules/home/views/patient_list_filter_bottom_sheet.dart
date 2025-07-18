import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:subqdocs/app/modules/home/controllers/home_controller.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_diamentions.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';

class PatientListFilterBottomSheet extends GetView<HomeController> {
  final VoidCallback onTap;

  List<DateTime>? selectedDate = [DateTime.now()];

  PatientListFilterBottomSheet({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Ensures full width
      child: Container(
        decoration: const BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(12)), color: AppColors.backgroundWhite),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimen.margin20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(width: 80, height: 5, margin: const EdgeInsets.only(top: 15), decoration: BoxDecoration(color: AppColors.textDarkGrey.withOpacity(0.4), borderRadius: BorderRadius.circular(8))),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text("Filter", style: AppFonts.medium(16, AppColors.textBlack)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      controller.globalController.homePatientListSortingModel.value?.selectedDateValue?.clear();
                      controller.globalController.homePatientListSortingModel.value?.startDate = "";
                      controller.globalController.homePatientListSortingModel.value?.endDate = "";
                      controller.globalController.saveHomePatientListData();
                      Get.back();
                      onTap();
                    },
                    child: Text("Clear", style: AppFonts.medium(14, AppColors.backgroundPurple).copyWith(decoration: TextDecoration.underline)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(children: [Text("Visit Date", style: AppFonts.regular(14, AppColors.textBlack)), const Spacer()]),
              const SizedBox(height: 10),
              Container(
                height: 45,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.grey.shade300, width: 1)),
                child: Row(
                  children: [
                    Text(controller.globalController.homePatientListSortingModel.value?.startDate != "" ? "${controller.globalController.homePatientListSortingModel.value?.startDate}-${controller.globalController.homePatientListSortingModel.value?.endDate}" : "Select", style: AppFonts.regular(14, AppColors.textBlack)),
                    const Spacer(),
                    SvgPicture.asset(ImagePath.down_arrow, width: 25, height: 25),
                  ],
                ),
              ),
              SizedBox(
                width: Get.width,
                child: CalendarDatePicker2(
                  config: CalendarDatePicker2Config(
                    weekdayLabelTextStyle: AppFonts.regular(14, AppColors.textGrey),
                    weekdayLabels: ["Mo", "Tu", "We", "Th", "Fr", "Sa", "su"],
                    daySplashColor: AppColors.clear,
                    calendarViewMode: CalendarDatePicker2Mode.day,
                    selectedDayHighlightColor: AppColors.backgroundPurple,
                    dayMaxWidth: 30,
                    allowSameValueSelection: true,
                    firstDayOfWeek: 6,
                    dayTextStyle: AppFonts.regular(14, AppColors.textBlack),
                    disableMonthPicker: true,
                    dayBorderRadius: const BorderRadius.all(Radius.circular(6)),
                    scrollViewTopHeaderTextStyle: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                    controlsTextStyle: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                    centerAlignModePicker: true,
                    customModePickerIcon: const SizedBox(),
                    calendarViewScrollPhysics: const NeverScrollableScrollPhysics(),
                    calendarType: CalendarDatePicker2Type.range,
                  ),
                  onValueChanged: (value) {
                    selectedDate = value;

                    controller.globalController.homePatientListSortingModel.value?.selectedDateValue = selectedDate;
                    List<String> dates = controller.getCustomDateRange(selectedDate ?? []);
                    if (dates.length == 2) {
                      controller.globalController.homePatientListSortingModel.value?.startDate = dates[0];
                      controller.globalController.homePatientListSortingModel.value?.endDate = dates[1];
                      controller.globalController.saveHomePatientListData();
                    } else {}
                  },
                  value: controller.globalController.homePatientListSortingModel.value?.selectedDateValue ?? [DateTime.now()],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

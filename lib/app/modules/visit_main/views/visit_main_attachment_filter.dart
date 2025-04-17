import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_diamentions.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../../../../widget/custom_animated_button.dart';
import '../controllers/visit_main_controller.dart';

class VisitMainAttachmentFilter extends StatelessWidget {
  VisitMainController controller = Get.find<VisitMainController>(tag: Get.arguments["unique_tag"]);

  final VoidCallback onTap;

  VisitMainAttachmentFilter({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    controller.pageController = PageController(initialPage: DateUtils.monthDelta(DateTime(2000, 01, 01), controller.selectedDate?.firstOrNull ?? DateTime.now()));
    return SizedBox(
      width: double.infinity, // Ensures full width
      child: Container(
        decoration: BoxDecoration(borderRadius: const BorderRadius.vertical(top: Radius.circular(12)), color: AppColors.backgroundWhite),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimen.margin0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimen.margin20),
                child: Row(
                  children: [
                    Text("Filter", style: AppFonts.medium(16, AppColors.textBlack)),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        controller.clearFilter();
                      },
                      child: Text("Clear", style: AppFonts.medium(14, AppColors.backgroundPurple).copyWith(decoration: TextDecoration.underline)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    spacing: 10,
                    children: [
                      const SizedBox(height: 20),
                      SizedBox(height: 30),
                      GestureDetector(
                        onTap: () {
                          controller.isSelectedAttchmentOption.value = 0;
                          controller.isDocument.value = true;
                          controller.isImage.value = false;
                          controller.isDateFilter.value = false;
                          controller.getPatientAttachment();
                          // onTap();
                          Get.back();
                        },
                        child: Obx(() {
                          return Row(
                            children: [
                              const SizedBox(width: 5),
                              SvgPicture.asset(
                                ImagePath.document_attchment,
                                width: 30,
                                height: 30,
                                colorFilter: ColorFilter.mode(controller.isSelectedAttchmentOption.value == 0 ? AppColors.backgroundPurple : AppColors.textDarkGrey, BlendMode.srcIn),
                              ),
                              const SizedBox(width: 8),
                              Text("Document", style: AppFonts.medium(17, controller.isSelectedAttchmentOption.value == 0 ? AppColors.backgroundPurple : AppColors.textBlack)),
                              const SizedBox(width: 5),
                              if (controller.isSelectedAttchmentOption.value == 0) ...[SvgPicture.asset(ImagePath.attchment_check, width: 16, height: 16)],
                            ],
                          );
                        }),
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.isSelectedAttchmentOption.value = 1;
                          controller.isDocument.value = false;
                          controller.isDateFilter.value = false;
                          controller.isImage.value = true;
                          controller.getPatientAttachment();
                          // onTap();
                          Get.back();
                        },
                        child: Obx(() {
                          return Row(
                            children: [
                              const SizedBox(width: 5),
                              SvgPicture.asset(
                                ImagePath.image_attchment,
                                width: 30,
                                height: 30,
                                colorFilter: ColorFilter.mode(controller.isSelectedAttchmentOption.value == 1 ? AppColors.backgroundPurple : AppColors.textDarkGrey, BlendMode.srcIn),
                              ),
                              const SizedBox(width: 8),
                              Text("Image", style: AppFonts.medium(17, controller.isSelectedAttchmentOption.value == 1 ? AppColors.backgroundPurple : AppColors.textBlack)),
                              const SizedBox(width: 5),
                              if (controller.isSelectedAttchmentOption.value == 1) ...[SvgPicture.asset(ImagePath.attchment_check, width: 16, height: 16)],
                            ],
                          );
                        }),
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.isSelectedAttchmentOption.value = 2;
                          controller.isDateFilter.value = true;
                          controller.isDocument.value = true;
                          controller.isImage.value = true;
                          controller.getPatientAttachment();
                          // onTap();
                          Get.back();
                        },
                        child: Obx(() {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  const SizedBox(width: 5),
                                  SvgPicture.asset(
                                    ImagePath.date_attchment,
                                    width: 30,
                                    height: 30,
                                    colorFilter: ColorFilter.mode(controller.isSelectedAttchmentOption.value == 2 ? AppColors.backgroundPurple : AppColors.textDarkGrey, BlendMode.srcIn),
                                  ),
                                  const SizedBox(width: 8),
                                  Text("Date", style: AppFonts.medium(17, controller.isSelectedAttchmentOption.value == 2 ? AppColors.backgroundPurple : AppColors.textBlack)),
                                  const SizedBox(width: 5),
                                  if (controller.isSelectedAttchmentOption.value == 2) ...[SvgPicture.asset(ImagePath.attchment_check, width: 16, height: 16)],
                                ],
                              ),
                              SizedBox(height: 20),
                              Obx(() {
                                return SizedBox(
                                  width: Get.width,
                                  child: Container(
                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.grey.shade300, width: 1)),
                                    child: CalendarDatePicker2(
                                      config: CalendarDatePicker2Config(
                                        dayViewController: controller.pageController,
                                        weekdayLabelTextStyle: AppFonts.regular(14, AppColors.textGrey),
                                        weekdayLabels: ["sun", "Mon", "Tu", "We", "Th", "Fri", "Sat"],
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
                                        scrollViewTopHeaderTextStyle: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                                        controlsTextStyle: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                                        centerAlignModePicker: true,
                                        customModePickerIcon: const SizedBox(),
                                        calendarViewScrollPhysics: RangeMaintainingScrollPhysics(),
                                        calendarType: CalendarDatePicker2Type.range,
                                        firstDate: DateTime(2000, 01, 01),
                                        lastDate: DateTime.now().add(Duration(days: 365)),
                                      ),
                                      onValueChanged: (value) {
                                        controller.selectedDate?.value = value;
                                        controller.updateSelectedDate();
                                      },
                                      value: controller.selectedDate ?? [DateTime.now()],
                                    ),
                                  ),
                                );
                              }),
                              SizedBox(height: 10),
                              CustomAnimatedButton(
                                onPressed: () {
                                  controller.updateSelectedDate();

                                  controller.isSelectedAttchmentOption.value = 2;
                                  controller.isDateFilter.value = true;
                                  controller.isDocument.value = true;
                                  controller.isImage.value = true;
                                  controller.getPatientAttachment();
                                  Get.back();
                                },
                                text: "Apply",
                                enabledColor: AppColors.backgroundPurple,
                                height: 45,
                              ),
                              // ]
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:subqdocs/app/modules/home/controllers/home_controller.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/utils/app_fonts.dart';
import 'package:subqdocs/widgets/custom_button.dart';
import 'package:subqdocs/widgets/custom_toastification.dart';
import 'package:toastification/toastification.dart';

import '../../../../widget/custom_animated_button.dart';
import '../../../../widgets/base_dropdown.dart';
import '../../../../widgets/custom_textfiled.dart';
import '../../../../widgets/date_field.dart';

class SchedulePatientDialog extends GetView<HomeController> {
  RxBool isCalendarOpen = RxBool(true);

  RxBool isLoading = RxBool(false);
  RxnString selectedVisitTimeValue = RxnString();
  DateTime? visitDate = DateTime.now();
  TextEditingController visitDateController = TextEditingController();

  RxList<String> generatedTime = RxList();

  RxList<String> visitTime = RxList([
    "12:00 AM", "12:15 AM", "12:30 AM", "12:45 AM",
    "01:00 AM", "01:15 AM", "01:30 AM", "01:45 AM",
    "02:00 AM", "02:15 AM", "02:30 AM", "02:45 AM",
    "03:00 AM", "03:15 AM", "03:30 AM", "03:45 AM",
    "04:00 AM", "04:15 AM", "04:30 AM", "04:45 AM",
    "05:00 AM", "05:15 AM", "05:30 AM", "05:45 AM",
    "06:00 AM", "06:15 AM", "06:30 AM", "06:45 AM",
    "07:00 AM", "07:15 AM", "07:30 AM", "07:45 AM",
    "08:00 AM", "08:15 AM", "08:30 AM", "08:45 AM",
    "09:00 AM", "09:15 AM", "09:30 AM", "09:45 AM",
    "10:00 AM", "10:15 AM", "10:30 AM", "10:45 AM",
    "11:00 AM", "11:15 AM", "11:30 AM", "11:45 AM",

    // PM times
    "12:00 PM", "12:15 PM", "12:30 PM", "12:45 PM",
    "01:00 PM", "01:15 PM", "01:30 PM", "01:45 PM",
    "02:00 PM", "02:15 PM", "02:30 PM", "02:45 PM",
    "03:00 PM", "03:15 PM", "03:30 PM", "03:45 PM",
    "04:00 PM", "04:15 PM", "04:30 PM", "04:45 PM",
    "05:00 PM", "05:15 PM", "05:30 PM", "05:45 PM",
    "06:00 PM", "06:15 PM", "06:30 PM", "06:45 PM",
    "07:00 PM", "07:15 PM", "07:30 PM", "07:45 PM",
    "08:00 PM", "08:15 PM", "08:30 PM", "08:45 PM",
    "09:00 PM", "09:15 PM", "09:30 PM", "09:45 PM",
    "10:00 PM", "10:15 PM", "10:30 PM", "10:45 PM",
    "11:00 PM", "11:15 PM", "11:30 PM", "11:45 PM"
  ]);

  List<DateTime?> _singleDatePickerValueWithDefaultValue = [
    DateTime.now().add(const Duration(days: 0)),
  ];

  final void Function(String, String) receiveParam;

  SchedulePatientDialog({super.key, required this.receiveParam});
  String getNextRoundedTime() {
    DateTime now = DateTime.now();


    int minutes = now.minute;
    int roundedMinutes = ((minutes + 14) ~/ 15) * 15; // Adding 14 ensures rounding up

    if (roundedMinutes == 60) {

      now = now.add(Duration(minutes: 60 - minutes));
      now = DateTime(now.year, now.month, now.day, now.hour + 1, 0);
    } else {
      now = DateTime(now.year, now.month, now.day, now.hour, roundedMinutes);
    }


    final DateFormat formatter = DateFormat('hh:mm a');
    return formatter.format(now);
  }

  @override
  Widget build(BuildContext context) {
    // print(generateTimeIntervals());
    //
    visitDateController.text = DateFormat('MM/dd/yyyy').format(DateTime.now());
    visitTime.value = generateTimeIntervals(DateTime.now());
    generatedTime.value = generateTimeIntervals(DateTime.now());
    selectedVisitTimeValue.value = generatedTime[0];
    // selectedVisitTimeValue.value = generatedTime.first;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 16,
      child: Obx(() {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 360,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Visit Date",
                            style: AppFonts.regular(14, AppColors.textBlack),
                          ),
                          Text(
                            "*",
                            style: AppFonts.regular(14, AppColors.redText),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        height: 48,
                        padding: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.textDarkGrey.withValues(alpha: 0.5), width: 0.5),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: DateFormatField(
                            decoration: InputDecoration(
                                hintText: "02/23/2024",
                                border: InputBorder.none,
                                suffixIconConstraints: BoxConstraints(maxHeight: 60),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    print("hello world");
                                    isCalendarOpen.value = !isCalendarOpen.value;
                                  },
                                  icon: const Icon(Icons.calendar_month),
                                )),
                            addCalendar: false,
                            controller: visitDateController,
                            type: DateFormatType.type2,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 365)),
                            onComplete: (date) {
                              visitTime.value = generateTimeIntervals(date!);
                              generatedTime.value = generateTimeIntervals(date!);
                              selectedVisitTimeValue.value = generatedTime[0];
                              print("date is :- ${visitDateController.text}");
                              print("DateFormatField date is:-  ${date}");
                              visitDate = date;
                            }),
                      ),
                      if (isCalendarOpen.value) ...[buildSingleDatePickerWithValue()],
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text(
                            "Visit Time",
                            style: AppFonts.regular(14, AppColors.textBlack),
                          ),
                          Text(
                            "*",
                            style: AppFonts.regular(14, AppColors.redText),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Obx(() {
                        return BaseDropdown<String>(
                          valueAsString: (value) => value ?? "",
                          items: visitTime,
                          selectedValue: selectedVisitTimeValue.value,
                          onChanged: (value) {
                            selectedVisitTimeValue.value = value;
                          },
                          selectText: "11 PM",
                        );
                      }),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        spacing: 10,
                        children: [
                          Expanded(
                            child: CustomAnimatedButton(
                              onPressed: () {
                                Get.back();
                              },
                              height: 45,
                              text: "Cancel",
                              isOutline: true,
                              isLoading: isLoading.value,
                              outlineColor: AppColors.backgroundPurple,
                              enabledTextColor: AppColors.backgroundPurple,
                              enabledColor: AppColors.white,
                            ),
                          ),
                          Expanded(
                            child: CustomAnimatedButton(
                              onPressed: () {
                                if (selectedVisitTimeValue.value == null) {
                                  CustomToastification().showToast("Please select Visit time", type: ToastificationType.error);
                                } else {
                                  bool isSameDate = visitDate != null && visitDate?.year == DateTime.now().year && visitDate?.month == DateTime.now().month && visitDate?.day == DateTime.now().day;

                                  if (isSameDate) {
                                    DateTime firstTime = DateFormat('hh:mm a').parse(selectedVisitTimeValue.value ?? "").toUtc(); // 10:30 AM to DateTime

                                    // Now format it to the hh:mm:ss format
                                    String formattedTime = DateFormat('HH:mm:ss').format(firstTime);

                                    DateFormat timeFormat = DateFormat('hh:mm a'); // 12-hour format with AM/PM
                                    DateTime givenTime = timeFormat.parse(selectedVisitTimeValue.value ?? "");

                                    // Combine current date with the given time
                                    DateTime givenDateTime = DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                      DateTime.now().day,
                                      givenTime.hour,
                                      givenTime.minute,
                                    );

                                    print("given time is :- ${givenDateTime}");
                                    print("current time is :- ${DateTime.now()}");

                                    // Compare the times
                                    bool isAhead = givenDateTime.isAfter(DateTime.now());

                                    if (isAhead) {
                                      receiveParam(formattedTime, DateFormat('yyyy-MM-dd').format(DateFormat('MM/dd/yyyy').parse(visitDateController.text.trim())));
                                      // controller.patientScheduleCreate(param: {});
                                      Get.back();
                                    } else {
                                      print('Given time is not ahead of the current time.');
                                      CustomToastification().showToast("Visit time must be in the future", type: ToastificationType.error);
                                    }
                                  } else {
                                    DateTime firstTime = DateFormat('hh:mm a').parse(selectedVisitTimeValue.value ?? "").toUtc(); // 10:30 AM to DateTime

                                    // Now format it to the hh:mm:ss format
                                    String formattedTime = DateFormat('HH:mm:ss').format(firstTime);
                                    print("visit time is $formattedTime");
                                    print("visit date is :- ${DateFormat('yyyy-MM-dd').format(DateFormat('MM/dd/yyyy').parse(visitDateController.text))}");
                                    receiveParam(formattedTime, DateFormat('yyyy-MM-dd').format(DateFormat('MM/dd/yyyy').parse(visitDateController.text)));
                                    Get.back();
                                  }
                                }
                              },
                              height: 45,
                              text: "Schedule Patient",
                              isOutline: true,
                              isLoading: isLoading.value,
                              outlineColor: AppColors.backgroundPurple,
                              enabledTextColor: AppColors.backgroundPurple,
                              enabledColor: AppColors.white,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  Widget buildSingleDatePickerWithValue() {
    return SizedBox(
      width: 400,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          CalendarDatePicker2(
            displayedMonthDate: _singleDatePickerValueWithDefaultValue.first,
            value: _singleDatePickerValueWithDefaultValue,
            onValueChanged: (value) {
              visitTime.value = generateTimeIntervals(value.first);
              generatedTime.value = generateTimeIntervals(value.first);
              selectedVisitTimeValue.value = generatedTime[0];
              print("value is :- ${value.first}");
              visitDate = value.first;
              String padDayMonth(int value) => value.toString().padLeft(2, '0');
              visitDateController.text = '${padDayMonth(value.first.month)}/${padDayMonth(value.first.day)}/${value.first.year}';
            },
            config: CalendarDatePicker2Config(firstDate: DateTime.now()),
          ),
        ],
      ),
    );
  }

  List<String> generateTimeIntervals(DateTime startTime) {
    List<String> times = [];

    bool isSameDate = startTime.year == DateTime.now().year && startTime.month == DateTime.now().month && startTime.day == DateTime.now().day;

    // Get the current date and time
    DateTime currentTime = startTime;

    if (isSameDate) {
      currentTime = DateTime.now();
    }

    // Round the current time to the next 15-minute interval
    int minutes = currentTime.minute;
    int remainingMinutes = (15 - (minutes % 15)) % 15;

    // If we are exactly on a 15-minute boundary (e.g. 3:45 PM), start from the next interval
    if (remainingMinutes == 0) {
      currentTime = currentTime.add(Duration(minutes: 15)); // Skip to next 15-minute mark
    } else {
      // Otherwise, round up to the next 15-minute mark
      currentTime = currentTime.add(Duration(minutes: remainingMinutes));
    }

    // Set the end time to 11:45 PM of the current day
    DateTime endOfDay = DateTime(currentTime.year, currentTime.month, currentTime.day, 23, 45);

    // Loop to add times from the adjusted current time up to 11:45 PM
    while (currentTime.isBefore(endOfDay.add(Duration(minutes: 15)))) {
      String formattedTime = formatTime(currentTime);
      times.add(formattedTime);
      currentTime = currentTime.add(Duration(minutes: 15)); // Increment by 15 minutes
    }
    print(times);
    return times;
  }

  String formatTime(DateTime time) {
    int hour = time.hour;
    int minute = time.minute;
    String period = (hour < 12) ? 'AM' : 'PM';

    // Convert 24-hour format to 12-hour format
    if (hour > 12) hour -= 12;
    if (hour == 0) hour = 12;

    String minuteStr = minute < 10 ? '0$minute' : '$minute';

    return '$hour:$minuteStr $period';
  }
}

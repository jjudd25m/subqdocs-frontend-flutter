import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:subqdocs/app/modules/home/controllers/home_controller.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/utils/app_fonts.dart';
import 'package:subqdocs/widgets/custom_toastification.dart';
import 'package:toastification/toastification.dart';
import '../../../../widget/custom_animated_button.dart';
import '../../../../widget/time_slot_selected.dart';
import '../../../../widgets/date_field.dart';
import '../../../core/common/logger.dart';

class ReschedulePatientDialog extends StatefulWidget {
  final void Function(String, String) receiveParam;

  const ReschedulePatientDialog({super.key, required this.receiveParam});

  @override
  State<ReschedulePatientDialog> createState() => _ReschedulePatientDialogState();
}

class _ReschedulePatientDialogState extends State<ReschedulePatientDialog> {
  RxBool isCalendarOpen = RxBool(true);

  var controller = Get.find<HomeController>();

  RxBool isLoading = RxBool(false);

  RxnString selectedVisitTimeValue = RxnString();

  DateTime? visitDate = DateTime.now();

  TextEditingController visitDateController = TextEditingController();

  RxList<String> generatedTime = RxList();

  RxList<String> visitTime = RxList([
    "12:00 AM", "12:15 AM", "12:30 AM", "12:45 AM",
    "1:00 AM", "1:15 AM", "1:30 AM", "1:45 AM",
    "2:00 AM", "2:15 AM", "2:30 AM", "2:45 AM",
    "3:00 AM", "3:15 AM", "3:30 AM", "3:45 AM",
    "4:00 AM", "4:15 AM", "4:30 AM", "4:45 AM",
    "5:00 AM", "5:15 AM", "5:30 AM", "5:45 AM",
    "6:00 AM", "6:15 AM", "6:30 AM", "6:45 AM",
    "7:00 AM", "7:15 AM", "7:30 AM", "7:45 AM",
    "8:00 AM", "8:15 AM", "8:30 AM", "8:45 AM",
    "9:00 AM", "9:15 AM", "9:30 AM", "9:45 AM",
    "10:00 AM", "10:15 AM", "10:30 AM", "10:45 AM",
    "11:00 AM", "11:15 AM", "11:30 AM", "11:45 AM",

    // PM times
    "12:00 PM", "12:15 PM", "12:30 PM", "12:45 PM",
    "1:00 PM", "1:15 PM", "1:30 PM", "1:45 PM",
    "2:00 PM", "2:15 PM", "2:30 PM", "2:45 PM",
    "3:00 PM", "3:15 PM", "3:30 PM", "3:45 PM",
    "4:00 PM", "4:15 PM", "4:30 PM", "4:45 PM",
    "5:00 PM", "5:15 PM", "5:30 PM", "5:45 PM",
    "6:00 PM", "6:15 PM", "6:30 PM", "6:45 PM",
    "7:00 PM", "7:15 PM", "7:30 PM", "7:45 PM",
    "8:00 PM", "8:15 PM", "8:30 PM", "8:45 PM",
    "9:00 PM", "9:15 PM", "9:30 PM", "9:45 PM",
    "10:00 PM", "10:15 PM", "10:30 PM", "10:45 PM",
    "11:00 PM", "11:15 PM", "11:30 PM", "11:45 PM",
  ]);

  @override
  void initState() {
    visitDateController.text = DateFormat('MM/dd/yyyy').format(DateTime.now());
    visitTime.value = generateTimeIntervals(DateTime.now());
    generatedTime.value = generateTimeIntervals(DateTime.now());
    selectedVisitTimeValue.value = generatedTime[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 16,
      child: Obx(() {
        return Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 360,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [Text("Visit Date", style: AppFonts.regular(14, AppColors.textBlack)), Text("*", style: AppFonts.regular(14, AppColors.redText))]),
                      const SizedBox(height: 8),
                      Container(
                        height: 48,
                        padding: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(border: Border.all(color: AppColors.textDarkGrey.withValues(alpha: 0.5), width: 0.5), color: Colors.white, borderRadius: BorderRadius.circular(6)),
                        child: DateFormatField(
                          decoration: InputDecoration(
                            hintText: "02/23/2024",
                            border: InputBorder.none,
                            suffixIconConstraints: const BoxConstraints(maxHeight: 60),
                            suffixIcon: IconButton(
                              onPressed: () {
                                customPrint("hello world");
                                isCalendarOpen.value = !isCalendarOpen.value;
                              },
                              icon: const Icon(Icons.calendar_month),
                            ),
                          ),
                          addCalendar: false,
                          controller: visitDateController,
                          type: DateFormatType.type2,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                          onComplete: (date) {
                            visitTime.value = generateTimeIntervals(date!);
                            generatedTime.value = generateTimeIntervals(date!);
                            // selectedVisitTimeValue.value = generatedTime[0];
                            customPrint("date is :- ${visitDateController.text}");
                            customPrint("DateFormatField date is:-  $date");
                            visitDate = date;
                          },
                        ),
                      ),
                      if (isCalendarOpen.value) ...[buildSingleDatePickerWithValue()],
                      const SizedBox(height: 5),
                      Row(children: [Text("Visit Time", style: AppFonts.regular(14, AppColors.textBlack)), Text("*", style: AppFonts.regular(14, AppColors.redText))]),
                      const SizedBox(height: 8),

                      TimeSlotTypeAhead(
                        prefixIcon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textDarkGrey),
                        timeSlotSuggestions: visitTime,
                        onSelected: (String value) {
                          selectedVisitTimeValue.value = value;
                        },
                        selectedValue: selectedVisitTimeValue.value ?? "Select Visit Time ",
                      ),
                      // Obx(() {
                      //   return BaseDropdown<String>(
                      //     valueAsString: (value) => value ?? "",
                      //     items: visitTime,
                      //     selectedValue: selectedVisitTimeValue.value,
                      //     onChanged: (value) {
                      //       selectedVisitTimeValue.value = value;
                      //     },
                      //     selectText: "11 PM",
                      //   );
                      // }),
                      const SizedBox(height: 20),
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
                                    DateTime givenDateTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, givenTime.hour, givenTime.minute);

                                    customPrint("given time is :- $givenDateTime");
                                    customPrint("current time is :- ${DateTime.now()}");

                                    // Compare the times
                                    bool isAhead = givenDateTime.isAfter(DateTime.now());

                                    if (isAhead) {
                                      widget.receiveParam(formattedTime, DateFormat('yyyy-MM-dd').format(DateFormat('MM/dd/yyyy').parse(visitDateController.text.trim())));
                                      // controller.patientScheduleCreate(param: {});
                                      Get.back();
                                    } else {
                                      customPrint('Given time is not ahead of the current time.');
                                      CustomToastification().showToast("Visit time must be in the future", type: ToastificationType.error);
                                    }
                                  } else {
                                    DateTime firstTime = DateFormat('hh:mm a').parse(selectedVisitTimeValue.value ?? "").toUtc(); // 10:30 AM to DateTime

                                    // Now format it to the hh:mm:ss format
                                    String formattedTime = DateFormat('HH:mm:ss').format(firstTime);
                                    customPrint("visit time is $formattedTime");
                                    customPrint("visit date is :- ${DateFormat('yyyy-MM-dd').format(DateFormat('MM/dd/yyyy').parse(visitDateController.text))}");
                                    widget.receiveParam(formattedTime, DateFormat('yyyy-MM-dd').format(DateFormat('MM/dd/yyyy').parse(visitDateController.text)));
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
                      ),
                    ],
                  ),
                ),
              ),
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
            value: [visitDate],
            onValueChanged: (value) {
              visitTime.value = generateTimeIntervals(value.first);
              generatedTime.value = generateTimeIntervals(value.first);
              // selectedVisitTimeValue.value = generatedTime[0];
              customPrint("value is :- ${value.first}");
              visitDate = value.first;
              String padDayMonth(int value) => value.toString().padLeft(2, '0');
              visitDateController.text = '${padDayMonth(value.first.month)}/${padDayMonth(value.first.day)}/${value.first.year}';
            },
            config: CalendarDatePicker2Config(firstDate: DateTime.now(), currentDate: DateTime.now()),
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
      currentTime = currentTime.add(const Duration(minutes: 15)); // Skip to next 15-minute mark
    } else {
      // Otherwise, round up to the next 15-minute mark
      currentTime = currentTime.add(Duration(minutes: remainingMinutes));
    }

    // Set the end time to 11:45 PM of the current day
    DateTime endOfDay = DateTime(currentTime.year, currentTime.month, currentTime.day, 23, 45);

    // Loop to add times from the adjusted current time up to 11:45 PM
    while (currentTime.isBefore(endOfDay.add(const Duration(minutes: 15)))) {
      String formattedTime = formatTime(currentTime);
      times.add(formattedTime);
      currentTime = currentTime.add(const Duration(minutes: 15)); // Increment by 15 minutes
    }
    customPrint(times);
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

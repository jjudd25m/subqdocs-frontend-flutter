import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:subqdocs/app/modules/home/controllers/home_controller.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/utils/app_fonts.dart';
import 'package:subqdocs/widgets/custom_toastification.dart';
import 'package:toastification/toastification.dart';

import '../../../../widget/base_image_view.dart';
import '../../../../widget/custom_animated_button.dart';
import '../../../../widget/timePickerTextFiled.dart';
import '../../../../widgets/base_dropdown2.dart';
import '../../../../widgets/date_field.dart';
import '../../../core/common/logger.dart';
import '../../../models/SelectedDoctorMedicationModel.dart';

class SchedulePatientDialog extends StatefulWidget {
  final void Function(String, String, int, int) receiveParam;

  const SchedulePatientDialog({super.key, required this.receiveParam});

  @override
  State<SchedulePatientDialog> createState() => _SchedulePatientDialogState();
}

class _SchedulePatientDialogState extends State<SchedulePatientDialog> {
  RxBool isCalendarOpen = RxBool(true);

  var controller = Get.find<HomeController>();

  RxBool isLoading = RxBool(false);

  RxnString selectedVisitTimeValue = RxnString();

  Rxn<DateTime> visitDate = Rxn(DateTime.now());

  TextEditingController visitDateController = TextEditingController();
  TextEditingController visitTimeController = TextEditingController();

  Rxn<SelectedDoctorModel> selectedDoctorValueModelSchedulePatient = Rxn();

  Rxn<SelectedDoctorModel> selectedMedialValueModelSchedulePatient = Rxn();

  FocusNode rescheduleDoctorFieldFocusNode = FocusNode();

  FocusNode rescheduleMedicalAssistantFieldFocusNode = FocusNode();

  String? selectedDoctorValueSchedule;

  String? selectedMedicalValueSchedule;
  RxList<String> generatedTime = RxList();

  String getNextRoundedTime() {
    DateTime now = DateTime.now();

    int minutes = now.minute;
    int roundedMinutes = ((minutes + 9) ~/ 10) * 10;

    if (roundedMinutes == 60) {
      now = now.add(Duration(minutes: 60 - minutes));
      now = DateTime(now.year, now.month, now.day, now.hour, 0);
    } else {
      now = DateTime(now.year, now.month, now.day, now.hour, roundedMinutes);
    }

    final DateFormat formatter = DateFormat('hh:mm a'); // zero-padded hour
    return formatter.format(now);
  }

  @override
  void initState() {
    visitDateController.text = DateFormat('MM/dd/yyyy').format(visitDate.value!);

    selectedVisitTimeValue.value = getNextRoundedTime();
    visitTimeController.text = selectedVisitTimeValue.value ?? "";

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
          child: SingleChildScrollView(
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
                            initialDate: visitDate.value,
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                            onComplete: (date) {
                              customPrint("date is :- ${visitDateController.text}");
                              customPrint("DateFormatField date is:-  $date");
                              if (date != null) {
                                visitDate.value = date;

                                generatedTime.value = generateTimeIntervals(date);
                                visitTimeController.text = generatedTime.first;
                                selectedVisitTimeValue.value = generatedTime.first;
                              }
                            },
                          ),
                        ),
                        if (isCalendarOpen.value) ...[buildSingleDatePickerWithValue()],
                        const SizedBox(height: 5),
                        Row(children: [Text("Visit Time", style: AppFonts.regular(14, AppColors.textBlack)), Text("*", style: AppFonts.regular(14, AppColors.redText))]),
                        const SizedBox(height: 8),

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
                        TimePickerFormField(
                          key: UniqueKey(),
                          label: "",
                          controller: visitTimeController,
                          onTimePicked: (pickedTime) {
                            selectedVisitTimeValue.value = pickedTime;
                          },
                        ),

                        const SizedBox(height: 8),
                        Row(
                          spacing: 10,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Row(children: [Text("Doctor Name", style: AppFonts.regular(14, AppColors.textBlack))]),
                                  const SizedBox(height: 8),
                                  Obx(() {
                                    return BaseDropdown2<SelectedDoctorModel>(
                                      direction: VerticalDirection.up,
                                      focusNode: rescheduleDoctorFieldFocusNode,
                                      valueAsString: (p) => p?.name ?? "",
                                      items: controller.globalController.selectedDoctorModel.toList(),
                                      selectedValue: selectedDoctorValueModelSchedulePatient.value,
                                      itemBuilder: (model) {
                                        return Container(
                                          color: Colors.white,
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Padding(padding: const EdgeInsets.only(left: 10), child: ClipRRect(borderRadius: BorderRadius.circular(14), child: BaseImageView(height: 32, width: 32, nameLetters: model.name ?? "", fontSize: 12, imageUrl: model.profileImage ?? ""))),
                                              const SizedBox(width: 10),
                                              Expanded(child: Container(color: AppColors.white, child: Text(model.name ?? "", style: AppFonts.medium(14, AppColors.black)))),
                                            ],
                                          ),
                                        );
                                      },

                                      onChanged: (model) {
                                        selectedDoctorValueModelSchedulePatient.value = model;

                                        selectedDoctorValueSchedule = model?.name ?? "";

                                        FocusScope.of(context).unfocus();
                                      },

                                      selectText: selectedDoctorValueSchedule,
                                      isSearchable: true,
                                      controller: TextEditingController(),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          spacing: 10,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Row(children: [Text("Medical Assistant", style: AppFonts.regular(14, AppColors.textBlack))]),
                                  const SizedBox(height: 8),
                                  Obx(() {
                                    return BaseDropdown2<SelectedDoctorModel>(
                                      focusNode: rescheduleMedicalAssistantFieldFocusNode,
                                      direction: VerticalDirection.up,
                                      valueAsString: (p) => p?.name ?? "",
                                      items: controller.globalController.selectedMedicalModel.toList(),
                                      selectedValue: selectedMedialValueModelSchedulePatient.value,
                                      itemBuilder: (model) {
                                        return Container(
                                          color: Colors.white,
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Padding(padding: const EdgeInsets.only(left: 10), child: ClipRRect(borderRadius: BorderRadius.circular(14), child: BaseImageView(height: 32, width: 32, nameLetters: model.name ?? "", fontSize: 12, imageUrl: model.profileImage ?? ""))),
                                              const SizedBox(width: 10),
                                              Expanded(child: Container(color: AppColors.white, child: Text(model.name ?? "", style: AppFonts.medium(14, AppColors.black)))),
                                            ],
                                          ),
                                        );
                                      },

                                      onChanged: (model) {
                                        selectedMedialValueModelSchedulePatient.value = model;

                                        selectedMedicalValueSchedule = model?.name ?? "";

                                        selectedMedialValueModelSchedulePatient.refresh();

                                        FocusScope.of(context).unfocus();
                                      },

                                      selectText: selectedMedicalValueSchedule,
                                      isSearchable: true,
                                      controller: TextEditingController(),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
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
                                  // if (selectedDoctorValueSchedule == null) {
                                  //   CustomToastification().showToast("Please Select Doctor", type: ToastificationType.error);
                                  //   return;
                                  // }

                                  if (selectedVisitTimeValue.value == null) {
                                    CustomToastification().showToast("Please select Visit time", type: ToastificationType.error);
                                  } else {
                                    bool isSameDate = visitDate.value != null && visitDate.value?.year == DateTime.now().year && visitDate.value?.month == DateTime.now().month && visitDate.value?.day == DateTime.now().day;

                                    try {
                                      DateTime firstTime = DateFormat('hh:mm a').parse(visitTimeController.text).toUtc(); // 10:30 AM to DateTime

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
                                          customPrint("doctor id ${controller.globalController.getDoctorIdByName(selectedDoctorValueSchedule)}");
                                          customPrint(" medical id ${controller.globalController.getMedicalIdByName(selectedMedicalValueSchedule)}");

                                          widget.receiveParam(formattedTime, DateFormat('yyyy-MM-dd').format(DateFormat('MM/dd/yyyy').parse(visitDateController.text.trim())), controller.globalController.getDoctorIdByName(selectedDoctorValueSchedule), controller.globalController.getMedicalIdByName(selectedMedicalValueSchedule));
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

                                        customPrint("doctor id ${controller.globalController.getDoctorIdByName(selectedDoctorValueSchedule)}");
                                        customPrint(" medical id ${controller.globalController.getMedicalIdByName(selectedMedicalValueSchedule)}");

                                        widget.receiveParam(formattedTime, DateFormat('yyyy-MM-dd').format(DateFormat('MM/dd/yyyy').parse(visitDateController.text)), controller.globalController.getDoctorIdByName(selectedDoctorValueSchedule), controller.globalController.getMedicalIdByName(selectedMedicalValueSchedule));
                                        Get.back();
                                      }
                                    } catch (e) {
                                      CustomToastification().showToast("Please enter valid time format", type: ToastificationType.error);
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
            value: [visitDate.value],
            onValueChanged: (value) {
              customPrint("value is :- ${value.first}");
              visitDate.value = value.first;
              String padDayMonth(int value) => value.toString().padLeft(2, '0');
              visitDateController.text = '${padDayMonth(value.first.month)}/${padDayMonth(value.first.day)}/${value.first.year}';

              generatedTime.value = generateTimeIntervals(value.first);
              visitTimeController.text = generatedTime.first;
              selectedVisitTimeValue.value = generatedTime.first;

              // visitTimeController ,
              // selectedVisitTimeValue.value = pickedTime;
            },
            config: CalendarDatePicker2Config(firstDate: DateTime.now(), currentDate: DateTime.now()),
          ),
        ],
      ),
    );
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
}

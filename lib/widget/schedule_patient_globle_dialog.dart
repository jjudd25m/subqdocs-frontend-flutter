import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:subqdocs/app/models/ScheduleModel.dart';
import 'package:subqdocs/widget/timePickerTextFiled.dart';
import 'package:subqdocs/widgets/custom_toastification.dart';
import 'package:toastification/toastification.dart';

import '../app/core/common/global_controller.dart';
import '../app/core/common/logger.dart';
import '../app/models/SelectedDoctorMedicationModel.dart';
import '../app/modules/home/model/patient_list_model.dart';
import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';
import '../widgets/base_dropdown2.dart';
import '../widgets/custom_animated_button.dart';
import '../widgets/date_field.dart';
import '../widgets/serachFiledTypeAhed.dart';
import 'base_image_view.dart';

class SchedulePatientGlobleDialog extends StatefulWidget {
  final void Function(String, String) receiveParam;

  const SchedulePatientGlobleDialog({super.key, required this.receiveParam});

  @override
  State<SchedulePatientGlobleDialog> createState() => _SchedulePatientGlobleDialogState();
}

class _SchedulePatientGlobleDialogState extends State<SchedulePatientGlobleDialog> {
  bool isCalendarOpen = true;
  bool isLoading = false;
  final GlobalController globalController = Get.find();

  TextEditingController doctorNameController = TextEditingController();

  List<String> visitTime = [
    "07:00",
    "07:10",
    "07:20",
    "07:30",
    "07:40",
    "07:50",
    "08:00",
    "08:10",
    "08:20",
    "08:30",
    "08:40",
    "08:50",
    "09:00",
    "09:10",
    "09:20",
    "09:30",
    "09:40",
    "09:50",
    "10:00",
    "10:10",
    "10:20",
    "10:30",
    "10:40",
    "10:50",
    "11:00",
    "11:10",
    "11:20",
    "11:30",
    "11:40",
    "11:50",
    "12:00",
    "12:10",
    "12:20",
    "12:30",
    "12:40",
    "12:50",
    "13:00",
    "13:10",
    "13:20",
    "13:30",
    "13:40",
    "13:50",
    "14:00",
    "14:10",
    "14:20",
    "14:30",
    "14:40",
    "14:50",
    "15:00",
    "15:10",
    "15:20",
    "15:30",
    "15:40",
    "15:50",
    "16:00",
    "16:10",
    "16:20",
    "16:30",
    "16:40",
    "16:50",
    "17:00",
    "17:10",
    "17:20",
    "17:30",
    "17:40",
    "17:50",
    "18:00",
    "18:10",
    "18:20",
    "18:30",
    "18:40",
    "18:50",
    "19:00",
    "19:10",
    "19:20",
    "19:30",
    "19:40",
    "19:50",
    "20:00",
    "20:10",
    "20:20",
    "20:30",
    "20:40",
    "20:50",
    "21:00",
    "21:10",
    "21:20",
    "21:30",
    "21:40",
    "21:50",
    "22:00",
    "22:10",
    "22:20",
    "22:30",
    "22:40",
    "22:50",
    "23:00",
    "23:10",
    "23:20",
    "23:30",
    "23:40",
    "23:50",
  ];

  RxList<DateTime?> _singleDatePickerValueWithDefaultValue = RxList([DateTime.now()]);

  FocusNode vistiTimeFocusNode = FocusNode();

  RxList<String> generatedTime = RxList();

  @override
  void initState() {
    super.initState();

    globalController.scheduleVisitModel.value = ScheduleModel(doctorFocusNodeSchedule: FocusNode(), medicationFocusNodeSchedule: FocusNode(), searchNodeSchedule: FocusNode(), timeSlotFocusNodeSchedule: FocusNode());
    globalController.scheduleVisitModel.value?.selectedVisitTimeValue.text = getNextRoundedTime();
    globalController.scheduleVisitModel.value?.visitDateController.text = DateFormat('MM/dd/yyyy').format(DateTime.now());
  }

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
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      color: AppColors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                customPrint("demo click");

                if (globalController.scheduleVisitModel.value?.searchController.text != "") {
                  globalController.scheduleVisitModel.value?.searchController.text = globalController.scheduleVisitModel.value?.selectedPatient ?? "";
                } else {
                  globalController.scheduleVisitModel.value?.selectedPatient = null;
                  globalController.scheduleVisitModel.value?.patientId = null;
                }

                FocusScope.of(context).unfocus();
              },
              child: Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [Text("Select Patient", style: AppFonts.regular(14, AppColors.textBlack)), Text("*", style: AppFonts.regular(14, AppColors.redText))]),
                          const SizedBox(height: 8),
                          Obx(() {
                            return Serachfiledtypeahed<PatientListData>(
                              suggestionsCallback: (search) async {
                                if (search.isNotEmpty) {
                                  return await globalController.getPatientList(searchValue: search);
                                }
                                return [];
                              },
                              suggestionsController: globalController.suggestionsController,
                              controller: globalController.scheduleVisitModel.value?.searchController ?? TextEditingController(),
                              valueAsString: (value) => value?.firstName ?? "",
                              items: globalController.patientList,
                              selectedValue: globalController.searchText.value,
                              isSearchable: true,
                              itemBuilder: (model) {
                                return Container(
                                  color: AppColors.white,
                                  child: Column(
                                    children: [
                                      Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0), child: Row(children: [Text(model.firstName ?? ""), const SizedBox(width: 5), Text(model.lastName ?? "")])),
                                      Container(height: 1, color: AppColors.appbarBorder),
                                    ],
                                  ),
                                );
                              },
                              onChanged: (value) {
                                globalController.scheduleVisitModel.value?.searchController.text = "${value?.firstName ?? ""} ${value?.lastName ?? ""}";

                                // controller.setUi(value);

                                globalController.scheduleVisitModel.value?.patientId = value?.id ?? 0;
                                globalController.scheduleVisitModel.value?.selectedPatient = globalController.scheduleVisitModel.value?.searchController.text ?? "";

                                globalController.searchText.value = value;
                                globalController.searchText.refresh();

                                FocusScope.of(context).unfocus();
                              },
                              selectText: "${globalController.searchText.value?.firstName ?? ""} ${globalController.searchText.value?.lastName ?? ""}",
                            );
                          }),
                          const SizedBox(height: 8),
                          Row(children: [Text("Visit Date", style: AppFonts.regular(14, AppColors.textBlack)), Text("*", style: AppFonts.regular(14, AppColors.redText))]),
                          const SizedBox(height: 8),
                          Container(
                            height: 48,
                            padding: const EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(border: Border.all(color: AppColors.textDarkGrey, width: 0.5), color: Colors.white, borderRadius: BorderRadius.circular(6)),
                            child: DateFormatField(
                              decoration: InputDecoration(hintText: "02/23/2024", border: InputBorder.none, suffixIcon: IconButton(onPressed: () => setState(() => isCalendarOpen = !isCalendarOpen), icon: const Icon(Icons.calendar_month))),
                              addCalendar: false,
                              controller: globalController.scheduleVisitModel.value?.visitDateController,
                              type: DateFormatType.type2,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                              onComplete: (date) {
                                if (date != null) {
                                  _singleDatePickerValueWithDefaultValue.value = [date];
                                  setState(() {
                                    globalController.scheduleVisitModel.value?.visitDate = date;
                                  });
                                }
                              },
                            ),
                          ),
                          if (isCalendarOpen) buildSingleDatePickerWithValue(),
                          const SizedBox(height: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [Text("Visit Time", style: AppFonts.regular(14, AppColors.textBlack)), Text("*", style: AppFonts.regular(14, AppColors.redText))]),
                              const SizedBox(height: 8),
                              // key: UniqueKey(),
                              TimePickerFormField(label: "", controller: globalController.scheduleVisitModel.value?.selectedVisitTimeValue, onTimePicked: (pickedTime) {}),
                            ],
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
                                        focusNode: globalController.scheduleVisitModel.value?.doctorFocusNodeSchedule,
                                        direction: VerticalDirection.up,
                                        valueAsString: (p) => p?.name ?? "",
                                        items: globalController.selectedDoctorModel.toList(),
                                        selectedValue: globalController.scheduleVisitModel.value?.selectedDoctorValueModelSchedulePatient.value,

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
                                          globalController.scheduleVisitModel.value?.selectedDoctorValueModelSchedulePatient.value = model;

                                          globalController.scheduleVisitModel.value?.selectedDoctorValueSchedule = model?.name ?? "";

                                          globalController.scheduleVisitModel.refresh();

                                          FocusScope.of(context).unfocus();
                                        },

                                        selectText: globalController.scheduleVisitModel.value?.selectedDoctorValueSchedule,
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
                                        focusNode: globalController.scheduleVisitModel.value?.medicationFocusNodeSchedule,
                                        direction: VerticalDirection.up,
                                        valueAsString: (p) => p?.name ?? "",
                                        items: globalController.selectedMedicalModel.toList(),
                                        selectedValue: globalController.scheduleVisitModel.value?.selectedMedicationModelSchedulePatient.value,

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
                                          globalController.scheduleVisitModel.value?.selectedMedicationModelSchedulePatient.value = model;

                                          globalController.scheduleVisitModel.value?.selectedMedicationValueSchedule = model?.name ?? "";

                                          globalController.scheduleVisitModel.refresh();
                                          globalController.scheduleVisitModel.value?.selectedMedicationModelSchedulePatient.refresh();
                                          FocusScope.of(context).unfocus();
                                        },

                                        selectText: globalController.scheduleVisitModel.value?.selectedMedicationValueSchedule,
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
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: CustomAnimatedButton(
                  onPressed: () {
                    globalController.searchText.value = null;
                    Navigator.pop(context);
                  },
                  height: 45,
                  text: "Cancel",
                  isOutline: true,
                  isLoading: isLoading,
                  outlineColor: AppColors.backgroundPurple,
                  enabledTextColor: AppColors.backgroundPurple,
                  enabledColor: AppColors.white,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomAnimatedButton(
                  onPressed: () {
                    globalController.searchText.value = null;

                    try {
                      String? time = globalController.scheduleVisitModel.value?.selectedVisitTimeValue.text;
                      if (time != null) {
                        customPrint("before time");
                        DateTime firstTime = DateFormat('hh:mm a').parse(time).toUtc(); // 10:30 AM to DateTime

                        globalController.scheduledVisit();
                      }
                    } catch (e) {
                      CustomToastification().showToast("Please enter valid time format", type: ToastificationType.error);
                    }
                  },
                  height: 45,
                  text: "Schedule Patient",
                  isOutline: true,
                  isLoading: isLoading,
                  outlineColor: AppColors.backgroundPurple,
                  enabledTextColor: AppColors.white,
                  enabledColor: AppColors.backgroundPurple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool isSelectedDateToday(DateTime selectedDate) {
    DateTime now = DateTime.now();

    return selectedDate.year == now.year && selectedDate.month == now.month && selectedDate.day == now.day;
  }

  Widget buildSingleDatePickerWithValue() {
    return SizedBox(
      width: 400,
      child: Column(
        children: [
          const SizedBox(height: 10),
          Obx(() {
            return CalendarDatePicker2(
              displayedMonthDate: globalController.scheduleVisitModel.value?.visitDate,
              value: _singleDatePickerValueWithDefaultValue,
              onValueChanged: (value) {
                setState(() {
                  _singleDatePickerValueWithDefaultValue.value = value; // ✅ Update the state variable

                  final selectedDate = value.first;

                  if (isSelectedDateToday(selectedDate)) {
                    // visitTime.value = generateTimeIntervals(value.first);
                    generatedTime.value = generateTimeIntervals(value.first);
                    globalController.scheduleVisitModel.value?.selectedVisitTimeValue.text = generatedTime[0];
                  }
                  globalController.scheduleVisitModel.value?.visitDate = selectedDate;

                  // String pad(int v) => v.toString().padLeft(2, '0');
                  String padDayMonth(int value) => value.toString().padLeft(2, '0');
                  // globalController.scheduleVisitModel.value?.visitDateController.text = '${pad(selectedDate?.month ?? 0)}/${pad(selectedDate?.day ?? 0)}/${selectedDate?.year ?? ''}';
                  globalController.scheduleVisitModel.value?.visitDateController.text = '${padDayMonth(value.first.month)}/${padDayMonth(value.first.day)}/${value.first.year}';
                });
              },
              config: CalendarDatePicker2Config(firstDate: DateTime.now()),
            );
          }),
        ],
      ),
    );
  }

  List<String> generateTimeIntervals(DateTime date) {
    List<String> times = [];
    DateTime now = DateTime.now();
    DateTime start = date.year == now.year && date.month == now.month && date.day == now.day ? now : date;

    int minutes = start.minute;
    int remaining = (15 - (minutes % 15)) % 15;
    start = remaining == 0 ? start.add(const Duration(minutes: 15)) : start.add(Duration(minutes: remaining));

    DateTime end = DateTime(start.year, start.month, start.day, 23, 45);

    while (start.isBefore(end.add(const Duration(minutes: 1)))) {
      times.add(formatTime(start));
      start = start.add(const Duration(minutes: 15));
    }
    return times;
  }

  String formatTime(DateTime time) {
    int hour = time.hour;
    int minute = time.minute;
    String period = hour < 12 ? 'AM' : 'PM';
    if (hour > 12) hour -= 12;
    if (hour == 0) hour = 12;
    return '$hour:${minute.toString().padLeft(2, '0')} $period';
  }
}

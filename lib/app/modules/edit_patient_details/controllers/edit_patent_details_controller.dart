import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../widgets/custom_toastification.dart';
import '../../home/model/patient_list_model.dart';
import '../model/patient_detail_model.dart';
import '../repository/edit_patient_details_repository.dart';

class EditPatentDetailsController extends GetxController {
  //TODO: Implement EditPatentDetailsController

  PatientDetailModel patientDetailModel = PatientDetailModel();
  final EditPatientDetailsRepository _editPatientDetailsRepository = EditPatientDetailsRepository();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController visitDateController = TextEditingController();
  TextEditingController patientIdController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  RxnString selectedSexValue = RxnString();
  RxnString selectedPatientValue = RxnString();
  RxnString selectedVisitTimeValue = RxnString();
  RxList<String> visitTime = RxList([]);
  List<String> sex = ["Female", "Male"];
  List<String> patientType = ["New Patient", "Old Patient"];
  // PatientListData patientListData = PatientListData();

  String patientId = "";

  RxBool isLoading = RxBool(false);

  RxString dob = RxString("");
  RxString visitDate = RxString("");

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();

    patientId = Get.arguments["patientData"];
    getPatient(patientId);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getPatient(String id) async {
    patientDetailModel = await _editPatientDetailsRepository.getPatient(id: id);

    firstNameController.text = patientDetailModel.responseData?.firstName ?? "";
    middleNameController.text = patientDetailModel.responseData?.middleName ?? "";
    lastNameController.text = patientDetailModel.responseData?.lastName ?? "";

    print("dob is :- ${patientDetailModel.responseData?.dateOfBirth}");

    // Parse the date string to a DateTime object
    DateTime dateTime = DateTime.parse(patientDetailModel.responseData?.dateOfBirth ?? "").toLocal();

    // Create a DateFormat to format the date
    DateFormat dateFormat = DateFormat('MM/dd/yyyy');

    // Format the DateTime object to the desired format
    String formattedDate = dateFormat.format(dateTime);

    dobController.text = formattedDate;
    print("dob is :- $formattedDate");

    emailAddressController.text = patientDetailModel.responseData?.email ?? "";

    print("dob is :- ${patientDetailModel.responseData?.dateOfBirth}");

    // Parse the date string to a DateTime object
    DateTime visitdateTime = DateTime.parse(patientDetailModel.responseData?.visitTime ?? "").toLocal();

    // Create a DateFormat to format the date
    DateFormat visitdateFormat = DateFormat('MM/dd/yyyy');

    // Format the DateTime object to the desired format
    String visitformattedDate = visitdateFormat.format(visitdateTime);

    visitDateController.text = visitformattedDate;

    // time

    // Parse the date string to a DateTime object
    DateTime visitTimeS = DateTime.parse(patientDetailModel.responseData?.visitTime ?? "").toLocal();

    // Create a DateFormat to format the date
    DateFormat visitTimeFormat = DateFormat('hh:mm a');

    // Format the DateTime object to the desired format
    String visitformattedTime = visitTimeFormat.format(visitTimeS);

    print("visitformattedTime is:- $visitformattedTime");

    selectedVisitTimeValue.value = visitformattedTime;

    selectedSexValue.value = patientDetailModel.responseData?.gender ?? "";
    // selectedVisitTimeValue.value = patientListData.visits?.last.visitTime ?? "";

    visitTime.value = generateTimeIntervals(visitdateTime);
    // selectedVisitTimeValue.value = visitTime.firstOrNull!;
  }

  List<String> generateTimeIntervals(DateTime date) {
    List<String> times = [];
    DateTime currentTime;

    // Get the current time rounded to the next 15-minute increment
    DateTime now = DateTime.now().toLocal();
    int minutes = now.minute;
    int nextQuarter = (minutes ~/ 15 + 1) * 15;

    // Round up the current time to the next 15-minute interval
    if (nextQuarter == 60) {
      currentTime = DateTime(now.year, now.month, now.day, now.hour + 1, 0); // Next hour
    } else {
      currentTime = DateTime(now.year, now.month, now.day, now.hour, nextQuarter);
    }

    // Scenario 1: If the input date is today
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      DateTime midnight = DateTime(now.year, now.month, now.day + 1); // Midnight of the next day

      while (currentTime.isBefore(midnight)) {
        String formattedTime = formatTime(currentTime);
        times.add(formattedTime);
        currentTime = currentTime.add(Duration(minutes: 15)); // Increment by 15 minutes
      }
    } else {
      // Scenario 2: If the input date is any other date
      currentTime = DateTime(date.year, date.month, date.day, 0, 0); // Start at 12:00 AM of the passed date

      for (int i = 0; i < 96; i++) {
        // 24 hours = 96 slots of 15 minutes
        String formattedTime = formatTime(currentTime);
        times.add(formattedTime);
        currentTime = currentTime.add(Duration(minutes: 15)); // Increment by 15 minutes
      }
    }

    return times;
  }

  String formatTime(DateTime time) {
    int hour = time.hour;
    int minute = time.minute;

    String period = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12;
    if (hour == 0) hour = 12; // Handle midnight and noon

    String minuteStr = minute.toString().padLeft(2, '0');
    return '$hour:$minuteStr $period';
  }

  void showVisitDateCupertinoDatePicker(BuildContext context, TextEditingController control) {
    DateTime _selectedDate = DateTime.now();

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text(
            "Pick a Date",
            style: AppFonts.medium(16, AppColors.black),
          ),
          actions: <Widget>[
            Container(
              height: 400,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                minimumDate: DateTime.now().subtract(Duration(hours: 1)),
                initialDateTime: _selectedDate,
                onDateTimeChanged: (DateTime newDate) {
                  _selectedDate = newDate;
                  // Update the TextField with selected date
                  String formattedDate = DateFormat('dd/MM/yyyy').format(_selectedDate);
                  String strDate = DateFormat('yyyy-MM-ddTHH:mm:ss.sssZ').format(_selectedDate);

                  if (control == dobController) {
                    dob.value = strDate;
                    print("controller dob is :- ${dob}");
                  }

                  if (control == visitDateController) {
                    visitDate.value = strDate;
                  }

                  control.text = formattedDate;

                  visitTime.value = generateTimeIntervals(newDate);
                  selectedVisitTimeValue.value = visitTime.firstOrNull!;
                  print('${_selectedDate.toLocal()}'.split(' ')[0]);
                },
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  void showDOBCupertinoDatePicker(BuildContext context, TextEditingController control) {
    DateTime _selectedDate = DateTime.now();

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text(
            "Pick a Date",
            style: AppFonts.medium(16, AppColors.black),
          ),
          actions: <Widget>[
            Container(
              height: 400,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: _selectedDate,
                maximumDate: control == dobController ? DateTime.now() : DateTime.now().add(Duration(days: 365)),
                minimumDate: control == visitDateController ? DateTime.now() : DateTime.now().subtract(Duration(days: 10950)),
                onDateTimeChanged: (DateTime newDate) {
                  _selectedDate = newDate;
                  // Update the TextField with selected date
                  String formattedDate = DateFormat('dd/MM/yyyy').format(_selectedDate);
                  String strDate = DateFormat('yyyy-MM-ddTHH:mm:ss.sssZ').format(_selectedDate);

                  if (control == dobController) {
                    dob.value = strDate;
                    print("controller dob is :- ${dob}");
                  }

                  if (control == visitDateController) {
                    visitDate.value = strDate;
                  }

                  control.text = formattedDate;

                  print('${_selectedDate.toLocal()}'.split(' ')[0]);
                },
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  Future<void> addPatient() async {
    isLoading.value = true;

    DateTime finalDateTimeFromString = mergeDateAndTimeFromString(visitDate.value, selectedVisitTimeValue.value ?? "");
    // DateTime finalDateTimeFromDateTime = mergeDateAndTimeFromDateTime(selectedDateTime, selectedTime);

    String strVisit_time = DateFormat('yyyy-MM-ddTHH:mm:ss.sssZ').format(finalDateTimeFromString);

    print("Merged DateTime from String: $finalDateTimeFromString");
    // print("Merged DateTime from DateTime: $finalDateTimeFromDateTime");

    Map<String, dynamic> param = {};

    patientDetailModel.responseData?.firstName = firstNameController.text;
    patientDetailModel.responseData?.middleName = middleNameController.text;
    patientDetailModel.responseData?.lastName = lastNameController.text;
    patientDetailModel.responseData?.dateOfBirth = '${dob.value}Z';
    patientDetailModel.responseData?.gender = selectedSexValue.value;
    patientDetailModel.responseData?.email = emailAddressController.text;
    patientDetailModel.responseData?.visitTime = '${strVisit_time}Z';
    patientDetailModel.responseData?.visitDate = '${visitDate.value}Z';

    // param['first_name'] = firstNameController.text;
    // param['middle_name'] = middleNameController.text;
    // param['last_name'] = lastNameController.text;
    // param['date_of_birth'] = '${dob.value}Z';
    // param['gender'] = selectedSexValue.value;
    // param['email'] = emailAddressController.text;
    // param['visit_date'] = '${visitDate.value}Z';
    // param['visit_time'] = '${strVisit_time}Z';

    print("param is :- ${patientDetailModel.responseData?.toJson()}");

    try {
      dynamic response = await _editPatientDetailsRepository.updatePatient(id: patientDetailModel.responseData!.patientId!, param: patientDetailModel.responseData!.toJson());
      isLoading.value = false;
      print("_editPatientDetailsRepository response is ${response} ");
      Get.back();
    } catch (error) {
      isLoading.value = false;
      print("_addPatientRepository catch error is $error");
      CustomToastification().showToast("$error", type: ToastificationType.error);
    }
  }

  DateTime mergeDateAndTimeFromString(String dateString, String timeString) {
    DateTime dateTime = DateTime.parse(dateString); // Convert string to DateTime

    // Parse the time to extract hour and minute
    DateTime time = parseTime(timeString);

    // Return a new DateTime with merged date and time
    return DateTime(dateTime.year, dateTime.month, dateTime.day, time.hour, time.minute);
  }

  DateTime parseTime(String timeString) {
    // Extract the hour and minute, and convert to 24-hour format
    RegExp timeRegExp = RegExp(r"(\d{1,2}):(\d{2}) (AM|PM)");
    Match? match = timeRegExp.firstMatch(timeString);

    if (match != null) {
      int hour = int.parse(match.group(1)!);
      int minute = int.parse(match.group(2)!);
      String period = match.group(3)!;

      // Convert hour to 24-hour format
      if (period == "PM" && hour != 12) {
        hour += 12;
      } else if (period == "AM" && hour == 12) {
        hour = 0;
      }

      return DateTime(0, 1, 1, hour, minute); // Return DateTime with hour and minute only
    } else {
      throw FormatException("Invalid time format.");
    }
  }
}

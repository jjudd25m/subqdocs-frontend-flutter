import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

import '../../../../services/media_picker_services.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/app_string.dart';
import '../../../../widgets/custom_toastification.dart';
import '../../../core/common/app_preferences.dart';
import '../../home/model/patient_list_model.dart';
import '../../login/model/login_model.dart';
import '../model/patient_detail_model.dart';
import '../repository/edit_patient_details_repository.dart';

class EditPatentDetailsController extends GetxController {
  //TODO: Implement EditPatentDetailsController

  PatientDetailModel patientDetailModel = PatientDetailModel();
  final EditPatientDetailsRepository _editPatientDetailsRepository = EditPatientDetailsRepository();
  TextEditingController firstNameController = TextEditingController();
  // TextEditingController patientIdController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController visitDateController = TextEditingController();
  TextEditingController patientIdController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  RxnString selectedSexValue = RxnString();
  RxnString profileImageUrl = RxnString();
  RxnString selectedPatientValue = RxnString();
  RxnString selectedVisitTimeValue = RxnString();

  Rxn<File> profileImage = Rxn();
  List<String> visitTime = [
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
  ];
  List<String> sex = ["Female", "Male"];
  List<String> patientType = ["New Patient", "Old Patient"];
  // PatientListData patientListData = PatientListData();

  String patientId = "";
  String visitId = "";

  RxBool isFromSchedule = RxBool(true);

  // bool f

  RxBool isLoading = RxBool(false);

  RxString dob = RxString("");
  RxString visitDate = RxString("");

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();

    print("edit patient list  ${Get.arguments["patientData"]}");

    patientId = Get.arguments["patientData"];
    visitId = Get.arguments["visitId"];
    isFromSchedule.value = Get.arguments["fromSchedule"];

    isFromSchedule.refresh();

    getPatient(patientId, visitId);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getPatient(String id, String visitId) async {
    Map<String, dynamic> param = {};

    if (visitId != "") {
      param['visit_id'] = visitId;
    }

    patientDetailModel = await _editPatientDetailsRepository.getPatient(id: id, param: param);
    firstNameController.text = patientDetailModel.responseData?.firstName ?? "";
    middleNameController.text = patientDetailModel.responseData?.middleName ?? "";
    lastNameController.text = patientDetailModel.responseData?.lastName ?? "";
    selectedSexValue.value = patientDetailModel.responseData?.gender;
    profileImageUrl.value = patientDetailModel.responseData?.profileImage;
    patientIdController.text = patientDetailModel.responseData?.patientId.toString() ?? "";

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

    if (isFromSchedule.value) {
      print(" at the time of the get the time  ${patientDetailModel.responseData?.visitTime} ");
      DateTime visitdateTime = DateTime.parse(patientDetailModel.responseData?.visitTime ?? "").toLocal();

      // Create a DateFormat to format the date
      DateFormat visitdateFormat = DateFormat('MM/dd/yyyy');

      // Format the DateTime object to the desired format
      String visitformattedDate = visitdateFormat.format(visitdateTime);

      visitDateController.text = visitformattedDate;
    }

    // time
    //
    // // Parse the date string to a DateTime object
    // DateTime visitTimeS = DateTime.parse(patientDetailModel.responseData?.visitTime ?? "").toLocal();
    //
    // // Create a DateFormat to format the date
    // DateFormat visitTimeFormat = DateFormat('hh:mm a');

    // // Format the DateTime object to the desired format
    // String visitformattedTime = visitTimeFormat.format(visitTimeS);
    //
    //
    // print("visitformattedTime is:- $visitformattedTime");

    if (isFromSchedule.value) {
      DateTime visitTimeS =
          DateTime.parse(patientDetailModel.responseData?.visitTime ?? ""); // Parsing the string to DateTime

      // Formatting to "hh:mm a" format
      String formattedTime = DateFormat('hh:mm a').format(visitTimeS.toLocal());

      print("visitformattedTime is:- $formattedTime");

      selectedVisitTimeValue.value = formattedTime;
    }

    // selectedVisitTimeValue.value = visitformattedTime;

    selectedSexValue.value = patientDetailModel.responseData?.gender ?? "";
    // selectedVisitTimeValue.value = patientListData.visits?.last.visitTime ?? "";

    // visitTime.value = generateTimeIntervals(visitdateTime);
    // selectedVisitTimeValue.value = visitTime.firstOrNull!;
  }

  // List<String> generateTimeIntervals(DateTime date) {
  //   List<String> times = [];
  //   DateTime currentTime;
  //
  //   // Get the current time rounded to the next 15-minute increment
  //   DateTime now = DateTime.now().toLocal();
  //   int minutes = now.minute;
  //   int nextQuarter = (minutes ~/ 15 + 1) * 15;
  //
  //   // Round up the current time to the next 15-minute interval
  //   if (nextQuarter == 60) {
  //     currentTime = DateTime(now.year, now.month, now.day, now.hour + 1, 0); // Next hour
  //   } else {
  //     currentTime = DateTime(now.year, now.month, now.day, now.hour, nextQuarter);
  //   }
  //
  //   // Scenario 1: If the input date is today
  //   if (date.year == now.year && date.month == now.month && date.day == now.day) {
  //     DateTime midnight = DateTime(now.year, now.month, now.day + 1); // Midnight of the next day
  //
  //     while (currentTime.isBefore(midnight)) {
  //       String formattedTime = formatTime(currentTime);
  //       times.add(formattedTime);
  //       currentTime = currentTime.add(Duration(minutes: 15)); // Increment by 15 minutes
  //     }
  //   } else {
  //     // Scenario 2: If the input date is any other date
  //     currentTime = DateTime(date.year, date.month, date.day, 0, 0); // Start at 12:00 AM of the passed date
  //
  //     for (int i = 0; i < 96; i++) {
  //       // 24 hours = 96 slots of 15 minutes
  //       String formattedTime = formatTime(currentTime);
  //       times.add(formattedTime);
  //       currentTime = currentTime.add(Duration(minutes: 15)); // Increment by 15 minutes
  //     }
  //   }
  //
  //   return times;
  // }
  //
  // String formatTime(DateTime time) {
  //   int hour = time.hour;
  //   int minute = time.minute;
  //
  //   String period = hour >= 12 ? 'PM' : 'AM';
  //   hour = hour % 12;
  //   if (hour == 0) hour = 12; // Handle midnight and noon
  //
  //   String minuteStr = minute.toString().padLeft(2, '0');
  //   return '$hour:$minuteStr $period';
  // }

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

                  // visitTime.value = generateTimeIntervals(newDate);
                  // selectedVisitTimeValue.value = visitTime.firstOrNull!;
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
                minimumDate:
                    control == visitDateController ? DateTime.now() : DateTime.now().subtract(Duration(days: 10950)),
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
    if (!isFromSchedule.value) {
      visitDateController.clear();
    }
    isLoading.value = true;

    Map<String, dynamic> param = {};
    Map<String, List<File>> profileParams = {};

    param['first_name'] = firstNameController.text;
    if (profileImage.value != null) {
      print("profile is   available");
      // param['profile_image'] = profileImage.value;
      profileParams['profile_image'] = [profileImage.value!];
    } else {
      print("profile is not  available");
    }

    // if (selectedList.isNotEmpty) {
    //   print("profile is   available");
    //   // param['profile_image'] = profileImage.value;
    //   // profileParams['attachments'] = .map((model) => model.file).toList().whereType<File>().toList();
    //
    //   ;
    // } else {
    //   print("profile is not  available");
    // }

    param['patient_id'] = patientIdController.text;

    if (middleNameController.text != "") {
      param['middle_name'] = middleNameController.text;
    }
    param['last_name'] = lastNameController.text;
    param['date_of_birth'] = DateFormat('yyyy-MM-dd').format(DateFormat('MM/dd/yyyy').parse(dobController.text));

    param['gender'] = selectedSexValue.value;
    if (emailAddressController.text != "") {
      param['email'] = emailAddressController.text;
    }

    if (visitDateController.text != "") {
      param['visit_date'] = DateFormat('yyyy-MM-dd').format(DateFormat('MM/dd/yyyy').parse(visitDateController.text));
    }

    String date = visitDateController.text;
    String? time = selectedVisitTimeValue.value;
    print(visitDateController.text);
    print(selectedVisitTimeValue.value);

    // DateTime dt = DateFormat("hh:mm:ss a").parse("10:30:00").toLocal();

    if (time != null) {
      DateTime firstTime = DateFormat('hh:mm a').parse(time); // 10:30 AM to DateTime

      // Now format it to the hh:mm:ss format
      String formattedTime = DateFormat('hh:mm:ss').format(firstTime);

      print("date time is ${formattedTime}");

      param['visit_time'] = formattedTime;
    }

    print("param is :- $param");

    try {
      var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));
      dynamic response = await _editPatientDetailsRepository.updatePatient(
          files: profileParams, id: patientId, param: param, token: loginData.responseData?.token ?? "");

      isLoading.value = false;
      print("_editPatientDetailsRepository response is ${response} ");
      Get.back(result: 1);
    } catch (error) {
      isLoading.value = false;
      print("_addPatientRepository catch error is $error");
      CustomToastification().showToast("$error", type: ToastificationType.error);
    }
  }

  Future<void> pickProfileImage() async {
    XFile? pickedImage = await MediaPickerServices().pickImage(fromCamera: false);

    if (pickedImage != null) {
      profileImage.value = File(pickedImage.path);
      profileImage.refresh();
    }
  }

  Future<void> captureProfileImage() async {
    XFile? pickedImage = await MediaPickerServices().pickImage();
    print("picked image is  ${pickedImage}");

    if (pickedImage != null) {
      profileImage.value = File(pickedImage.path);
      profileImage.refresh();
    }
  }
}

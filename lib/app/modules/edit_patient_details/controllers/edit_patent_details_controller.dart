import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

import '../../../../services/media_picker_services.dart';
import '../../../../utils/Loader.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/app_string.dart';
import '../../../../widgets/custom_toastification.dart';
import '../../../core/common/app_preferences.dart';
import '../../../core/common/logger.dart';
import '../../home/model/patient_list_model.dart';
import '../../login/model/login_model.dart';
import '../model/patient_detail_model.dart';
import '../repository/edit_patient_details_repository.dart';

class EditPatentDetailsController extends GetxController {
  //TODO: Implement EditPatentDetailsController

  Rxn<DateTime> selectedDOBDate = Rxn<DateTime>();

  PatientDetailModel patientDetailModel = PatientDetailModel();
  final EditPatientDetailsRepository _editPatientDetailsRepository = EditPatientDetailsRepository();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
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

  String patientId = "";
  String visitId = "";

  RxBool isFromSchedule = RxBool(true);
  RxBool isLoading = RxBool(false);

  RxString dob = RxString("");
  RxString visitDate = RxString("");

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();

    customPrint("edit patient list  ${Get.arguments["patientData"]}");

    patientId = Get.arguments["patientData"];
    visitId = Get.arguments["visitId"];
    isFromSchedule.value = Get.arguments["fromSchedule"];

    isFromSchedule.refresh();
    contactNumberController.text = "+1";

    getPatient(patientId, visitId);
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

    customPrint("dob is :- ${patientDetailModel.responseData?.dateOfBirth}");

    // Parse the date string to a DateTime object
    DateTime dateTime = DateTime.parse(patientDetailModel.responseData?.dateOfBirth ?? "").toLocal();

    // Create a DateFormat to format the date
    DateFormat dateFormat = DateFormat('MM/dd/yyyy');

    // Format the DateTime object to the desired format
    String formattedDate = dateFormat.format(dateTime);

    dobController.text = formattedDate;
    customPrint("dob is :- $formattedDate");

    emailAddressController.text = patientDetailModel.responseData?.email ?? "";
    contactNumberController.text = patientDetailModel.responseData?.contactNumber ?? "+1";

    customPrint("dob is :- ${patientDetailModel.responseData?.dateOfBirth}");

    // Parse the date string to a DateTime object

    if (isFromSchedule.value) {
      customPrint(" at the time of the get the time  ${patientDetailModel.responseData?.visitTime} ");
      DateTime visitdateTime = DateTime.parse(patientDetailModel.responseData?.visitTime ?? "");

      // Create a DateFormat to format the date
      DateFormat visitdateFormat = DateFormat('MM/dd/yyyy');

      // Format the DateTime object to the desired format
      String visitformattedDate = visitdateFormat.format(visitdateTime);

      visitDateController.text = visitformattedDate;
    }

    if (isFromSchedule.value) {
      DateTime visitTimeS = DateTime.parse(patientDetailModel.responseData?.visitTime ?? ""); // Parsing the string to DateTime

      // Formatting to "hh:mm a" format
      String formattedTime = DateFormat('hh:mm a').format(visitTimeS.toLocal());

      customPrint("visitformattedTime is:- $formattedTime");

      selectedVisitTimeValue.value = formattedTime;
    }

    selectedSexValue.value = patientDetailModel.responseData?.gender ?? "";
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
                  String formattedDate = DateFormat('MM/dd/yyyy').format(_selectedDate);
                  String strDate = DateFormat('yyyy-MM-ddTHH:mm:ss.sssZ').format(_selectedDate);

                  if (control == dobController) {
                    dob.value = strDate;
                    customPrint("controller dob is :- ${dob}");
                  }

                  if (control == visitDateController) {
                    visitDate.value = strDate;
                  }

                  control.text = formattedDate;

                  customPrint('${_selectedDate.toLocal()}'.split(' ')[0]);
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
                  String formattedDate = DateFormat('MM/dd/yyyy').format(_selectedDate);
                  String strDate = DateFormat('yyyy-MM-ddTHH:mm:ss.sssZ').format(_selectedDate);

                  if (control == dobController) {
                    dob.value = strDate;
                    customPrint("controller dob is :- ${dob}");
                  }

                  if (control == visitDateController) {
                    visitDate.value = strDate;
                  }

                  control.text = formattedDate;

                  customPrint('${_selectedDate.toLocal()}'.split(' ')[0]);
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
    Loader().showLoadingDialogForSimpleLoader();

    if (!isFromSchedule.value) {
      visitDateController.clear();
    }
    isLoading.value = true;

    Map<String, dynamic> param = {};
    Map<String, List<File>> profileParams = {};

    param['first_name'] = firstNameController.text;
    if (profileImage.value != null) {
      customPrint("profile is   available");
      // param['profile_image'] = profileImage.value;
      profileParams['profile_image'] = [profileImage.value!];
    } else {
      customPrint("profile is not  available");
    }

    param['patient_id'] = patientIdController.text;

    if (visitId != "") {
      param['visit_id'] = visitId;
    }

    if (middleNameController.text != "") {
      param['middle_name'] = middleNameController.text;
    }
    param['last_name'] = lastNameController.text;
    param['date_of_birth'] = DateFormat('yyyy-MM-dd').format(DateFormat('MM/dd/yyyy').parse(dobController.text));

    param['gender'] = selectedSexValue.value;
    if (emailAddressController.text != "") {
      param['email'] = emailAddressController.text;
    }
    if (contactNumberController.text != "") {
      param['contact_no'] = contactNumberController.text.trim();
    }

    if (visitDateController.text != "") {
      param['visit_date'] = DateFormat('yyyy-MM-dd').format(DateFormat('MM/dd/yyyy').parse(visitDateController.text));
    }

    String date = visitDateController.text;
    String? time = selectedVisitTimeValue.value;
    customPrint(visitDateController.text);
    customPrint(selectedVisitTimeValue.value);

    if (time != null) {
      DateTime firstTime = DateFormat('hh:mm a').parse(time).toUtc(); // 10:30 AM to DateTime

      // Now format it to the hh:mm:ss format
      String formattedTime = DateFormat('HH:mm:ss').format(firstTime);

      customPrint("date time is ${formattedTime}");

      param['visit_time'] = formattedTime;
    }

    if (isFromSchedule.value) {
      param['visit_id'] = visitId;
    }

    customPrint("param is :- $param");

    try {
      var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

      dynamic response = await _editPatientDetailsRepository.updatePatient(files: profileParams, id: patientId, param: param, token: loginData.responseData?.token ?? "");

      isLoading.value = false;
      customPrint("_editPatientDetailsRepository response is ${response} ");
      Get.back();
      Get.back(result: 1);
    } catch (error) {
      Get.back();
      isLoading.value = false;
      customPrint("_addPatientRepository catch error is $error");
      CustomToastification().showToast("$error", type: ToastificationType.error);
    }
  }

  Future<void> pickProfileImage() async {
    XFile? pickedImage = await MediaPickerServices().pickImage(fromCamera: false);

    if (pickedImage != null) {
      profileImageUrl.value = null;
      profileImage.value = File(pickedImage.path);
      profileImage.refresh();
    }
  }

  Future<void> captureProfileImage() async {
    XFile? pickedImage = await MediaPickerServices().pickImage();
    customPrint("picked image is  ${pickedImage}");

    if (pickedImage != null) {
      profileImageUrl.value = null;
      profileImage.value = File(pickedImage.path);
      profileImage.refresh();
    }
  }
}

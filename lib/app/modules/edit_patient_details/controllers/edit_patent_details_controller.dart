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
import '../../../core/common/global_controller.dart';
import '../../../core/common/logger.dart';
import '../../../routes/app_pages.dart';
import '../../login/model/login_model.dart';
import '../model/patient_detail_model.dart';
import '../repository/edit_patient_details_repository.dart';

class EditPatentDetailsController extends GetxController {
  //TODO: Implement EditPatentDetailsController

  Rxn<DateTime> selectedDOBDate = Rxn<DateTime>();
  final GlobalController globalController = Get.find();
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
  RxnString selectedDoctorValue = RxnString();
  RxnString selectedMedicalValue = RxnString();

  Rxn<File> profileImage = Rxn();
  List<String> visitTime = [
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
  ];

  List<String> sex = ["Female", "Male"];
  List<String> patientType = ["New Patient", "Old Patient"];
  RxBool isExistingPatient = RxBool(false);
  RxnString selectedPatientTypeValue = RxnString("New Patient");

  String patientId = "";
  String visitId = "";

  RxBool isFromSchedule = RxBool(true);
  RxBool isLoading = RxBool(false);

  RxString dob = RxString("");
  RxString visitDate = RxString("");

  final count = 0.obs;

  @override
  String formatPhoneNumber(String rawNumber) {
    // Ensure the number is exactly 10 digits (US phone number format)
    if (rawNumber.length == 11) {
      return '+1 (${rawNumber.substring(1, 4)}) ${rawNumber.substring(4, 7)}-${rawNumber.substring(7)}';
    } else {
      // Handle invalid number length (you can customize this behavior)
      return '+1 ';
    }
  }

  String extractDigits(String input) {
    // Use a regular expression to extract digits only
    return input.replaceAll(RegExp(r'\D'), '');
  }

  void onInit() {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      globalController.addRouteInit(Routes.EDIT_PATENT_DETAILS);
    });

    customPrint("edit patient list  ${Get.arguments["patientData"]}");

    patientId = Get.arguments["patientData"];
    visitId = Get.arguments["visitId"];
    isFromSchedule.value = Get.arguments["fromSchedule"];

    isFromSchedule.refresh();
    contactNumberController.text = "+1";

    getPatient(patientId, visitId);
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();

    if (globalController.getKeyByValue(globalController.breadcrumbHistory.last) == Routes.EDIT_PATENT_DETAILS) {
      globalController.popRoute();
    }
  }

  Future<void> getPatient(String id, String visitId) async {
    Map<String, dynamic> param = {};

    if (visitId != "" && visitId != "null") {
      param['visit_id'] = visitId;
    }

    patientDetailModel = await _editPatientDetailsRepository.getPatient(id: id, param: param);
    firstNameController.text = patientDetailModel.responseData?.firstName ?? "";
    middleNameController.text = patientDetailModel.responseData?.middleName ?? "";
    lastNameController.text = patientDetailModel.responseData?.lastName ?? "";
    selectedSexValue.value = patientDetailModel.responseData?.gender;
    profileImageUrl.value = patientDetailModel.responseData?.profileImage;
    patientIdController.text = patientDetailModel.responseData?.patientId ?? "";
    emailAddressController.text = patientDetailModel.responseData?.email ?? "";
    contactNumberController.text = formatPhoneNumber(patientDetailModel.responseData?.contactNumber ?? "");

    if (patientDetailModel.responseData?.doctorId != null) {
      selectedDoctorValue.value = globalController.getDoctorNameById(patientDetailModel.responseData?.doctorId ?? -1);
    }

    if (patientDetailModel.responseData?.medicalAssistantId != null) {
      selectedMedicalValue.value = globalController.getDoctorNameById(patientDetailModel.responseData?.medicalAssistantId ?? -1);
    }

    customPrint("patientid:- ${patientDetailModel.responseData?.patientId}");

    customPrint("dob is :- ${patientDetailModel.responseData?.dateOfBirth}");

    // Parse the date string to a DateTime object

    if (patientDetailModel.responseData?.dateOfBirth != null) {
      DateTime dateTime = DateTime.parse(patientDetailModel.responseData?.dateOfBirth ?? "").toLocal();

      // Create a DateFormat to format the date
      DateFormat dateFormat = DateFormat('MM/dd/yyyy');

      // Format the DateTime object to the desired format
      String formattedDate = dateFormat.format(dateTime);

      dobController.text = formattedDate;
      customPrint("dob is :- $formattedDate");

      customPrint("dob is :- ${patientDetailModel.responseData?.dateOfBirth}");
    }

    // Parse the date string to a DateTime object

    if (patientDetailModel.responseData?.visitTime != null) {
      customPrint(" at the time of the get the time  ${patientDetailModel.responseData?.visitTime} ");
      DateTime visitdateTime = DateTime.parse(patientDetailModel.responseData?.visitTime ?? "");

      // Create a DateFormat to format the date
      DateFormat visitdateFormat = DateFormat('MM/dd/yyyy');

      // Format the DateTime object to the desired format
      String visitformattedDate = visitdateFormat.format(visitdateTime);

      visitDateController.text = visitformattedDate;
    }

    if (patientDetailModel.responseData?.visitTime != null) {
      DateTime visitTimeS = DateTime.parse(patientDetailModel.responseData?.visitTime ?? ""); // Parsing the string to DateTime

      // Formatting to "hh:mm a" format
      String formattedTime = DateFormat('hh:mm a').format(visitTimeS.toLocal());

      customPrint("visitformattedTime is:- $formattedTime");

      selectedVisitTimeValue.value = formattedTime;
      selectedVisitTimeValue.refresh();
    }

    selectedSexValue.value = patientDetailModel.responseData?.gender ?? "";
  }

  void showVisitDateCupertinoDatePicker(BuildContext context, TextEditingController control) {
    DateTime _selectedDate = DateTime.now();

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text("Pick a Date", style: AppFonts.medium(16, AppColors.black)),
          actions: <Widget>[
            Container(
              height: 400,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                minimumDate: DateTime.now().subtract(const Duration(hours: 1)),
                initialDateTime: _selectedDate,
                onDateTimeChanged: (DateTime newDate) {
                  _selectedDate = newDate;
                  // Update the TextField with selected date
                  String formattedDate = DateFormat('MM/dd/yyyy').format(_selectedDate);
                  String strDate = DateFormat('yyyy-MM-ddTHH:mm:ss.sssZ').format(_selectedDate);

                  if (control == dobController) {
                    dob.value = strDate;
                    customPrint("controller dob is :- $dob");
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
            child: const Text('Cancel'),
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
          title: Text("Pick a Date", style: AppFonts.medium(16, AppColors.black)),
          actions: <Widget>[
            Container(
              height: 400,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: _selectedDate,
                maximumDate: control == dobController ? DateTime.now() : DateTime.now().add(const Duration(days: 365)),
                minimumDate: control == visitDateController ? DateTime.now() : DateTime.now().subtract(const Duration(days: 10950)),
                onDateTimeChanged: (DateTime newDate) {
                  _selectedDate = newDate;
                  // Update the TextField with selected date
                  String formattedDate = DateFormat('MM/dd/yyyy').format(_selectedDate);
                  String strDate = DateFormat('yyyy-MM-ddTHH:mm:ss.sssZ').format(_selectedDate);

                  if (control == dobController) {
                    dob.value = strDate;
                    customPrint("controller dob is :- $dob");
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
            child: const Text('Cancel'),
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
      profileParams['profile_image'] = [profileImage.value!];
    } else {
      if (profileImageUrl.value == null) {
        param['isDeleteProfileImage'] = true;
      }

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

    if (dobController.text != "") {
      param['date_of_birth'] = DateFormat('yyyy-MM-dd').format(DateFormat('MM/dd/yyyy').parse(dobController.text));
    }

    param['gender'] = selectedSexValue.value;
    if (emailAddressController.text != "") {
      param['email'] = emailAddressController.text;
    }

    print("contact_no is :- ${contactNumberController.text}");

    if (contactNumberController.text.trim() != "+1") {
      param['contact_no'] = extractDigits(contactNumberController.text.trim());
    }

    if (visitDateController.text != "") {
      param['visit_date'] = DateFormat('yyyy-MM-dd').format(DateFormat('MM/dd/yyyy').parse(visitDateController.text));
    }

    if (selectedDoctorValue.value != null && selectedDoctorValue.value != "") {
      if (globalController.getDoctorIdByName(selectedDoctorValue.value) != -1) {
        param['doctor_id'] = globalController.getDoctorIdByName(selectedDoctorValue.value);
      }
    }

    if (selectedMedicalValue.value != null && selectedMedicalValue.value != "") {
      if (globalController.getMedicalIdByName(selectedMedicalValue.value) != -1) {
        param['medical_assistant_id'] = globalController.getMedicalIdByName(selectedMedicalValue.value);
      }
    }

    String date = visitDateController.text;
    String? time = selectedVisitTimeValue.value;
    customPrint(visitDateController.text);
    customPrint(selectedVisitTimeValue.value);

    if (time != null) {
      DateTime firstTime = DateFormat('hh:mm a').parse(time).toUtc(); // 10:30 AM to DateTime

      // Now format it to the hh:mm:ss format
      String formattedTime = DateFormat('HH:mm:ss').format(firstTime);

      customPrint("date time is $formattedTime");

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
      customPrint("_editPatientDetailsRepository response is $response ");
      Loader().stopLoader();
      // Get.back();
      Get.back(result: 1);
    } catch (error) {
      // Get.back();
      Loader().stopLoader();
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
    customPrint("picked image is  $pickedImage");

    if (pickedImage != null) {
      profileImageUrl.value = null;
      profileImage.value = File(pickedImage.path);
      profileImage.refresh();
    }
  }
}

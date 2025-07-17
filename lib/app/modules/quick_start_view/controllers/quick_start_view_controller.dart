import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:toastification/toastification.dart';

import '../../../../utils/Loader.dart';
import '../../../../utils/app_string.dart';
import '../../../../widgets/customPermission.dart';
import '../../../../widgets/custom_toastification.dart';
import '../../../core/common/app_preferences.dart';
import '../../../core/common/global_controller.dart';
import '../../../core/common/logger.dart';
import '../../../mobile_modules/add_recording_mobile_view/model/add_mobile_patient_model.dart';
import '../../add_patient/model/add_patient_model.dart';
import '../../add_patient/model/latest_genrated_id.dart';
import '../../add_patient/repository/add_patient_repository.dart';
import '../../home/model/patient_list_model.dart';
import '../../home/repository/home_repository.dart';
import '../../login/model/login_model.dart';

class QuickStartViewController extends GetxController {
  //TODO: Implement QuickStartViewController

  final GlobalController globalController = Get.find();
  SuggestionsController<PatientListData> suggestionsController = SuggestionsController();
  final HomeRepository _homeRepository = HomeRepository();
  TextEditingController searchController = TextEditingController();

  Rxn<PatientListModel> patientListModel = Rxn<PatientListModel>();
  RxList<PatientListData> patientList = RxList<PatientListData>();
  Rxn<PatientListData> searchText = Rxn();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final AddPatientRepository _addPatientRepository = AddPatientRepository();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController patientId = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  RxnString selectedSexValue = RxnString("Male");
  List<String> sex = ["Female", "Male"];

  RxString editId = RxString("");
  RxBool isValid = RxBool(true);

  RxnString selectedVisitTimeValue = RxnString();
  TextEditingController visitDateController = TextEditingController();
  RxBool isAddPatient = RxBool(false);

  @override
  void onInit() {
    super.onInit();

    getLatestId();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  Future<void> getLatestId() async {
    try {
      LatestPatientId latestPatientIdModel = await _addPatientRepository.getLatestId();
      if (latestPatientIdModel.responseType == "success") {
        patientId.text = latestPatientIdModel.responseData?.patientId ?? "";
      }
    } catch (e) {
      customPrint(e);
    }
  }

  Future<void> addPatient() async {
    Loader().showLoadingDialogForSimpleLoader();

    Map<String, dynamic> param = {};

    param['first_name'] = firstNameController.text;

    if (patientId.text != "") {
      param['patient_id'] = patientId.text;
    }

    if (middleNameController.text != "") {
      param['middle_name'] = middleNameController.text;
    }

    param['last_name'] = lastNameController.text;

    if (dobController.text != "") {
      param['date_of_birth'] = DateFormat('yyyy-MM-dd').format(DateFormat('MM/dd/yyyy').parse(dobController.text));
    }

    param['gender'] = selectedSexValue.value;

    try {
      AddMobilePatientModel addPatientModel = await _addPatientRepository.addMobilePatient(param: param);
      customPrint("_addPatientRepository response is ${addPatientModel.toJson()} ");
      CustomToastification().showToast("Patient added successfully", type: ToastificationType.success);
      Loader().stopLoader();

      quickStartAudioRecord(addPatientModel.responseData?.patientId.toString() ?? "", addPatientModel.responseData?.id.toString() ?? "", firstNameController.text, lastNameController.text);
      Get.back();
      // Get.toNamed(Routes.ADD_RECORDING_MOBILE_VIEW, arguments: {"patientId": addPatientModel.responseData?.patientId.toString(), "visitId": addPatientModel.responseData?.id.toString()});
    } catch (error) {
      customPrint("_addPatientRepository catch error is $error");
      CustomToastification().showToast("$error", type: ToastificationType.error);
      Loader().stopLoader();
    }
  }

  Future<void> createVisit(int patientId) async {
    Loader().showLoadingDialogForSimpleLoader();

    Map<String, dynamic> param = {};

    param['id'] = patientId;

    try {
      AddMobilePatientModel addPatientModel = await _addPatientRepository.addMobilePatient(param: param);
      customPrint("_addPatientRepository response is ${addPatientModel.toJson()} ");
      CustomToastification().showToast("Patient added successfully", type: ToastificationType.success);
      Loader().stopLoader();

      quickStartAudioRecord(addPatientModel.responseData?.patientId.toString() ?? "", addPatientModel.responseData?.id.toString() ?? "", firstNameController.text, lastNameController.text);
      Get.back();

      // await Get.toNamed(Routes.ADD_RECORDING_MOBILE_VIEW, arguments: {"patientId": addPatientModel.responseData?.patientId.toString(), "visitId": addPatientModel.responseData?.id.toString()});
    } catch (error) {
      customPrint("_addPatientRepository catch error is $error");
      CustomToastification().showToast("$error", type: ToastificationType.error);
      Loader().stopLoader();
    }
  }

  Future<List<PatientListData>> getPatientList({String searchValue = ""}) async {
    // patientList.clear();
    Map<String, dynamic> param = {};

    if (searchValue.isNotEmpty) {
      param['search'] = searchValue;
    }

    try {
      patientListModel.value = await _homeRepository.getPatient(param: param);

      if (patientListModel.value?.responseData?.data != null) {
        patientList.value = patientListModel.value?.responseData?.data ?? [];
        return patientList;
      }
    } catch (e) {
      return [];
    }
    return [];
  }

  Future<void> schedulePatient() async {
    Loader().showLoadingDialogForSimpleLoader();

    Map<String, List<File>> profileParams = {};

    Map<String, dynamic> param = {};

    if (patientId.text.trim().isNotEmpty) {
      param['patient_id'] = patientId.text;
    }

    param['last_name'] = lastNameController.text;

    if (dobController.text != "") {
      param['date_of_birth'] = DateFormat('yyyy-MM-dd').format(DateFormat('MM/dd/yyyy').parse(dobController.text));
    }

    param['gender'] = selectedSexValue.value;

    if (contactNumberController.text != "") {
      if (extractDigits(contactNumberController.text.trim()) != "") {
        param['contact_no'] = extractDigits(contactNumberController.text.trim());
      }
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

      customPrint("date time is $formattedTime");

      param['visit_time'] = formattedTime;
    }

    customPrint("param is :- $param");

    var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

    try {
      AddPatientModel addPatientModel = await _addPatientRepository.addPatient(param: param, files: profileParams, token: loginData.responseData?.token ?? "");
      customPrint("_addPatientRepository response is ${addPatientModel.toJson()} ");
      CustomToastification().showToast("Patient added successfully", type: ToastificationType.success);
    } catch (error) {
      Get.back();
      customPrint("_addPatientRepository catch error is $error");
      CustomToastification().showToast("$error", type: ToastificationType.error);
    }
  }

  void setUi(PatientListData? value) {
    if (value?.patientId != null) {
      patientId.text = value?.patientId.toString() ?? "";
    }
    editId.value = value?.id.toString() ?? "";
    firstNameController.text = value?.firstName ?? "";
    lastNameController.text = value?.lastName ?? "";
    middleNameController.text = value?.middleName ?? "";
    dobController.text = value?.dateOfBirth ?? "";
    selectedSexValue.value = value?.gender ?? "";
    contactNumberController.text = value?.contactNo ?? "+1";
    contactNumberController.text = formatPhoneNumber(value?.contactNo ?? "+1");
    isAddPatient.value = false;
    selectedVisitTimeValue.value = getNextRoundedTime();
    visitDateController.text = DateFormat('MM/dd/yyyy').format(DateTime.now());

    if (value?.dateOfBirth != null) {
      DateTime dateTime = DateTime.parse(value?.dateOfBirth ?? "").toLocal();
      DateFormat dateFormat = DateFormat('MM/dd/yyyy');

      // Format the DateTime object to the desired format
      String formattedDate = dateFormat.format(dateTime);

      dobController.text = formattedDate;
      customPrint("dob is :- $formattedDate");
    }

    formKey.currentState?.validate(); // Thi
  }

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

  String getNextRoundedTime() {
    DateTime now = DateTime.now();

    int minutes = now.minute;
    int roundedMinutes = ((minutes + 14) ~/ 15) * 15; // Adding 14 ensures rounding up

    if (roundedMinutes == 60) {
      now = now.add(Duration(minutes: 60 - minutes));
      now = DateTime(now.year, now.month, now.day, now.hour, 0);
    } else {
      now = DateTime(now.year, now.month, now.day, now.hour, roundedMinutes);
    }

    final DateFormat formatter = DateFormat('h:mm a');
    return formatter.format(now);
  }

  String extractDigits(String input) {
    // Use a regular expression to extract digits only
    return input.replaceAll(RegExp(r'\D'), '');
  }

  Future<void> quickStartAudioRecord(String patientId, String visitId, String firstName, String lastName) async {
    if (globalController.visitId.isNotEmpty) {
      CustomToastification().showToast("Recording is already in progress", type: ToastificationType.info);
    } else {
      if (await globalController.recorderService.audioRecorder.hasPermission()) {
        globalController.isStartTranscript.value = true;

        // controller.globalController.patientId.value = controller.patientId.value;
        // controller.globalController.visitId.value = controller.visitId.value;

        globalController.patientFirstName.value = firstName;
        globalController.attachmentId.value = patientId;
        globalController.patientLsatName.value = lastName;
        globalController.patientFirstName.value = firstName;
        globalController.patientLsatName.value = lastName;

        globalController.valueOfx.value = 0;
        globalController.valueOfy.value = 0;

        globalController.visitId = RxString(visitId);
        globalController.patientId = RxString(patientId);

        globalController.changeStatus("In-Room");
        // If not recording, start the recording
        globalController.startAudioWidget();
        globalController.recorderService.audioRecorder = AudioRecorder();
        globalController.getConnectedInputDevices();
        await globalController.recorderService.startRecording(Get.context!);

        update();
        // updateData();
      } else if ((await Permission.microphone.isPermanentlyDenied || await Permission.microphone.isDenied)) {
        // Handle permission denial here

        showDialog(barrierDismissible: false, context: Get.context!, builder: (context) => const PermissionAlert(permissionDescription: "To record audio, the app needs access to your microphone. Please enable the microphone permission in your app settings.", permissionTitle: " Microphone  permission request", isMicPermission: true));
      }
    }
  }
}

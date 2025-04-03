import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:path/path.dart' as p;
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../services/media_picker_services.dart';
import '../../../../utils/Loader.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/app_string.dart';
import '../../../../widgets/custom_toastification.dart';
import '../../../core/common/app_preferences.dart';
import '../../../core/common/global_controller.dart';
import '../../../core/common/logger.dart';
import '../../../models/media_listing_model.dart';
import '../../../routes/app_pages.dart';
import '../../login/model/login_model.dart';
import '../model/add_patient_model.dart';
import '../repository/add_patient_repository.dart';

class AddPatientController extends GetxController {
  //TODO: Implement AddPatientController

  RxBool isSaveAddAnother = RxBool(false);
  final GlobalController globalController = Get.find();
  final AddPatientRepository _addPatientRepository = AddPatientRepository();
  RxBool isLoading = RxBool(false);
  RxBool isAddPatient = RxBool(false);

  TextEditingController firstNameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController patientId = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController visitDateController = TextEditingController();
  TextEditingController patientIdController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  RxString dob = RxString("");
  Rxn<DateTime> rxnDob = Rxn();

  RxString visitDate = RxString("");
  RxBool isValid = RxBool(true);
  Rxn<File> profileImage = Rxn();
  RxnString selectedSexValue = RxnString("Male");
  RxnString selectedPatientValue = RxnString();
  RxnString selectedVisitTimeValue = RxnString();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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

  RxString selectedVisitTime = RxString("11 PM");
  List<String> sex = ["Female", "Male"];
  List<String> patientType = ["New Patient", "Old Patient"];

  RxList<MediaListingModel> list = RxList();
  RxList<MediaListingModel> selectedList = RxList();

  double totalFileSize = 0.0;

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
  void onReady() {
    // TODO: implement onReady
    super.onReady();

    if (Get.currentRoute == Routes.SCHEDULE_PATIENT) {
      visitDateController.text = DateFormat('MM/dd/yyyy').format(DateTime.now());
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();

    if (globalController.getKeyByValue(globalController.breadcrumbHistory.last) == Routes.ADD_PATIENT ||
        globalController.getKeyByValue(globalController.breadcrumbHistory.last) == Routes.SCHEDULE_PATIENT) {
      globalController.popRoute();
    }
    // globalController.popRoute();
  }

  String extractDigits(String input) {
    // Use a regular expression to extract digits only

    if (input.trim() == "+1") {
      return "";
    }
    return input.replaceAll(RegExp(r'\D'), '');
  }

  @override
  void onInit() {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.currentRoute == Routes.ADD_PATIENT) {
        isAddPatient.value = true;

        globalController.addRouteInit(Routes.ADD_PATIENT);
      } else {
        isAddPatient.value = false;
        globalController.addRouteInit(Routes.SCHEDULE_PATIENT);
        selectedVisitTimeValue.value = getNextRoundedTime();
      }
    });
    contactNumberController.text = "+1 ";
    print(getNextRoundedTime());
  }

  String _formatFileSize(int bytes) {
    double sizeInKB = bytes / 1024; // Convert bytes to KB
    double sizeInMB = sizeInKB / 1024; // Convert KB to MB
    return "${sizeInMB.toStringAsFixed(2)} MB";
  }

  String _formatDate(DateTime date) {
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    return dateFormat.format(date); // Format date to dd/MM/yyyy
  }

  void calculateTotalFileSize() {
    totalFileSize = 0.0;
    for (var item in list) {
      totalFileSize += (item.file?.lengthSync() ?? 0) / (1024 * 1024); // Convert bytes to MB
    }
  }

  void addImage() {
    selectedList.addAll(list);
    list.clear();
  }

  void deleteAttachments(int index) {
    selectedList.removeAt(index);
    Get.back();
  }

  Future<void> pickFiles() async {
    List<PlatformFile>? fileList = await MediaPickerServices().pickAllFiles(fileType: FileType.custom);

    customPrint("media  file is  ${fileList}");

    // double totalFileSize = 0.0;

    fileList?.forEach(
      (element) {
        XFile? _pickedFile;
        String? _fileName;
        DateTime? _pickDate;
        int? _fileSize;

        if (element != null) {
          _fileName = element.name; // Get the file name
          _pickDate = DateTime.now(); // Get the date when the file is picked

          // Get the size of the file
          File file = File(element.xFile.path);
          _fileSize = file.lengthSync(); // Size in bytes

          // totalFileSize += _fileSize / (1024 * 1024);

          String? _filesizeString = _formatFileSize(_fileSize);

          String? _shortFileName;
          if (p.basename(_fileName).length > 15) {
            // Truncate the name to 12 characters and add ellipsis
            _shortFileName = p.basename(_fileName).substring(0, 12) + '...';
          } else {
            _shortFileName = p.basename(_fileName); // Use the full name if it's already short
          }
          list.value.add(MediaListingModel(file: file, previewImage: null, fileName: _shortFileName, date: _formatDate(_pickDate), Size: _filesizeString));
        }

        list.refresh();
      },
    );

    calculateTotalFileSize();

    print("total file size is $totalFileSize");
  }

  Future<void> captureProfileImage() async {
    XFile? pickedImage = await MediaPickerServices().pickImage();
    customPrint("picked image is  $pickedImage");

    if (pickedImage != null) {
      profileImage.value = File(pickedImage.path);
    }
  }

  Future<void> pickProfileImage() async {
    XFile? pickedImage = await MediaPickerServices().pickImage(fromCamera: false);

    if (pickedImage != null) {
      profileImage.value = File(pickedImage.path);
    }
  }

  Future<void> captureImage() async {
    XFile? image = await MediaPickerServices().pickImage();

    customPrint("media  file is  $image");

    XFile? _pickedFile;
    String? _fileName;
    DateTime? _pickDate;
    int? _fileSize;
    if (image != null) {
      _fileName = image.name; // Get the file name
      _pickDate = DateTime.now(); // Get the date when the file is picked

      // Get the size of the file
      File file = File(image.path);
      _fileSize = file.lengthSync(); // Size in bytes

      String? _filesizeString = _formatFileSize(_fileSize);
      String? _shortFileName;
      if (p.basename(_fileName).length > 15) {
        // Truncate the name to 12 characters and add ellipsis
        _shortFileName = p.basename(_fileName).substring(0, 12) + '...';
      } else {
        _shortFileName = p.basename(_fileName); // Use the full name if it's already short
      }
      list.value.add(MediaListingModel(file: file, previewImage: null, fileName: _shortFileName, date: _formatDate(_pickDate), Size: _filesizeString));
    }

    list.refresh();
  }

  void removeItem(int index) {
    list.removeAt(index);
    list.refresh();
  }

  Future<void> addPatient() async {
    Loader().showLoadingDialogForSimpleLoader();
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

    if (selectedList.isNotEmpty) {
      customPrint("profile is   available");
      // param['profile_image'] = profileImage.value;
      // profileParams['attachments'] = selectedList.map((model) => model.file).toList().whereType<File>().toList();
    } else {
      customPrint("profile is not  available");
    }

    if (patientId.text != "") {
      param['patient_id'] = patientId.text;
    }

    if (middleNameController.text != "") {
      param['middle_name'] = middleNameController.text;
    }
    if (contactNumberController.text != "") {
      if (extractDigits(contactNumberController.text.trim()) != "") {
        param['contact_no'] = extractDigits(contactNumberController.text.trim());
      }
    }
    param['last_name'] = lastNameController.text;

    if (dobController.text != "") {
      param['date_of_birth'] = DateFormat('yyyy-MM-dd').format(DateFormat('MM/dd/yyyy').parse(dobController.text));
    }

    param['gender'] = selectedSexValue.value;

    if (emailAddressController.text != "") {
      param['email'] = emailAddressController.text;
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
      String formattedTime = DateFormat('HH:mm:ss').format(firstTime.toUtc());

      customPrint("date time is ${formattedTime}");

      param['visit_time'] = formattedTime;
    }

    customPrint("param is :- $param");

    var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

    try {
      AddPatientModel addPatientModel = await _addPatientRepository.addPatient(param: param, files: profileParams, token: loginData.responseData?.token ?? "");
      customPrint("_addPatientRepository response is ${addPatientModel.toJson()} ");
      await uploadAttachments(addPatientModel.responseData?.id.toString() ?? "");
      isLoading.value = false;
      CustomToastification().showToast("Patient added successfully", type: ToastificationType.success);

      if (isSaveAddAnother.value == false) {
        Get.back();
        if (visitDateController.text.isNotEmpty) {
          Get.back(result: 1);
        } else {
          Get.back(result: 0);
        }
      } else {
        Get.back();
        clearForm();
      }
    } catch (error) {
      Get.back();
      isLoading.value = false;
      customPrint("_addPatientRepository catch error is $error");
      CustomToastification().showToast("$error", type: ToastificationType.error);
    }
  }

  Future<bool> uploadAttachments(String patientId) async {
    Loader().showLoadingDialogForSimpleLoader();
    var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

    Map<String, List<File>> profileParams = {};
    if (selectedList.isNotEmpty) {
      customPrint("profile is   available");
      // param['profile_image'] = profileImage.value;
      profileParams['attachments'] = selectedList.map((model) => model.file).toList().whereType<File>().toList();
      // profileParams['attachments'] = list.map((model) => model.file).toList().whereType<File>().toList();
    } else {
      customPrint("profile is not  available");
    }
    await _addPatientRepository.uploadAttachments(files: profileParams, token: loginData.responseData?.token ?? "", patientVisitId: patientId);
    selectedList.clear();
    Get.back();

    return true;
    // getPatientAttachment();
  }

  Future<void> clearForm() async {
    // selectedVisitTime.value = "";
    selectedVisitTimeValue.value = null;
    visitDateController.clear();

    patientId.clear();
    firstNameController.clear();
    middleNameController.clear();
    lastNameController.clear();
    dobController.clear();
    emailAddressController.clear();
    formKey.currentState!.reset();
    list.clear();
    selectedList.clear();
    profileImage.value = null;

    patientId.text = "";
    firstNameController.text = "";
    middleNameController.text = "";
    lastNameController.text = "";
    emailAddressController.text = "";
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
                  if (selectedVisitTimeValue.value == null) {
                    selectedVisitTimeValue.value = "12:00 AM";
                  }

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

  Future<void> launchInAppWithBrowserOptions(Uri url) async {
    customPrint("launch url is :- ${url}");

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}

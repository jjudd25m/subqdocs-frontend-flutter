import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:subqdocs/app/models/SelectedDoctorMedicationModel.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../services/media_picker_services.dart';
import '../../../../utils/Loader.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/app_string.dart';
import '../../../../widget/add_patient_attchment_dailog.dart';
import '../../../../widgets/custom_toastification.dart';
import '../../../core/common/app_preferences.dart';
import '../../../core/common/global_controller.dart';
import '../../../core/common/logger.dart';
import '../../../models/media_listing_model.dart';
import '../../../routes/app_pages.dart';
import '../../edit_patient_details/model/patient_detail_model.dart';
import '../../edit_patient_details/repository/edit_patient_details_repository.dart';
import '../../forgot_password/models/common_respons.dart';
import '../../home/model/patient_list_model.dart';
import '../../home/repository/home_repository.dart';
import '../../login/model/login_model.dart';
import '../../visit_main/model/patient_attachment_list_model.dart';
import '../../visit_main/repository/visit_main_repository.dart';
import '../model/add_patient_model.dart';
import '../model/latest_genrated_id.dart';
import '../repository/add_patient_repository.dart';
import '../widgets/custom_dailog.dart';

class AddPatientController extends GetxController {
  //TODO: Implement AddPatientController

  RxBool isExistingPatient = RxBool(false);

  RxBool isSaveAddAnother = RxBool(false);
  final GlobalController globalController = Get.find();
  final AddPatientRepository _addPatientRepository = AddPatientRepository();
  RxBool isLoading = RxBool(false);
  RxBool isAddPatient = RxBool(false);
  RxBool isOldPatient = RxBool(false);

  TextEditingController firstNameController = TextEditingController();
  final VisitMainRepository visitMainRepository = VisitMainRepository();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController patientId = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  final EditPatientDetailsRepository _editPatientDetailsRepository = EditPatientDetailsRepository();

  SuggestionsController<PatientListData> suggestionsController = SuggestionsController();

  TextEditingController selectedMedicalAssistantController = TextEditingController();
  TextEditingController doctorFiledController = TextEditingController();

  TextEditingController dobController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController visitDateController = TextEditingController();
  TextEditingController patientIdController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  PatientDetailModel patientDetailModel = PatientDetailModel();

  RxList<PatientAttachmentResponseData> patientAttachmentList = RxList();

  RxString dob = RxString("");
  Rxn<DateTime> rxnDob = Rxn();

  RxString visitDate = RxString("");
  RxString editId = RxString("");
  final HomeRepository _homeRepository = HomeRepository();
  RxBool isValid = RxBool(true);
  Rxn<File> profileImage = Rxn();
  RxnString selectedSexValue = RxnString("Male");
  RxnString selectedDoctorValue = RxnString();
  Rxn<SelectedDoctorModel> selectedDoctorValueModel = Rxn();
  Rxn<SelectedDoctorModel> selectedMedicalValueModel = Rxn();

  RxnString selectedMedicalValue = RxnString();
  RxnString selectedPatientValue = RxnString();

  TextEditingController selectedVisitTimeValueController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  RxList<MediaListingModel> listOldPatient = RxList();

  RxList<PatientListData> patientList = RxList<PatientListData>();

  Rxn<PatientListModel> patientListModel = Rxn<PatientListModel>();
  RxString selectedVisitTime = RxString("11 PM");
  List<String> sex = ["Female", "Male"];

  List<String> patientType = ["New Patient", "Old Patient"];

  RxnString selectedPatientTypeValue = RxnString("New Patient");

  RxList<MediaListingModel> list = RxList();
  RxList<MediaListingModel> selectedList = RxList();

  Rxn<PatientListData> searchText = Rxn();

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

    if (globalController.getKeyByValue(globalController.breadcrumbHistory.last) == Routes.ADD_PATIENT || globalController.getKeyByValue(globalController.breadcrumbHistory.last) == Routes.SCHEDULE_PATIENT) {
      globalController.popRoute();
    }
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

    getLatestId();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.currentRoute == Routes.ADD_PATIENT) {
        globalController.addRouteInit(Routes.ADD_PATIENT);
      } else {
        globalController.addRouteInit(Routes.SCHEDULE_PATIENT);
        selectedVisitTimeValueController.text = getNextRoundedTime();
      }
    });
    contactNumberController.text = "+1 ";
    customPrint(getNextRoundedTime());
  }

  DateTime fromDate = DateTime.now().subtract(const Duration(days: 371));

  void showCustomDialogOldPatient(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      // Allows dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return AddPatientAttachment(controller: this); // Our custom dialog
      },
    );
  }

  // Future<void> captureImageOldPatient(BuildContext context, {bool fromCamera = true, bool clear = true}) async {
  //   if (clear) {
  //     listOldPatient.clear();
  //   }
  //
  //   XFile? image = await MediaPickerServices().pickImage(fromCamera: fromCamera);
  //
  //   customPrint("media  file is  $image");
  //
  //   XFile? _pickedFile;
  //   String? _fileName;
  //   DateTime? _pickDate;
  //   int? _fileSize;
  //   if (image != null) {
  //     _fileName = image.name; // Get the file name
  //     _pickDate = DateTime.now(); // Get the date when the file is picked
  //
  //     // Get the size of the file
  //     File file = File(image.path);
  //     _fileSize = file.lengthSync(); // Size in bytes
  //
  //     String? _filesizeString = _formatFileSize(_fileSize);
  //
  //     double? _filesizeStringDouble = _formatFileSizeDouble(_fileSize);
  //     String? _shortFileName;
  //     if (p.basename(_fileName).length > 15) {
  //       // Truncate the name to 12 characters and add ellipsis
  //       _shortFileName = p.basename(_fileName).substring(0, 12) + '...';
  //     } else {
  //       _shortFileName = p.basename(_fileName); // Use the full name if it's already short
  //     }
  //     listOldPatient.value.add(MediaListingModel(file: file, previewImage: null, fileName: _shortFileName, date: _formatDate(_pickDate), Size: _filesizeString, calculateSize: _filesizeStringDouble, isGraterThan10: _filesizeStringDouble < 10.00 ? false : true));
  //   }
  //
  //   listOldPatient.refresh();
  //
  //   if (clear) {
  //     if (listOldPatient.isNotEmpty) {
  //       showCustomDialogOldPatient(context);
  //     }
  //   }
  // }

  Future<void> captureImageOldPatient(BuildContext context, {bool fromCamera = true, bool clear = true}) async {
    if (clear) {
      listOldPatient.clear();
    }

    final XFile? image = await MediaPickerServices().pickImage(fromCamera: fromCamera);
    customPrint("Media file: $image");

    if (image == null) return;

    final File file = File(image.path);
    final MediaListingModel mediaItem = await _createMediaListingModel(image, file);

    listOldPatient.value.add(mediaItem);
    listOldPatient.refresh();

    if (clear && listOldPatient.isNotEmpty) {
      showCustomDialogOldPatient(context);
    }
  }

  Future<MediaListingModel> _createMediaListingModel(XFile image, File file) async {
    final String fileName = p.basename(image.name);
    final DateTime pickDate = DateTime.now();
    final int fileSize = file.lengthSync();

    return MediaListingModel(file: file, previewImage: null, fileName: _getShortFileName(fileName), date: _formatDate(pickDate), Size: _formatFileSize(fileSize), calculateSize: _formatFileSizeDouble(fileSize), isGraterThan10: _formatFileSizeDouble(fileSize) >= 10.00);
  }

  String _getShortFileName(String fileName) {
    return fileName.length > 15 ? '${fileName.substring(0, 12)}...' : fileName;
  }

  Future<void> pickFilesOldPatient(BuildContext context, {bool clear = true}) async {
    if (clear) {
      listOldPatient.clear();
    }

    List<PlatformFile>? fileList = await MediaPickerServices().pickAllFiles(fileType: FileType.custom);

    customPrint("media  file is  $fileList");

    fileList?.forEach((element) {
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

        String? _filesizeString = _formatFileSize(_fileSize);

        double? _filesizeStringDouble = _formatFileSizeDouble(_fileSize);

        String? _shortFileName;
        if (p.basename(_fileName).length > 15) {
          // Truncate the name to 12 characters and add ellipsis
          _shortFileName = '${p.basename(_fileName).substring(0, 12)}...';
        } else {
          _shortFileName = p.basename(_fileName); // Use the full name if it's already short
        }
        listOldPatient.value.add(MediaListingModel(file: file, previewImage: null, fileName: _shortFileName, date: _formatDate(_pickDate), Size: _filesizeString, calculateSize: _filesizeStringDouble, isGraterThan10: _filesizeStringDouble < 10.00 ? false : true));
      }
    });
    listOldPatient.refresh();
    if (clear) {
      if (listOldPatient.isNotEmpty) {
        showCustomDialogOldPatient(context);
      }
    }
  }

  Future<void> uploadAttachmentsOldPatient() async {
    if (checkTotalSize()) {
      if (checkSingleSize()) {
        CustomToastification().showToast("File Size must not exceed 10 MB", type: ToastificationType.error);
      } else {
        Get.back();
        Loader().showLoadingDialogForSimpleLoader();
        var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

        Map<String, List<File>> profileParams = {};
        if (listOldPatient.isNotEmpty) {
          customPrint("profile is   available");
          // param['profile_image'] = profileImage.value;
          profileParams['attachments'] = listOldPatient.map((model) => model.file).toList().whereType<File>().toList();
        } else {
          customPrint("profile is not  available");
        }
        await visitMainRepository.uploadAttachments(files: profileParams, token: loginData.responseData?.token ?? "", patientVisitId: editId.value);
        listOldPatient.clear();
        Get.back();
        getPatientAttachment(editId.value);
      }
    } else {
      CustomToastification().showToast(" Total Files Size must not exceed 100 MB", type: ToastificationType.error);
    }
  }

  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      // Allows dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return const CustomDialogAttachment(); // Our custom dialog
      },
    );
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

        return patientList.value;
      }
    } catch (e) {
      return [];
    }

    return [];
  }

  Future<void> getLatestId() async {
    try {
      LatestPatientId latestPatientIdModel = await _addPatientRepository.getLatestId();

      if (latestPatientIdModel.responseType == "success") {
        patientId.text = latestPatientIdModel.responseData?.patientId ?? "";
      }
    } catch (e) {
      // getLatestId();
    }
  }

  bool isImage(File file) {
    final imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp'];

    customPrint("file extension is :- ${getFileExtension(file.path)}");
    final fileExtension = file.uri.pathSegments.last.split('.').last.toLowerCase();
    return imageExtensions.contains(fileExtension);
  }

  String getFileExtension(String filePath) {
    // Define image extensions
    final imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp'];

    // Get the file extension
    String extension = p.extension(filePath);

    // Check if the extension is an image type
    if (imageExtensions.contains(extension.toLowerCase())) {
      return 'image'; // Return "image" if it's an image extension
    } else {
      return extension.replaceFirst('.', ''); // Return extension without dot
    }
  }

  String _formatFileSize(int bytes) {
    double sizeInKB = bytes / 1024; // Convert bytes to KB
    double sizeInMB = sizeInKB / 1024; // Convert KB to MB
    return "${sizeInMB.toStringAsFixed(2)} MB";
  }

  double _formatFileSizeDouble(int bytes) {
    double sizeInKB = bytes / 1024; // Convert bytes to KB
    double sizeInMB = sizeInKB / 1024; // Convert KB to MB
    return (sizeInMB * 100).roundToDouble() / 100;
  }

  String _formatDate(DateTime date) {
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    return dateFormat.format(date); // Format date to dd/MM/yyyy
  }

  bool checkTotalSize() {
    double totalSize = 0.0;

    list.value.forEach((element) {
      totalSize += element.calculateSize ?? 0;
    });

    if (totalSize < 100) {
      return true;
    } else {
      return false;
    }
  }

  bool checkSingleSize() {
    bool isGraterThan10 = false;

    list.value.forEach((element) {
      if (element.isGraterThan10 ?? false) {
        isGraterThan10 = true;
      }
    });

    return isGraterThan10;
  }

  void addImage() {
    if (checkTotalSize()) {
      if (checkSingleSize()) {
        CustomToastification().showToast("File Size must not exceed 10 MB", type: ToastificationType.error);
      } else {
        selectedList.clear();

        selectedList.addAll(list);
        Get.back();
      }
    } else {
      CustomToastification().showToast(" Total Files Size must not exceed 100 MB", type: ToastificationType.error);
    }
  }

  void deleteAttachments(int index) {
    selectedList.removeAt(index);
    Get.back();
  }

  Future<void> deleteAttachmentsOldPatient(int id) async {
    Loader().showLoadingDialogForSimpleLoader();
    Map<String, List<int>> params = {};
    params["attachments"] = [id];

    customPrint("attch :- $params");
    CommonResponse commonResponse = await visitMainRepository.deleteAttachments(params: params);
    if (commonResponse.responseType == "success") {
      CustomToastification().showToast(commonResponse.message ?? "", type: ToastificationType.success);
    } else {
      CustomToastification().showToast(commonResponse.message ?? "", type: ToastificationType.error);
    }
    Get.back();
    Get.back();
    getPatientAttachment(editId.value);
  }

  Future<void> pickFiles() async {
    List<PlatformFile>? fileList = await MediaPickerServices().pickAllFiles(fileType: FileType.custom);

    customPrint("media  file is  $fileList");

    fileList?.forEach((element) {
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
        double? _filesizeStringDouble = _formatFileSizeDouble(_fileSize);

        String? _shortFileName;
        if (p.basename(_fileName).length > 15) {
          // Truncate the name to 12 characters and add ellipsis
          _shortFileName = '${p.basename(_fileName).substring(0, 12)}...';
        } else {
          _shortFileName = p.basename(_fileName); // Use the full name if it's already short
        }
        list.value.add(MediaListingModel(file: file, previewImage: null, fileName: _shortFileName, date: _formatDate(_pickDate), Size: _filesizeString, calculateSize: _filesizeStringDouble, isGraterThan10: _filesizeStringDouble < 10.00 ? false : true));
      }

      list.refresh();
    });
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

      double? _filesizeStringDouble = _formatFileSizeDouble(_fileSize);

      if (p.basename(_fileName).length > 15) {
        // Truncate the name to 12 characters and add ellipsis
        _shortFileName = '${p.basename(_fileName).substring(0, 12)}...';
      } else {
        _shortFileName = p.basename(_fileName); // Use the full name if it's already short
      }
      list.value.add(MediaListingModel(file: file, previewImage: null, fileName: _shortFileName, date: _formatDate(_pickDate), Size: _filesizeString, calculateSize: _filesizeStringDouble, isGraterThan10: _filesizeStringDouble < 10.00 ? false : true));
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
      profileParams['profile_image'] = [profileImage.value!];
    } else {
      customPrint("profile is not  available");
    }

    if (selectedList.isNotEmpty) {
      customPrint("profile is   available");
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
    String? time = selectedVisitTimeValueController.text;
    customPrint(visitDateController.text);
    customPrint(selectedVisitTimeValueController.text);

    if (time != "") {
      DateTime firstTime = DateFormat('hh:mm a').parse(time).toUtc(); // 10:30 AM to DateTime

      // Now format it to the hh:mm:ss format
      String formattedTime = DateFormat('HH:mm:ss').format(firstTime.toUtc());

      customPrint("date time is $formattedTime");

      param['visit_time'] = formattedTime;
    }

    param["existing_patient"] = isExistingPatient.value.toString();

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

  Future<void> editPatient() async {
    Loader().showLoadingDialogForSimpleLoader();

    // if (!isFromSchedule.value) {
    //   visitDateController.clear();
    // }
    isLoading.value = true;

    Map<String, dynamic> param = {};
    Map<String, List<File>> profileParams = {};

    param['first_name'] = firstNameController.text;
    if (profileImage.value != null) {
      customPrint("profile is   available");
      profileParams['profile_image'] = [profileImage.value!];
    } else {
      if (profileImage.value == null) {
        param['isDeleteProfileImage'] = true;
      }

      customPrint("profile is not  available");
    }

    if (patientIdController.text.trim().isNotEmpty) {
      param['patient_id'] = patientIdController.text;
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
    if (contactNumberController.text != "") {
      if (extractDigits(contactNumberController.text.trim()) != "") {
        param['contact_no'] = extractDigits(contactNumberController.text.trim());
      }
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
    String? time = selectedVisitTimeValueController.text;
    customPrint(visitDateController.text);
    customPrint(selectedVisitTimeValueController.text);

    if (time != null) {
      DateTime firstTime = DateFormat('hh:mm a').parse(time).toUtc(); // 10:30 AM to DateTime

      // Now format it to the hh:mm:ss format
      String formattedTime = DateFormat('HH:mm:ss').format(firstTime);

      customPrint("date time is $formattedTime");

      param['visit_time'] = formattedTime;
    }

    customPrint("param is :- $param");

    try {
      var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

      dynamic response = await _editPatientDetailsRepository.updatePatient(files: profileParams, id: editId.value, param: param, token: loginData.responseData?.token ?? "");

      isLoading.value = false;
      await uploadAttachments(patientId.text);
      isLoading.value = false;
      CustomToastification().showToast("Patient Update successfully", type: ToastificationType.success);

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
      profileParams['attachments'] = selectedList.map((model) => model.file).toList().whereType<File>().toList();
    } else {
      customPrint("profile is not  available");
    }

    try {
      await _addPatientRepository.uploadAttachments(files: profileParams, token: loginData.responseData?.token ?? "", patientVisitId: patientId);
      selectedList.clear();
      Get.back();
    } catch (e) {
      selectedList.clear();
      Get.back();
    }

    return true;
  }

  Future<void> clearForm({BuildContext? context}) async {
    // selectedVisitTime.value = "";
    patientAttachmentList.clear();

    selectedVisitTimeValueController.clear();

    doctorFiledController = TextEditingController();

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
    firstNameController.text = "";
    middleNameController.text = "";
    lastNameController.text = "";
    emailAddressController.text = "";
    selectedMedicalValue.value = "";
    selectedDoctorValue.value = "";
    selectedMedicalValueModel.value = null;
    selectedDoctorValueModel.value = null;
    selectedDoctorValue.refresh();
    selectedMedicalValue.refresh();
    isValid.refresh();
    selectedVisitTimeValueController.text = getNextRoundedTime();
    visitDateController.text = DateFormat('MM/dd/yyyy').format(DateTime.now());
    selectedSexValue.value = "Male";
    selectedSexValue.refresh();
    isAddPatient.value = false;
    isOldPatient.value = false;
    searchController.text = "";
    suggestionsController.close();
    getLatestId();

    if (context != null) FocusScope.of(context).unfocus();
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
                  if (selectedVisitTimeValueController.text == "") {
                    selectedVisitTimeValueController.text = "12:00 AM";
                  }

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

  Future<void> launchInAppWithBrowserOptions(Uri url) async {
    customPrint("launch url is :- $url");

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
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

  Future<void> getPatientById(String id) async {
    patientDetailModel = await _editPatientDetailsRepository.getPatient(id: id, param: {});
  }

  Future<void> getPatientAttachment(String attachmentPatientId) async {
    if (attachmentPatientId != "") {
      try {
        PatientAttachmentListModel patientAttachmentData = await visitMainRepository.getPatientAttachment(id: attachmentPatientId, param: {});
        patientAttachmentList.value = patientAttachmentData.responseData ?? [];
      } catch (error) {
        customPrint("getPatientAttachment error is :- $error");
      }
    }
  }

  void setUi(PatientListData? value) {
    getPatientAttachment(value?.id.toString() ?? "");

    patientId.text = value?.patientId ?? "";
    editId.value = value?.id.toString() ?? "";
    firstNameController.text = value?.firstName ?? "";
    lastNameController.text = value?.lastName ?? "";
    middleNameController.text = value?.middleName ?? "";
    // dobController.text = value?.dateOfBirth ?? "" ;
    selectedSexValue.value = value?.gender ?? "";
    contactNumberController.text = value?.contactNo ?? "+1";
    contactNumberController.text = formatPhoneNumber(value?.contactNo ?? "+1");
    emailAddressController.text = value?.email ?? "";
    isOldPatient.value = true;

    selectedVisitTimeValueController.text = getNextRoundedTime();
    visitDateController.text = DateFormat('MM/dd/yyyy').format(DateTime.now());
    if (value?.dateOfBirth != null) {
      DateTime dateTime = DateTime.parse(value?.dateOfBirth ?? "").toLocal();
      DateFormat dateFormat = DateFormat('MM/dd/yyyy');

      // Format the DateTime object to the desired format
      String formattedDate = dateFormat.format(dateTime);

      dobController.text = formattedDate;
      customPrint("dob is :- $formattedDate");
    }
  }
}

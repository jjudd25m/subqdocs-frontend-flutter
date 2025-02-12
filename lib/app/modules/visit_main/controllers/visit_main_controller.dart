import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../services/media_picker_services.dart';
import '../../../../utils/app_string.dart';
import '../../../core/common/app_preferences.dart';
import '../../../data/service/recorder_service.dart';
import '../../../models/media_listing_model.dart';
import '../../../routes/app_pages.dart';
import '../../login/model/login_model.dart';
import '../model/patient_transcript_upload_model.dart';
import '../repository/visit_main_repository.dart';
import '../views/attachmentDailog.dart';

class VisitMainController extends GetxController {
  //TODO: Implement VisitMainController

  final VisitMainRepository _visitMainRepository = VisitMainRepository();
  RecorderService recorderService = RecorderService();

  RxBool isExpandRecording = true.obs;
  final count = 0.obs;
  RxBool isStartRecording = false.obs;
  RxInt isSelectedAttchmentOption = RxInt(0);
  List<String> patientType = ["New Patient", "Old Patient"];
  RxnString selectedMedicalAssistant = RxnString();
  RxList<MediaListingModel> selectedList = RxList();

  Future<void> captureProfileImage() async {
    XFile? pickedImage = await MediaPickerServices().pickImage();
    print("picked image is  ${pickedImage}");

    if (pickedImage != null) {}
  }

  String _formatDate(DateTime date) {
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    return dateFormat.format(date); // Format date to dd/MM/yyyy
  }

  String _formatFileSize(int bytes) {
    double sizeInKB = bytes / 1024; // Convert bytes to KB
    double sizeInMB = sizeInKB / 1024; // Convert KB to MB
    return "${sizeInMB.toStringAsFixed(2)} MB";
  }

  Future<void> captureImage(BuildContext context, {bool fromCamera = true}) async {
    XFile? image = await MediaPickerServices().pickImage(fromCamera: fromCamera);

    print("media  file is  ${image}");

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
      list.value.add(MediaListingModel(
          file: file,
          previewImage: null,
          fileName: _shortFileName,
          date: _formatDate(_pickDate),
          Size: _filesizeString));
    }

    list.refresh();
    showCustomDialog(context);
  }

  Future<void> pickFiles(BuildContext context) async {
    List<XFile>? fileList = await MediaPickerServices().pickMultiMedia();

    print("media  file is  ${fileList}");

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
          File file = File(element.path);
          _fileSize = file.lengthSync(); // Size in bytes

          String? _filesizeString = _formatFileSize(_fileSize);

          String? _shortFileName;
          if (p.basename(_fileName).length > 15) {
            // Truncate the name to 12 characters and add ellipsis
            _shortFileName = p.basename(_fileName).substring(0, 12) + '...';
          } else {
            _shortFileName = p.basename(_fileName); // Use the full name if it's already short
          }
          list.value.add(MediaListingModel(
              file: file,
              previewImage: null,
              fileName: _shortFileName,
              date: _formatDate(_pickDate),
              Size: _filesizeString));
        }

        list.refresh();

        showCustomDialog(context);
      },
    );
  }

  RxString visitId = RxString("");
  RxList<MediaListingModel> list = RxList();

  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true, // Allows dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return attachmentDailog(); // Our custom dialog
      },
    );
  }

  @override
  void onInit() {
    super.onInit();

    visitId.value = Get.arguments["visitId"];
    print("visit id is :- $visitId");
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  Future<void> submitAudio(File audioFile) async {
    var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

    PatientTranscriptUploadModel patientTranscriptUploadModel = await _visitMainRepository.uploadAudio(
        audioFile: audioFile, token: loginData.responseData?.token ?? "", patientVisitId: visitId.value);
    print("audio upload response is :- ${patientTranscriptUploadModel.toJson()}");

    Get.toNamed(Routes.PATIENT_INFO, arguments: {
      "trascriptUploadData": patientTranscriptUploadModel,
    });
  }

  Future<void> uploadAttachments() async {
    var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

    Map<String, List<File>> profileParams = {};
    if (selectedList.isNotEmpty) {
      print("profile is   available");
      // param['profile_image'] = profileImage.value;
      profileParams['attachments'] = selectedList.map((model) => model.file).toList().whereType<File>().toList();

      ;
    } else {
      print("profile is not  available");
    }
    await _visitMainRepository.uploadAttachments(
        files: profileParams, token: loginData.responseData?.token ?? "", patientVisitId: visitId.value);
  }
}

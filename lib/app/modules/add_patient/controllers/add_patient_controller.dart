import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:path/path.dart' as p;

import '../../../../services/media_picker_services.dart';
import '../../../models/media_listing_model.dart';

class AddPatientController extends GetxController {
  //TODO: Implement AddPatientController

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
  List<String> visitTime = ["11 PM", "12 PM", "13 PM"];
  List<String> sex = ["Female", "Male"];
  List<String> patientType = ["New Patient", "Old Patient"];

  RxList<MediaListingModel> list = RxList();

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
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
  String _formatFileSize(int bytes) {
    double sizeInKB = bytes / 1024; // Convert bytes to KB
    double sizeInMB = sizeInKB / 1024; // Convert KB to MB
    return "${sizeInMB.toStringAsFixed(2)} MB";
  }

  String _formatDate(DateTime date) {
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    return dateFormat.format(date); // Format date to dd/MM/yyyy
  }

  Future<void> pickFiles() async {
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
          list.value.add(MediaListingModel(null, _fileName, _formatDate(_pickDate), _filesizeString));
        }

        list.refresh();
      },
    );
  }

  Future<void> captureImage() async {
    XFile? image = await MediaPickerServices().pickImage();

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
      list.value.add(MediaListingModel(null, _shortFileName, _formatDate(_pickDate), _filesizeString));
    }

    list.refresh();
  }

  void removeItem(int index) {
    list.value.removeAt(index);
    list.refresh();
  }
}

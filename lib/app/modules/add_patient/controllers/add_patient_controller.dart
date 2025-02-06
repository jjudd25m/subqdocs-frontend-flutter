import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:path/path.dart' as p;
import 'package:toastification/toastification.dart';

import '../../../../services/media_picker_services.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../widgets/custom_toastification.dart';
import '../../../models/media_listing_model.dart';
import '../model/add_patient_model.dart';
import '../repository/add_patient_repository.dart';

class AddPatientController extends GetxController {
  //TODO: Implement AddPatientController

  final AddPatientRepository _addPatientRepository = AddPatientRepository();
  RxBool isLoading = RxBool(false);

  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController visitDateController = TextEditingController();
  TextEditingController patientIdController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  RxString dob = RxString("");
  RxString visitDate = RxString("");

  RxnString selectedSexValue = RxnString("Male");
  RxnString selectedPatientValue = RxnString();
  RxnString selectedVisitTimeValue = RxnString();
  List<String> visitTime = ["10 AM ", "11 AM", "12 PM", " 1 PM", "2 PM", "3 PM"];
  RxString selectedVisitTime = RxString("11 PM");
  List<String> sex = ["Female", "Male"];
  List<String> patientType = ["New Patient", "Old Patient"];

  RxList<MediaListingModel> list = RxList();

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();

    // visitTime = generateTimeIntervals();
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
    list.removeAt(index);
    list.refresh();
  }

  Future<void> addPatient() async {
    isLoading.value = true;

    // DateTime finalDateTimeFromString = mergeDateAndTimeFromString(visitDate.value, selectedVisitTimeValue.value ?? "");
    // DateTime finalDateTimeFromDateTime = mergeDateAndTimeFromDateTime(selectedDateTime, selectedTime);

    // String strVisit_time = DateFormat('yyyy-MM-ddTHH:mm:ss.sssZ').format(finalDateTimeFromString);
    //
    // print("Merged DateTime from String: $finalDateTimeFromString");
    // print("Merged DateTime from DateTime: $finalDateTimeFromDateTime");

    Map<String, dynamic> param = {};

    param['first_name'] = firstNameController.text;
    param['middle_name'] = middleNameController.text;
    param['last_name'] = lastNameController.text;
    param['date_of_birth'] = DateFormat('yyyy-MM-dd').format(DateFormat('MM/dd/yyyy').parse(dobController.text));

    param['gender'] = selectedSexValue.value;
    param['email'] = emailAddressController.text;
    param['visit_date'] = '${visitDate.value}Z';
    param['visit_date'] = DateFormat('yyyy-MM-dd').format(DateFormat('MM/dd/yyyy').parse(visitDateController.text));

    String date = visitDateController.text;
    String time = selectedVisitTime.value;
    print(visitDateController.text);
    print(selectedVisitTime.value);

    DateTime dt = DateFormat("dd/MM/yyyy hh a").parse("$date $time");
    print(" time is  ${dt.toIso8601String()}");
    param['visit_time'] = dt.toIso8601String();

    print("param is :- $param");

    // try {
    //   AddPatientModel addPatientModel = await _addPatientRepository.addPatient(param: param);
    //   isLoading.value = false;
    //   print("_addPatientRepository response is ${addPatientModel.toJson()} ");
    //   Get.back();
    // } catch (error) {
    //   isLoading.value = false;
    //   print("_addPatientRepository catch error is $error");
    //   CustomToastification().showToast("$error", type: ToastificationType.error);
    // }
  }

  // List<String> generateTimeIntervals() {
  //   List<String> times = [];
  //   DateTime currentTime = DateTime(2023, 1, 1, 0, 0); // Start at 12:00 AM
  //
  //   for (int i = 0; i < 48; i++) {
  //     String formattedTime = formatTime(currentTime);
  //     times.add(formattedTime);
  //     currentTime = currentTime.add(Duration(minutes: 15)); // Increment by 15 minutes
  //   }
  //
  //   return times;
  // }

//   String formatTime(DateTime time) {
//     int hour = time.hour;
//     int minute = time.minute;
//
//     String period = hour >= 12 ? 'PM' : 'AM';
//     hour = hour % 12;
//     if (hour == 0) hour = 12; // Handle midnight and noon
//
//     String minuteStr = minute.toString().padLeft(2, '0');
//     return '$hour:$minuteStr $period';
//   }
//
//   // Merge time into the date when the date is a String
//   DateTime mergeDateAndTimeFromString(String dateString, String timeString) {
//     DateTime dateTime = DateTime.parse(dateString); // Convert string to DateTime
//
//     // Parse the time to extract hour and minute
//     DateTime time = parseTime(timeString);
//
//     // Return a new DateTime with merged date and time
//     return DateTime(dateTime.year, dateTime.month, dateTime.day, time.hour, time.minute);
//   }
//
// // Merge time into the date when the date is a DateTime
//   DateTime mergeDateAndTimeFromDateTime(DateTime dateTime, String timeString) {
//     // Parse the time to extract hour and minute
//     DateTime time = parseTime(timeString);
//
//     // Return a new DateTime with merged date and time
//     return DateTime(dateTime.year, dateTime.month, dateTime.day, time.hour, time.minute);
//   }
//
// // Helper function to parse time string (e.g., "3:30 PM") into DateTime
//   DateTime parseTime(String timeString) {
//     // Extract the hour and minute, and convert to 24-hour format
//     RegExp timeRegExp = RegExp(r"(\d{1,2}):(\d{2}) (AM|PM)");
//     Match? match = timeRegExp.firstMatch(timeString);
//
//     if (match != null) {
//       int hour = int.parse(match.group(1)!);
//       int minute = int.parse(match.group(2)!);
//       String period = match.group(3)!;
//
//       // Convert hour to 24-hour format
//       if (period == "PM" && hour != 12) {
//         hour += 12;
//       } else if (period == "AM" && hour == 12) {
//         hour = 0;
//       }
//
//       return DateTime(0, 1, 1, hour, minute); // Return DateTime with hour and minute only
//     } else {
//       throw FormatException("Invalid time format.");
//     }
//   }

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
}

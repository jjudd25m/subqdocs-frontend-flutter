import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:path/path.dart' as p;
import 'package:toastification/toastification.dart';

import '../../../../services/media_picker_services.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/app_string.dart';
import '../../../../widgets/custom_toastification.dart';
import '../../../core/common/app_preferences.dart';
import '../../../models/media_listing_model.dart';
import '../../login/model/login_model.dart';
import '../model/add_patient_model.dart';
import '../repository/add_patient_repository.dart';

class AddPatientController extends GetxController {
  //TODO: Implement AddPatientController

  final AddPatientRepository _addPatientRepository = AddPatientRepository();
  RxBool isLoading = RxBool(false);

  TextEditingController firstNameController = TextEditingController();
  TextEditingController patientId = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController visitDateController = TextEditingController();
  TextEditingController patientIdController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  RxString dob = RxString("");
  RxString visitDate = RxString("");
  Rxn<File> profileImage = Rxn();
  RxnString selectedSexValue = RxnString("Male");
  RxnString selectedPatientValue = RxnString();
  RxnString selectedVisitTimeValue = RxnString();

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

  void addImage() {
    selectedList.addAll(list);
    list.clear();
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
          list.value.add(MediaListingModel(file: file, previewImage: null, fileName: _shortFileName, date: _formatDate(_pickDate), Size: _filesizeString));
        }

        list.refresh();
      },
    );
  }

  Future<void> captureProfileImage() async {
    XFile? pickedImage = await MediaPickerServices().pickImage();
    print("picked image is  ${pickedImage}");

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
      list.value.add(MediaListingModel(file: file, previewImage: null, fileName: _shortFileName, date: _formatDate(_pickDate), Size: _filesizeString));
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
    Map<String, List<File>> profileParams = {};

    param['first_name'] = firstNameController.text;
    if (profileImage.value != null) {
      print("profile is   available");
      // param['profile_image'] = profileImage.value;
      profileParams['profile_image'] = [profileImage.value!];
    } else {
      print("profile is not  available");
    }

    if (selectedList.isNotEmpty) {
      print("profile is   available");
      // param['profile_image'] = profileImage.value;
      profileParams['attachments'] = selectedList.map((model) => model.file).toList().whereType<File>().toList();

      ;
    } else {
      print("profile is not  available");
    }

    param['patient_id'] = patientId.text;

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

    var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

    try {
      AddPatientModel addPatientModel = await _addPatientRepository.addPatient(param: param, files: profileParams, token: loginData.responseData?.token ?? "");
      isLoading.value = false;
      print("_addPatientRepository response is ${addPatientModel.toJson()} ");
      Get.back(result: 1);
    } catch (error) {
      isLoading.value = false;
      print("_addPatientRepository catch error is $error");
      CustomToastification().showToast("$error", type: ToastificationType.error);
    }
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
                  if (selectedVisitTimeValue.value == null) {
                    selectedVisitTimeValue.value = "12:00 AM";
                  }

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

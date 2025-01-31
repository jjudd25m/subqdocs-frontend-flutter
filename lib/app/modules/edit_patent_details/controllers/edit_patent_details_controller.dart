import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class EditPatentDetailsController extends GetxController {
  //TODO: Implement EditPatentDetailsController

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
}

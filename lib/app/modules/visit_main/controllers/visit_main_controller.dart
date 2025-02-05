import 'package:get/get.dart';

class VisitMainController extends GetxController {
  //TODO: Implement VisitMainController

  RxBool isExpandRecording = true.obs;
  final count = 0.obs;
  RxBool isStartRecording = false.obs;
  RxInt isSelectedAttchmentOption = RxInt(0);
  List<String> patientType = ["New Patient", "Old Patient"];
  RxnString selectedMedicalAssistant = RxnString();

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

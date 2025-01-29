import 'package:get/get.dart';

class PatientInfoController extends GetxController {
  //TODO: Implement PatientInfoController

  RxInt tabIndex = RxInt(1);
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

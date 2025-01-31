import 'package:get/get.dart';

class PatientViewReadOnlyController extends GetxController {
  //TODO: Implement PatientViewReadOnlyController

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

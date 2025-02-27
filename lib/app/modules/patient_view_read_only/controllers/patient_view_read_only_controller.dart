import 'package:get/get.dart';

class PatientViewReadOnlyController extends GetxController {
  //TODO: Implement PatientViewReadOnlyController

  RxInt tabIndex = RxInt(1);
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  void increment() => count.value++;
}

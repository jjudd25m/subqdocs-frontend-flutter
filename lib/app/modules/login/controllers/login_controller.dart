import 'package:get/get.dart';

class LoginController extends GetxController {
  //TODO: Implement LoginController

  RxBool visiblity = RxBool(false);

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

  void changeVisiblity() {
    visiblity.value = visiblity == true ? false : true;
    visiblity.refresh();
  }
}

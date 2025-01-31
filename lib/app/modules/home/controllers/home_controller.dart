import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();

  final count = 0.obs;

  RxInt tabIndex = RxInt(0);

  RxBool isPast = RxBool(false);

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

  void changeScreen(bool isPast) async {
    this.isPast.value = isPast;
    this.isPast.refresh();
  }
}

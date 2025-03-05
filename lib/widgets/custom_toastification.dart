import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

class CustomToastification {
  //App related

  void showToast(String message, {ToastificationType type = ToastificationType.success, int toastDuration = 3}) {
    toastification.show(
      context: Get.context,
      type: type,
      title: Text(message),
      alignment: Alignment.bottomCenter,
      style: ToastificationStyle.flat,
      autoCloseDuration: Duration(seconds: toastDuration),
      showProgressBar: false,
    );
  }
}

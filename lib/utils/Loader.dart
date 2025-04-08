import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'app_colors.dart';

class Loader {
  void showLoadingDialogForSimpleLoader() {
    Get.dialog(
      Center(
        child: Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: AppColors.backgroundPurple), // Customize color here
                SizedBox(height: 20),
                Text('Please wait...', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false, // Prevent dismissing the dialog by tapping outside
    );
  }

  void stopLoader() {
    Get.back();
  }
}

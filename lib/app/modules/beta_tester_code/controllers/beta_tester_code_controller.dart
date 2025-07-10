import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

import '../../../../widgets/custom_toastification.dart';
import '../../../core/common/logger.dart';
import '../../../routes/app_pages.dart';
import '../Model/validate_beta_tester_code_model.dart';
import '../repository/beta_tester_code_repository.dart';

class BetaTesterCodeController extends GetxController {
  //TODO: Implement BetaTesterCodeController

  final BetaTesterCodeRepository betaTesterCodeRepository = BetaTesterCodeRepository();

  TextEditingController emailController = TextEditingController();
  TextEditingController betaCodeController = TextEditingController();

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  Future<void> validateBetaTesterCode() async {
    ValidateBetaTesterCodeModel res = await betaTesterCodeRepository.validateBetaTesterCode(code: betaCodeController.text.trim());
    customPrint("response is:- $res");
    if (res.responseData == true) {
      Get.toNamed(Routes.SIGN_UP, arguments: {'beta_code': betaCodeController.text.trim()});
    } else {
      CustomToastification().showToast(res.message ?? "", type: ToastificationType.error);
    }
  }

  Future<void> joinWishlist() async {
    dynamic res = await betaTesterCodeRepository.joinWishlist(email: emailController.text);
    CustomToastification().showToast(res['message'] ?? "", type: ToastificationType.success);
    Get.back();
  }
}

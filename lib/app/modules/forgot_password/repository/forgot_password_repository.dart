import 'package:subqdocs/app/modules/forgot_password/models/valid_otp_model.dart';

import '../../../core/common/logger.dart';
import '../../../data/provider/api_provider.dart';
import '../models/send_otp_model.dart';

class ForgotPasswordRepository {
  Future<SendOtpModel> sendOtp({required String email}) async {
    var response = await ApiProvider.instance.callPost("user/sendOtp/$email", params: {});
    customPrint("Login API  internal response $response");
    return SendOtpModel.fromJson(response);
  }

  Future<VerifyOtpModel> verifyOpt({required Map<String, dynamic> param}) async {
    var response = await ApiProvider.instance.callPost("user/verifyOtp", params: param);
    customPrint("Login API  internal response $response");
    return VerifyOtpModel.fromJson(response);
  }

  Future<VerifyOtpModel> resetPassword({required Map<String, dynamic> param}) async {
    var response = await ApiProvider.instance.callPost("user/resetPassword", params: param);
    customPrint("Login API  internal response $response");
    return VerifyOtpModel.fromJson(response);
  }
}

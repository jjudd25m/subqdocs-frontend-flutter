import '../../../core/common/logger.dart';
import '../../../data/provider/api_provider.dart';
import '../models/sign_up_models.dart';

class SignupRepository {
  Future<SignUpModel> registerUser({
    required Map<String, dynamic> param,
  }) async {
    var response = await ApiProvider.instance.callPostWithoutHeader(
      "auth/register",
      params: param,
    );

    customPrint("registerUser API  internal response $response");

    return SignUpModel.fromJson(response);
  }

  Future<CheckNewUserModel> checkIsNewUser({required String email}) async {
    var response = await ApiProvider.instance.callGet(
      "user/checkIsNewUser?email=$email",
    );

    customPrint("checkIsNewUser API  internal response $response");

    return CheckNewUserModel.fromJson(response);
  }
}

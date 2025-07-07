import '../../../core/common/app_preferences.dart';
import '../../../core/common/logger.dart';
import '../../../data/provider/api_provider.dart';
import '../model/login_model.dart';

class LoginRepository {
  Future<LoginModel> login({required String email, required String password}) async {
    try {
      var response = await ApiProvider.instance.callPost("auth/login", params: {"email": email, "password": password});
      customPrint("Login API  internal response $response");
      return LoginModel.fromJson(response);
    } catch (e) {
      customPrint("catch Login API  internal response $e");
      return LoginModel.fromJson({});
    }
  }

  Future<bool> logOutUser() async {
    var response = await ApiProvider.instance.callPost("auth/logout");
    if (response["data"]["success"]) {
      AppPreference.instance.clearPreference();
    }
    return response["data"]["success"];
  }
}

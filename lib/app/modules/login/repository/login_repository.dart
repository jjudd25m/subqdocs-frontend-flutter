import '../../../core/common/app_preferences.dart';
import '../../../data/provider/api_provider.dart';
import '../model/login_model.dart';

class LoginRepository {
  Future<LoginModel> login({required String email, required String password}) async {
    var response = await ApiProvider.instance.callPost("auth/login", params: {"email": email, "password": password});
    print("Login API  internal response ${response}");
    return LoginModel.fromJson(response);
  }

  Future<bool> logOutUser() async {
    var response = await ApiProvider.instance.callPost("auth/logout");
    if (response["data"]["success"]) {
      AppPreference.instance.clearPreference();
    }
    return response["data"]["success"];
  }
}

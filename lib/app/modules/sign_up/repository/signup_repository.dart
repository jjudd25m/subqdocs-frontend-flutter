import 'package:flutter/foundation.dart';

import '../../../data/provider/api_provider.dart';
import '../models/sign_up_models.dart';

class SignupRepository {
  Future<SignUpModel> registerUser({required Map<String, dynamic> param}) async {
    var response = await ApiProvider.instance.callPostWithoutHeader("auth/register", params: param);

    print("registerUser API  internal response $response");

    return SignUpModel.fromJson(response);
  }
}

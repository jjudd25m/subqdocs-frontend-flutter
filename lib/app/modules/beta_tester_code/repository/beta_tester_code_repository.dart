import '../../../data/provider/api_provider.dart';
import '../Model/validate_beta_tester_code_model.dart';

class BetaTesterCodeRepository {
  Future<ValidateBetaTesterCodeModel> validateBetaTesterCode({required String code}) async {
    var response = await ApiProvider.instance.callPostWithoutHeader("user/validateBetaTesterCode", params: {'code': code});
    print("ValidateBetaTesterCodeModel res:- ${response}");
    ValidateBetaTesterCodeModel res = ValidateBetaTesterCodeModel.fromJson(response);
    return res;
  }

  Future<dynamic> joinWishlist({required String email}) async {
    var response = await ApiProvider.instance.callPostWithoutHeader("user/joinWishlist", params: {'email': email});
    print("joinWishlist :- $response");
    return response;
  }
}

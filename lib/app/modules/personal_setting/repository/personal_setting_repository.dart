import '../../../core/common/app_preferences.dart';
import '../../../core/common/logger.dart';
import '../../../data/provider/api_provider.dart';
import '../model/get_user_detail_model.dart';

class PersonalSettingRepository {
  Future<GetUserDetailModel> getUserDetail({required String userId}) async {
    var response = await ApiProvider.instance.callGet("user/$userId");
    customPrint("getUserDetail API  internal response $response");
    return GetUserDetailModel.fromJson(response);
  }

  Future<GetOrganizationDetailModel> getOrganizationDetail() async {
    var response = await ApiProvider.instance.callGet("organization");
    customPrint("getUserDetail API  internal response $response");
    return GetOrganizationDetailModel.fromJson(response);
  }

  Future<GetUserOrganizationListModel> getUserByOrganization() async {
    var response = await ApiProvider.instance.callGet("organization/users");
    customPrint("getUserByOrganization API  internal response $response");
    return GetUserOrganizationListModel.fromJson(response);
  }

  Future<UpdateRoleAndAdminResponseModel> updateRoleAndAdminControl({required Map<String, dynamic> param}) async {
    var response = await ApiProvider.instance.callPut("user/updateRoleAndAdminControll", param);
    customPrint("UpdateRoleAndAdminControl API  internal response $response");
    return UpdateRoleAndAdminResponseModel.fromJson(response);
  }
}

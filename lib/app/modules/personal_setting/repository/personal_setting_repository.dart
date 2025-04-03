import 'dart:io';

import '../../../core/common/app_preferences.dart';
import '../../../core/common/logger.dart';
import '../../../data/provider/api_provider.dart';
import '../model/get_user_detail_model.dart';

class PersonalSettingRepository {
  Future<GetUserDetailModel> getUserDetail({required String userId}) async {
    var response = await ApiProvider.instance.callGet("user");
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
    var response = await ApiProvider.instance.callPutWithoutError("user/updateRoleAndAdminControll", param);
    customPrint("UpdateRoleAndAdminControl API  internal response $response");
    return UpdateRoleAndAdminResponseModel.fromJson(response);
  }

  Future<GetUserRolesModel> getUserRole() async {
    var response = await ApiProvider.instance.callGet("user/roles");
    customPrint("getUserRole API  internal response $response");
    return GetUserRolesModel.fromJson(response);
  }

  Future<InvitedUserResponseModel> userInvite({required Map<String, dynamic> param}) async {
    var response = await ApiProvider.instance.callPost("user/invite", params: param);
    customPrint("userInvite API  internal response $response");
    return InvitedUserResponseModel.fromJson(response);
  }

  Future<dynamic> updateUserDetail({required Map<String, dynamic> param, required Map<String, List<File>> files, required String token}) async {
    var response = await ApiProvider.instance.callPutMultiPartDioListOfFiles(url: 'user', params: param, files: files, token: token);
    customPrint("updateOrganization API  internal response $response");
    return response;
  }

  Future<dynamic> updateOrganization({required Map<String, dynamic> param, required Map<String, List<File>> files, required String token}) async {
    var response = await ApiProvider.instance.callPutMultiPartDioListOfFiles(url: "organization", params: param, files: files, token: token);
    customPrint("updateOrganization API  internal response $response");
    return response;
  }
}

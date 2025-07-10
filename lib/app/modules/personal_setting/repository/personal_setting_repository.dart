import 'dart:io';

import '../../../core/common/logger.dart';
import '../../../data/provider/api_provider.dart';
import '../../sign_up_set_organization_info/models/SignUpOrganizationModel.dart';
import '../model/delete_user_model.dart';
import '../model/force_sync_log_model.dart';
import '../model/get_available_visit_types.dart';
import '../model/get_emaconfig_model.dart';
import '../model/get_user_detail_model.dart';

class PersonalSettingRepository {
  Future<GetUserDetailModel> getUserDetail({required String userId}) async {
    var response = await ApiProvider.instance.callGet("user");
    customPrint("getUserDetail API  internal response $response");
    return GetUserDetailModel.fromJson(response);
  }

  Future<GetOrganizationDetailModel> getOrganizationDetail() async {
    var response = await ApiProvider.instance.callGet("organization");
    customPrint("getOrganizationDetail API  internal response $response");
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
    try {
      var response = await ApiProvider.instance.callPutMultiPartDioListOfFiles(url: "organization", params: param, files: files, token: token);
      customPrint("updateOrganization API  internal response $response");
      return response;
    } catch (e) {
      customPrint("updateOrganization API  internal response $e");
      rethrow;
    }
  }

  Future<SignUpOrganizationModel> organizationUpdate({required Map<String, dynamic> param, required String organizationId}) async {
    var response = await ApiProvider.instance.callPut("organization/update/$organizationId", param);
    customPrint("organizationUpdate API  internal response $response");
    return SignUpOrganizationModel.fromJson(response);
  }

  Future<DeleteUserModel> deleteUserAccount({required String userId}) async {
    var response = await ApiProvider.instance.callDelete(url: 'user/delete/$userId', data: {});
    customPrint("deleteUserAccount API  internal response $response");
    return DeleteUserModel.fromJson(response);
  }

  Future<DeleteUserModel> deleteUserManagementMember({required String userId}) async {
    var response = await ApiProvider.instance.callDelete(url: 'user/invite/$userId', data: {});
    customPrint("deleteUserManagementMember API  internal response $response");
    return DeleteUserModel.fromJson(response);
  }

  Future<GetAvailableVisitTypes> getAvailableVisitTypes() async {
    var response = await ApiProvider.instance.callGet("patient-visit/getAvailableVisitTypes");
    customPrint("getAvailableVisitTypes API  internal response $response");
    return GetAvailableVisitTypes.fromJson(response);
  }

  Future<dynamic> forceSyncUpdate() async {
    var response = await ApiProvider.instance.callGet("patient-visit/force-sync");
    customPrint("forceSyncUpdate API  internal response $response");
    return response;
  }

  Future<GetEmaConfigModel> getEmaConfig() async {
    var response = await ApiProvider.instance.callGet("ema/ema-config");
    customPrint("getEmaConfig API  internal response $response");
    return GetEmaConfigModel.fromJson(response);
  }

  Future<ForceSyncLogModel> getForceSyncLog() async {
    var response = await ApiProvider.instance.callGet("patient-visit/force-sync-log");
    // customPrint("getEmaConfig API  internal response $response");
    return ForceSyncLogModel.fromJson(response);
  }

  Future<dynamic> saveEmaConfig(Map<String, dynamic> param) async {
    try {
      var response = await ApiProvider.instance.callPost("ema/organization/EmaConfig", params: param);
      customPrint("saveEmaConfig API  internal response $response");
      return response;
    } catch (e) {
      // return {"message": "Something went wrong"};
    }
  }

  Future<DefaultResponseModel> activeUser(Map<String, dynamic> param) async {
    var response = await ApiProvider.instance.callPost("user/activate", params: param);
    // customPrint("activeUser API  internal response $response");
    return DefaultResponseModel.fromJson(response);
  }
}

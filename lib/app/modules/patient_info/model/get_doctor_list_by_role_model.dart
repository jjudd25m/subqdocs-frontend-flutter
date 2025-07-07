class GetDoctorListByRoleModel {
  List<GetDoctorListByRoleResponseData>? responseData;
  String? message;
  bool? toast;
  String? responseType;

  GetDoctorListByRoleModel({this.responseData, this.message, this.toast, this.responseType});

  GetDoctorListByRoleModel.fromJson(Map<String, dynamic> json) {
    if (json['responseData'] != null) {
      responseData = <GetDoctorListByRoleResponseData>[];
      json['responseData'].forEach((v) {
        responseData!.add(GetDoctorListByRoleResponseData.fromJson(v));
      });
    }
    message = json['message'];
    toast = json['toast'];
    responseType = json['response_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (responseData != null) {
      data['responseData'] = responseData!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    data['toast'] = toast;
    data['response_type'] = responseType;
    return data;
  }
}

class GetDoctorListByRoleResponseData {
  int? id;
  String? name;
  String? profileImage;
  String? deletedAt;

  GetDoctorListByRoleResponseData({this.id, this.name, this.profileImage, this.deletedAt});

  GetDoctorListByRoleResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    profileImage = json['profile_image'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['profile_image'] = profileImage;
    data['deleted_at'] = deletedAt;
    return data;
  }
}

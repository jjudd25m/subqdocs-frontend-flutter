class MedicalDoctorModel {
  List<ResponseData>? responseData;
  String? message;
  bool? toast;
  String? responseType;

  MedicalDoctorModel({this.responseData, this.message, this.toast, this.responseType});

  MedicalDoctorModel.fromJson(Map<String, dynamic> json) {
    if (json['responseData'] != null) {
      responseData = <ResponseData>[];
      json['responseData'].forEach((v) {
        responseData!.add(ResponseData.fromJson(v));
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

class ResponseData {
  int? id;
  String? name;
  String? profileImage;
  String? deletedAt;

  ResponseData({this.id, this.name, this.profileImage, this.deletedAt});

  ResponseData.fromJson(Map<String, dynamic> json) {
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

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
        responseData!.add(new ResponseData.fromJson(v));
      });
    }
    message = json['message'];
    toast = json['toast'];
    responseType = json['response_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.responseData != null) {
      data['responseData'] = this.responseData!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['toast'] = this.toast;
    data['response_type'] = this.responseType;
    return data;
  }
}

class ResponseData {
  int? id;
  String? name;
  String? profileImage;

  ResponseData({this.id, this.name, this.profileImage});

  ResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['profile_image'] = this.profileImage;
    return data;
  }
}

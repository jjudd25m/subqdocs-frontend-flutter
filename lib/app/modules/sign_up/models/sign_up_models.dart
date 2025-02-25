class SignUpModel {
  ResponseData? responseData;
  String? message;
  bool? toast;
  String? responseType;

  SignUpModel({this.responseData, this.message, this.toast, this.responseType});

  SignUpModel.fromJson(Map<String, dynamic> json) {
    responseData = json['responseData'] != null ? ResponseData.fromJson(json['responseData']) : null;
    message = json['message'];
    toast = json['toast'];
    responseType = json['response_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (responseData != null) {
      data['responseData'] = responseData!.toJson();
    }
    data['message'] = message;
    data['toast'] = toast;
    data['response_type'] = responseType;
    return data;
  }
}

class ResponseData {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String? updatedAt;
  String? createdAt;
  dynamic secret2fa;
  dynamic profileImage;
  dynamic otp;
  dynamic otpGeneratedAt;
  dynamic deletedAt;

  ResponseData({this.id, this.firstName, this.lastName, this.email, this.password, this.updatedAt, this.createdAt, this.secret2fa, this.profileImage, this.otp, this.otpGeneratedAt, this.deletedAt});

  ResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    password = json['password'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    secret2fa = json['secret_2fa'];
    profileImage = json['profile_image'];
    otp = json['otp'];
    otpGeneratedAt = json['otp_generated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['password'] = password;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['secret_2fa'] = secret2fa;
    data['profile_image'] = profileImage;
    data['otp'] = otp;
    data['otp_generated_at'] = otpGeneratedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}

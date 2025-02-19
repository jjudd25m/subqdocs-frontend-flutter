class SignUpModel {
  ResponseData? responseData;
  String? message;
  bool? toast;
  String? responseType;

  SignUpModel({this.responseData, this.message, this.toast, this.responseType});

  SignUpModel.fromJson(Map<String, dynamic> json) {
    responseData = json['responseData'] != null ? new ResponseData.fromJson(json['responseData']) : null;
    message = json['message'];
    toast = json['toast'];
    responseType = json['response_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.responseData != null) {
      data['responseData'] = this.responseData!.toJson();
    }
    data['message'] = this.message;
    data['toast'] = this.toast;
    data['response_type'] = this.responseType;
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
  Null? secret2fa;
  Null? profileImage;
  Null? otp;
  Null? otpGeneratedAt;
  Null? deletedAt;

  ResponseData(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.password,
      this.updatedAt,
      this.createdAt,
      this.secret2fa,
      this.profileImage,
      this.otp,
      this.otpGeneratedAt,
      this.deletedAt});

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['password'] = this.password;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['secret_2fa'] = this.secret2fa;
    data['profile_image'] = this.profileImage;
    data['otp'] = this.otp;
    data['otp_generated_at'] = this.otpGeneratedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

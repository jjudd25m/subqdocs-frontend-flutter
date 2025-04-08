// class SignUpModel {
//   ResponseData? responseData;
//   String? message;
//   bool? toast;
//   String? responseType;
//
//   SignUpModel({this.responseData, this.message, this.toast, this.responseType});
//
//   SignUpModel.fromJson(Map<String, dynamic> json) {
//     responseData = json['responseData'] != null ? ResponseData.fromJson(json['responseData']) : null;
//     message = json['message'];
//     toast = json['toast'];
//     responseType = json['response_type'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (responseData != null) {
//       data['responseData'] = responseData!.toJson();
//     }
//     data['message'] = message;
//     data['toast'] = toast;
//     data['response_type'] = responseType;
//     return data;
//   }
// }
//
// class ResponseData {
//   int? id;
//   String? firstName;
//   String? lastName;
//   String? email;
//   String? password;
//   String? updatedAt;
//   String? createdAt;
//   dynamic secret2fa;
//   dynamic profileImage;
//   dynamic otp;
//   dynamic otpGeneratedAt;
//   dynamic deletedAt;
//
//   ResponseData({this.id, this.firstName, this.lastName, this.email, this.password, this.updatedAt, this.createdAt, this.secret2fa, this.profileImage, this.otp, this.otpGeneratedAt, this.deletedAt});
//
//   ResponseData.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     firstName = json['first_name'];
//     lastName = json['last_name'];
//     email = json['email'];
//     password = json['password'];
//     updatedAt = json['updated_at'];
//     createdAt = json['created_at'];
//     secret2fa = json['secret_2fa'];
//     profileImage = json['profile_image'];
//     otp = json['otp'];
//     otpGeneratedAt = json['otp_generated_at'];
//     deletedAt = json['deleted_at'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['first_name'] = firstName;
//     data['last_name'] = lastName;
//     data['email'] = email;
//     data['password'] = password;
//     data['updated_at'] = updatedAt;
//     data['created_at'] = createdAt;
//     data['secret_2fa'] = secret2fa;
//     data['profile_image'] = profileImage;
//     data['otp'] = otp;
//     data['otp_generated_at'] = otpGeneratedAt;
//     data['deleted_at'] = deletedAt;
//     return data;
//   }
// }

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
  bool? isAdmin;
  String? role;
  String? status;
  int? organizationId;
  String? degree;
  String? updatedAt;
  String? createdAt;
  dynamic secret2fa;
  dynamic profileImage;
  dynamic otp;
  dynamic otpGeneratedAt;
  dynamic lastLoginDate;
  dynamic contactNo;
  dynamic country;
  dynamic state;
  dynamic city;
  dynamic streetName;
  dynamic postalCode;
  dynamic title;
  dynamic medicalLicenseNumber;
  dynamic licenseExpiryDate;
  dynamic nationalProviderIdentifier;
  dynamic taxonomyCode;
  dynamic specialization;
  dynamic uploadedAt;
  dynamic invitationToken;
  dynamic deletedAt;

  ResponseData(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.isAdmin,
      this.role,
      this.status,
      this.organizationId,
      this.degree,
      this.updatedAt,
      this.createdAt,
      this.secret2fa,
      this.profileImage,
      this.otp,
      this.otpGeneratedAt,
      this.lastLoginDate,
      this.contactNo,
      this.country,
      this.state,
      this.city,
      this.streetName,
      this.postalCode,
      this.title,
      this.medicalLicenseNumber,
      this.licenseExpiryDate,
      this.nationalProviderIdentifier,
      this.taxonomyCode,
      this.specialization,
      this.uploadedAt,
      this.invitationToken,
      this.deletedAt});

  ResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    isAdmin = json['is_admin'];
    role = json['role'];
    status = json['status'];
    organizationId = json['organization_id'];
    degree = json['degree'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    secret2fa = json['secret_2fa'];
    profileImage = json['profile_image'];
    otp = json['otp'];
    otpGeneratedAt = json['otp_generated_at'];
    lastLoginDate = json['last_login_date'];
    contactNo = json['contact_no'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    streetName = json['street_name'];
    postalCode = json['postal_code'];
    title = json['title'];
    medicalLicenseNumber = json['medical_license_number'];
    licenseExpiryDate = json['license_expiry_date'];
    nationalProviderIdentifier = json['national_provider_identifier'];
    taxonomyCode = json['taxonomy_code'];
    specialization = json['specialization'];
    uploadedAt = json['uploaded_at'];
    invitationToken = json['invitation_token'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['is_admin'] = isAdmin;
    data['role'] = role;
    data['status'] = status;
    data['organization_id'] = organizationId;
    data['degree'] = degree;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['secret_2fa'] = secret2fa;
    data['profile_image'] = profileImage;
    data['otp'] = otp;
    data['otp_generated_at'] = otpGeneratedAt;
    data['last_login_date'] = lastLoginDate;
    data['contact_no'] = contactNo;
    data['country'] = country;
    data['state'] = state;
    data['city'] = city;
    data['street_name'] = streetName;
    data['postal_code'] = postalCode;
    data['title'] = title;
    data['medical_license_number'] = medicalLicenseNumber;
    data['license_expiry_date'] = licenseExpiryDate;
    data['national_provider_identifier'] = nationalProviderIdentifier;
    data['taxonomy_code'] = taxonomyCode;
    data['specialization'] = specialization;
    data['uploaded_at'] = uploadedAt;
    data['invitation_token'] = invitationToken;
    data['deleted_at'] = deletedAt;
    return data;
  }
}

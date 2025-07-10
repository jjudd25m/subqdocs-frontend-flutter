class UpdateUserResponseModel {
  ResponseData? responseData;
  String? message;
  bool? toast;
  String? responseType;

  UpdateUserResponseModel({this.responseData, this.message, this.toast, this.responseType});

  UpdateUserResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? email;
  String? firstName;
  String? lastName;
  int? organizationId;
  dynamic secret2fa;
  dynamic profileImage;
  String? degree;
  dynamic otp;
  dynamic otpGeneratedAt;
  String? lastLoginDate;
  bool? isAdmin;
  String? role;
  String? status;
  String? contactNo;
  String? country;
  String? state;
  String? city;
  String? streetName;
  String? postalCode;
  String? title;
  String? medicalLicenseNumber;
  String? licenseExpiryDate;
  int? nationalProviderIdentifier;
  String? taxonomyCode;
  String? specialization;
  String? uploadedAt;
  String? invitationToken;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? token;

  ResponseData({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.organizationId,
    this.secret2fa,
    this.profileImage,
    this.degree,
    this.otp,
    this.otpGeneratedAt,
    this.lastLoginDate,
    this.isAdmin,
    this.role,
    this.status,
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
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.token,
  });

  ResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    organizationId = json['organization_id'];
    secret2fa = json['secret_2fa'];
    profileImage = json['profile_image'];
    degree = json['degree'];
    otp = json['otp'];
    otpGeneratedAt = json['otp_generated_at'];
    lastLoginDate = json['last_login_date'];
    isAdmin = json['is_admin'];
    role = json['role'];
    status = json['status'];
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
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['organization_id'] = organizationId;
    data['secret_2fa'] = secret2fa;
    data['profile_image'] = profileImage;
    data['degree'] = degree;
    data['otp'] = otp;
    data['otp_generated_at'] = otpGeneratedAt;
    data['last_login_date'] = lastLoginDate;
    data['is_admin'] = isAdmin;
    data['role'] = role;
    data['status'] = status;
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
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['token'] = token;
    return data;
  }
}

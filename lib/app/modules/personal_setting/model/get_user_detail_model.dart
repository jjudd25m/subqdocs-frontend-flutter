class GetUserDetailModel {
  ResponseData? responseData;
  String? message;
  bool? toast;
  String? responseType;

  GetUserDetailModel({this.responseData, this.message, this.toast, this.responseType});

  GetUserDetailModel.fromJson(Map<String, dynamic> json) {
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
  String? email;
  String? firstName;
  String? lastName;
  int? organizationId;
  String? secret2fa;
  String? profileImage;
  String? degree;
  String? otp;
  String? otpGeneratedAt;
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
  String? nationalProviderIdentifier;
  String? taxonomyCode;
  String? specialization;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  ResponseData(
      {this.id,
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
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

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
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
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
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}

class GetOrganizationDetailModel {
  GetOrganizationDetailResponseData? responseData;
  String? message;
  bool? toast;
  String? responseType;

  GetOrganizationDetailModel({this.responseData, this.message, this.toast, this.responseType});

  GetOrganizationDetailModel.fromJson(Map<String, dynamic> json) {
    responseData = json['responseData'] != null ? new GetOrganizationDetailResponseData.fromJson(json['responseData']) : null;
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

class GetOrganizationDetailResponseData {
  int? id;
  String? organizationId;
  String? profileImage;
  String? name;
  String? email;
  String? contactNo;
  String? country;
  String? state;
  String? city;
  String? streetName;
  String? address1;
  String? address2;
  String? postalCode;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? employeesCount;

  GetOrganizationDetailResponseData(
      {this.id,
      this.organizationId,
      this.profileImage,
      this.name,
      this.email,
      this.contactNo,
      this.country,
      this.state,
      this.city,
      this.streetName,
      this.address1,
      this.address2,
      this.postalCode,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.employeesCount});

  GetOrganizationDetailResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    organizationId = json['organization_id'];
    name = json['name'];
    profileImage = json['profile_image'];
    email = json['email'];
    contactNo = json['contact_no'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    streetName = json['street_name'];
    address1 = json['address1'];
    address2 = json['address2'];
    postalCode = json['postal_code'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    employeesCount = json['employeesCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['organization_id'] = organizationId;
    data['name'] = name;
    data['profile_image'] = profileImage;
    data['email'] = email;
    data['contact_no'] = contactNo;
    data['country'] = country;
    data['state'] = state;
    data['city'] = city;
    data['street_name'] = streetName;
    data['address1'] = address1;
    data['address2'] = address2;
    data['postal_code'] = postalCode;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['employeesCount'] = employeesCount;
    return data;
  }
}

class GetUserOrganizationListModel {
  List<GetUserOrganizationListResponseData>? responseData;
  String? message;
  bool? toast;
  String? responseType;

  GetUserOrganizationListModel({this.responseData, this.message, this.toast, this.responseType});

  GetUserOrganizationListModel.fromJson(Map<String, dynamic> json) {
    if (json['responseData'] != null) {
      responseData = <GetUserOrganizationListResponseData>[];
      json['responseData'].forEach((v) {
        responseData!.add(new GetUserOrganizationListResponseData.fromJson(v));
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

class GetUserOrganizationListResponseData {
  int? organizationId;
  String? role;
  String? email;
  bool? isAdmin;
  String? lastLoginDate;
  String? name;
  String? status;
  int? id;

  GetUserOrganizationListResponseData({this.organizationId, this.role, this.email, this.isAdmin, this.lastLoginDate, this.name, this.status, this.id});

  GetUserOrganizationListResponseData.fromJson(Map<String, dynamic> json) {
    organizationId = json['organization_id'];
    role = json['role'];
    email = json['email'];
    isAdmin = json['is_admin'];
    lastLoginDate = json['last_login_date'];
    name = json['name'];
    status = json['status'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['organization_id'] = organizationId;
    data['role'] = role;
    data['email'] = email;
    data['is_admin'] = isAdmin;
    data['last_login_date'] = lastLoginDate;
    data['name'] = name;
    data['status'] = status;
    data['id'] = id;
    return data;
  }
}

class UpdateRoleAndAdminResponseModel {
  UpdateRoleAndAdminResponseData? responseData;
  String? message;
  bool? toast;
  String? responseType;

  UpdateRoleAndAdminResponseModel({this.responseData, this.message, this.toast, this.responseType});

  UpdateRoleAndAdminResponseModel.fromJson(Map<String, dynamic> json) {
    responseData = json['responseData'] != null ? new UpdateRoleAndAdminResponseData.fromJson(json['responseData']) : null;
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

class UpdateRoleAndAdminResponseData {
  int? id;
  String? email;
  String? firstName;
  String? lastName;
  String? password;
  int? organizationId;
  String? secret2fa;
  String? profileImage;
  String? degree;
  String? otp;
  String? otpGeneratedAt;
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
  String? nationalProviderIdentifier;
  String? taxonomyCode;
  String? specialization;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  UpdateRoleAndAdminResponseData(
      {this.id,
      this.email,
      this.firstName,
      this.lastName,
      this.password,
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
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  UpdateRoleAndAdminResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    password = json['password'];
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
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['password'] = this.password;
    data['organization_id'] = this.organizationId;
    data['secret_2fa'] = this.secret2fa;
    data['profile_image'] = this.profileImage;
    data['degree'] = this.degree;
    data['otp'] = this.otp;
    data['otp_generated_at'] = this.otpGeneratedAt;
    data['last_login_date'] = this.lastLoginDate;
    data['is_admin'] = this.isAdmin;
    data['role'] = this.role;
    data['status'] = this.status;
    data['contact_no'] = this.contactNo;
    data['country'] = this.country;
    data['state'] = this.state;
    data['city'] = this.city;
    data['street_name'] = this.streetName;
    data['postal_code'] = this.postalCode;
    data['title'] = this.title;
    data['medical_license_number'] = this.medicalLicenseNumber;
    data['license_expiry_date'] = this.licenseExpiryDate;
    data['national_provider_identifier'] = this.nationalProviderIdentifier;
    data['taxonomy_code'] = this.taxonomyCode;
    data['specialization'] = this.specialization;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

class GetUserRolesModel {
  List<String>? responseData;
  String? message;
  bool? toast;
  String? responseType;

  GetUserRolesModel({this.responseData, this.message, this.toast, this.responseType});

  GetUserRolesModel.fromJson(Map<String, dynamic> json) {
    responseData = json['responseData'].cast<String>();
    message = json['message'];
    toast = json['toast'];
    responseType = json['response_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responseData'] = this.responseData;
    data['message'] = this.message;
    data['toast'] = this.toast;
    data['response_type'] = this.responseType;
    return data;
  }
}

class InvitedUserResponseModel {
  InvitedUserResponseData? responseData;
  String? message;
  bool? toast;
  String? responseType;

  InvitedUserResponseModel({this.responseData, this.message, this.toast, this.responseType});

  InvitedUserResponseModel.fromJson(Map<String, dynamic> json) {
    responseData = json['responseData'] != null ? new InvitedUserResponseData.fromJson(json['responseData']) : null;
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

class InvitedUserResponseData {
  int? id;
  int? fromUser;
  int? toUser;
  bool? isAdmin;
  String? status;
  String? role;
  int? organizationId;
  String? updatedAt;
  String? createdAt;
  Null? deletedAt;

  InvitedUserResponseData({this.id, this.fromUser, this.toUser, this.isAdmin, this.status, this.role, this.organizationId, this.updatedAt, this.createdAt, this.deletedAt});

  InvitedUserResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fromUser = json['from_user'];
    toUser = json['to_user'];
    isAdmin = json['is_admin'];
    status = json['status'];
    role = json['role'];
    organizationId = json['organization_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['from_user'] = this.fromUser;
    data['to_user'] = this.toUser;
    data['is_admin'] = this.isAdmin;
    data['status'] = this.status;
    data['role'] = this.role;
    data['organization_id'] = this.organizationId;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

class GetUserDetailModel {
  ResponseData? responseData;
  String? message;
  bool? toast;
  String? responseType;

  GetUserDetailModel({this.responseData, this.message, this.toast, this.responseType});

  GetUserDetailModel.fromJson(Map<String, dynamic> json) {
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
  String? secret2fa;
  String? profileImage;
  String? degree;
  String? otp;
  String? pin;
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
  int? nationalProviderIdentifier;
  String? taxonomyCode;
  String? specialization;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? organizationName;
  bool? is_multi_language_preference;

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
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.organizationName,
    this.is_multi_language_preference,
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
    pin = json['pin'];
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
    organizationName = json['organization_name'];
    is_multi_language_preference = json['is_multi_language_preference'];
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
    data['pin'] = pin;
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
    data['organization_name'] = organizationName;
    data['is_multi_language_preference'] = is_multi_language_preference;
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
    responseData = json['responseData'] != null ? GetOrganizationDetailResponseData.fromJson(json['responseData']) : null;
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
  String? organization_name;
  int? employeesCount;
  bool? isEmaIntegration;
  bool? has_ema_configs;
  AppointmentType? appointmentType;

  GetOrganizationDetailResponseData({this.id, this.organizationId, this.profileImage, this.name, this.email, this.contactNo, this.country, this.state, this.city, this.streetName, this.address1, this.address2, this.postalCode, this.createdAt, this.updatedAt, this.deletedAt, this.organization_name, this.employeesCount, this.isEmaIntegration, this.has_ema_configs, this.appointmentType});

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
    organization_name = json['organization_name'];
    employeesCount = json['employeesCount'];
    isEmaIntegration = json['is_ema_integration'];
    has_ema_configs = json['has_ema_configs'];
    appointmentType = json['appointment_type'] != null ? AppointmentType.fromJson(json['appointment_type']) : null;
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
    data['organization_name'] = organization_name;
    data['employeesCount'] = employeesCount;
    data['is_ema_integration'] = isEmaIntegration;
    data['has_ema_configs'] = has_ema_configs;
    if (appointmentType != null) {
      data['appointment_type'] = appointmentType!.toJson();
    }
    return data;
  }
}

class AppointmentType {
  String? label;
  String? value;

  AppointmentType({this.label, this.value});

  AppointmentType.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['value'] = value;
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
        responseData!.add(GetUserOrganizationListResponseData.fromJson(v));
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
  bool? suspended;
  int? id;
  int? inviteId;

  GetUserOrganizationListResponseData({this.organizationId, this.role, this.suspended = false, this.email, this.isAdmin, this.lastLoginDate, this.name, this.status, this.id, this.inviteId});

  GetUserOrganizationListResponseData.fromJson(Map<String, dynamic> json) {
    organizationId = json['organization_id'];
    role = json['role'];
    email = json['email'];
    suspended = json['suspended'];
    isAdmin = json['is_admin'];
    lastLoginDate = json['last_login_date'];
    name = json['name'];
    status = json['status'];
    id = json['id'];
    inviteId = json['inviteId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['organization_id'] = organizationId;
    data['role'] = role;
    data['email'] = email;
    data['suspended'] = suspended;
    data['is_admin'] = isAdmin;
    data['last_login_date'] = lastLoginDate;
    data['name'] = name;
    data['status'] = status;
    data['id'] = id;
    data['inviteId'] = inviteId;
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
    responseData = json['responseData'] != null ? UpdateRoleAndAdminResponseData.fromJson(json['responseData']) : null;
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
  dynamic nationalProviderIdentifier;
  String? taxonomyCode;
  String? specialization;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  UpdateRoleAndAdminResponseData({
    this.id,
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
    this.deletedAt,
  });

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['password'] = password;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['responseData'] = responseData;
    data['message'] = message;
    data['toast'] = toast;
    data['response_type'] = responseType;
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
    responseData = json['responseData'] != null ? InvitedUserResponseData.fromJson(json['responseData']) : null;
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
  String? deletedAt;

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['from_user'] = fromUser;
    data['to_user'] = toUser;
    data['is_admin'] = isAdmin;
    data['status'] = status;
    data['role'] = role;
    data['organization_id'] = organizationId;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}

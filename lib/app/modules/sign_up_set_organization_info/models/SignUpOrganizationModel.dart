class SignUpOrganizationModel {
  ResponseData? responseData;
  String? message;
  bool? toast;
  String? responseType;

  SignUpOrganizationModel({this.responseData, this.message, this.toast, this.responseType});

  SignUpOrganizationModel.fromJson(Map<String, dynamic> json) {
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
  String? organizationId;
  String? name;
  Null profileImage;
  Null uploadedAt;
  Null email;
  Null contactNo;
  Null country;
  Null state;
  Null city;
  Null streetName;
  Null address1;
  Null address2;
  Null postalCode;
  int? providersCount;
  String? createdAt;
  String? updatedAt;
  Null deletedAt;

  ResponseData({this.id, this.organizationId, this.name, this.profileImage, this.uploadedAt, this.email, this.contactNo, this.country, this.state, this.city, this.streetName, this.address1, this.address2, this.postalCode, this.providersCount, this.createdAt, this.updatedAt, this.deletedAt});

  ResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    organizationId = json['organization_id'];
    name = json['name'];
    profileImage = json['profile_image'];
    uploadedAt = json['uploaded_at'];
    email = json['email'];
    contactNo = json['contact_no'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    streetName = json['street_name'];
    address1 = json['address1'];
    address2 = json['address2'];
    postalCode = json['postal_code'];
    providersCount = json['providers_count'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['organization_id'] = organizationId;
    data['name'] = name;
    data['profile_image'] = profileImage;
    data['uploaded_at'] = uploadedAt;
    data['email'] = email;
    data['contact_no'] = contactNo;
    data['country'] = country;
    data['state'] = state;
    data['city'] = city;
    data['street_name'] = streetName;
    data['address1'] = address1;
    data['address2'] = address2;
    data['postal_code'] = postalCode;
    data['providers_count'] = providersCount;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}

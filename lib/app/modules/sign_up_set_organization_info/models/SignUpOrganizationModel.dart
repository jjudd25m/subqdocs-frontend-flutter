class SignUpOrganizationModel {
  ResponseData? responseData;
  String? message;
  bool? toast;
  String? responseType;

  SignUpOrganizationModel(
      {this.responseData, this.message, this.toast, this.responseType});

  SignUpOrganizationModel.fromJson(Map<String, dynamic> json) {
    responseData = json['responseData'] != null
        ? new ResponseData.fromJson(json['responseData'])
        : null;
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
  String? organizationId;
  String? name;
  Null? profileImage;
  Null? uploadedAt;
  Null? email;
  Null? contactNo;
  Null? country;
  Null? state;
  Null? city;
  Null? streetName;
  Null? address1;
  Null? address2;
  Null? postalCode;
  int? providersCount;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

  ResponseData(
      {this.id,
        this.organizationId,
        this.name,
        this.profileImage,
        this.uploadedAt,
        this.email,
        this.contactNo,
        this.country,
        this.state,
        this.city,
        this.streetName,
        this.address1,
        this.address2,
        this.postalCode,
        this.providersCount,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['organization_id'] = this.organizationId;
    data['name'] = this.name;
    data['profile_image'] = this.profileImage;
    data['uploaded_at'] = this.uploadedAt;
    data['email'] = this.email;
    data['contact_no'] = this.contactNo;
    data['country'] = this.country;
    data['state'] = this.state;
    data['city'] = this.city;
    data['street_name'] = this.streetName;
    data['address1'] = this.address1;
    data['address2'] = this.address2;
    data['postal_code'] = this.postalCode;
    data['providers_count'] = this.providersCount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
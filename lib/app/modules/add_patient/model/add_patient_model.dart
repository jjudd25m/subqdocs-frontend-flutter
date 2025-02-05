class AddPatientModel {
  ResponseData? responseData;
  String? message;
  bool? toast;
  String? responseType;

  AddPatientModel({this.responseData, this.message, this.toast, this.responseType});

  AddPatientModel.fromJson(Map<String, dynamic> json) {
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
  int? patientId;
  String? firstName;
  String? lastName;
  String? middleName;
  String? dateOfBirth;
  String? gender;
  String? email;
  int? age;
  dynamic appointmentTime;
  String? status;
  dynamic address;
  dynamic contactNo;
  dynamic streetAddress;
  dynamic city;
  dynamic state;
  dynamic zipcode;
  dynamic homePhone;
  dynamic cellphone;
  dynamic visitHistory;
  int? createdBy;
  int? updatedBy;
  String? updatedAt;
  String? createdAt;
  dynamic profileImage;
  dynamic deletedBy;
  dynamic deletedAt;

  ResponseData(
      {this.id,
      this.patientId,
      this.firstName,
      this.lastName,
      this.middleName,
      this.dateOfBirth,
      this.gender,
      this.email,
      this.age,
      this.appointmentTime,
      this.status,
      this.address,
      this.contactNo,
      this.streetAddress,
      this.city,
      this.state,
      this.zipcode,
      this.homePhone,
      this.cellphone,
      this.visitHistory,
      this.createdBy,
      this.updatedBy,
      this.updatedAt,
      this.createdAt,
      this.profileImage,
      this.deletedBy,
      this.deletedAt});

  ResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientId = json['patient_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    middleName = json['middle_name'];
    dateOfBirth = json['date_of_birth'];
    gender = json['gender'];
    email = json['email'];
    age = json['age'];
    appointmentTime = json['appointment_time'];
    status = json['status'];
    address = json['address'];
    contactNo = json['contact_no'];
    streetAddress = json['street_address'];
    city = json['city'];
    state = json['state'];
    zipcode = json['zipcode'];
    homePhone = json['home_phone'];
    cellphone = json['cellphone'];
    visitHistory = json['visit_history'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    profileImage = json['profile_image'];
    deletedBy = json['deleted_by'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['patient_id'] = patientId;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['middle_name'] = middleName;
    data['date_of_birth'] = dateOfBirth;
    data['gender'] = gender;
    data['email'] = email;
    data['age'] = age;
    data['appointment_time'] = appointmentTime;
    data['status'] = status;
    data['address'] = address;
    data['contact_no'] = contactNo;
    data['street_address'] = streetAddress;
    data['city'] = city;
    data['state'] = state;
    data['zipcode'] = zipcode;
    data['home_phone'] = homePhone;
    data['cellphone'] = cellphone;
    data['visit_history'] = visitHistory;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['profile_image'] = profileImage;
    data['deleted_by'] = deletedBy;
    data['deleted_at'] = deletedAt;
    return data;
  }
}

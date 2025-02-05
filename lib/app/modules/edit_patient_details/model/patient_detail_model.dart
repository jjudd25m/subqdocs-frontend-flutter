class PatientDetailModel {
  ResponseData? responseData;
  String? message;
  bool? toast;
  String? responseType;

  PatientDetailModel({this.responseData, this.message, this.toast, this.responseType});

  PatientDetailModel.fromJson(Map<String, dynamic> json) {
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
  String? email;
  String? gender;
  int? age;
  dynamic profileImage;
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
  dynamic deletedBy;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  String? visitDate;
  String? visitTime;
  int? visitId;

  ResponseData(
      {this.id,
      this.patientId,
      this.firstName,
      this.lastName,
      this.middleName,
      this.dateOfBirth,
      this.email,
      this.gender,
      this.age,
      this.profileImage,
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
      this.deletedBy,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.visitDate,
      this.visitTime,
      this.visitId});

  ResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientId = json['patient_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    middleName = json['middle_name'];
    dateOfBirth = json['date_of_birth'];
    email = json['email'];
    gender = json['gender'];
    age = json['age'];
    profileImage = json['profile_image'];
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
    deletedBy = json['deleted_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    visitDate = json['visit_date'];
    visitTime = json['visit_time'];
    visitId = json['visit_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['patient_id'] = patientId;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['middle_name'] = middleName;
    data['date_of_birth'] = dateOfBirth;
    data['email'] = email;
    data['gender'] = gender;
    data['age'] = age;
    data['profile_image'] = profileImage;
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
    data['deleted_by'] = deletedBy;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['visit_date'] = visitDate;
    data['visit_time'] = visitTime;
    data['visit_id'] = visitId;
    return data;
  }
}

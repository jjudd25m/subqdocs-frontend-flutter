class PatientListModel {
  ResponseData? responseData;
  String? message;
  bool? toast;
  String? responseType;

  PatientListModel({this.responseData, this.message, this.toast, this.responseType});

  PatientListModel.fromJson(Map<String, dynamic> json) {
    responseData = json['responseData'] != null ? ResponseData.fromJson(json['responseData']) : null;
    message = json['message'];
    toast = json['toast'];
    responseType = json['response_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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
  List<PatientListData>? data;
  int? totalCount;

  ResponseData({this.data, this.totalCount});

  ResponseData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <PatientListData>[];
      json['data'].forEach((v) {
        data!.add(PatientListData.fromJson(v));
      });
    }
    totalCount = json['totalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['totalCount'] = totalCount;
    return data;
  }
}

class PatientListData {
  int? id;
  String? patientId;
  int? visitId;

  String? firstName;
  String? lastName;
  String? middleName;
  String? dateOfBirth;
  String? email;
  String? gender;
  int? age;
  dynamic profileImage;
  String? appointmentTime;
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
  int? pastVisitCount;
  String? lastVisitDate;
  // String? appointmentTime;
  List<Visits>? visits;

  PatientListData(
      {this.id,
      this.patientId,
      this.visitId,
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
      this.pastVisitCount,
      this.lastVisitDate,
      // this.appointmentTime,
      this.visits});

  PatientListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientId = json['patient_id'];
    visitId = json["visit_id"];
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
    pastVisitCount = json['visitCount'];
    appointmentTime = json['appointmentTime'];
    lastVisitDate = json['lastVisitDate'];
    if (json['visits'] != null) {
      visits = <Visits>[];
      json['visits'].forEach((v) {
        visits!.add(Visits.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['patient_id'] = patientId;
    data['visit_id'] = visitId;
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
    data['visitCount'] = pastVisitCount;
    data['appointmentTime'] = appointmentTime;
    data['lastVisitDate'] = lastVisitDate;
    if (visits != null) {
      data['visits'] = visits!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Visits {
  int? id;
  String? visitDate;
  String? visitTime;
  String? appointmentTime;

  Visits({this.id, this.visitDate, this.visitTime, this.appointmentTime});

  Visits.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    visitDate = json['visitDate'];
    visitTime = json['visitTime'];
    appointmentTime = json['appointmentTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['visitDate'] = visitDate;
    data['visitTime'] = visitTime;
    data['appointmentTime'] = appointmentTime;
    return data;
  }
}

class PatientDetailModel {
  ResponseData? responseData;
  String? message;
  bool? toast;
  String? responseType;

  PatientDetailModel({this.responseData, this.message, this.toast, this.responseType});

  PatientDetailModel.fromJson(Map<String, dynamic> json) {
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
  String? patientId;
  String? firstName;
  String? lastName;
  String? middleName;
  String? dateOfBirth;
  int? age;
  String? email;
  String? gender;
  dynamic profileImage;
  List<ScheduledVisits>? scheduledVisits;
  List<PastVisits>? pastVisits;
  String? visitDate;
  String? visitTime;

  ResponseData(
      {this.id,
      this.patientId,
      this.firstName,
      this.lastName,
      this.middleName,
      this.dateOfBirth,
      this.age,
      this.email,
      this.visitDate,
      this.visitTime,
      this.gender,
      this.profileImage,
      this.scheduledVisits,
      this.pastVisits});

  ResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientId = json['patient_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    middleName = json['middle_name'];
    dateOfBirth = json['date_of_birth'];
    age = json['age'];
    email = json['email'];
    gender = json['gender'];
    visitDate = json['visit_date'];
    visitTime = json['visit_time'];
    profileImage = json['profile_image'];
    if (json['scheduledVisits'] != null) {
      scheduledVisits = <ScheduledVisits>[];
      json['scheduledVisits'].forEach((v) {
        scheduledVisits!.add(new ScheduledVisits.fromJson(v));
      });
    }
    if (json['pastVisits'] != null) {
      pastVisits = <PastVisits>[];
      json['pastVisits'].forEach((v) {
        pastVisits!.add(new PastVisits.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['patient_id'] = this.patientId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['middle_name'] = this.middleName;
    data['date_of_birth'] = this.dateOfBirth;
    data['age'] = this.age;
    data['email'] = this.email;
    data['gender'] = this.gender;

    if (visitDate != null) {
      data['visit_date'] = visitDate;
    }

    if (visitDate != null) {
      data['visit_time'] = visitTime;
    }
    data['profile_image'] = this.profileImage;
    if (this.scheduledVisits != null) {
      data['scheduledVisits'] = this.scheduledVisits!.map((v) => v.toJson()).toList();
    }
    if (this.pastVisits != null) {
      data['pastVisits'] = this.pastVisits!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ScheduledVisits {
  String? visitDate;
  String? visitTime;
  String? visitStatus;
  int? id;

  ScheduledVisits({this.visitDate, this.visitTime, this.visitStatus, this.id});

  ScheduledVisits.fromJson(Map<String, dynamic> json) {
    visitDate = json['visit_date'];
    visitTime = json['visit_time'];
    visitStatus = json['visit_status'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['visit_date'] = this.visitDate;
    data['visit_time'] = this.visitTime;
    data['visit_status'] = this.visitStatus;
    data['id'] = this.id;
    return data;
  }
}

class PastVisits {
  String? visitDate;
  String? visitTime;
  String? visitStatus;
  int? id;
  String? summary;

  PastVisits({this.visitDate, this.visitTime, this.visitStatus, this.id, this.summary});

  PastVisits.fromJson(Map<String, dynamic> json) {
    visitDate = json['visit_date'];
    visitTime = json['visit_time'];
    visitStatus = json['visit_status'];
    id = json['id'];
    summary = json['summary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['visit_date'] = this.visitDate;
    data['visit_time'] = this.visitTime;
    data['visit_status'] = this.visitStatus;
    data['id'] = this.id;
    data['summary'] = this.summary;
    return data;
  }
}

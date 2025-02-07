class ScheduleVisitListModel {
  ResponseData? responseData;
  String? message;
  bool? toast;
  String? responseType;

  ScheduleVisitListModel({this.responseData, this.message, this.toast, this.responseType});

  ScheduleVisitListModel.fromJson(Map<String, dynamic> json) {
    responseData = json['responseData'] != null ? ResponseData.fromJson(json['responseData']) : null;
    message = json['message'];
    toast = json['toast'];
    responseType = json['response_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
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
  List<ScheduleVisitListData>? data;
  int? totalCount;

  ResponseData({this.data, this.totalCount});

  ResponseData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ScheduleVisitListData>[];
      json['data'].forEach((v) {
        data!.add(ScheduleVisitListData.fromJson(v));
      });
    }
    totalCount = json['totalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['totalCount'] = this.totalCount;
    return data;
  }
}

class ScheduleVisitListData {
  int? id;
  int? patientId;
  int? visitId;
  String? visitStatus;
  String? visitDate;
  String? visitTime;
  Null? visitType;
  Null? visitNotes;
  String? status;
  Null? visitDetails;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  String? firstName;
  String? lastName;
  String? gender;
  int? age;
  String? appointmentTime;
  int? previousVisitCount;

  ScheduleVisitListData(
      {this.id,
      this.patientId,
      this.visitId,
      this.visitStatus,
      this.visitDate,
      this.visitTime,
      this.visitType,
      this.visitNotes,
      this.status,
      this.visitDetails,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.firstName,
      this.lastName,
      this.gender,
      this.age,
      this.appointmentTime,
      this.previousVisitCount});

  ScheduleVisitListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientId = json['patient_id'];
    visitId = json['visit_id'];
    visitStatus = json['visit_status'];
    visitDate = json['visit_date'];
    visitTime = json['visit_time'];
    visitType = json['visit_type'];
    visitNotes = json['visit_notes'];
    status = json['status'];
    // visitDetails = json['visit_details'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    gender = json['gender'];
    age = json['age'];
    appointmentTime = json['appointmentTime'];
    previousVisitCount = json['previousVisitCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['patient_id'] = this.patientId;
    data['visit_id'] = this.visitId;
    data['visit_status'] = this.visitStatus;
    data['visit_date'] = this.visitDate;
    data['visit_time'] = this.visitTime;
    data['visit_type'] = this.visitType;
    data['visit_notes'] = this.visitNotes;
    data['status'] = this.status;
    data['visit_details'] = this.visitDetails;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['gender'] = this.gender;
    data['age'] = this.age;
    data['appointmentTime'] = this.appointmentTime;
    data['previousVisitCount'] = this.previousVisitCount;
    return data;
  }
}

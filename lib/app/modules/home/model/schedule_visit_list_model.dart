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
    data['totalCount'] = totalCount;
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
    data['id'] = id;
    data['patient_id'] = patientId;
    data['visit_id'] = visitId;
    data['visit_status'] = visitStatus;
    data['visit_date'] = visitDate;
    data['visit_time'] = visitTime;
    data['visit_type'] = visitType;
    data['visit_notes'] = visitNotes;
    data['status'] = status;
    data['visit_details'] = visitDetails;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['gender'] = gender;
    data['age'] = age;
    data['appointmentTime'] = appointmentTime;
    data['previousVisitCount'] = previousVisitCount;
    return data;
  }
}

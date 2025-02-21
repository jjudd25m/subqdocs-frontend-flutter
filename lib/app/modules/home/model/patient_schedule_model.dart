class PatientScheduleModel {
  ResponseData? responseData;
  String? message;
  bool? toast;
  String? responseType;

  PatientScheduleModel({this.responseData, this.message, this.toast, this.responseType});

  PatientScheduleModel.fromJson(Map<String, dynamic> json) {
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
  int? patientId;
  String? visitDate;
  String? visitTime;
  String? visitStatus;
  String? status;
  String? updatedAt;
  String? createdAt;
  dynamic visitType;
  dynamic visitNotes;
  dynamic visitDetails;
  dynamic deletedAt;

  ResponseData(
      {this.id, this.patientId, this.visitDate, this.visitTime, this.visitStatus, this.status, this.updatedAt, this.createdAt, this.visitType, this.visitNotes, this.visitDetails, this.deletedAt});

  ResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientId = json['patient_id'];
    visitDate = json['visit_date'];
    visitTime = json['visit_time'];
    visitStatus = json['visit_status'];
    status = json['status'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    visitType = json['visit_type'];
    visitNotes = json['visit_notes'];
    visitDetails = json['visit_details'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['patient_id'] = this.patientId;
    data['visit_date'] = this.visitDate;
    data['visit_time'] = this.visitTime;
    data['visit_status'] = this.visitStatus;
    data['status'] = this.status;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['visit_type'] = this.visitType;
    data['visit_notes'] = this.visitNotes;
    data['visit_details'] = this.visitDetails;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

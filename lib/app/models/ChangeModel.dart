class ChangeStatusModel {
  ResponseData? responseData;
  String? message;
  bool? toast;
  String? responseType;

  ChangeStatusModel(
      {this.responseData, this.message, this.toast, this.responseType});

  ChangeStatusModel.fromJson(Map<String, dynamic> json) {
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
  int? patientId;
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

  ResponseData(
      {this.id,
        this.patientId,
        this.visitStatus,
        this.visitDate,
        this.visitTime,
        this.visitType,
        this.visitNotes,
        this.status,
        this.visitDetails,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  ResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientId = json['patient_id'];
    visitStatus = json['visit_status'];
    visitDate = json['visit_date'];
    visitTime = json['visit_time'];
    visitType = json['visit_type'];
    visitNotes = json['visit_notes'];
    status = json['status'];
    visitDetails = json['visit_details'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['patient_id'] = this.patientId;
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
    return data;
  }
}
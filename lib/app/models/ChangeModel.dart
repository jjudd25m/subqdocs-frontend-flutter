class ChangeStatusModel {
  ResponseData? responseData;
  String? message;
  bool? toast;
  String? responseType;

  ChangeStatusModel({this.responseData, this.message, this.toast, this.responseType});

  ChangeStatusModel.fromJson(Map<String, dynamic> json) {
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
  String? visitStatus;
  String? visitDate;
  String? visitTime;
  dynamic visitType;
  dynamic visitNotes;
  String? status;
  dynamic visitDetails;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  ResponseData({this.id, this.patientId, this.visitStatus, this.visitDate, this.visitTime, this.visitType, this.visitNotes, this.status, this.visitDetails, this.createdAt, this.updatedAt, this.deletedAt});

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['patient_id'] = patientId;
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
    return data;
  }
}

class AddMobilePatientModel {
  ResponseData? responseData;
  String? message;
  bool? toast;
  String? responseType;

  AddMobilePatientModel({this.responseData, this.message, this.toast, this.responseType});

  AddMobilePatientModel.fromJson(Map<String, dynamic> json) {
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
  String? visitDate;
  String? visitTime;
  String? visitStatus;
  String? status;
  int? doctorId;
  String? updatedAt;
  String? createdAt;
  dynamic visitType;
  dynamic visitNotes;
  dynamic visitDetails;
  dynamic medicalAssistantId;
  dynamic deletedAt;

  ResponseData({this.id, this.patientId, this.visitDate, this.visitTime, this.visitStatus, this.status, this.doctorId, this.updatedAt, this.createdAt, this.visitType, this.visitNotes, this.visitDetails, this.medicalAssistantId, this.deletedAt});

  ResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientId = json['patient_id'];
    visitDate = json['visit_date'];
    visitTime = json['visit_time'];
    visitStatus = json['visit_status'];
    status = json['status'];
    doctorId = json['doctor_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    visitType = json['visit_type'];
    visitNotes = json['visit_notes'];
    visitDetails = json['visit_details'];
    medicalAssistantId = json['medical_assistant_id'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['patient_id'] = patientId;
    data['visit_date'] = visitDate;
    data['visit_time'] = visitTime;
    data['visit_status'] = visitStatus;
    data['status'] = status;
    data['doctor_id'] = doctorId;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['visit_type'] = visitType;
    data['visit_notes'] = visitNotes;
    data['visit_details'] = visitDetails;
    data['medical_assistant_id'] = medicalAssistantId;
    data['deleted_at'] = deletedAt;
    return data;
  }
}

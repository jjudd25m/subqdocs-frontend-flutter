class PatientAttachmentListModel {
  List<ResponseData>? responseData;
  String? message;
  bool? toast;
  String? responseType;

  PatientAttachmentListModel({this.responseData, this.message, this.toast, this.responseType});

  PatientAttachmentListModel.fromJson(Map<String, dynamic> json) {
    if (json['responseData'] != null) {
      responseData = <ResponseData>[];
      json['responseData'].forEach((v) {
        responseData!.add(ResponseData.fromJson(v));
      });
    }
    message = json['message'];
    toast = json['toast'];
    responseType = json['response_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (responseData != null) {
      data['responseData'] = responseData!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    data['toast'] = toast;
    data['response_type'] = responseType;
    return data;
  }
}

class ResponseData {
  int? id;
  String? fileName;
  String? filePath;
  String? fileType;
  int? fileSize;
  int? uploadedBy;
  dynamic visitId;
  int? patientId;
  bool? isActive;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;

  ResponseData({this.id, this.fileName, this.filePath, this.fileType, this.fileSize, this.uploadedBy, this.visitId, this.patientId, this.isActive, this.createdAt, this.updatedAt, this.deletedAt});

  ResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fileName = json['file_name'];
    filePath = json['file_path'];
    fileType = json['file_type'];
    fileSize = json['file_size'];
    uploadedBy = json['uploaded_by'];
    visitId = json['visit_id'];
    patientId = json['patient_id'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['file_name'] = fileName;
    data['file_path'] = filePath;
    data['file_type'] = fileType;
    data['file_size'] = fileSize;
    data['uploaded_by'] = uploadedBy;
    data['visit_id'] = visitId;
    data['patient_id'] = patientId;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}

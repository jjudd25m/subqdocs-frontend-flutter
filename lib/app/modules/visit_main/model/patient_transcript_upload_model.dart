class PatientTranscriptUploadModel {
  ResponseData? responseData;
  String? message;
  bool? toast;
  String? responseType;

  PatientTranscriptUploadModel({this.responseData, this.message, this.toast, this.responseType});

  PatientTranscriptUploadModel.fromJson(Map<String, dynamic> json) {
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
  int? visitId;
  String? fileName;
  String? fileType;
  int? fileSize;
  String? path;
  String? updatedAt;
  String? createdAt;
  dynamic fileDuration;
  dynamic deletedAt;

  ResponseData({this.id, this.visitId, this.fileName, this.fileType, this.fileSize, this.path, this.updatedAt, this.createdAt, this.fileDuration, this.deletedAt});

  ResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    visitId = json['visit_id'];
    fileName = json['file_name'];
    fileType = json['file_type'];
    fileSize = json['file_size'];
    path = json['path'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    fileDuration = json['file_duration'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['visit_id'] = visitId;
    data['file_name'] = fileName;
    data['file_type'] = fileType;
    data['file_size'] = fileSize;
    data['path'] = path;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['file_duration'] = fileDuration;
    data['deleted_at'] = deletedAt;
    return data;
  }
}

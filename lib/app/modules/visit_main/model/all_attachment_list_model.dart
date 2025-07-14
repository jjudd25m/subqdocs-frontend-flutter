// class FileAttachment {
//   int id;
//   String fileName;
//   String filePath;
//   String fileType;
//   int fileSize;
//   int uploadedBy;
//   String uploadedAt;
//   dynamic visitId;
//   int patientId;
//   bool isActive;
//   String createdAt;
//   String updatedAt;
//   dynamic deletedAt;
//
//   FileAttachment({
//     required this.id,
//     required this.fileName,
//     required this.filePath,
//     required this.fileType,
//     required this.fileSize,
//     required this.uploadedBy,
//     required this.uploadedAt,
//     this.visitId,
//     required this.patientId,
//     required this.isActive,
//     required this.createdAt,
//     required this.updatedAt,
//     this.deletedAt,
//   });
//
//   // From JSON to FileAttachment
//   factory FileAttachment.fromJson(Map<String, dynamic> json) {
//     return FileAttachment(
//       id: json['id'],
//       fileName: json['file_name'],
//       filePath: json['file_path'],
//       fileType: json['file_type'],
//       fileSize: json['file_size'],
//       uploadedBy: json['uploaded_by'],
//       uploadedAt: json['uploaded_at'],
//       visitId: json['visit_id'],
//       patientId: json['patient_id'],
//       isActive: json['is_active'],
//       createdAt: json['created_at'],
//       updatedAt: json['updated_at'],
//       deletedAt: json['deleted_at'],
//     );
//   }
//
//   // FileAttachment to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'file_name': fileName,
//       'file_path': filePath,
//       'file_type': fileType,
//       'file_size': fileSize,
//       'uploaded_by': uploadedBy,
//       'uploaded_at': uploadedAt,
//       'visit_id': visitId,
//       'patient_id': patientId,
//       'is_active': isActive,
//       'created_at': createdAt,
//       'updated_at': updatedAt,
//       'deleted_at': deletedAt,
//     };
//   }
// }

class FileAttachment {
  int? id;
  String? fileName;
  String? filePath;
  String? fileType;
  int? fileSize;
  int? uploadedBy;
  String? uploadedAt;
  dynamic visitId;
  int? patientId;
  bool? isActive;
  dynamic timestamp;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;

  FileAttachment({this.id, this.fileName, this.filePath, this.fileType, this.fileSize, this.uploadedBy, this.uploadedAt, this.visitId, this.patientId, this.isActive, this.timestamp, this.createdAt, this.updatedAt, this.deletedAt});

  FileAttachment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fileName = json['file_name'];
    filePath = json['file_path'];
    fileType = json['file_type'];
    fileSize = json['file_size'];
    uploadedBy = json['uploaded_by'];
    uploadedAt = json['uploaded_at'];
    visitId = json['visit_id'];
    patientId = json['patient_id'];
    isActive = json['is_active'];
    timestamp = json['timestamp'];
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
    data['uploaded_at'] = uploadedAt;
    data['visit_id'] = visitId;
    data['patient_id'] = patientId;
    data['is_active'] = isActive;
    data['timestamp'] = timestamp;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}

class ResponseData {
  // The response data contains dynamic keys (dates) and lists of FileAttachment objects.
  Map<String, List<FileAttachment>> data;

  ResponseData({required this.data});

  // From JSON to ResponseData
  factory ResponseData.fromJson(Map<String, dynamic> json) {
    Map<String, List<FileAttachment>> data = {};
    json.forEach((date, files) {
      data[date] = List<FileAttachment>.from(files.map((fileJson) => FileAttachment.fromJson(fileJson)));
    });
    return ResponseData(data: data);
  }

  // ResponseData to JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    data.forEach((date, files) {
      json[date] = files.map((file) => file.toJson()).toList();
    });
    return json;
  }
}

class AllAttachmentListModel {
  ResponseData responseData;
  String message;
  bool toast;
  String responseType;

  AllAttachmentListModel({required this.responseData, required this.message, required this.toast, required this.responseType});

  // From JSON to ApiResponse
  factory AllAttachmentListModel.fromJson(Map<String, dynamic> json) {
    return AllAttachmentListModel(responseData: ResponseData.fromJson(json['responseData']), message: json['message'], toast: json['toast'], responseType: json['response_type']);
  }

  // ApiResponse to JSON
  Map<String, dynamic> toJson() {
    return {'responseData': responseData.toJson(), 'message': message, 'toast': toast, 'response_type': responseType};
  }
}

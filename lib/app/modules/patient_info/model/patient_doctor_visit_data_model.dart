class PatientDoctorVisitDataModel {
  ResponseData? responseData;
  String? message;
  bool? toast;
  String? responseType;

  PatientDoctorVisitDataModel({this.responseData, this.message, this.toast, this.responseType});

  PatientDoctorVisitDataModel.fromJson(Map<String, dynamic> json) {
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

class VisitNoteDetails {
  String yourVisitSummary;
  Map<String, List<String>> dynamicData;

  VisitNoteDetails({
    required this.yourVisitSummary,
    required this.dynamicData,
  });

  // fromJson method
  factory VisitNoteDetails.fromJson(Map<String, dynamic> json) {
    return VisitNoteDetails(
      yourVisitSummary: json['visit_details'] ?? '',
      dynamicData: _parseDynamicData(json),
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'visit_details': yourVisitSummary,
      ...dynamicData.map((key, value) => MapEntry(key, value)),
    };
  }

  // Parse dynamic keys to Map<String, List<String>>
  static Map<String, List<String>> _parseDynamicData(Map<String, dynamic> json) {
    Map<String, List<String>> dynamicData = {};
    json.forEach((key, value) {
      if (value is List) {
        dynamicData[key] = List<String>.from(value.map((e) => e.toString()));
      }
    });
    return dynamicData;
  }
}

class ResponseData {
  int id;
  String status;
  VisitNoteDetails visitNoteDetails;

  ResponseData({
    required this.id,
    required this.status,
    required this.visitNoteDetails,
  });

  // fromJson method
  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
      id: json['id'] ?? 0,
      status: json['status'] ?? '',
      visitNoteDetails: VisitNoteDetails.fromJson(json['visit_details'] ?? {}),
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'visit_details': visitNoteDetails.toJson(),
    };
  }
}

class ApiResponse {
  ResponseData responseData;
  String message;
  bool toast;
  String responseType;

  ApiResponse({
    required this.responseData,
    required this.message,
    required this.toast,
    required this.responseType,
  });

  // fromJson method
  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      responseData: ResponseData.fromJson(json['responseData'] ?? {}),
      message: json['message'] ?? '',
      toast: json['toast'] ?? false,
      responseType: json['response_type'] ?? '',
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'responseData': responseData.toJson(),
      'message': message,
      'toast': toast,
      'response_type': responseType,
    };
  }
}

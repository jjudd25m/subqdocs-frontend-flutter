class LatestPatientId {
  ResponseData? responseData;
  String? message;
  bool? toast;
  String? responseType;

  LatestPatientId({this.responseData, this.message, this.toast, this.responseType});

  LatestPatientId.fromJson(Map<String, dynamic> json) {
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
  String? patientId;

  ResponseData({this.patientId});

  ResponseData.fromJson(Map<String, dynamic> json) {
    patientId = json['patientId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['patientId'] = patientId;
    return data;
  }
}

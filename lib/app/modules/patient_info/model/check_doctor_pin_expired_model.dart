class CheckDoctorPinExpiredModel {
  bool? responseData;
  String? message;
  bool? toast;
  String? responseType;

  CheckDoctorPinExpiredModel({this.responseData, this.message, this.toast, this.responseType});

  CheckDoctorPinExpiredModel.fromJson(Map<String, dynamic> json) {
    responseData = json['responseData'];
    message = json['message'];
    toast = json['toast'];
    responseType = json['response_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responseData'] = this.responseData;
    data['message'] = this.message;
    data['toast'] = this.toast;
    data['response_type'] = this.responseType;
    return data;
  }
}

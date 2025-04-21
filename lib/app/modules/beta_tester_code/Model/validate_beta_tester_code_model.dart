class ValidateBetaTesterCodeModel {
  bool? responseData;
  String? message;
  bool? toast;
  String? responseType;

  ValidateBetaTesterCodeModel({this.responseData, this.message, this.toast, this.responseType});

  ValidateBetaTesterCodeModel.fromJson(Map<String, dynamic> json) {
    responseData = json['responseData'];
    message = json['message'];
    toast = json['toast'];
    responseType = json['response_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['responseData'] = responseData;
    data['message'] = message;
    data['toast'] = toast;
    data['response_type'] = responseType;
    return data;
  }
}

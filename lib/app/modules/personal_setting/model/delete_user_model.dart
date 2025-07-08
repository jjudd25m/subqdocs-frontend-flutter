class DeleteUserModel {
  bool? responseData;
  String? message;
  bool? toast;
  String? responseType;

  DeleteUserModel({this.responseData, this.message, this.toast, this.responseType});

  DeleteUserModel.fromJson(Map<String, dynamic> json) {
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

class DefaultResponseModel {
  dynamic responseData;
  String? message;
  bool? toast;
  String? responseType;

  DefaultResponseModel({this.responseData, this.message, this.toast, this.responseType});

  DefaultResponseModel.fromJson(Map<String, dynamic> json) {
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

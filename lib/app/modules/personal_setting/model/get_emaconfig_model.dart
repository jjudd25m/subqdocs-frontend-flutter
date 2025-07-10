class GetEmaConfigModel {
  List<GetEmaConfigResponseData>? responseData;
  String? message;
  bool? toast;
  String? responseType;

  GetEmaConfigModel({this.responseData, this.message, this.toast, this.responseType});

  GetEmaConfigModel.fromJson(Map<String, dynamic> json) {
    if (json['responseData'] != null) {
      responseData = <GetEmaConfigResponseData>[];
      json['responseData'].forEach((v) {
        responseData!.add(new GetEmaConfigResponseData.fromJson(v));
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

class GetEmaConfigResponseData {
  String? key;
  String? value;
  String? vendor;

  GetEmaConfigResponseData({this.key, this.value, this.vendor});

  GetEmaConfigResponseData.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value = json['value'];
    vendor = json['vendor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['value'] = value;
    data['vendor'] = vendor;
    return data;
  }
}

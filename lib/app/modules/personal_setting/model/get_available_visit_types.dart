class GetAvailableVisitTypes {
  List<GetAvailableVisitTypesResponseData>? responseData;
  String? message;
  bool? toast;
  String? responseType;

  GetAvailableVisitTypes({this.responseData, this.message, this.toast, this.responseType});

  GetAvailableVisitTypes.fromJson(Map<String, dynamic> json) {
    if (json['responseData'] != null) {
      responseData = <GetAvailableVisitTypesResponseData>[];
      json['responseData'].forEach((v) {
        responseData!.add(GetAvailableVisitTypesResponseData.fromJson(v));
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

class GetAvailableVisitTypesResponseData {
  String? code;
  String? display;

  GetAvailableVisitTypesResponseData({this.code, this.display});

  GetAvailableVisitTypesResponseData.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    display = json['display'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['display'] = display;
    return data;
  }
}

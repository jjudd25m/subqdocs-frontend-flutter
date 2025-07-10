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
        responseData!.add(new GetAvailableVisitTypesResponseData.fromJson(v));
      });
    }
    message = json['message'];
    toast = json['toast'];
    responseType = json['response_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.responseData != null) {
      data['responseData'] = this.responseData!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['toast'] = this.toast;
    data['response_type'] = this.responseType;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['display'] = this.display;
    return data;
  }
}

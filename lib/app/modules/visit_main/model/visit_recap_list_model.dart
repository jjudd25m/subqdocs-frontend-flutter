class VisitRecapListModel {
  List<VisitRecapListResponseData>? responseData;
  String? message;
  bool? toast;
  String? responseType;

  VisitRecapListModel({this.responseData, this.message, this.toast, this.responseType});

  VisitRecapListModel.fromJson(Map<String, dynamic> json) {
    if (json['responseData'] != null) {
      responseData = <VisitRecapListResponseData>[];
      json['responseData'].forEach((v) {
        responseData!.add(VisitRecapListResponseData.fromJson(v));
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

class VisitRecapListResponseData {
  int? id;
  String? visitDate;
  String? summary;

  VisitRecapListResponseData({this.visitDate, this.summary});

  VisitRecapListResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    visitDate = json['visit_date'];
    summary = json['summary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['visit_date'] = visitDate;
    data['summary'] = summary;
    return data;
  }
}

class GetCPTCodeModel {
  GetCPTCodeResponseData? responseData;
  String? message;
  bool? toast;
  String? responseType;

  GetCPTCodeModel({this.responseData, this.message, this.toast, this.responseType});

  GetCPTCodeModel.fromJson(Map<String, dynamic> json) {
    responseData = json['responseData'] != null ? GetCPTCodeResponseData.fromJson(json['responseData']) : null;
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

class GetCPTCodeResponseData {
  List<GetCPTCodeResponseDataData>? data;
  String? page;
  String? limit;
  int? totalCount;
  int? totalPage;

  GetCPTCodeResponseData({this.data, this.page, this.limit, this.totalCount, this.totalPage});

  GetCPTCodeResponseData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <GetCPTCodeResponseDataData>[];
      json['data'].forEach((v) {
        data!.add(GetCPTCodeResponseDataData.fromJson(v));
      });
    }
    page = json['page'];
    limit = json['limit'];
    totalCount = json['totalCount'];
    totalPage = json['totalPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['page'] = page;
    data['limit'] = limit;
    data['totalCount'] = totalCount;
    data['totalPage'] = totalPage;
    return data;
  }
}

class GetCPTCodeResponseDataData {
  int? id;
  String? code;
  String? description;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  GetCPTCodeResponseDataData({this.id, this.code, this.description, this.createdAt, this.updatedAt, this.deletedAt});

  GetCPTCodeResponseDataData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['description'] = description;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}

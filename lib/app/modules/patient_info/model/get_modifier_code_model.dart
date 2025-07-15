class GetModifierCodeModel {
  GetModifierCodeResponseData? responseData;
  String? message;
  bool? toast;
  String? responseType;

  GetModifierCodeModel({this.responseData, this.message, this.toast, this.responseType});

  GetModifierCodeModel.fromJson(Map<String, dynamic> json) {
    responseData = json['responseData'] != null ? GetModifierCodeResponseData.fromJson(json['responseData']) : null;
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

class GetModifierCodeResponseData {
  List<GetModifierCodeResponseDataData>? data;
  String? page;
  String? limit;
  int? totalCount;
  int? totalPage;

  GetModifierCodeResponseData({this.data, this.page, this.limit, this.totalCount, this.totalPage});

  GetModifierCodeResponseData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <GetModifierCodeResponseDataData>[];
      json['data'].forEach((v) {
        data!.add(GetModifierCodeResponseDataData.fromJson(v));
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

class GetModifierCodeResponseDataData {
  int? id;
  String? modifier;
  String? description;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  GetModifierCodeResponseDataData({this.id, this.modifier, this.description, this.createdAt, this.updatedAt, this.deletedAt});

  GetModifierCodeResponseDataData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    modifier = json['modifier'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['modifier'] = modifier;
    data['description'] = description;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}

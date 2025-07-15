class ForceSyncLogModel {
  ResponseData? responseData;
  String? message;
  bool? toast;
  String? responseType;

  ForceSyncLogModel({this.responseData, this.message, this.toast, this.responseType});

  ForceSyncLogModel.fromJson(Map<String, dynamic> json) {
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
  bool? isSyncing;

  ResponseData({this.isSyncing});

  ResponseData.fromJson(Map<String, dynamic> json) {
    isSyncing = json['isSyncing'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isSyncing'] = isSyncing;
    return data;
  }
}

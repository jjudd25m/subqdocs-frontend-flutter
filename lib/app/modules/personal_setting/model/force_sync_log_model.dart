class ForceSyncLogModel {
  ResponseData? responseData;
  String? message;
  bool? toast;
  String? responseType;

  ForceSyncLogModel({this.responseData, this.message, this.toast, this.responseType});

  ForceSyncLogModel.fromJson(Map<String, dynamic> json) {
    responseData = json['responseData'] != null ? new ResponseData.fromJson(json['responseData']) : null;
    message = json['message'];
    toast = json['toast'];
    responseType = json['response_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.responseData != null) {
      data['responseData'] = this.responseData!.toJson();
    }
    data['message'] = this.message;
    data['toast'] = this.toast;
    data['response_type'] = this.responseType;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSyncing'] = this.isSyncing;
    return data;
  }
}

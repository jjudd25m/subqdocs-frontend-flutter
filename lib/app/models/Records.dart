import 'dart:convert';

Records recordsFromJson(String str) => Records.fromJson(json.decode(str));

String recordsToJson(Records data) => json.encode(data.toJson());

class Records {
  ResponseData? responseData;
  String? message;
  bool? toast;
  String? responseType;

  Records({
    this.responseData,
    this.message,
    this.toast,
    this.responseType,
  });

  factory Records.fromJson(Map<String, dynamic> json) => Records(
    responseData: json["responseData"] == null ? null : ResponseData.fromJson(json["responseData"]),
    message: json["message"],
    toast: json["toast"],
    responseType: json["response_type"],
  );

  Map<String, dynamic> toJson() => {
    "responseData": responseData?.toJson(),
    "message": message,
    "toast": toast,
    "response_type": responseType,
  };
}

class ResponseData {
  String? sessionId;
  String? uploadId;

  ResponseData({
    this.sessionId,
    this.uploadId,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
    sessionId: json["sessionId"],
    uploadId: json["uploadId"],
  );

  Map<String, dynamic> toJson() => {
    "sessionId": sessionId,
    "uploadId": uploadId,
  };
}

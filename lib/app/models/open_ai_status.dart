import 'dart:convert';

OpenAiStatus openAiStatusFromJson(String str) => OpenAiStatus.fromJson(json.decode(str));

String openAiStatusToJson(OpenAiStatus data) => json.encode(data.toJson());

class OpenAiStatus {
  ResponseData? responseData;
  String? message;
  bool? toast;
  String? responseType;

  OpenAiStatus({
    this.responseData,
    this.message,
    this.toast,
    this.responseType,
  });

  factory OpenAiStatus.fromJson(Map<String, dynamic> json) => OpenAiStatus(
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
  String? type;
  Status? status;

  ResponseData({
    this.type,
    this.status,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
    type: json["type"],
    status: json["status"] == null ? null : Status.fromJson(json["status"]),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "status": status?.toJson(),
  };
}

class Status {
  String? description;
  String? indicator;

  Status({
    this.description,
    this.indicator,
  });

  factory Status.fromJson(Map<String, dynamic> json) => Status(
    description: json["description"],
    indicator: json["indicator"],
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "indicator": indicator,
  };
}

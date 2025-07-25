class ChatbotHistoryModel {
  ResponseData? responseData;
  String? message;
  bool? toast;
  String? responseType;

  ChatbotHistoryModel({this.responseData, this.message, this.toast, this.responseType});

  ChatbotHistoryModel.fromJson(Map<String, dynamic> json) {
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
  int? id;
  int? visitId;
  List<ChatHistory>? chatHistory;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  ResponseData({this.id, this.visitId, this.chatHistory, this.createdAt, this.updatedAt, this.deletedAt});

  ResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    visitId = json['visit_id'];
    if (json['chat_history'] != null) {
      chatHistory = <ChatHistory>[];
      json['chat_history'].forEach((v) {
        chatHistory!.add(ChatHistory.fromJson(v));
      });
    }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['visit_id'] = visitId;
    if (chatHistory != null) {
      data['chat_history'] = chatHistory!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}

class ChatHistory {
  int? id;
  String? type;
  String? sender;
  String? content;
  String? timestamp;
  bool? isLoading;
  Metadata? metadata;
  int? actualTimestamp;

  ChatHistory({this.id, this.type, this.sender, this.content, this.timestamp, this.isLoading, this.metadata});

  ChatHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    sender = json['sender'];
    content = json['content'];
    timestamp = json['timestamp'];
    actualTimestamp = timestampStringToMillis(timestamp!);
    isLoading = json['isLoading'];
    metadata = json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['sender'] = sender;
    data['content'] = content;
    data['timestamp'] = timestamp;
    data['isLoading'] = isLoading;
    if (metadata != null) {
      data['metadata'] = metadata!.toJson();
    }
    return data;
  }

  int? timestampStringToMillis(String timestampString) {
    try {
      final dateTime = DateTime.tryParse(timestampString);
      return dateTime?.millisecondsSinceEpoch;
    } catch (e) {
      return null;
    }
  }
}

class Metadata {
  String? url;
  int? size;
  String? filename;
  String? filetype;

  Metadata({this.url, this.size, this.filename, this.filetype});

  Metadata.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    size = json['size'];
    filename = json['filename'];
    filetype = json['filetype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['size'] = size;
    data['filename'] = filename;
    data['filetype'] = filetype;
    return data;
  }
}

class TranscriptListModel {
  TranscriptListResponseData? responseData;
  String? message;
  bool? toast;
  String? responseType;

  TranscriptListModel({this.responseData, this.message, this.toast, this.responseType});

  TranscriptListModel.fromJson(Map<String, dynamic> json) {
    responseData = json['responseData'] != null ? TranscriptListResponseData.fromJson(json['responseData']) : null;
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

class TranscriptListResponseData {
  int? id;
  String? status;
  CleanedTranscript? cleanedTranscript;
  CleanedTranscript? mergedTranscript;
  String? message;

  TranscriptListResponseData({this.id, this.status, this.cleanedTranscript});

  TranscriptListResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    message = json['message'];
    cleanedTranscript = json['cleaned_transcript'] != null ? CleanedTranscript.fromJson(json['cleaned_transcript']) : null;
    mergedTranscript = json['merged_transcript'] != null ? CleanedTranscript.fromJson(json['merged_transcript']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['message'] = message;
    data['status'] = status;
    if (cleanedTranscript != null) {
      data['cleaned_transcript'] = cleanedTranscript!.toJson();
    }
    if (mergedTranscript != null) {
      data['merged_transcript'] = mergedTranscript!.toJson();
    }
    return data;
  }
}

class CleanedTranscript {
  List<CleanedTranscriptResponseData>? responseData;

  CleanedTranscript({this.responseData});

  CleanedTranscript.fromJson(Map<String, dynamic> json) {
    if (json['response_data'] != null) {
      responseData = <CleanedTranscriptResponseData>[];
      json['response_data'].forEach((v) {
        responseData!.add(CleanedTranscriptResponseData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (responseData != null) {
      data['response_data'] = responseData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CleanedTranscriptResponseData {
  int? chunkId;
  String? fileName;
  List<Transcript>? transcript;

  CleanedTranscriptResponseData({this.chunkId, this.fileName, this.transcript});

  CleanedTranscriptResponseData.fromJson(Map<String, dynamic> json) {
    chunkId = json['chunk_id'];
    fileName = json['file_name'];
    if (json['transcript'] != null) {
      transcript = <Transcript>[];
      json['transcript'].forEach((v) {
        transcript!.add(Transcript.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chunk_id'] = chunkId;
    data['file_name'] = fileName;
    if (transcript != null) {
      data['transcript'] = transcript!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Transcript {
  dynamic end;
  dynamic start;
  String? speaker;
  String? sentence;

  Transcript({this.end, this.start, this.speaker, this.sentence});

  Transcript.fromJson(Map<String, dynamic> json) {
    end = json['end'];
    start = json['start'];
    speaker = json['speaker'];
    sentence = json['sentence'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['end'] = end;
    data['start'] = start;
    data['speaker'] = speaker;
    data['sentence'] = sentence;
    return data;
  }
}

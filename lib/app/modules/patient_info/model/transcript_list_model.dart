// class TranscriptListModel {
//   ResponseData responseData;
//   String message;
//   bool toast;
//   String responseType;
//
//   TranscriptListModel({
//     required this.responseData,
//     required this.message,
//     required this.toast,
//     required this.responseType,
//   });
//
//   factory TranscriptListModel.fromJson(Map<String, dynamic> json) => TranscriptListModel(
//         responseData: ResponseData.fromJson(json["responseData"]),
//         message: json["message"],
//         toast: json["toast"],
//         responseType: json["response_type"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "responseData": responseData.toJson(),
//         "message": message,
//         "toast": toast,
//         "response_type": responseType,
//       };
// }
//
// class ResponseData {
//   int id;
//   String status;
//   CleanedTranscript cleanedTranscript;
//
//   ResponseData({
//     required this.id,
//     required this.status,
//     required this.cleanedTranscript,
//   });
//
//   factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
//         id: json["id"],
//         status: json["status"],
//         cleanedTranscript: CleanedTranscript.fromJson(json["cleaned_transcript"]),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "status": status,
//         "cleaned_transcript": cleanedTranscript.toJson(),
//       };
// }
//
// class CleanedTranscript {
//   List<List<CleanedTranscriptResponseDatum>> cleanedTranscriptResponseData;
//
//   CleanedTranscript({
//     required this.cleanedTranscriptResponseData,
//   });
//
//   factory CleanedTranscript.fromJson(Map<String, dynamic> json) => CleanedTranscript(
//         cleanedTranscriptResponseData: List<List<CleanedTranscriptResponseDatum>>.from(
//             json["cleaned_transcript_response_data"].map((x) => List<CleanedTranscriptResponseDatum>.from(x.map((x) => CleanedTranscriptResponseDatum.fromJson(x))))),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "cleaned_transcript_response_data": List<dynamic>.from(cleanedTranscriptResponseData.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
//       };
// }
//
// class CleanedTranscriptResponseDatum {
//   double end;
//   double start;
//   String speaker;
//   String sentence;
//
//   CleanedTranscriptResponseDatum({
//     required this.end,
//     required this.start,
//     required this.speaker,
//     required this.sentence,
//   });
//
//   factory CleanedTranscriptResponseDatum.fromJson(Map<String, dynamic> json) => CleanedTranscriptResponseDatum(
//         end: json["end"]?.toDouble(),
//         start: json["start"]?.toDouble(),
//         speaker: json["speaker"],
//         sentence: json["sentence"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "end": end,
//         "start": start,
//         "speaker": speaker,
//         "sentence": sentence,
//       };
// }
//-------------------------------------------------------

class TranscriptListModel {
  TranscriptListResponseData? responseData;
  String? message;
  bool? toast;
  String? responseType;

  TranscriptListModel({this.responseData, this.message, this.toast, this.responseType});

  TranscriptListModel.fromJson(Map<String, dynamic> json) {
    responseData = json['responseData'] != null ? new TranscriptListResponseData.fromJson(json['responseData']) : null;
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

class TranscriptListResponseData {
  int? id;
  String? status;
  CleanedTranscript? cleanedTranscript;

  TranscriptListResponseData({this.id, this.status, this.cleanedTranscript});

  TranscriptListResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    cleanedTranscript = json['cleaned_transcript'] != null ? new CleanedTranscript.fromJson(json['cleaned_transcript']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    if (this.cleanedTranscript != null) {
      data['cleaned_transcript'] = this.cleanedTranscript!.toJson();
    }
    return data;
  }
}

class CleanedTranscript {
  List<ResponseData>? responseData;

  CleanedTranscript({this.responseData});

  CleanedTranscript.fromJson(Map<String, dynamic> json) {
    if (json['response_data'] != null) {
      responseData = <ResponseData>[];
      json['response_data'].forEach((v) {
        responseData!.add(new ResponseData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.responseData != null) {
      data['response_data'] = this.responseData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ResponseData {
  int? chunkId;
  String? fileName;
  List<Transcript>? transcript;

  ResponseData({this.chunkId, this.fileName, this.transcript});

  ResponseData.fromJson(Map<String, dynamic> json) {
    chunkId = json['chunk_id'];
    fileName = json['file_name'];
    if (json['transcript'] != null) {
      transcript = <Transcript>[];
      json['transcript'].forEach((v) {
        transcript!.add(new Transcript.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chunk_id'] = this.chunkId;
    data['file_name'] = this.fileName;
    if (this.transcript != null) {
      data['transcript'] = this.transcript!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['end'] = this.end;
    data['start'] = this.start;
    data['speaker'] = this.speaker;
    data['sentence'] = this.sentence;
    return data;
  }
}
//-----------------------------------------------------

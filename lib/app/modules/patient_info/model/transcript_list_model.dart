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
  TranscriptListModel({
    required this.responseData,
    required this.message,
    required this.toast,
    required this.responseType,
  });

  final ResponseData? responseData;
  final String? message;
  final bool? toast;
  final String? responseType;

  factory TranscriptListModel.fromJson(Map<String, dynamic> json) {
    return TranscriptListModel(
      responseData: json["responseData"] == null ? null : ResponseData.fromJson(json["responseData"]),
      message: json["message"],
      toast: json["toast"],
      responseType: json["response_type"],
    );
  }

  Map<String, dynamic> toJson() => {
        "responseData": responseData?.toJson(),
        "message": message,
        "toast": toast,
        "response_type": responseType,
      };
}

class ResponseData {
  ResponseData({
    required this.id,
    required this.status,
    required this.cleanedTranscript,
  });

  final int? id;
  final String? status;
  final CleanedTranscript? cleanedTranscript;

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
      id: json["id"],
      status: json["status"],
      cleanedTranscript: json["cleaned_transcript"] == null ? null : CleanedTranscript.fromJson(json["cleaned_transcript"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "cleaned_transcript": cleanedTranscript?.toJson(),
      };
}

class CleanedTranscript {
  List<List<TranscriptEntry>> responseData;

  CleanedTranscript({required this.responseData});

  factory CleanedTranscript.fromJson(Map<String, dynamic> json) {
    var list = json['response_data'] as List;
    List<List<TranscriptEntry>> responseDataList = list.map((e) => (e as List).map((item) => TranscriptEntry.fromJson(item)).toList()).toList();

    return CleanedTranscript(responseData: responseDataList);
  }

  Map<String, dynamic> toJson() {
    return {
      'response_data': responseData.map((e) => e.map((item) => item.toJson()).toList()).toList(),
    };
  }
}

class TranscriptEntry {
  double start;
  double end;
  String speaker;
  String sentence;

  TranscriptEntry({
    required this.start,
    required this.end,
    required this.speaker,
    required this.sentence,
  });

  factory TranscriptEntry.fromJson(Map<String, dynamic> json) {
    return TranscriptEntry(
      start: json['start'].toDouble(),
      end: json['end'].toDouble(),
      speaker: json['speaker'],
      sentence: json['sentence'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start': start,
      'end': end,
      'speaker': speaker,
      'sentence': sentence,
    };
  }
}
//-----------------------------------------------------

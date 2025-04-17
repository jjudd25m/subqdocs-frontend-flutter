import 'package:flutter/services.dart';
import 'package:live_activities/models/live_activity_file.dart';

class FootballGameLiveActivityModel {
  // final DateTime? matchStartDate;
  // final DateTime? matchEndDate;
  // final String? matchName;
  // final LiveActivityFileFromAsset? ruleFile;

  final String? userName;
  final String? recordingTime;
  final String? resumeRecording;
  // final String? teamAState;
  // final int? teamAScore;
  // final LiveActivityFileFromAsset? teamALogo;

  // final String? teamBName;
  // final String? teamBState;
  // final int? teamBScore;
  // final LiveActivityFileFromAsset? teamBLogo;

  FootballGameLiveActivityModel({
    this.userName,
    this.recordingTime,
    this.resumeRecording,
    // this.matchName,
    // this.teamAState,
    // this.ruleFile,
    // this.teamAScore = 0,
    // this.teamBScore = 0,
    // this.teamALogo,
    // this.teamBName,
    // this.teamBState,
    // this.teamBLogo,
    // this.matchEndDate,
    // this.matchStartDate,
  });

  Map<String, dynamic> toMap() {
    final map = {
      // 'matchName': matchName,
      // 'ruleFile': ruleFile,
      'userName': userName,
      'recordingTime': recordingTime,
      'resumeRecording': resumeRecording,
      // 'teamAState': teamAState,
      // 'teamALogo': teamALogo,
      // 'teamAScore': teamAScore,
      // 'teamBScore': teamBScore,
      // 'teamBName': teamBName,
      // 'teamBState': teamBState,
      // 'teamBLogo': teamBLogo,
      // 'matchStartDate': matchStartDate?.millisecondsSinceEpoch,
      // 'matchEndDate': matchEndDate?.millisecondsSinceEpoch,
    };

    return map;
  }

  FootballGameLiveActivityModel copyWith({
    String? userName,
    String? recordingTime,
    String? resumeRecording,
    // DateTime? matchStartDate,
    // DateTime? matchEndDate,
    // LiveActivityFileFromAsset? ruleFile,
    // String? matchName,
    // String? teamAName,
    // String? teamAState,
    // int? teamAScore,
    // LiveActivityFileFromAsset? teamALogo,
    // String? teamBName,
    // String? teamBState,
    // int? teamBScore,
    // LiveActivityFileFromAsset? teamBLogo,
  }) {
    return FootballGameLiveActivityModel(
      // ruleFile: ruleFile ?? this.ruleFile,
      // matchStartDate: matchStartDate ?? this.matchStartDate,
      // matchEndDate: matchEndDate ?? this.matchEndDate,
      // matchName: matchName ?? this.matchName,
      userName: userName ?? this.userName,
      recordingTime: recordingTime ?? this.recordingTime,
      resumeRecording: resumeRecording ?? this.resumeRecording,
      // teamAState: teamAState ?? this.teamAState,
      // teamAScore: teamAScore ?? this.teamAScore,
      // teamALogo: teamALogo ?? this.teamALogo,
      // teamBName: teamBName ?? this.teamBName,
      // teamBState: teamBState ?? this.teamBState,
      // teamBScore: teamBScore ?? this.teamBScore,
      // teamBLogo: teamBLogo ?? this.teamBLogo,
    );
  }
}

// class LiveActivityFileFromAsset extends LiveActivityFile {
//   final String path;
//
//   LiveActivityFileFromAsset._(
//     this.path,
//     LiveActivityImageFileOptions? options,
//   ) : super(
//           options,
//         );
//
//   factory LiveActivityFileFromAsset(
//     String path,
//   ) {
//     return LiveActivityFileFromAsset._(path, null);
//   }
//
//   factory LiveActivityFileFromAsset.image(
//     String path, {
//     LiveActivityImageFileOptions? imageOptions,
//   }) {
//     return LiveActivityFileFromAsset._(
//       path,
//       imageOptions,
//     );
//   }
//
//   @override
//   Future<Uint8List> loadFile() async {
//     final byteData = await rootBundle.load(path);
//     return byteData.buffer.asUint8List();
//   }
//
//   @override
//   String get fileName => path.split('/').last;
// }
//
// abstract class LiveActivityFile {
//   final LiveActivityImageFileOptions? imageOptions;
//
//   LiveActivityFile(this.imageOptions);
//
//   /// Load the image.
//   Future<Uint8List> loadFile();
//   String get fileName;
// }
//
// class LiveActivityImageFileOptions {
//   num? resizeFactor;
//
//   LiveActivityImageFileOptions({this.resizeFactor});
// }

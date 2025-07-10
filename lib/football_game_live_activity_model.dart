class FootballGameLiveActivityModel {
  final String? userName;
  final String? recordingTime;
  final String? resumeRecording;

  FootballGameLiveActivityModel({this.userName, this.recordingTime, this.resumeRecording});

  Map<String, dynamic> toMap() {
    final map = {'userName': userName, 'recordingTime': recordingTime, 'resumeRecording': resumeRecording};

    return map;
  }

  FootballGameLiveActivityModel copyWith({String? userName, String? recordingTime, String? resumeRecording}) {
    return FootballGameLiveActivityModel(userName: userName ?? this.userName, recordingTime: recordingTime ?? this.recordingTime, resumeRecording: resumeRecording ?? this.resumeRecording);
  }
}

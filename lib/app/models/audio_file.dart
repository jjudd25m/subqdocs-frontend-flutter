import 'package:flutter/services.dart';

class AudioFile {
  int? id;
  String? fileName;
  String status;
  String? visitId;
  Uint8List? audioData;

  AudioFile({
    this.id,
    this.fileName,
    required this.status,
    required this.visitId,
    this.audioData,
  });

  factory AudioFile.fromMap(Map<String, dynamic> map, {Uint8List? audioData}) {
    return AudioFile(
      id: map['id'],
      fileName: map['fileName'],
      status: map['status'],
      visitId: map['visit_id'],
      audioData: audioData,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'fileName': fileName,
      'status': status,
      'visit_id': visitId,
      'audioData' : audioData
      // audioData is not stored in the metadata table
    };
  }
}
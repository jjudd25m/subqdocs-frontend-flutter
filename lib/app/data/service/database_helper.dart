// import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('audio_files.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE audioFiles(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      audioData BLOB,
      fileName TEXT,
      status TEXT,
      visit_id TEXT
    )
  ''');
  }

  // Future _createDB(Database db, int version) async {
  //   await db.execute('''
  //     CREATE TABLE audioFiles(
  //       id INTEGER PRIMARY KEY AUTOINCREMENT,
  //       audioData BLOB,
  //       fileName TEXT,
  //       status TEXT
  //     )
  //   ''');
  // }

  // Insert audio file to the database
  Future<int> insertAudioFile(AudioFile audioFile) async {
    final db = await instance.database;
    return await db.insert('audioFiles', audioFile.toMap());
  }
  // Future<int> insertAudioFile(AudioFile audioFile) async {
  //   final db = await instance.database;
  //   return await db.insert('audioFiles', audioFile.toMap());
  // }

  // Get all pending audio files
  // Get all pending audio files, optionally filtered by visit_id (String)
  // Future<List<AudioFile>> getPendingAudioFiles({String? visitId}) async {
  //   final db = await instance.database;
  //   final whereArgs = visitId != null ? ['pending', visitId] : ['pending'];
  //   final maps = await db.query(
  //     'audioFiles',
  //     where: 'status = ? AND visit_id = ?',
  //     whereArgs: whereArgs,
  //   );
  //   return List.generate(maps.length, (i) => AudioFile.fromMap(maps[i]));
  // }

  Future<List<AudioFile>> getPendingAudioFiles() async {
    final db = await instance.database;
    final maps = await db.query('audioFiles', where: 'status = ?', whereArgs: ['pending']);
    return List.generate(maps.length, (i) => AudioFile.fromMap(maps[i]));
  }

  // Update status to 'uploaded' after successful upload
  // Future<int> updateAudioFileStatus(int id) async {
  //   final db = await instance.database;
  //   return await db.update('audioFiles', {'status': 'uploaded'}, where: 'id = ?', whereArgs: [id]);
  // }
  //
  // Delete audio file by ID
  Future<int> deleteAudioFile(int id) async {
    final db = await instance.database;
    return await db.delete('audioFiles', where: 'id = ?', whereArgs: [id]);
  }

// Update status to 'uploaded' after successful upload, considering visit_id (String)
  Future<int> updateAudioFileStatus(int id, {String? visitId}) async {
    final db = await instance.database;
    final whereArgs = visitId != null ? [id, visitId] : [id];
    return await db.update(
      'audioFiles',
      {'status': 'uploaded'},
      where: 'id = ? AND visit_id = ?',
      whereArgs: whereArgs,
    );
  }

// Delete audio file by ID and visit_id (String)
//   Future<int> deleteAudioFile(int id, {String? visitId}) async {
//     final db = await instance.database;
//     final whereArgs = visitId != null ? [id, visitId] : [id];
//     return await db.delete(
//       'audioFiles',
//       where: 'id = ? AND visit_id = ?',
//       whereArgs: whereArgs,
//     );
//   }
}

// class AudioFile {
//   int? id;
//   Uint8List audioData; // Storing audio data as bytes (BLOB)
//   String? fileName;
//   String status; // 'pending' or 'uploaded'
//
//   AudioFile({this.id, required this.audioData, this.fileName, required this.status});
//
//   // Convert AudioFile to Map for SQFLite
//   Map<String, dynamic> toMap() {
//     return {
//       'audioData': audioData, // Save the audio data as BLOB
//       'fileName': fileName,
//       'status': status,
//     };
//   }
//
//   // Convert Map to AudioFile
//   factory AudioFile.fromMap(Map<String, dynamic> map) {
//     return AudioFile(
//       id: map['id'],
//       audioData: map['audioData'],
//       fileName: map['fileName'],
//       status: map['status'],
//     );
//   }
// }

class AudioFile {
  int? id;
  Uint8List audioData; // Storing audio data as bytes (BLOB)
  String? fileName;
  String status; // 'pending' or 'uploaded'
  String? visitId; // Change visitId to String

  AudioFile({
    this.id,
    required this.audioData,
    this.fileName,
    required this.status,
    required this.visitId, // visitId is now a String
  });

  // Convert AudioFile to Map for SQFLite
  Map<String, dynamic> toMap() {
    return {
      'audioData': audioData, // Save the audio data as BLOB
      'fileName': fileName,
      'status': status,
      'visit_id': visitId, // Store visit_id as String
    };
  }

  // Convert Map to AudioFile
  factory AudioFile.fromMap(Map<String, dynamic> map) {
    return AudioFile(
      id: map['id'],
      audioData: map['audioData'],
      fileName: map['fileName'],
      status: map['status'],
      visitId: map['visit_id'], // Read visit_id as String from map
    );
  }
}

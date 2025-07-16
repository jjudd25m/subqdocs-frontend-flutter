import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:subqdocs/app/core/common/logger.dart';

import '../../models/audio_file.dart';

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
    return await openDatabase(path, version: 3, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE audioFiles(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      fileName TEXT,
      status TEXT,
      visit_id TEXT
    )
    ''');
    await db.execute('''
    CREATE TABLE audioChunks(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      audioId INTEGER,
      chunkIndex INTEGER,
      chunkData BLOB,
      FOREIGN KEY(audioId) REFERENCES audioFiles(id)
    )
    ''');
  }

  // Insert audio file in chunks
  // Future<int> insertAudioFile(Uint8List audioData, String? fileName, String status, String? visitId, {int chunkSize = 1024 * 1024}) async {
  Future<int> insertAudioFile(AudioFile file, {int chunkSize = 1024 * 1024}) async {
    try {
      final db = await instance.database;
      int audioId = await db.insert('audioFiles', {
        'fileName': file.fileName,
        'status': file.status,
        'visit_id': file.visitId,
      });
      int totalChunks = (file.audioData?.length ?? 0 / chunkSize).ceil();
      for (int i = 0; i < totalChunks; i++) {
        int start = i * chunkSize;
        int end = start + chunkSize;
        if (end > (file.audioData?.length ?? 0)) end = file.audioData?.length ?? 0;
        List<int> chunk = file.audioData?.sublist(start, end) ?? [];
        await db.insert('audioChunks', {
          'audioId': audioId,
          'chunkIndex': i,
          'chunkData': chunk,
        });
      }
      return audioId;
    } catch (e) {
      customPrint("error message: $e");
      return -1;
    }
  }

  // Retrieve audio data for a file
  Future<Uint8List> getAudioFileData(int audioId) async {
    final db = await instance.database;
    final chunks = await db.query(
      'audioChunks',
      where: 'audioId = ?',
      whereArgs: [audioId],
      orderBy: 'chunkIndex ASC',
    );
    List<int> audioData = [];
    for (final chunk in chunks) {
      audioData.addAll((chunk['chunkData'] as Uint8List).toList());
    }
    return Uint8List.fromList(audioData);
  }

  Future<List<AudioFile>> getPendingAudioFiles() async {
    try {
      final db = await DatabaseHelper.instance.database;
      final maps = await db.query('audioFiles', where: 'status = ?', whereArgs: ['pending']);
      List<AudioFile> result = [];
      for (final map in maps) {
        final id = map['id'] as int;
        final audioData = await DatabaseHelper.instance.getAudioFileData(id);
        result.add(AudioFile.fromMap(map, audioData: audioData));
      }
      return result;
    } catch (e) {
      customPrint("error message: $e");
      return [];
    }
  }

  // Delete audio file and its chunks by ID
  Future<int> deleteAudioFile(int id) async {
    final db = await instance.database;
    await db.delete('audioChunks', where: 'audioId = ?', whereArgs: [id]);
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
}
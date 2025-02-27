import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

import '../app/core/common/logger.dart';

const int mediaLimit = 4;

class MediaPickerServices {
  MediaPickerServices._privateConstructor();

  static final MediaPickerServices _instance = MediaPickerServices._privateConstructor();

  factory MediaPickerServices() {
    return _instance;
  }

  final ImagePicker _picker = ImagePicker();

  Future<XFile?> pickImage({bool fromCamera = true}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: fromCamera ? ImageSource.camera : ImageSource.gallery);
    return image;
  }

  Future<XFile?> pickImageVideoMedia() async {
    final XFile? image = await _picker.pickMedia();
    if (image != null) {
      if (lookupMimeType(image.name)?.contains(("image")) ?? false) {
        return image;
      } else if (lookupMimeType(image.name)?.contains(("video")) ?? false) {
        return image;
      } else {
        // showToast("Only allow image and video");
        return null;
      }
    }
    return null;
  }

  Future<XFile?> pickVideo({required bool fromCamera}) async {
    final XFile? image = await _picker.pickVideo(source: fromCamera ? ImageSource.camera : ImageSource.gallery);
    return image;
  }

  Future<List<PlatformFile>?> pickAllFiles() async {
    // Pick multiple files, setting type as FileType.any to allow all types of files
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true, // Allows multiple files to be selected
      type: FileType.any, // Accepts any type of file
    );

    // Check if the user picked any files
    if (result != null) {
      List<PlatformFile> files = result.files; // List of selected files
      customPrint("Files selected: $files");
      return files;
    } else {
      customPrint("No files selected");
      return null;
    }
  }

  Future<List<XFile>?> pickMultiMedia() async {
    List<XFile>? image = await _picker.pickMultipleMedia(limit: mediaLimit);
    customPrint("file is  ${image}");
    return image;
  }

  Future<List<XFile>?> pickMultiPdf() async {
    List<XFile>? pdf = await _picker.pickMultipleMedia(limit: mediaLimit);

    if (pdf.isNotEmpty) {
      bool check = pdf.any((e) => getFileType(File(e.path)) != "pdf");
      if (check) {
        // showToast("Please select pdf type");
        return null;
      }
    }
    return pdf;
  }

  Future<File?> pickSrt() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['srt'], // Only allow .srt files
    );

    if (result?.files.firstOrNull == null) {
      return null;
    } else {
      return File(result?.files.firstOrNull?.path ?? "");
    }
  }

  Future<bool> validateMediaFiles(List<XFile>? files) async {
    if (files == null || files.isEmpty) {
      return false;
    }
    for (var file in files) {
      final mimeType = lookupMimeType(file.path);
      if (mimeType == null || (!mimeType.startsWith('image/') && !mimeType.startsWith('video/'))) {
        return false;
      }
    }

    if (files.length > mediaLimit) {
      return false;
    }
    return true;
  }

  MediaType? getMediaType(XFile file) {
    final mimeType = lookupMimeType(file.path);
    if (mimeType?.startsWith('image/') ?? false) {
      return MediaType.Image;
    }
    if (mimeType?.startsWith('video/') ?? false) {
      return MediaType.Video;
    }
    return null;
  }
}

String getFileType(File file) {
  String fileName = file.path.split('/').last;

  String? mimeType = lookupMimeType(fileName);
  String type = mimeType?.split('/')[1] ?? "";

  return type ?? "";
}

enum MediaType {
  Image('Image'),
  Video("Video");

  final String value;
  const MediaType(this.value);
}

extension MediaTypeExtension on MediaType {
  static MediaType fromString(String value) {
    try {
      return MediaType.values.firstWhere((quiz) => quiz.value.toLowerCase() == value.toLowerCase(), orElse: () => MediaType.Image);
    } catch (e) {
      return MediaType.Image; // Return null if no match is found
    }
  }
}

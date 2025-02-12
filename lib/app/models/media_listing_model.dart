import 'dart:io';
import 'dart:ui';

class MediaListingModel {
  File? file;

  Image? previewImage;
  String? fileName;
  String? date;
  String? Size;

  MediaListingModel({
    this.file,
    this.previewImage,
    this.fileName,
    this.date,
    this.Size,
  });
}

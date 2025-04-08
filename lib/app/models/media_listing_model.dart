import 'dart:io';
import 'dart:ui';

class MediaListingModel {
  File? file;

  Image? previewImage;
  String? fileName;
  String? date;
  String? Size;
  double? calculateSize;
  bool? isGraterThan10;

  MediaListingModel({
    this.file,
    this.previewImage,
    this.isGraterThan10,
    this.calculateSize,
    this.fileName,
    this.date,
    this.Size,
  });
}

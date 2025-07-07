import 'dart:io';

import 'package:flutter/material.dart';

class RoundedImageFileWidget extends StatelessWidget {
  final double? size;
  final File? imagePath;

  const RoundedImageFileWidget({super.key, this.size = 44, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(height: size, width: size, decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle, image: DecorationImage(fit: BoxFit.cover, image: FileImage(imagePath ?? File("")))));
  }
}

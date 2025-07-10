import 'package:flutter/material.dart';

class RoundedImageWidget extends StatelessWidget {
  final double? size;
  final String? imagePath;

  const RoundedImageWidget({super.key, this.size = 44, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(height: size, width: size, decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle, image: DecorationImage(fit: BoxFit.cover, image: AssetImage(imagePath!))));
  }
}

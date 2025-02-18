import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:subqdocs/utils/extension.dart';
import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';
import '../utils/imagepath.dart';

class BaseImageView extends StatelessWidget {
  const BaseImageView({super.key, required this.imageUrl, this.width, this.height, this.errorWidget, this.nameLetters, this.circleColor, this.fontSize = 24.0});

  final String imageUrl;
  final double? width;
  final double? height;
  final Widget? errorWidget;
  final String? nameLetters;
  final Color? circleColor;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    print(" image url is ${imageUrl}");
    return imageUrl.isNotEmpty
        ? CachedNetworkImage(
            imageUrl: imageUrl,
            width: width ?? 80,
            height: height ?? 80,
            errorWidget: (context, url, error) {
              if (errorWidget == null) {
                return (nameLetters?.isNotEmpty ?? false)
                    ? Container(
                        width: width ?? 80,
                        height: height ?? 80,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: circleColor ?? generateDarkRandomColor()),
                        child: Center(
                          child: Text(
                            nameLetters?.getFirstTwoWordInitials() ?? "",
                            style: AppFonts.semiBold(fontSize ?? 24.0, AppColors.textWhite),
                          ),
                        ),
                      )
                    : SvgPicture.asset(
                        ImagePath.avatar,
                        width: width ?? 80,
                        height: height ?? 80,
                        fit: BoxFit.fitWidth,
                      );
              } else {
                return errorWidget!;
              }
            },
            placeholder: (context, url) => SvgPicture.asset(
              ImagePath.avatar,
              width: width ?? 80,
              height: height ?? 80,
              fit: BoxFit.fitWidth,
            ),
            fit: BoxFit.cover,
          )
        : (nameLetters?.isNotEmpty ?? false)
            ? Container(
                width: width ?? 80,
                height: height ?? 80,
                decoration: BoxDecoration(shape: BoxShape.circle, color: circleColor ?? generateDarkRandomColor()),
                child: Center(
                  child: Text(
                    nameLetters?.getFirstTwoWordInitials() ?? "",
                    style: AppFonts.semiBold(fontSize ?? 24.0, AppColors.textWhite),
                  ),
                ),
              )
            : SvgPicture.asset(
                ImagePath.avatar,
                width: width ?? 80,
                height: height ?? 80,
                fit: BoxFit.fitWidth,
              );
  }
}

Color generateDarkRandomColor() {
  final random = Random();

  // Generate random values for red, green, blue (0 to 127) to ensure a dark color
  int red = random.nextInt(128); // 0-127 (dark shades)
  int green = random.nextInt(128); // 0-127 (dark shades)
  int blue = random.nextInt(128); // 0-127 (dark shades)

  // Return a Color using the generated RGB values
  return Color.fromRGBO(red, green, blue, 1.0); // Alpha value is 1.0 (fully opaque)
}

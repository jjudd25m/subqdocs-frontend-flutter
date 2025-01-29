import 'package:flutter/material.dart';

import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/utils/app_fonts.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? navigate;
  final String? label;
  final Color backGround;
  final Color textColor;
  final bool isTrue;

  CustomButton(
      {super.key,
      required this.navigate,
      required this.label,
      this.backGround = AppColors.backgroundPurple,
      this.textColor = Colors.white,
      this.isTrue = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(116, 103, 183, 0.3),
                offset: Offset(0, 3),
                blurRadius: 6,
              ),
            ]),
            height: 47,
            child: ElevatedButton(
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                backgroundColor: WidgetStateProperty.all<Color>(backGround),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                    side: isTrue == true
                        ? BorderSide(color: Color.fromRGBO(0, 0, 0, 0))
                        : BorderSide(width: 1, color: Color.fromRGBO(18, 82, 234, 1)),
                  ),
                ),
              ),
              onPressed: navigate,
              child: Text(
                "$label",
                style: AppFonts.medium(14, textColor).copyWith(color: textColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

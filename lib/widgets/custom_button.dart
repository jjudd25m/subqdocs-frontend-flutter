import 'package:flutter/material.dart';

import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/utils/app_fonts.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? navigate;
  final String? label;
  final Color backGround;
  final Color textColor;
  final bool isTrue;
  double? hight = 40;

  CustomButton({super.key, required this.navigate, required this.label, this.backGround = AppColors.backgroundPurple, this.textColor = Colors.white, this.hight = 40, this.isTrue = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), boxShadow: const [BoxShadow(color: AppColors.clear, offset: Offset(0, 0), blurRadius: 0)]),
            height: hight,
            child: ElevatedButton(
              style: ButtonStyle(
                elevation: const WidgetStatePropertyAll(0),
                padding: const WidgetStatePropertyAll(EdgeInsets.zero),
                visualDensity: VisualDensity.compact,
                foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                backgroundColor: WidgetStateProperty.all<Color>(backGround),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(6), side: isTrue == true ? const BorderSide(color: Color.fromRGBO(0, 0, 0, 0)) : const BorderSide(width: 1, color: Color.fromRGBO(18, 82, 234, 1)))),
              ),
              onPressed: navigate,
              child: Text("$label", style: AppFonts.medium(14, textColor).copyWith(color: textColor)),
            ),
          ),
        ),
      ],
    );
  }
}

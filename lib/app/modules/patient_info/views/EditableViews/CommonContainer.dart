import 'package:flutter/material.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_fonts.dart';

class CommonContainer extends StatelessWidget {
  final String title;
  final Widget child;

  const CommonContainer({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6), bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)),
        color: AppColors.white,
        border: Border.all(color: AppColors.backgroundPurple.withAlpha(50), width: 1),
      ),
      child: Column(
        children: [
          Container(
            height: 40,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
              color: AppColors.backgroundPurple.withAlpha(50),
              border: Border.all(color: AppColors.backgroundPurple.withAlpha(50), width: 0.01),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Row(children: [Text(title, textAlign: TextAlign.center, style: AppFonts.medium(16, AppColors.textPurple)), const Spacer()]),
              ],
            ),
          ),

          child,
          const SizedBox(height: 3),
        ],
      ),
    );
  }
}

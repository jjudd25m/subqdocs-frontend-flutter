import 'package:flutter/material.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';

class CommonPatientData extends StatelessWidget {
  final String? label, data;

  const CommonPatientData({super.key, this.label, this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label ?? "", style: AppFonts.regular(12, AppColors.textBlack)),
        const SizedBox(height: 6),
        Text(data ?? "", style: AppFonts.regular(14, AppColors.textDarkGrey)),
      ],
    );
  }
}

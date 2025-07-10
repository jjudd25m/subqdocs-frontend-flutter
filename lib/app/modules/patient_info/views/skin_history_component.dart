import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';

class SkinHistoryComponent extends StatelessWidget {
  final String title;
  final List<String>? dataList;
  final VoidCallback? onEdit;

  const SkinHistoryComponent({
    super.key,
    required this.title,
    this.dataList,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final filteredList =
        dataList?.where((item) => item.trim().isNotEmpty).toList() ?? [];
    final hasData = filteredList.isNotEmpty;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: AppColors.white,
        border: Border.all(
          color: AppColors.backgroundPurple.withAlpha(50),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
              color: AppColors.backgroundPurple.withAlpha(50),
              border: Border.all(
                color: AppColors.backgroundPurple.withAlpha(50),
                width: 0.1,
              ),
            ),
            child: Row(
              children: [
                Text(title, style: AppFonts.medium(16, AppColors.textPurple)),
                const Spacer(),
                if (onEdit != null)
                  InkWell(
                    onTap: onEdit,
                    child: SvgPicture.asset(
                      ImagePath.edit_outline,
                      height: 24,
                      width: 24,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Data List or Dash
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child:
                hasData
                    ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final item = filteredList[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text.rich(
                            TextSpan(
                              text: "• ",
                              style: AppFonts.bold(15, AppColors.black),
                              children: [
                                TextSpan(
                                  text: item,
                                  style: AppFonts.regular(
                                    15,
                                    AppColors.textGrey,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.left,
                          ),
                        );
                      },
                    )
                    : Text(
                      "-",
                      style: AppFonts.medium(16, AppColors.textPurple),
                    ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

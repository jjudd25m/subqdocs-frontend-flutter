import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/utils/app_fonts.dart';

class DrawerItem extends StatelessWidget {
  final bool isSelected;
  final String itemName;
  final iconPath;

  const DrawerItem({super.key, this.isSelected = false, required this.itemName, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 44,
          child: Card(
            margin: EdgeInsets.zero,
            color: isSelected ? AppColors.backgroundPurple : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            elevation: isSelected ? 1 : 0,
            child: Row(
              children: [
                const SizedBox(width: 18.5),
                SizedBox(
                  height: 18,
                  width: 18,
                  child: SvgPicture.asset(
                    iconPath,
                    colorFilter:
                        isSelected
                            ? const ColorFilter.mode(
                              Colors.white, // The color you want to apply
                              BlendMode.srcIn, // This blend mode is commonly used for coloring SVGs
                            )
                            : const ColorFilter.mode(
                              Colors.black, // The color you want to apply
                              BlendMode.srcIn, // This blend mode is commonly used for coloring SVGs
                            ),
                  ),
                ),
                const SizedBox(width: 10.5),
                Text(itemName, style: isSelected ? AppFonts.medium(16, AppColors.white) : AppFonts.medium(16, AppColors.drawerText)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
      ],
    );
  }
}

class DrawerMobileItem extends StatelessWidget {
  final bool isSelected;
  final String itemName;
  final iconPath;

  const DrawerMobileItem({super.key, this.isSelected = false, required this.itemName, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 44,
          child: Container(
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(color: isSelected ? AppColors.backgroundLightBlue : Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                const SizedBox(width: 15),
                SizedBox(
                  height: 22,
                  width: 22,
                  child: SvgPicture.asset(
                    iconPath,
                    colorFilter:
                        isSelected
                            ? const ColorFilter.mode(
                              AppColors.textPurple, // The color you want to apply
                              BlendMode.srcIn, // This blend mode is commonly used for coloring SVGs
                            )
                            : const ColorFilter.mode(
                              AppColors.textDarkGrey, // The color you want to apply
                              BlendMode.srcIn, // This blend mode is commonly used for coloring SVGs
                            ),
                  ),
                ),
                const SizedBox(width: 10.5),
                Text(itemName, style: isSelected ? AppFonts.medium(16, AppColors.textPurple) : AppFonts.medium(16, AppColors.textDarkGrey)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
      ],
    );
  }
}

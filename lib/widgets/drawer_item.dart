import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/utils/app_fonts.dart';
import 'package:subqdocs/utils/imagepath.dart';

class DrawerItem extends StatelessWidget {
  final bool isSelected;
  final String itemName;
  final iconPath;

  DrawerItem({this.isSelected = false, required this.itemName, required this.iconPath});

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
                SizedBox(
                  width: 18.5,
                ),
                SizedBox(
                  height: 18,
                  width: 18,
                  child: SvgPicture.asset(
                    iconPath,
                    colorFilter: isSelected
                        ? ColorFilter.mode(
                            Colors.white, // The color you want to apply
                            BlendMode.srcIn, // This blend mode is commonly used for coloring SVGs
                          )
                        : ColorFilter.mode(
                            Colors.black, // The color you want to apply
                            BlendMode.srcIn, // This blend mode is commonly used for coloring SVGs
                          ),
                  ),
                ),
                SizedBox(
                  width: 10.5,
                ),
                Text(
                  itemName,
                  style: isSelected ? AppFonts.medium(16, AppColors.white) : AppFonts.medium(16, AppColors.drawerText),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 6,
        ),
      ],
    );
  }
}

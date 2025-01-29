import 'package:flutter/material.dart';
import 'package:subqdocs/utils/app_colors.dart';

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
                // SizedBox(
                //   height: 18.h,
                //   width: 18.h,
                //   child: SvgProvider(
                //     path: "${AssetPath.stoke}${iconPath}.svg",
                //     iconColor: isSelected ? Colors.white : Colors.black,
                //   ),
                // ),
                SizedBox(
                  width: 10.5,
                ),
                Text(
                  itemName,
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

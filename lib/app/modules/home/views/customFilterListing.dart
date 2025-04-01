import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:subqdocs/utils/app_fonts.dart';
import 'package:subqdocs/utils/imagepath.dart';

import '../../../../utils/app_colors.dart';
import '../model/FilterListingModel.dart';

class CustomFilterListing extends StatelessWidget {
  List<FilterListingModel> items;
  final VoidCallback? oneClearAll;

  final void Function(String) onDeleteItem;

  CustomFilterListing({super.key, required this.items, required this.onDeleteItem, this.oneClearAll});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.symmetric(vertical: 3, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.ScreenBackGround,
        border: Border.all(
          color: AppColors.lightpurpule,
          width: 1,
        ),
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Filters:",
            style: AppFonts.medium(14, AppColors.textBlack),
          ),
          SizedBox(width: 5),
          Expanded(
            // Use Expanded to take up the remaining space
            child: Wrap(
              // Space between items horizontally
              // Space between lines vertically
              children: List.generate(items.length + 1, (index) {
                if (index != items.length) {
                  final item = items[index]; // Get the item based on the index

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.ScreenBackGround,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.filterBorder, width: 1),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${item.filterName}:",
                            style: AppFonts.medium(14, AppColors.offBlackText),
                          ),
                          SizedBox(width: 6),
                          Text(
                            item.filterValue,
                            style: AppFonts.medium(14, AppColors.filterText),
                          ),
                          SizedBox(width: 6),
                          GestureDetector(
                            onTap: () {
                              onDeleteItem(item.filterName);
                            },
                            child: SvgPicture.asset(ImagePath.filter_icon),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 13),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: oneClearAll,
                          child: Text(
                            "Clear all",
                            style: AppFonts.medium(12, AppColors.filterText),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }),
            ),
          )
        ],
      ),
    );
  }
}

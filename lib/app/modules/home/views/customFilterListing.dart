import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:subqdocs/utils/app_fonts.dart';

import '../../../../utils/app_colors.dart';
import '../model/FilterListingModel.dart';

class CustomFilterListing extends StatelessWidget {


  List<FilterListingModel> items;

  CustomFilterListing({super.key, required this.items});


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.symmetric(vertical: 8, horizontal: 10),
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
          Expanded( // Use Expanded to take up the remaining space
            child: Wrap(
              spacing: 8.0, // Space between items horizontally
              runSpacing: 4.0, // Space between lines vertically
              children: items.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.ScreenBackGround,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item.filterName,
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          item.filterName,
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(width: 5),
                        IconButton(
                          icon: Icon(Icons.cancel, color: Colors.white),
                          onPressed: () {
                            // Handle cancel button press (you can remove the item or perform any action)
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

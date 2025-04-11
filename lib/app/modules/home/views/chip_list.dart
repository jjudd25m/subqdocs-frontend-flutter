import 'package:flutter/material.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/utils/app_fonts.dart';
import 'dart:math';

class CustomCapsuleList extends StatefulWidget {
  final List<String> items;
  final Function(String, int) onRemove;

  const CustomCapsuleList({
    Key? key,
    required this.items,
    required this.onRemove,
  }) : super(key: key);

  @override
  _CustomCapsuleListState createState() => _CustomCapsuleListState();
}

class _CustomCapsuleListState extends State<CustomCapsuleList> {
  // Cache to store color for each item
  final Map<String, Color> _itemColorCache = {};

  // List of predefined colors
  final List<Color> predefinedColors = [
    AppColors.filterPendingColor,
    AppColors.filterFinalizedColor,
    AppColors.filterCheckedInColor,
    AppColors.filterInProgressColor,
    AppColors.filterPausedColor,
    AppColors.filterScheduleColor,
    AppColors.filterNotRecordedColor,
    AppColors.filterLateColor,
    AppColors.filterCancelledColor,
    AppColors.filterCanceledColor,
    AppColors.filterNoShowColor,
    AppColors.filterInsufficientInfoColor,
  ];

  // Function to get a random color from the predefined list
  Color _getRandomColor(String item) {
    // If the color is already cached, return it
    if (_itemColorCache.containsKey(item)) {
      return _itemColorCache[item]!;
    }

    // Randomly pick a color from the predefined list
    Random random = Random(item.hashCode); // Ensures the same item gets the same color
    Color color = predefinedColors[random.nextInt(predefinedColors.length)];

    // Cache the color
    _itemColorCache[item] = color;

    return color;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Wrap(
            spacing: 4,
            runSpacing: 8,
            children: List.generate(widget.items.length, (index) {
              Color backgroundColor = _getRandomColor(widget.items[index]);

              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: backgroundColor.withValues(alpha: 0.2), // Use randomly selected color
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.items[index],
                      style: AppFonts.medium(12, backgroundColor),
                    ),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => widget.onRemove(widget.items[index], index),
                      child: Icon(Icons.close, size: 18, color: AppColors.textBlack),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

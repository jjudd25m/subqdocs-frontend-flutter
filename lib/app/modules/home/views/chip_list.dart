import 'package:flutter/material.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/utils/app_fonts.dart';

import '../../../core/common/logger.dart';

class CustomCapsuleList extends StatefulWidget {
  final List<String> items;
  final Function(String, int) onRemove;

  const CustomCapsuleList({
    super.key,
    required this.items,
    required this.onRemove,
  });

  @override
  _CustomCapsuleListState createState() => _CustomCapsuleListState();
}

class _CustomCapsuleListState extends State<CustomCapsuleList> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Wrap(
            spacing: 4,
            runSpacing: 8,
            children:
                List.generate(widget.items.length, (index) {
                  customPrint("color name:- ${widget.items[index]}");

                  Color backgroundColor = getStatusColor(
                    widget.items[index].replaceAll(" ", "-"),
                  );

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: backgroundColor.withValues(alpha: 0.2),
                      // Use randomly selected color
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.items[index],
                          style: AppFonts.medium(12, backgroundColor),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap:
                              () => widget.onRemove(widget.items[index], index),
                          child: const Icon(
                            Icons.close,
                            size: 18,
                            color: AppColors.textBlack,
                          ),
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

  // Function to map the status to color
  Color getStatusColor(String status) {
    switch (status) {
      case "Pending":
        return AppColors.filterPendingColor;
      case "Finalized":
        return AppColors.filterFinalizedColor;
      case "Checked-in":
        return AppColors.filterCheckedInColor;
      case "Checked-In":
        return AppColors.filterCheckedInColor;
      case "In-Progress":
        return AppColors.filterInProgressColor;
      case "Paused":
        return AppColors.filterPausedColor;
      case "Scheduled":
        return AppColors.filterScheduleColor;
      case "In-Room":
        return AppColors.filterNotRecordedColor;
      case "In-Exam":
        return AppColors.filterInProgressColor;
      case "Late":
        return AppColors.filterLateColor;
      case "Checked-out":
        return AppColors.filterCancelledColor;
      case "Cancelled":
        return AppColors.filterCanceledColor;
      case "No-Show":
        return AppColors.filterNoShowColor;
      case "Not-Recorded":
        return AppColors.filterNotRecordedColor;
      default:
        return AppColors
            .filterInsufficientInfoColor; // Default if status is unknown
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:subqdocs/utils/app_fonts.dart';

import '../app/core/common/logger.dart';
import '../utils/app_colors.dart';
import '../utils/no_space_lowercase.dart';

class TimeSlotTypeAhead extends StatefulWidget {
  final List<String> timeSlotSuggestions;
  final Widget prefixIcon;
  final ValueChanged<String> onSelected;

  // final ValueChanged<String>? onChanged;
  final String selectedValue;
  final VerticalDirection? direction;

  final VoidCallback? onFocusLost;

  final FocusNode? focusNode;

  const TimeSlotTypeAhead({super.key, this.focusNode, this.onFocusLost, required this.timeSlotSuggestions, required this.prefixIcon, required this.onSelected, required this.selectedValue, this.direction});

  @override
  State<TimeSlotTypeAhead> createState() => _TimeSlotTypeAheadState();
}

class _TimeSlotTypeAheadState extends State<TimeSlotTypeAhead> {
  late final TextEditingController _controller = TextEditingController();
  late FocusNode _internalFocusNode;

  @override
  void initState() {
    super.initState();

    _internalFocusNode = widget.focusNode ?? FocusNode();

    _internalFocusNode.addListener(() {
      if (!_internalFocusNode.hasFocus) {
        if (widget.onFocusLost != null) {
          customPrint("Focus lost detected");
          widget.onFocusLost!();
        }
      }
    });
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _internalFocusNode.dispose();
    }
    _controller.dispose();
    super.dispose();
  }

  // Target time

  List<String> _getSuggestions(String query) {
    widget.selectedValue;

    if (widget.selectedValue == "Select Visit Time") {
      return widget.timeSlotSuggestions.where((slot) => slot.toLowerCase().contains("")).toList();
    }

    try {
      // Parse the selected time in 24-hour format (e.g., "07:00")
      if (query.trim() != "") {
        DateTime selectedTime = DateFormat('HH:mm').parse(query);

        return widget.timeSlotSuggestions.where((slot) {
          // Parse each slot time in 24-hour format
          DateTime slotTime = DateFormat('HH:mm').parse(slot);

          // Compare times
          return slotTime.isAfter(selectedTime);
        }).toList();
      } else {
        DateTime selectedTime = DateFormat('HH:mm').parse(widget.selectedValue);

        return widget.timeSlotSuggestions.where((slot) {
          // Parse each slot time in 24-hour format
          DateTime slotTime = DateFormat('HH:mm').parse(slot);

          // Compare times
          return slotTime.isAfter(selectedTime);
        }).toList();
      }
    } catch (e) {
      return widget.timeSlotSuggestions.where((slot) => slot.contains(query)).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<String>(
      focusNode: widget.focusNode,
      controller: _controller,
      direction: widget.direction,
      listBuilder: (context, children) {
        return ListView(children: children);
      },
      builder: (context, controller, focusNode) {
        return TextField(
          controller: controller,
          onChanged: (value) {
            widget.onSelected(value);
          },

          focusNode: focusNode,
          inputFormatters: [TimeInputFormatter()],
          decoration: InputDecoration(
            errorStyle: const TextStyle(height: 1),
            // Controls the height of the error text
            errorMaxLines: 1,

            // To reserve error space when no error,
            // you can add a transparent helperText of the same height:
            helperText: ' ',
            hintText: widget.selectedValue,

            hintStyle: AppFonts.regular(14, AppColors.textBlack),
            suffixIcon: Padding(padding: const EdgeInsets.all(10), child: widget.prefixIcon),
            fillColor: Colors.white,
            filled: true,
            contentPadding: const EdgeInsets.only(left: 10, top: 4, bottom: 4, right: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(width: 0, color: Colors.red)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(width: 0, color: AppColors.textDarkGrey)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(width: 1, color: AppColors.textDarkGrey)),
          ),
        );
      },
      suggestionsCallback: _getSuggestions,
      constraints: const BoxConstraints(maxHeight: 200),
      itemBuilder: (context, suggestion) {
        return Container(color: Colors.white, child: ListTile(title: Text(suggestion)));
      },
      onSelected: (value) {
        _controller.clear();
        widget.onSelected(value);
      },
      emptyBuilder: (context) => Container(color: Colors.white, child: const Padding(padding: EdgeInsets.all(8.0), child: Center(child: Text('No matching time slots')))),
    );
  }
}

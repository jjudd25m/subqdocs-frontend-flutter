import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../utils/app_colors.dart';

class TimeSlotTypeAhead extends StatefulWidget {
  final List<String> timeSlotSuggestions;
  final Widget prefixIcon;
  final ValueChanged<String> onSelected;
  final String selectedValue;

  const TimeSlotTypeAhead({
    super.key,
    required this.timeSlotSuggestions,
    required this.prefixIcon,
    required this.onSelected,
    required this.selectedValue,
  });

  @override
  State<TimeSlotTypeAhead> createState() => _TimeSlotTypeAheadState();
}

class _TimeSlotTypeAheadState extends State<TimeSlotTypeAhead> {
  late final TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.selectedValue);
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _validateInput();
      }
    });
  }

  void _validateInput() {
    final input = _controller.text.trim();
    final match = widget.timeSlotSuggestions.firstWhere(
      (slot) => slot.toLowerCase() == input.toLowerCase(),
      orElse:
          () =>
              widget.timeSlotSuggestions.isNotEmpty
                  ? widget.timeSlotSuggestions.first
                  : '',
    );
    _controller.text = match;
    widget.onSelected(match);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  List<String> _getSuggestions(String query) {
    widget.selectedValue;

    if (query != widget.selectedValue) {
      return widget.timeSlotSuggestions
          .where((slot) => slot.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      return widget.timeSlotSuggestions
          .where((slot) => slot.toLowerCase().contains(""))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<String>(
      focusNode: _focusNode,
      controller: _controller,
      builder: (context, controller, focusNode) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            suffixIcon: Padding(
              padding: const EdgeInsets.all(10),
              child: widget.prefixIcon,
            ),
            fillColor: Colors.white,
            filled: true,
            contentPadding: const EdgeInsets.only(
              left: 10,
              top: 4,
              bottom: 4,
              right: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(width: 0, color: Colors.red),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(
                width: 0,
                color: AppColors.textDarkGrey,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(
                width: 1,
                color: AppColors.textDarkGrey,
              ),
            ),
          ),
        );
      },
      suggestionsCallback: _getSuggestions,
      constraints: const BoxConstraints(maxHeight: 200),
      itemBuilder: (context, suggestion) {
        return Container(
          color: Colors.white,
          child: ListTile(title: Text(suggestion)),
        );
      },
      onSelected: (value) {
        _controller.text = value;
        widget.onSelected(value);
      },
      emptyBuilder:
          (context) => Container(
            color: Colors.white,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(child: Text('No matching time slots')),
            ),
          ),
    );
  }
}

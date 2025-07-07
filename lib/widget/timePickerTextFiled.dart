import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/no_space_lowercase.dart';
import '../utils/validation_service.dart';
import '../widgets/custom_textfiled.dart';
import 'iosTimePicker.dart';

// Custom widget for Time Picker Field
class TimePickerFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String label;
  final String hint;
  final List<TextInputFormatter>? format;
  final IconData? suffixIcon;
  final bool isImportant;
  final Function(String)? onTimePicked;

  const TimePickerFormField({super.key, required this.controller, this.label = "Visit Time", this.hint = "Select Visit Time", this.format, this.suffixIcon = Icons.watch_later_outlined, this.isImportant = false, this.onTimePicked});

  @override
  State<TimePickerFormField> createState() => _TimePickerFormFieldState();
}

class _TimePickerFormFieldState extends State<TimePickerFormField> {
  String? warningMessage = "";

  String formatTimeOfDayWithLeadingZero(TimeOfDay time) {
    final hour = time.hourOfPeriod.toString().padLeft(2, '0'); // pad left with zero
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  TimeOfDay getNextRoundedTime() {
    DateTime now = DateTime.now();

    int minutes = now.minute;
    int roundedMinutes = ((minutes + 9) ~/ 10) * 10;

    if (roundedMinutes == 60) {
      now = now.add(Duration(minutes: 60 - minutes));
      now = DateTime(now.year, now.month, now.day, now.hour, 0);
    } else {
      now = DateTime(now.year, now.month, now.day, now.hour, roundedMinutes);
    }

    return TimeOfDay(hour: now.hour, minute: now.minute);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormFiledWidget(
      onChanged: (value) {
        setState(() {
          warningMessage = Validation.validateVisitTime12Hour(value ?? "");
        });
      },
      autovalidateMode: AutovalidateMode.onUnfocus,
      helperText: warningMessage,
      format: widget.format ?? [TimeInputFormatter()],
      suffixIcon: Icon(widget.suffixIcon),
      label: widget.label,
      controller: widget.controller,
      hint: widget.hint,
      onTap: () async {
        TimeOfDay initial = getNextRoundedTime();
        TimeOfDay? picked = await IosTimePickerHelper.showTimePicker(context: context, initialTime: initial);
        if (picked != null) {
          final formattedTime = formatTimeOfDayWithLeadingZero(picked);
          widget.controller?.text = formattedTime;

          setState(() {
            warningMessage = Validation.validateVisitTime12Hour(formattedTime ?? "");
          });

          if (widget.onTimePicked != null) {
            widget.onTimePicked!(formattedTime);
          }
        }
      },
    );
  }
}

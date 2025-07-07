import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/utils/app_fonts.dart';

class IosTimePickerHelper {
  /// Shows an iOS-style time picker as a bottom modal popup.
  ///
  /// Returns a Future<TimeOfDay?> which completes when user presses Done or dismisses.
  static Future<TimeOfDay?> showTimePicker({required BuildContext context, required TimeOfDay initialTime}) {
    DateTime now = DateTime.now();
    DateTime initialDateTime = DateTime(now.year, now.month, now.day, initialTime.hour, initialTime.minute);

    return showCupertinoModalPopup<TimeOfDay>(context: context, builder: (_) => Container(height: 280, color: CupertinoColors.systemBackground.resolveFrom(context), child: _IosTimePickerContent(initialDateTime: initialDateTime)));
  }
}

class _IosTimePickerContent extends StatefulWidget {
  final DateTime initialDateTime;

  const _IosTimePickerContent({required this.initialDateTime});

  @override
  __IosTimePickerContentState createState() => __IosTimePickerContentState();
}

DateTime getNextRoundedDateTime() {
  DateTime now = DateTime.now();

  int minutes = now.minute;
  int roundedMinutes = ((minutes + 9) ~/ 10) * 10;

  if (roundedMinutes == 60) {
    // Add minutes to jump to next hour exactly
    now = now.add(Duration(minutes: 60 - minutes));
    // Set minutes to 0, keep the hour updated by the addition
    now = DateTime(now.year, now.month, now.day, now.hour, 0, 0);
  } else {
    // Round minutes up within the current hour
    now = DateTime(now.year, now.month, now.day, now.hour, roundedMinutes, 0);
  }

  return now;
}

class __IosTimePickerContentState extends State<_IosTimePickerContent> {
  late DateTime _selectedDateTime;
  late Key _pickerKey;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.initialDateTime;
    _pickerKey = ValueKey(DateTime.now()); // initial key
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // The CupertinoDatePicker with dynamic key and initialDateTime
        Expanded(
          child: CupertinoDatePicker(
            key: _pickerKey,
            mode: CupertinoDatePickerMode.time,
            initialDateTime: _selectedDateTime,
            use24hFormat: false,
            onDateTimeChanged: (DateTime newDateTime) {
              setState(() {
                _selectedDateTime = newDateTime;
              });
            },
          ),
        ),
        Container(height: 1, color: AppColors.appbarBorder),
        Material(
          color: AppColors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 15, bottom: 15),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDateTime = getNextRoundedDateTime();
                      _pickerKey = ValueKey(DateTime.now());
                    });
                  },
                  child: Text('Reset', style: AppFonts.medium(20, AppColors.backgroundPurple)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15, top: 15, bottom: 15),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(TimeOfDay(hour: _selectedDateTime.hour, minute: _selectedDateTime.minute));
                  },
                  child: Text('Done', style: AppFonts.medium(20, AppColors.backgroundPurple)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

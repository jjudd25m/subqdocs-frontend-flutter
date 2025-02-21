import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCalender extends StatelessWidget {
  CustomCalender({super.key});
  final _scrollController = ScrollController();

  final _dateC = TextEditingController();
  final _timeC = TextEditingController();

  ///Date
  DateTime selected = DateTime.now();
  DateTime initial = DateTime(2000);
  DateTime last = DateTime(2025);

  TimeOfDay timeOfDay = TimeOfDay.now();

  Future displayTimePicker(BuildContext context) async {
    var time = await showTimePicker(
      context: context,
      initialTime: timeOfDay,
    );

    print("log 11  ${time} ");

    if (time != null) {
      CustomCalender();

      _timeC.text = "${time.hour}:${time.minute}";
    }
  }

  List<DateTime?> _singleDatePickerValueWithDefaultValue = [];

  List<DateTime?> _rangeDatePickerValueWithDefaultValue = [
    DateTime(1999, 5, 6),
    DateTime(1999, 5, 21),
  ];

  @override
  Widget build(BuildContext context) {
    _buildCalendarDialogButton() {
      const dayTextStyle = TextStyle(color: Colors.black, fontWeight: FontWeight.w700);
      final weekendTextStyle = TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w600);

      final config = CalendarDatePicker2WithActionButtonsConfig(
        daySplashColor: Colors.transparent,
        calendarViewScrollPhysics: const NeverScrollableScrollPhysics(),
        calendarType: CalendarDatePicker2Type.single,
        selectedDayHighlightColor: Color.fromRGBO(116, 103, 183, 1),
        closeDialogOnCancelTapped: true,
        allowSameValueSelection: true,
        firstDayOfWeek: 0,
        disableMonthPicker: true,
        scrollViewTopHeaderTextStyle: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
        weekdayLabelTextStyle: const TextStyle(
          color: Colors.black87,
        ),
        controlsTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
        centerAlignModePicker: true,
        customModePickerIcon: const SizedBox(),
        selectedDayTextStyle: dayTextStyle.copyWith(color: Colors.white),
        dayTextStylePredicate: ({required date}) {
          TextStyle? textStyle;
          if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
            textStyle = weekendTextStyle;
          }
          if (DateUtils.isSameDay(date, DateTime(2021, 1, 25))) {}
          return textStyle;
        },
        dayBuilder: ({
          required date,
          textStyle,
          decoration,
          isSelected,
          isDisabled,
          isToday,
        }) {
          Widget? dayWidget;
          if (date.day % 3 == 0 && date.day % 9 != 0) {
            dayWidget = Container(
              decoration: decoration,
              child: Center(
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Text(
                      MaterialLocalizations.of(context).formatDecimal(date.day),
                      style: textStyle,
                    ),
                  ],
                ),
              ),
            );
          }
          return dayWidget;
        },
        yearBuilder: ({
          required year,
          decoration,
          isCurrentYear,
          isDisabled,
          isSelected,
          textStyle,
        }) {},
      );
      return SizedBox(
        width: 375,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final values = await showCalendarDatePicker2Dialog(
                    context: context,
                    config: config,
                    dialogSize: Size(350, 370),
                    borderRadius: BorderRadius.circular(15),
                    value: _rangeDatePickerValueWithDefaultValue,
                    dialogBackgroundColor: Colors.white,
                  );
                  //
                  // print("log11 ${values}");
                  if (values != null) {
                    displayTimePicker(context);

                    print("log11 ${values}");

                    // ignore: avoid_print
                    print(_getValueText(
                      config.calendarType,
                      values,
                    ));
                  }
                },
                child: const Text('Open Calendar Dialog'),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            children: <Widget>[
              _buildCalendarDialogButton(),
            ],
          ),
          Wrap(
            alignment: WrapAlignment.center,
            children: <Widget>[],
          ),
        ],
      ),
    );
  }

  String _getValueText(
    CalendarDatePicker2Type datePickerType,
    List<DateTime?> values,
  ) {
    values = values.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();
    var valueText = (values.isNotEmpty ? values[0] : null).toString().replaceAll('00:00:00.000', '');

    if (datePickerType == CalendarDatePicker2Type.multi) {
      valueText =
          values.isNotEmpty ? values.map((v) => v.toString().replaceAll('00:00:00.000', '')).join(', ') : 'null';
    } else if (datePickerType == CalendarDatePicker2Type.range) {
      if (values.isNotEmpty) {
        final startDate = values[0].toString().replaceAll('00:00:00.000', '');
        final endDate = values.length > 1 ? values[1].toString().replaceAll('00:00:00.000', '') : 'null';
        valueText = '$startDate to $endDate';
      } else {
        return 'null';
      }
    }

    return valueText;
  }
}

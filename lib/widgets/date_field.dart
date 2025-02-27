import 'package:flutter/material.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/widgets/custom_textfiled.dart';

import 'formater.dart';

/// [type1] => 02/11/22
/// [type2] => 02/11/2022
/// [type3] => 02-11-22
/// [type4] => 02-11-2022

enum DateFormatType {
  // type1, // 12/02/22
  type2, // 12/02/2022
  // type3, // 12-02-22
  // type4, // 12-02-2022
}

class DateFormatField extends StatefulWidget {
  const DateFormatField({
    super.key,
    this.checkValidation,
    required this.onComplete,
    required this.type,
    this.addCalendar = true,
    this.decoration,
    this.controller,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.focusNode,
  });

  final String? Function(String?)? checkValidation;

  /// [InputDecoration] a styling class for form field
  ///
  /// This is the default flutter Input decoration used to style input fields
  final InputDecoration? decoration;

  /// [DateFormatType] is an enum for specifying the type
  final DateFormatType type;

  /// [onSubmit] returns a nullable Datetime object
  ///
  /// Returns null when the datetime field is not complete
  /// Returns a datetime object when the field has been completed
  final Function(DateTime?) onComplete;

  /// [addCalendar] sets a button that allows the selection of date from a
  /// calendar pop up
  final bool addCalendar;

  /// [initialDate] set init day before show datetime picker
  final DateTime? initialDate;

  /// [lastDate] set last date show in datetime picker
  final DateTime? lastDate;

  /// [firstDate] set first date show in date time picker
  /// the default value is 1000-0-0
  final DateTime? firstDate;

  /// [focusNode] set focusNode for DateFormatField
  /// the default value is 3000-0-0
  final FocusNode? focusNode;

  /// TextEditingController for the date format field
  /// This is used to control the input text
  final TextEditingController? controller;
  @override
  State<DateFormatField> createState() => _DateFormatFieldState();
}

class _DateFormatFieldState extends State<DateFormatField> {
  late final TextEditingController _dobFormater;

  @override
  void initState() {
    _dobFormater = widget.controller ?? TextEditingController();
    super.initState();
  }

  InputDecoration? decoration() {
    if (!widget.addCalendar) return widget.decoration;

    if (widget.decoration == null) {
      return InputDecoration(
        suffixIcon: IconButton(
          onPressed: pickDate,
          icon: const Icon(Icons.calendar_month),
        ),
      );
    }

    return widget.decoration!.copyWith(
      suffixIcon: IconButton(
        onPressed: pickDate,
        icon: const Icon(Icons.calendar_month),
      ),
    );
  }

  void formatInput(String value) {
    /// formater for the text input field
    DateTime? completeDate;
    switch (widget.type) {
      case DateFormatType.type2:
        completeDate = Formater.type2(value, _dobFormater);
        break;
    }
    setState(() {
      // update the datetime
      widget.onComplete(completeDate);
    });
  }

  Future<void> pickDate() async {
    /// pick the date directly from the screen
    final picked = await showDatePicker(
      context: context,
      initialDate: widget.initialDate,
      firstDate: widget.firstDate ?? DateTime(1000),
      lastDate: widget.lastDate ?? DateTime(3000),
    );
    if (picked != null) {
      String inputText;
      switch (widget.type) {
        case DateFormatType.type2:
          inputText = '${padDayMonth(picked.month)}/${padDayMonth(picked.day)}/${picked.year}';
          break;
      }
      setState(() {
        _dobFormater.text = inputText;
      });
      widget.onComplete(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      controller: _dobFormater,
      onTap: () {
        _dobFormater.selection = TextSelection.fromPosition(
          TextPosition(offset: _dobFormater.text.length),
        );
      },
      focusNode: widget.focusNode,
      decoration: decoration(),
      validator: widget.checkValidation,
      keyboardType: TextInputType.datetime,
      onChanged: formatInput,
    );
  }

  String padDayMonth(int value) => value.toString().padLeft(2, '0');
}

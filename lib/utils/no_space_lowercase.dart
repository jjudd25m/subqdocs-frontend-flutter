import 'package:flutter/services.dart';

class NoSpaceLowercaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove spaces and convert to lowercase
    String newText = newValue.text.replaceAll(' ', '').toLowerCase();

    // Return the new text value
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

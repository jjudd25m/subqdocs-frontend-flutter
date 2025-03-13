import 'package:flutter/services.dart';

class NoSpaceTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove spaces from the input
    String newText = newValue.text.replaceAll(' ', '');

    // Return the new text value
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}


class PlusTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Ensure the text starts with +1, and allow additional characters after that
    if (newValue.text.startsWith('+1')) {
      return newValue;
    } else if (newValue.text.isEmpty || !newValue.text.startsWith('+1')) {
      return TextEditingValue(text: '+1', selection: TextSelection.collapsed(offset: 3));
    }
    return newValue;
  }
}
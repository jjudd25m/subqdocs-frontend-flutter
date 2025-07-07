import 'package:flutter/services.dart';

class NoNumbersTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Allow only letters and ignore numbers
    String newText = newValue.text.replaceAll(RegExp(r'[^a-zA-Z]'), '');

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

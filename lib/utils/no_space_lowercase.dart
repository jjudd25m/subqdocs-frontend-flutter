import 'package:flutter/services.dart';

class NoSpaceLowercaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove spaces and convert to lowercase
    String newText = newValue.text.replaceAll(' ', '').toLowerCase();

    // Calculate the new cursor position (keeping it as close as possible to the old position)
    int newCursorPosition = newValue.selection.baseOffset;

    // If the new cursor position exceeds the length of the new string, move it to the end
    if (newCursorPosition > newText.length) {
      newCursorPosition = newText.length;
    }

    // Return the new text value with the updated cursor position
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
  }
}

class CustomTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Filter the input to allow only letters (both lowercase and uppercase)
    String newText = newValue.text.replaceAll(RegExp(r'[^a-zA-Z]'), ''); // Allow only letters (A-Z, a-z)

    // Calculate the new cursor position (keeping it as close as possible to the old position)
    int newCursorPosition = newValue.selection.baseOffset;

    // If the new cursor position exceeds the length of the new string, move it to the end
    if (newCursorPosition > newText.length) {
      newCursorPosition = newText.length;
    }

    // Return the new text value with the updated cursor position
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
  }
}

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

class PostalCodeFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Define a regex pattern that allows only 5 digits
    final regex = RegExp(r'^[0-9]{0,5}$');

    // If the input matches the regex pattern (i.e., it is 5 digits or less), accept the input
    if (regex.hasMatch(newValue.text)) {
      return newValue;
    }

    // If the input doesn't match the regex pattern, return the old value (prevent any change)
    return oldValue;
  }
}

class MedicalLicenseNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Allow only alphanumeric characters (A-Z, a-z, 0-9) and restrict to a maximum of 9 characters.
    String filtered = newValue.text.replaceAll(RegExp('[^a-zA-Z0-9]'), '');

    if (filtered.length > 9) {
      filtered = filtered.substring(0, 9); // Limit to 9 characters.
    }

    return TextEditingValue(
      text: filtered,
      selection: TextSelection.collapsed(offset: filtered.length),
    );
  }
}

class NpiFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Allow only digits (0-9) and restrict to a maximum of 10 digits
    String filtered = newValue.text.replaceAll(RegExp('[^0-9]'), '');

    // Limit the length to 10 digits
    if (filtered.length > 10) {
      filtered = filtered.substring(0, 10);
    }

    return TextEditingValue(
      text: filtered,
      selection: TextSelection.collapsed(offset: filtered.length),
    );
  }
}

class TaxonomyCodeFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Allow only alphanumeric characters (0-9, A-Z, a-z)
    String filtered = newValue.text.replaceAll(RegExp('[^a-zA-Z0-9]'), '');

    // Limit the length to exactly 7 characters (if more, truncate)
    if (filtered.length > 7) {
      filtered = filtered.substring(0, 7);
    }

    return TextEditingValue(
      text: filtered,
      selection: TextSelection.collapsed(offset: filtered.length),
    );
  }
}

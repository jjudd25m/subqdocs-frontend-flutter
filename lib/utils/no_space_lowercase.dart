import 'package:flutter/services.dart';

class NoSpaceLowercaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
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
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Filter the input to allow only letters (both lowercase and uppercase)
    String newText = newValue.text.replaceAll(
      RegExp(r'[^a-zA-Z]'),
      '',
    ); // Allow only letters (A-Z, a-z)

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
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
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
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
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
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
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
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Allow only alphanumeric characters (0-9, A-Z, a-z)
    String filtered = newValue.text.replaceAll(RegExp('[^a-zA-Z0-9]'), '');

    // Limit the length to exactly 7 characters (if more, truncate)
    if (filtered.length > 10) {
      filtered = filtered.substring(0, 10);
    }

    return TextEditingValue(
      text: filtered,
      selection: TextSelection.collapsed(offset: filtered.length),
    );
  }
}

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove all non-digit characters
    String digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Limit to 8 digits (MMDDYYYY)
    if (digitsOnly.length > 8) {
      digitsOnly = digitsOnly.substring(0, 8);
    }

    final buffer = StringBuffer();
    int selectionIndex = digitsOnly.length;

    for (int i = 0; i < digitsOnly.length; i++) {
      buffer.write(digitsOnly[i]);
      if ((i == 1 || i == 3) && i != digitsOnly.length - 1) {
        buffer.write('/');
        selectionIndex++;
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

class TimeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    String newText = newValue.text;
    int selectionIndex = newValue.selection.end;

    // Extract digits and letters separately
    String raw = newText.replaceAll(RegExp(r'[^0-9aApPmM]'), '');
    String digitsOnly = raw.replaceAll(RegExp(r'[aApPmM]'), '');

    if (digitsOnly.length > 4) {
      digitsOnly = digitsOnly.substring(0, 4);
    }

    // Build time with colon
    final buffer = StringBuffer();
    int colonAddedAt = -1;

    for (int i = 0; i < digitsOnly.length; i++) {
      if (i == 2) {
        buffer.write(':');
        colonAddedAt = buffer.length - 1;
      }
      buffer.write(digitsOnly[i]);
    }

    String timeFormatted = buffer.toString();

    // Detect if user deleted the auto-inserted space after minutes
    bool userDeletedSpaceAfterMinutes = false;
    if (oldValue.text.endsWith(' ') && !newText.endsWith(' ')) {
      // Check if the difference between old and new is exactly the space after minutes
      String oldWithoutSpace = oldValue.text.substring(0, oldValue.text.length - 1);
      if (oldWithoutSpace == newText) {
        userDeletedSpaceAfterMinutes = true;
      }
    }

    // Auto-add space after minutes only if user didn't just delete it
    bool addedSpace = false;
    if (digitsOnly.length == 4 && !timeFormatted.endsWith(' ') && !userDeletedSpaceAfterMinutes) {
      timeFormatted += ' ';
      addedSpace = true;
    }

    // Adjust selection for colon insertion
    if (colonAddedAt != -1 && selectionIndex > colonAddedAt) {
      selectionIndex++;
    }

    // Adjust selection for space insertion
    if (addedSpace && selectionIndex >= timeFormatted.length - 1) {
      selectionIndex++;
    }

    // Handle AM/PM input
    String result = timeFormatted;
    String lastChar = '';
    if (newText.length > oldValue.text.length) {
      lastChar = newText.substring(newText.length - 1).toLowerCase();
    }

    if (digitsOnly.length == 4 && (lastChar == 'a' || lastChar == 'p')) {
      result += lastChar == 'a' ? 'AM' : 'PM';
      selectionIndex = result.length;
    } else {
      String meridiem = raw.replaceAll(RegExp(r'[^aApPmM]'), '').toUpperCase();
      if (meridiem.isNotEmpty && 'AM'.startsWith(meridiem)) {
        result += ' AM'.substring(0, meridiem.length + 1);
      } else if (meridiem.isNotEmpty && 'PM'.startsWith(meridiem)) {
        result += ' PM'.substring(0, meridiem.length + 1);
      } else if (meridiem.isNotEmpty &&
          meridiem != 'A' &&
          meridiem != 'P' &&
          meridiem != 'AM' &&
          meridiem != 'PM') {
        return oldValue;
      }
    }

    // Validate hours
    if (digitsOnly.length >= 2) {
      int hour = int.tryParse(digitsOnly.substring(0, 2)) ?? 0;
      if (hour < 1 || hour > 12) return oldValue;
    }

    // Validate minutes
    if (digitsOnly.length == 4) {
      int minute = int.tryParse(digitsOnly.substring(2)) ?? 0;
      if (minute > 59) return oldValue;
    }

    // Clamp cursor position
    if (selectionIndex > result.length) {
      selectionIndex = result.length;
    } else if (selectionIndex < 0) {
      selectionIndex = 0;
    }

    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

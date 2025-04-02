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
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Ensure the text starts with +1, and allow additional characters after that
    if (newValue.text.startsWith('+1')) {
      return newValue;
    } else if (newValue.text.isEmpty || !newValue.text.startsWith('+1')) {
      return TextEditingValue(text: '+1', selection: TextSelection.collapsed(offset: 3));
    }
    return newValue;
  }
}

class PhoneNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // If the new text is shorter (backspace/delete), we allow it to happen
    if (newValue.text.length < oldValue.text.length) {
      return newValue;
    }

    // Remove non-numeric characters (anything that's not a digit)
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Limit the input to 10 digits
    if (digitsOnly.length > 10) {
      return oldValue;
    }

    // Apply the phone number formatting
    String formattedText = _formatPhoneNumber(digitsOnly);

    // Return the newly formatted text
    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }

  // Method to format the phone number as (xxx) xxx-xxxx
  String _formatPhoneNumber(String digits) {
    // If there are no digits, don't show any formatting
    if (digits.isEmpty) return '';

    String result = '';
    if (digits.length > 0) {
      result += '(${digits.substring(0, digits.length > 3 ? 3 : digits.length)})';
    }
    if (digits.length > 3) {
      result += ' ${digits.substring(3, digits.length > 6 ? 6 : digits.length)}';
    }
    if (digits.length > 6) {
      result += '-${digits.substring(6, digits.length)}';
    }

    // After 1 digit is entered, prepend +1
    if (digits.length > 0) {
      result = '+1 ' + result;
    }

    return result;
  }
}

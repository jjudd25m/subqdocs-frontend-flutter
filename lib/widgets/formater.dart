import 'package:flutter/material.dart';

class Formater {
  static int _parseInt(String input) {
    return int.parse(input);
  }

  static DateTime _parseDateTimeShort(String input) {
    int month = int.parse(input.substring(0, 2));
    int day = int.parse(input.substring(3, 5));
    // int day = int.parse(input.substring(0, 2));
    // int month = int.parse(input.substring(3, 5));
    int year = int.parse(input.substring(6, 8));
    return DateTime(year + 2000, month, day);
  }

  static DateTime _parseDateTimeLong(String input) {
    int month = int.parse(input.substring(0, 2));
    int day = int.parse(input.substring(3, 5));
    // int day = int.parse(input.substring(0, 2));
    // int month = int.parse(input.substring(3, 5));
    int year = int.parse(input.substring(6, 10));
    return DateTime(year, month, day);
  }

  // static void _typeTemplate(String input, TextEditingController controller, String seperator, int lastIndex) {
  //   print("input length  is :- ${input.length}");
  //
  //   switch (input.length) {
  //     case 1:
  //       if (_parseInt(input) > 3) {
  //         controller.text = '0$input$seperator';
  //       }
  //       break;
  //     case 2:
  //       if (_parseInt(input) > 31) {
  //         controller.text = input[0];
  //       }
  //       break;
  //     case 3:
  //       if (input[2] != seperator) {
  //         controller.text = int.parse(input[2]) <= 1 ? '${input.substring(0, 2)}$seperator${input[2]}' : '${input.substring(0, 2)}${seperator}0${input[2]}$seperator';
  //       }
  //       break;
  //     case 4:
  //       break;
  //     case 5:
  //       if (_parseInt(input.substring(3, 5)) > 12) {
  //         controller.text = input.substring(0, 4);
  //         break;
  //       }
  //       break;
  //     case 6:
  //       if (input[5] != seperator) {
  //         controller.text = '${input.substring(0, 5)}$seperator${input[5]}';
  //       }
  //       break;
  //     default:
  //       if (input.length == lastIndex) {
  //         controller.text = input.substring(0, lastIndex - 1);
  //       }
  //   }
  //   // move to the end of textfield
  //   controller.selection = TextSelection.fromPosition(
  //     TextPosition(offset: controller.text.length),
  //   );
  // }

  static void _typeTemplate(String input, TextEditingController controller, String separator, int lastIndex) {
    print("input length is :- ${input.length}");

    switch (input.length) {
      case 1:
        if (_parseInt(input) > 1) {
          // Month cannot exceed 12
          controller.text = '0$input$separator';
        }
        break;
      case 2:
        if (_parseInt(input) > 12) {
          // If more than 12, revert to just the first digit
          controller.text = input[0];
        }
        break;
      case 3:
        if (input[2] != separator) {
          controller.text = '${input.substring(0, 2)}$separator${input[2]}';
        }
        break;
      case 4:
        if (_parseInt(input.substring(3, 4)) > 3) {
          controller.text = '${input.substring(0, 3)}0';
        }
        break;
      case 5:
        if (_parseInt(input.substring(3, 5)) > 31) {
          controller.text = input.substring(0, 4);
        }
        break;
      case 6:
        if (input[5] != separator) {
          controller.text = '${input.substring(0, 5)}$separator${input[5]}';
        }
        break;
      case 7:
      case 8:
      case 9:
        // No specific checks for these lengths, just allow input
        break;
      case 10:
        if (input.length > lastIndex) {
          controller.text = input.substring(0, lastIndex);
        }
        break;
      default:
        if (input.length > 10) {
          // Here we ensure that after 10 characters, no more are added
          controller.text = input.substring(0, 10);
        }
    }
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
  }

  static DateTime? type2(String input, TextEditingController controller) {
    int maxLength = 11;
    _typeTemplate(input, controller, '/', maxLength);
    if (input.length >= maxLength - 1) {
      return _parseDateTimeLong(input);
    }
    return null;
  }
}

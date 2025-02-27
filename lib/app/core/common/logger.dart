import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

void customPrint(dynamic message) {
  // final time = DateTime.now().toIso8601String();
  if (kDebugMode) {
    print(message);
  }
}

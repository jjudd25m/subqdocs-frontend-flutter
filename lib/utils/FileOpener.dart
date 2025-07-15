import 'package:open_file_plus/open_file_plus.dart';
import 'package:toastification/toastification.dart';

import '../widgets/custom_toastification.dart';

class FileOpener {
  // A method to open any document given a local path
  static Future<void> openDocument(String filePath) async {
    // Attempt to open the document using open_file_plus
    final result = await OpenFile.open(filePath);

    // Check if the result is successful or not
    if (result.type != ResultType.done) {
      // Handle the error (no view available or unable to open)
      _showErrorDialog('No view available or unable to open this document.');
    }
  }

  // Method to show error message if no view is available
  static void _showErrorDialog(String message) {
    CustomToastification().showToast(message, type: ToastificationType.error);
  }
}

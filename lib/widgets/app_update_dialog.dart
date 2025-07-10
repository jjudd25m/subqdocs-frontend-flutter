import 'package:flutter/cupertino.dart';
import 'package:store_redirect/store_redirect.dart';

void showIOSForceUpdateDialog(BuildContext context, String updateText) {
  showCupertinoDialog(
    context: context,
    barrierDismissible: false, // Prevent closing by tapping outside
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: const Text("Update Required"),
        content: Text(updateText.trim().isNotEmpty ? updateText : "A new version of the app is available. Please update to continue using the app."),
        actions: <Widget>[
          // Only one button (forces user to update)
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              StoreRedirect.redirect(androidAppId: "", iOSAppId: "6744890639");

              // Open App Store link
              // Example: launchUrl(Uri.parse("https://apps.apple.com/app/idYOUR_APP_ID"));
            },
            child: const Text("Update Now"),
          ),
        ],
      );
    },
  );
}

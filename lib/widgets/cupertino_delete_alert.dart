import 'package:flutter/cupertino.dart';

class CupertinoDeleteAlert extends StatelessWidget {
  final String title;
  final String description;
  final String cancelButtonText;
  final String deleteButtonText;
  final VoidCallback onDeletePressed;
  final VoidCallback? onCancelPressed;

  const CupertinoDeleteAlert({super.key, required this.title, required this.description, this.cancelButtonText = 'Cancel', this.deleteButtonText = 'Delete', required this.onDeletePressed, this.onCancelPressed});

  void _showAlert(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder:
          (BuildContext context) => CupertinoAlertDialog(
            title: Text(title),
            content: Text(description),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () {
                  Navigator.pop(context);
                  onCancelPressed?.call();
                },
                child: Text(cancelButtonText),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.pop(context);
                  onDeletePressed();
                },
                child: Text(deleteButtonText),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink(); // This widget doesn't display anything itself
  }

  // Helper method to show the alert directly
  static void show({required BuildContext context, required String title, required String description, String cancelButtonText = 'Cancel', String deleteButtonText = 'Delete', VoidCallback? onCancelPressed, required VoidCallback onDeletePressed}) {
    showCupertinoModalPopup<void>(
      context: context,
      builder:
          (BuildContext context) => CupertinoAlertDialog(
            title: Text(title),
            content: Text(description),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () {
                  Navigator.pop(context);
                  onCancelPressed?.call();
                },
                child: Text(cancelButtonText),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.pop(context);
                  onDeletePressed();
                },
                child: Text(deleteButtonText),
              ),
            ],
          ),
    );
  }
}

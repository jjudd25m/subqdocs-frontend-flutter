import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';
import 'custom_button.dart';

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

class DeleteConfirmationDialog extends StatelessWidget {
  final String title;
  final String description;
  final String cancelButtonText;
  final String deleteButtonText;
  final VoidCallback onDeletePressed;
  final VoidCallback? onCancelPressed;

  const DeleteConfirmationDialog({super.key, required this.title, required this.description, this.cancelButtonText = 'Cancel', this.deleteButtonText = 'Delete', required this.onDeletePressed, this.onCancelPressed});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 16,
      child: Container(
        constraints: BoxConstraints(maxWidth: Get.width * 0.45),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with purple background
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(color: AppColors.backgroundPurple, borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Row(
                  children: [
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), child: Text(title, style: AppFonts.medium(14, Colors.white))),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        onCancelPressed?.call();
                      },
                      child: Container(padding: const EdgeInsets.all(15), color: AppColors.clear, child: SvgPicture.asset("assets/images/cross_white.svg", width: 15)),
                    ),
                  ],
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(description, style: AppFonts.regular(14, AppColors.textBlack), textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 100,
                        child: CustomButton(
                          navigate: () {
                            Navigator.pop(context);
                            onCancelPressed?.call();
                          },
                          label: cancelButtonText,
                          backGround: Colors.white,
                          isTrue: false,
                          textColor: AppColors.backgroundPurple,
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 100,
                        child: CustomButton(
                          navigate: () {
                            Navigator.pop(context);
                            onDeletePressed();
                          },
                          label: deleteButtonText,
                          backGround: AppColors.redText,
                          textColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

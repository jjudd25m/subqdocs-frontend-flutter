import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:subqdocs/utils/app_fonts.dart';
import 'package:subqdocs/widgets/ContainerButton.dart';

import '../utils/app_colors.dart';

// class PermissionAlert extends StatelessWidget {
//   final bool? isMicPermission;
//   final String permissionTitle;
//   final String permissionDescription;
//   const PermissionAlert(
//       {super.key, this.isMicPermission = true, required this.permissionDescription, required this.permissionTitle});
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.white,
//       child: SizedBox(
//         width: 400,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     width: 50,
//                     height: 50,
//                     decoration: BoxDecoration(
//                         color: AppColors.backgroundPurple.withAlpha(50), borderRadius: BorderRadius.circular(25)),
//                     child: const Icon(
//                       Icons.mic_off_rounded,
//                     ),
//                   ),
//                   SizedBox(width: 16),
//                   Expanded(
//                     child: Text(
//                       permissionTitle,
//                       style: AppFonts.regular(16, AppColors.black),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20),
//               Padding(
//                 padding: const EdgeInsets.only(left: 16, right: 16),
//                 child: Text(
//                   permissionDescription,
//                   style: AppFonts.regular(14, AppColors.black),
//                 ),
//               ),
//               SizedBox(height: 32),
//               Row(
//                 children: [
//                   Expanded(
//                       child: ContainerButton(
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                           backgroundColor: AppColors.white,
//                           needBorder: true,
//                           textColor: AppColors.backgroundPurple,
//                           borderColor: AppColors.backgroundPurple,
//                           text: "Cancel")),
//                   SizedBox(
//                     width: 5,
//                   ),
//                   if (isMicPermission!)
//                     Expanded(
//                         child: ContainerButton(
//                             onPressed: () async {
//                               Navigator.pop(context);
//                               await openAppSettings();
//                             },
//                             backgroundColor: AppColors.backgroundPurple,
//                             text: "Setting")),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class PermissionAlert extends StatelessWidget {
  final bool? isMicPermission;
  final String permissionTitle;
  final String permissionDescription;

  final VoidCallback? onCancel; // Optional callback for cancel
  final VoidCallback? onOpenSetting; // Optional callback for cancel

  const PermissionAlert({super.key, this.isMicPermission = true, required this.permissionDescription, required this.permissionTitle, this.onCancel, this.onOpenSetting});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: SizedBox(
        width: 400,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(children: [Container(padding: const EdgeInsets.all(12), width: 50, height: 50, decoration: BoxDecoration(color: AppColors.backgroundPurple.withAlpha(50), borderRadius: BorderRadius.circular(25)), child: const Icon(Icons.mic_off_rounded)), const SizedBox(width: 16), Expanded(child: Text(permissionTitle, style: AppFonts.regular(16, AppColors.black)))]),
              const SizedBox(height: 20),
              Padding(padding: const EdgeInsets.only(left: 16, right: 16), child: Text(permissionDescription, style: AppFonts.regular(14, AppColors.black))),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: ContainerButton(
                      onPressed: () {
                        Navigator.pop(context);
                        if (onCancel != null) {
                          onCancel!(); // Execute callback if provided
                        }
                      },
                      backgroundColor: AppColors.white,
                      needBorder: true,
                      textColor: AppColors.backgroundPurple,
                      borderColor: AppColors.backgroundPurple,
                      text: "Cancel",
                    ),
                  ),
                  const SizedBox(width: 5),
                  if (isMicPermission!)
                    Expanded(
                      child: ContainerButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          onOpenSetting!();
                          await openAppSettings();
                        },
                        backgroundColor: AppColors.backgroundPurple,
                        text: "Setting",
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

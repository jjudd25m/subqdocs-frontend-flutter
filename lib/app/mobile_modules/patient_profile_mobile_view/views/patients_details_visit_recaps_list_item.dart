import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/utils/app_fonts.dart';

import '../../../modules/edit_patient_details/model/patient_detail_model.dart';
import '../../../routes/app_pages.dart';
import '../controllers/patient_profile_mobile_view_controller.dart';

class PatientDetailsVisitRecapsItem extends GetView<PatientProfileMobileViewController> {
  PastVisits? data;

  PatientDetailsVisitRecapsItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(controller.getDate(data?.visitDate), style: AppFonts.medium(14, AppColors.textDarkGrey)),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.PATIENT_INFO_MOBILE_VIEW, arguments: {"patientId": controller.patientId, "visitId": data?.id.toString()});
                  },
                  child: Padding(padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10), child: Text("View", style: AppFonts.medium(14, AppColors.textPurple))),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ExpandableText(
              text: data?.summary,
              maxLines: 3,
              key: ValueKey(data?.id),
              // isExpanded: data?.isExpanded ?? false,
              // onTap: () {
              //   // setState(() {
              //     data?.isExpanded = !data!.isExpanded!;
              //   // });
              // },
            ),
            // ExpandableText(data?.summary ?? "")
            // RichText(
            //   maxLines: isExpanded ? null : 3,
            //   overflow: isExpanded ? null : TextOverflow.ellipsis,
            //   text: TextSpan(
            //     children: [
            //       TextSpan(
            //         text: widget.text,
            //         style: AppFonts.regular(14, AppColors.textDarkGrey),
            //       ),
            //       if (needsExpandButton && !isExpanded)
            //         TextSpan(
            //           text: ' View More',
            //           style: AppFonts.regular(14, AppColors.textPurple),
            //           recognizer: TapGestureRecognizer()
            //             ..onTap = () => setState(() => isExpanded = true),
            //         ),
            //       if (needsExpandButton && isExpanded)
            //         TextSpan(
            //           text: ' View Less',
            //           style: AppFonts.regular(14, AppColors.textPurple),
            //           recognizer: TapGestureRecognizer()
            //             ..onTap = () => setState(() => isExpanded = false),
            //         ),
            //     ],
            //   ),
            // ),
            // Text(data?.summary ?? "", maxLines: 3, overflow: TextOverflow.ellipsis, style: AppFonts.regular(14, AppColors.textDarkGrey)),
          ],
        ),
      ),
    );
  }
}

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;

  const ExpandableText({super.key, required this.text, this.maxLines = 3});

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;
  bool _needsExpandButton = false;
  late TextPainter _textPainter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkTextOverflow();
    });
  }

  void _checkTextOverflow() {
    final textSpan = TextSpan(text: widget.text, style: AppFonts.regular(14, AppColors.textDarkGrey));

    _textPainter = TextPainter(text: textSpan, maxLines: widget.maxLines, textDirection: TextDirection.ltr);

    _textPainter.layout(maxWidth: context.size!.width);

    setState(() {
      _needsExpandButton = _textPainter.didExceedMaxLines;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _needsExpandButton ? () => setState(() => _isExpanded = !_isExpanded) : null,
      child: RichText(maxLines: _isExpanded ? null : widget.maxLines, overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis, text: TextSpan(children: [TextSpan(text: widget.text, style: AppFonts.regular(14, AppColors.textDarkGrey)), if (_needsExpandButton) TextSpan(text: _isExpanded ? ' View Less' : ' View More', style: AppFonts.regular(14, AppColors.textPurple))])),
    );
  }
}

// class ExpandableText extends StatelessWidget {
//   final String text;
//   final bool isExpanded;
//   final VoidCallback onTap;
//   final int maxCollapsedLines;
//
//   const ExpandableText({
//     super.key,
//     required this.text,
//     required this.isExpanded,
//     required this.onTap,
//     this.maxCollapsedLines = 3,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final span = TextSpan(
//           text: text,
//           style: AppFonts.regular(14, AppColors.textDarkGrey),
//         );
//
//         final textPainter = TextPainter(
//           text: span,
//           maxLines: maxCollapsedLines,
//           textDirection: TextDirection.ltr,
//         )..layout(maxWidth: constraints.maxWidth);
//
//         final needsExpandButton = textPainter.didExceedMaxLines;
//
//         return RichText(
//           maxLines: isExpanded ? null : maxCollapsedLines,
//           overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
//           text: TextSpan(
//             children: [
//               TextSpan(text: text),
//               if (needsExpandButton)
//                 TextSpan(
//                   text: isExpanded ? ' View Less' : ' View More',
//                   style: AppFonts.regular(14, AppColors.textPurple),
//                   recognizer: TapGestureRecognizer()..onTap = onTap,
//                 ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

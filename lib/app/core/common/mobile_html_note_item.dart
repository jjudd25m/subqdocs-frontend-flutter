import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/utils/app_fonts.dart';

class MobileHtmlNoteItem extends StatelessWidget {
  const MobileHtmlNoteItem({super.key, required this.title, required this.data, this.titleFontSize = 14});

  final String title;
  final String data;
  final double titleFontSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppFonts.medium(titleFontSize, AppColors.textPurple)),
        Html(data: data.isEmpty ? "Note is Empty" : data, style: {"section": Style(fontSize: FontSize(16)), "body": Style(padding: HtmlPaddings.all(0))}),
      ],
    );
  }
}

class FullNoteCommonContainer extends StatelessWidget {
  final String title;
  final Widget child;

  const FullNoteCommonContainer({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      // padding: const EdgeInsets.symmetric(horizontal: 0),
      // decoration: BoxDecoration(borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6), bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)), color: AppColors.white, border: Border.all(color: AppColors.backgroundPurple.withAlpha(50), width: 1)),
      child: Column(
        children: [
          Container(
            height: 35,
            // decoration: BoxDecoration(borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)), color: AppColors.backgroundPurple.withAlpha(50), border: Border.all(color: AppColors.backgroundPurple.withAlpha(50), width: 0.01)),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                const SizedBox(height: 0),
                Row(children: [Text(title, textAlign: TextAlign.center, style: AppFonts.medium(16, AppColors.textPurple)), const Spacer()]),
              ],
            ),
          ),
          child,
          // const SizedBox(height: 3),
        ],
      ),
    );
  }
}

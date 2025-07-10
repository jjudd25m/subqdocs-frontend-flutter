import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';

class ContainerDropdownViewPopUpFiled extends StatefulWidget {
  final String name;
  final void Function(bool) receiveParam;
  String? label;

  bool isValid;

  ContainerDropdownViewPopUpFiled({super.key, required this.name, this.isValid = false, this.label, required this.receiveParam});

  @override
  State<ContainerDropdownViewPopUpFiled> createState() => _ContainerDropdownViewState();
}

class _ContainerDropdownViewState extends State<ContainerDropdownViewPopUpFiled> {
  bool isExpand = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.label != "" ? Row(children: [Text("${widget.label}", style: AppFonts.regular(14, AppColors.textBlack)), const SizedBox(width: 5), widget.isValid ? Text("*", style: AppFonts.regular(16, Colors.red)) : const SizedBox()]) : const SizedBox(width: 0),
        widget.label != "" ? const SizedBox(height: 8) : const SizedBox(height: 0),
        GestureDetector(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            height: 50,
            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(6), border: Border.all(width: 1, color: AppColors.textfieldBorder)),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [Expanded(child: Padding(padding: const EdgeInsets.only(left: 0), child: Text(widget.name, textAlign: TextAlign.start))), const SizedBox(width: 5), isExpand ? const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textDarkGrey) : const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textDarkGrey)]),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/utils/app_fonts.dart';

class TextFormFiledWidget extends StatefulWidget {
  final String? label;
  final IconData? suffix;
  final bool visibility;
  final controller;
  final TextInputType? type;
  final List<TextInputFormatter> format;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final void Function()? onTap;
  final void Function(String?)? onChanged;
  final bool isValid;
  bool isSuffixIconVisible;
  AutovalidateMode autovalidateMode;

  bool isFirst;
  String? helperText;

  final String? hint;
  final String? Function(String?)? checkValidation;
  final Widget? iconButton;
  final int? maxLines;
  final int? maxLength;
  final Color fillColor;
  bool readOnly;

  // final Widget? suffix;

  TextFormFiledWidget({
    super.key,
    required this.label,
    this.suffix,
    this.isFirst = false,
    this.checkValidation,
    this.isValid = false,
    this.iconButton,
    this.isSuffixIconVisible = true,
    this.visibility = false,
    this.helperText = "",
    this.controller,
    this.readOnly = false,
    this.hint = "",
    this.format = const [],
    this.autovalidateMode = AutovalidateMode.disabled,

    this.type = TextInputType.text,
    this.onTap,
    this.suffixIcon,
    this.maxLines = 1,
    this.onChanged,
    this.maxLength = null,
    this.fillColor = Colors.white,
    this.prefixIcon,
  });

  @override
  State<TextFormFiledWidget> createState() => _TextFormFiledWidgetState();
}

class _TextFormFiledWidgetState extends State<TextFormFiledWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.label != "" ? Row(children: [Text("${widget.label}", style: AppFonts.regular(14, AppColors.textBlack)), const SizedBox(width: 5), widget.isValid ? Text("*", style: AppFonts.regular(14, Colors.red)) : const SizedBox()]) : const SizedBox(width: 0),
        widget.label != "" ? const SizedBox(height: 8) : const SizedBox(height: 0),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Container(
                child: Column(
                  children: [
                    TextFormField(
                      maxLength: widget.maxLength,
                      maxLines: widget.maxLines,
                      readOnly: widget.readOnly,
                      onChanged: (value) {
                        if (widget.onChanged != null) {
                          widget.onChanged!(value);
                        }
                        if (widget.isFirst == true) {
                          value.isEmpty ? widget.isSuffixIconVisible = false : widget.isSuffixIconVisible = true;

                          if (value.isEmpty || value.length == 1) {
                            setState(() {});
                          }
                        }
                      },
                      inputFormatters: widget.format,
                      keyboardType: widget.type,
                      cursorColor: AppColors.backgroundPurple,
                      controller: widget.controller,
                      textAlign: TextAlign.start,
                      obscureText: widget.visibility,
                      autovalidateMode: widget.autovalidateMode,
                      decoration: InputDecoration(
                        suffixIcon:
                            widget.isSuffixIconVisible
                                ? InkWell(
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    widget.onTap?.call();

                                    if (widget.isFirst == true) {
                                      widget.isSuffixIconVisible = false;
                                    }
                                    setState(() {});
                                  },
                                  child: Padding(padding: const EdgeInsets.all(10), child: widget.suffixIcon),
                                )
                                : null,
                        prefixIcon: widget.prefixIcon != null ? InkWell(splashColor: Colors.transparent, onTap: widget.onTap, child: Padding(padding: const EdgeInsets.only(top: 10, left: 10, right: 0, bottom: 10), child: widget.prefixIcon)) : null,
                        fillColor: widget.fillColor,
                        filled: true,
                        hintText: "${widget.hint}",

                        errorStyle: AppFonts.regular(14, AppColors.redText),
                        // Controls the height of the error text
                        errorMaxLines: 1,

                        // To reserve error space when no error,
                        // you can add a transparent helperText of the same height:
                        helperText: widget.helperText,
                        helperStyle: AppFonts.regular(14, AppColors.redText),
                        helperMaxLines: 2,

                        hintStyle: AppFonts.regular(14, AppColors.textDarkGrey),
                        contentPadding: const EdgeInsets.only(left: 10, top: 4, bottom: 4, right: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(width: 0, color: Colors.red)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(width: 0, color: AppColors.textDarkGrey)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(width: 1, color: AppColors.textDarkGrey)),
                      ),
                      validator: widget.checkValidation,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

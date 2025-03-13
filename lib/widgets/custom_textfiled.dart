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
  final bool isValid;
  bool isSuffixIconVisible;

  bool isFirst ;


  final String? hint;
  final String? Function(String?)? checkValidation;
  final Widget? iconButton;

  bool readOnly;

  // final Widget? suffix;

  TextFormFiledWidget(
      {required this.label,
      this.suffix,
        this.isFirst = false,
      this.checkValidation,
      this.isValid = false,
      this.iconButton,
      this.isSuffixIconVisible = true,
      this.visibility = false,
      this.controller,
      this.readOnly = false,
      this.hint = "",
      this.format = const [],
      this.type = TextInputType.text,
      this.onTap,
      this.suffixIcon,
      this.prefixIcon});

  @override
  State<TextFormFiledWidget> createState() => _TextFormFiledWidgetState();
}

class _TextFormFiledWidgetState extends State<TextFormFiledWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.label != ""
            ? Row(
                children: [
                  Text(
                    "${widget.label}",
                    style: AppFonts.regular(14, AppColors.textBlack),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  widget.isValid
                      ? Text(
                          "*",
                          style: AppFonts.regular(16, Colors.red),
                        )
                      : SizedBox()
                ],
              )
            : SizedBox(
                width: 0,
              ),
        widget.label != ""
            ? SizedBox(
                height: 8,
              )
            : SizedBox(
                height: 0,
              ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Container(
                child: TextFormField(
                  readOnly: widget.readOnly,
                  onChanged: (value) {

                    if(widget.isFirst == true) {
                      value.isEmpty
                          ? widget.isSuffixIconVisible = false
                          : widget.isSuffixIconVisible = true;

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
                  decoration: InputDecoration(
                    suffixIcon: widget.isSuffixIconVisible
                        ? InkWell(
                            splashColor: Colors.transparent,
                            onTap: widget.onTap,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: widget.suffixIcon,
                            ),
                          )
                        : null,
                    prefixIcon: widget.prefixIcon != null
                        ? InkWell(
                            splashColor: Colors.transparent,
                            onTap: widget.onTap,
                            child: Padding(
                              padding: EdgeInsets.only(top: 10, left: 10, right: 0, bottom: 10),
                              child: widget.prefixIcon,
                            ),
                          )
                        : null,
                    fillColor: Colors.white,
                    filled: true,
                    hintText: "${widget.hint}",
                    hintStyle: AppFonts.regular(14, AppColors.textDarkGrey),
                    contentPadding: EdgeInsets.only(left: 10, top: 4, bottom: 4, right: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(
                        width: 0,
                        color: Colors.red,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                        width: 0,
                        color: AppColors.textDarkGrey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                        width: 1,
                        color: AppColors.textDarkGrey,
                      ),
                    ),
                  ),
                  validator: widget.checkValidation,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

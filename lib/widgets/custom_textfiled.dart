import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/utils/app_fonts.dart';

class TextFormFiledWidget extends StatelessWidget {
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

  final String? hint;
  final String? Function(String?)? checkValidation;
  final Widget? iconButton;
  void Function(String)? onChanged;
  bool readOnly;

  // final Widget? suffix;

  TextFormFiledWidget(
      {required this.label,
      this.suffix,
      this.checkValidation,
      this.isValid = false,
      this.iconButton,
      this.visibility = false,
      this.controller,
      this.readOnly = false,
      this.onChanged,
      this.hint = "",
      this.format = const [],
      this.type = TextInputType.text,
      this.onTap,
      this.suffixIcon,
      this.prefixIcon});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label != ""
            ? Row(
                children: [
                  Text(
                    "$label",
                    style: AppFonts.regular(14, AppColors.textBlack),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  isValid
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
        label != ""
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
                  readOnly: readOnly,
                  onChanged: onChanged,
                  inputFormatters: format,
                  keyboardType: type,
                  cursorColor: AppColors.backgroundPurple,
                  controller: controller,
                  textAlign: TextAlign.start,
                  obscureText: visibility,
                  decoration: InputDecoration(
                    suffixIcon: InkWell(
                      splashColor: Colors.transparent,
                      onTap: onTap,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: suffixIcon,
                      ),
                    ),
                    prefixIcon: prefixIcon != null
                        ? InkWell(
                            splashColor: Colors.transparent,
                            onTap: onTap,
                            child: Padding(
                              padding: EdgeInsets.only(top: 10, left: 10, right: 0, bottom: 10),
                              child: prefixIcon,
                            ),
                          )
                        : null,
                    fillColor: Colors.white,
                    filled: true,
                    hintText: "$hint",
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
                  validator: checkValidation,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

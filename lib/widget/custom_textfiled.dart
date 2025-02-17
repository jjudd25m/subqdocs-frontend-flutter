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

  final String? hint;
  final String? Function(String?)? checkValidation;
  final Widget? iconButton;

  // final Widget? suffix;

  TextFormFiledWidget(
      {required this.label,
      this.suffix,
      this.checkValidation,
      this.iconButton,
      this.visibility = false,
      this.controller,
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
            ? Text(
                "$label",
                style: AppFonts.regular(14, AppColors.textBlack),
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
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFCCCAC6).withOpacity(0.9),
                      offset: const Offset(-2, -2),
                      blurRadius: 0.1,
                      spreadRadius: 0.2,
                    ),
                    BoxShadow(
                        color: Color(0xFFCCCAC6).withOpacity(0.2),
                        offset: const Offset(2, 2),
                        blurRadius: 0.2,
                        // spreadRadius: 0.2,
                        blurStyle: BlurStyle.inner),
                  ],
                ),
                child: TextFormField(
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
                        padding: EdgeInsets.all(7),
                        child: suffixIcon,
                      ),
                    ),
                    prefixIcon: prefixIcon != null
                        ? InkWell(
                            splashColor: Colors.transparent,
                            onTap: onTap,
                            child: Padding(
                              padding: EdgeInsets.all(7),
                              child: prefixIcon,
                            ),
                          )
                        : null,
                    fillColor: Colors.white,
                    filled: true,
                    hintText: "$hint",
                    hintStyle: AppFonts.regular(14, AppColors.textDarkGrey),
                    contentPadding: EdgeInsets.only(left: 10, top: 7, bottom: 7, right: 10),
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
                        color: Colors.transparent,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                        width: 1,
                        color: Colors.transparent,
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

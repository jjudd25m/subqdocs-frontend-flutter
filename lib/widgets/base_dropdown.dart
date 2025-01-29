import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:subqdocs/utils/app_diamentions.dart';
import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';

class BaseDropdown<T> extends StatelessWidget {
  final List<T?> items;
  final void Function(T?)? onChanged;
  final String Function(T?) valueAsString;
  final T? selectedValue;
  final String? textLabel;
  final bool isRequired;
  final BoxDecoration? decoration;
  final String? selectText;
  final double? fontSize;

  const BaseDropdown(
      {super.key, this.onChanged, this.selectText, this.decoration, required this.valueAsString, this.selectedValue, this.textLabel, this.isRequired = false, required this.items, this.fontSize = 14});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<T>(
        isExpanded: true,
        selectedItemBuilder: (context) {
          return items
              .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    valueAsString(item),
                    maxLines: 2,
                    style: AppFonts.regular(fontSize ?? 14, AppColors.textBlack),
                  )))
              .toList();
        },
        hint: Text(
          selectText ?? 'Select...',
          style: AppFonts.regular(14, AppColors.textDarkGrey),
        ),
        items: items
            .map((item) => DropdownMenuItem(
                value: item,
                child: Text(
                  valueAsString(item),
                  maxLines: 2,
                  style: AppFonts.regular(14, AppColors.textBlack),
                )))
            .toList(),
        value: selectedValue,
        style: AppFonts.medium(14, AppColors.textBlack),
        onChanged: onChanged,
        buttonStyleData: ButtonStyleData(
          height: 50,
          decoration: decoration ??
              BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.textfieldBorder, width: 2),
              ),
        ),
        iconStyleData: const IconStyleData(
            icon: Icon(
          Icons.keyboard_arrow_down_rounded,
        )),
        dropdownStyleData: DropdownStyleData(
            maxHeight: Dimen.margin200,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
            )),
        menuItemStyleData: MenuItemStyleData(
          height: Dimen.margin40,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          selectedMenuItemBuilder: (context, child) {
            return Container(
              color: AppColors.white,
              child: child,
            );
          },
        ),
      ),
    );
  }
}

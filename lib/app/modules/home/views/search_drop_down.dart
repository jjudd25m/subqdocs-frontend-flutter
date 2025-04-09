import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../../utils/app_colors.dart';

class SearchDropDown extends StatelessWidget {
  const SearchDropDown({super.key, required this.onSearchCallBack});

  final List<String?> Function(String) onSearchCallBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: CupertinoTypeAheadField(
        // controller: controller.searchDoctorController,
        builder: (context, controller, focusNode) => CupertinoTextField(
          selectionHeightStyle: BoxHeightStyle.tight,
          controller: controller,
          suffix: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.textDarkGrey,
            ),
          ),
          focusNode: focusNode,
          autofocus: true,
          padding: const EdgeInsets.all(12),
          placeholder: "Sea.",
          decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.appbarBorder, width: 2)),
        ),
        decorationBuilder: (context, child) => DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: CupertinoDynamicColor.resolve(
                CupertinoColors.systemGrey4,
                context,
              ),
              width: 1,
            ),
          ),
          child: child,
        ),
        offset: Offset(0, 7),
        // constraints: BoxConstraints(maxHeight: 500, minHeight: 30),
        hideOnError: true,
        emptyBuilder: (context) {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "No Options ",
              textAlign: TextAlign.center,
            ),
          );
        },
        itemSeparatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, item) => CupertinoListTile(title: Text(item ?? "", style: const TextStyle(fontSize: 14))),
        debounceDuration: const Duration(milliseconds: 500),
        onSelected: (value) {
          // controller.searchDoctorController.text = value;
          print(value);
          // return controller.selectedAddress.value = value;
        },
        suggestionsCallback: (search) async {
          List<String?> items = onSearchCallBack(search);
          return items;
        },
      ),
    );
  }
}

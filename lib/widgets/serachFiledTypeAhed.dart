import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:subqdocs/utils/app_fonts.dart';

import '../utils/app_colors.dart';

class Serachfiledtypeahed<T> extends StatefulWidget {
  final List<T?> items;
  final void Function(T?)? onChanged;
  final String Function(T?) valueAsString;
  final Widget Function(T)? itemBuilder;
  final T? selectedValue;
  final String? textLabel;
  final bool isRequired;
  final BoxDecoration? decoration;
  final String? selectText;
  final String? hintText;
  final double? fontSize;
  final bool isSearchable;

  final SuggestionsController<T>? suggestionsController;
  final FutureOr<List<T>?> Function(String) suggestionsCallback;
  final TextEditingController controller;
  final void Function(String?)? onChangedTextFiled;
  final ScrollController? scrollController;
  final VerticalDirection? direction;
  final Color fillColor;

  Serachfiledtypeahed({
    super.key,
    this.onChanged,
    this.selectText,
    this.hintText = "Select...",
    this.decoration,
    this.scrollController,
    this.suggestionsController,
    required this.valueAsString,
    this.onChangedTextFiled,
    required this.suggestionsCallback,
    this.itemBuilder,
    this.selectedValue,
    required this.controller,
    this.textLabel,
    this.direction,
    this.isRequired = false,
    required this.items,
    this.fontSize = 14,
    this.isSearchable = false,
    this.fillColor = Colors.white,
  });

  @override
  State<Serachfiledtypeahed<T>> createState() => _SerachfiledtypeahedState<T>();
}

class _SerachfiledtypeahedState<T> extends State<Serachfiledtypeahed<T>> {
  final FocusNode _focusNode = FocusNode();
  Timer? timer;

  @override
  void initState() {
    super.initState();

    if (widget.selectText?.isEmpty ?? false) {
      widget.controller.text = widget.selectText ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<T>(
      debounceDuration: const Duration(milliseconds: 500),
      controller: widget.controller,
      direction: widget.direction,
      suggestionsController: widget.suggestionsController,
      focusNode: _focusNode,
      itemBuilder: (context, value) {
        if (widget.itemBuilder != null) {
          return widget.itemBuilder!(value);
        }
        return Container(color: Colors.white, child: ListTile(title: Text(widget.valueAsString(value))));
      },
      suggestionsCallback: widget.suggestionsCallback,
      onSelected: (value) {
        widget.onChanged?.call(value);
      },
      constraints: const BoxConstraints(maxHeight: 200),
      loadingBuilder: (context) {
        return Container(color: AppColors.white, child: const Center(child: CircularProgressIndicator()));
      },
      emptyBuilder: (context) {
        if (widget.controller.text.isNotEmpty) {
          return Container(height: 100, color: Colors.white, child: const Padding(padding: EdgeInsets.all(8.0), child: Center(child: Text('No data found'))));
        } else {
          return const SizedBox();
        }
      },
      builder: (context, controller, focusNode) {
        return SizedBox(
          height: 36,
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            autofocus: false,
            readOnly: !widget.isSearchable,
            decoration: InputDecoration(
              fillColor: widget.fillColor,
              filled: true,
              prefixIcon: const Padding(padding: EdgeInsets.only(left: 10, top: 4, bottom: 4, right: 10), child: Icon(Icons.search, color: AppColors.textDarkGrey)),
              hintText: widget.valueAsString(widget.selectedValue).isEmpty ? "Select..." : widget.valueAsString(widget.selectedValue),
              hintStyle: widget.valueAsString(widget.selectedValue).isEmpty ? AppFonts.regular(14, AppColors.textDarkGrey) : AppFonts.regular(14, AppColors.textDarkGrey),
              contentPadding: const EdgeInsets.only(left: 10, top: 4, bottom: 4, right: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(width: 0, color: AppColors.textDarkGrey)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(width: 0, color: AppColors.textDarkGrey)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(width: 0, color: AppColors.textDarkGrey)),
            ),
          ),
        );
      },
    );
  }
}

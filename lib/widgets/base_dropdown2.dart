import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:subqdocs/utils/app_fonts.dart';

import '../utils/app_colors.dart';

class BaseDropdown2<T> extends StatefulWidget {
  final List<T?> items;
  final void Function(T?)? onChanged;
  final String Function(T?) valueAsString;
  final Widget Function(T)? itemBuilder;
  final T? selectedValue;
  final String? textLabel;
  final bool isRequired;
  final BoxDecoration? decoration;
  final InputDecoration? inputDecoration;
  final String? selectText;
  final double? fontSize;
  final double? height;
  final double? width;

  final bool isSearchable;

  final String? Function(String?)? checkValidation;

  final ScrollController? scrollController;
  final FocusNode? focusNode;
  final VerticalDirection? direction;
  final Color fillColor;

  TextEditingController controller = TextEditingController();

  BaseDropdown2({
    super.key,
    this.onChanged,
    this.height,
    this.width,
    this.inputDecoration,
    this.selectText,
    this.checkValidation,
    this.decoration,
    required this.valueAsString,
    this.itemBuilder,
    this.selectedValue,
    this.textLabel,
    this.isRequired = false,
    required this.items,
    this.fontSize = 14,
    this.isSearchable = false,
    this.scrollController,
    this.focusNode,
    this.direction,
    required this.controller,
    this.fillColor = Colors.white,
  });

  @override
  State<BaseDropdown2<T>> createState() => _BaseDropdown2State<T>();
}

class _BaseDropdown2State<T> extends State<BaseDropdown2<T>> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus) {
      widget.scrollController?.animateTo(widget.scrollController!.offset + 500, duration: const Duration(milliseconds: 100), curve: Curves.easeInOut);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<T>(
      focusNode: widget.focusNode,
      controller: widget.controller,
      direction: widget.direction,
      // focusNode: _focusNode,
      itemBuilder: (context, value) {
        if (widget.itemBuilder != null) {
          return widget.itemBuilder!(value);
        }
        return Container(color: Colors.white, child: ListTile(title: Text(widget.valueAsString(value))));
      },
      suggestionsCallback: (search) {
        List<T> ii = [];
        if (search.trim().isEmpty) {
          ii = List.from(widget.items);
          return ii;
        }
        ii = List<T>.from(widget.items).where((e) => widget.valueAsString(e).toLowerCase().contains(search.toLowerCase())).toList();
        return ii;
      },
      onSelected: (value) {
        widget.onChanged?.call(value);
      },
      constraints: const BoxConstraints(maxHeight: 200),
      emptyBuilder: (context) => Container(height: 100, color: Colors.white, child: const Padding(padding: EdgeInsets.all(8.0), child: Center(child: Text('No data found')))),
      builder: (context, controller, focusNode) {
        return SizedBox(
          height: widget.height,
          width: widget.width,

          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            autofocus: false,
            readOnly: !widget.isSearchable,

            validator: widget.checkValidation,
            decoration:
                widget.inputDecoration == null
                    ? InputDecoration(
                      suffixIcon: const Padding(padding: EdgeInsets.all(10), child: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textDarkGrey)),
                      fillColor: widget.fillColor,
                      filled: true,
                      errorStyle: TextStyle(height: 1),
                      // Controls the height of the error text
                      errorMaxLines: 1,

                      // To reserve error space when no error,
                      // you can add a transparent helperText of the same height:
                      helperText: ' ',
                      hintText: widget.valueAsString(widget.selectedValue).isEmpty ? "Select..." : widget.valueAsString(widget.selectedValue),
                      hintStyle: widget.valueAsString(widget.selectedValue).isEmpty ? AppFonts.regular(14, AppColors.textDarkGrey) : AppFonts.regular(14, AppColors.textBlack),
                      contentPadding: const EdgeInsets.only(left: 10, top: 4, bottom: 4, right: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(width: 0, color: AppColors.textDarkGrey)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(width: 0, color: AppColors.textDarkGrey)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(width: 0, color: AppColors.textDarkGrey)),
                    )
                    : widget.inputDecoration,
          ),
        );
      },
    );
  }
}

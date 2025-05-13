import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/imagepath.dart';

class HomeCustomSearchBar extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmit;
  final String hintText;
  final TextEditingController? controller;
  final BorderRadius? borderRadius;
  final Border? border;
  final Color? fillColor;
  final EdgeInsetsGeometry? padding;
  final TextStyle? hintStyle;
  final double? iconSize;
  final Color? iconColor;

  const HomeCustomSearchBar({
    Key? key,
    this.onChanged,
    this.onSubmit,
    this.hintText = 'Search',
    this.controller,
    this.borderRadius,
    this.border,
    this.fillColor,
    this.padding,
    this.hintStyle,
    this.iconSize = 20.0,
    this.iconColor,
  }) : super(key: key);

  @override
  _HomeCustomSearchBarState createState() => _HomeCustomSearchBarState();
}

class _HomeCustomSearchBarState extends State<HomeCustomSearchBar> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  final ValueNotifier<bool> _showClearButton = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.dispose();
    _showClearButton.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    _showClearButton.value = _controller.text.isNotEmpty;
    widget.onChanged?.call(_controller.text);
  }

  void _onClearPressed() {
    _controller.clear();
    widget.onChanged?.call('');
  }

  void _onSearchIconPressed() {
    FocusScope.of(context).requestFocus(_focusNode);
  }

  void _onSubmitted(String value) {
    widget.onSubmit?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultBorderRadius = widget.borderRadius ?? BorderRadius.circular(8.0);
    final defaultBorder = widget.border ?? Border.all(color: AppColors.textGrey.withValues(alpha: 0.5), width: 1.0);
    final fillColor = widget.fillColor ?? theme.cardColor;
    final iconColor = widget.iconColor ?? theme.iconTheme.color;
    final hintStyle = widget.hintStyle ?? theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor);

    return Container(
      // height: 40,
      decoration: BoxDecoration(color: Colors.white, borderRadius: defaultBorderRadius, border: defaultBorder),
      child: Row(
        children: [
          // Search icon button
          GestureDetector(onTap: () => _onSearchIconPressed, child: Padding(padding: const EdgeInsets.all(8.0), child: SvgPicture.asset(ImagePath.search, height: 25, width: 25))),

          // Text field
          Expanded(
            child: Padding(
              padding: widget.padding ?? const EdgeInsets.symmetric(vertical: 2),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                onSubmitted: _onSubmitted,
                decoration: InputDecoration(hintText: widget.hintText, hintStyle: hintStyle, border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
              ),
            ),
          ),

          // Clear button with ValueListenableBuilder for smooth appearance
          ValueListenableBuilder<bool>(
            valueListenable: _showClearButton,
            builder: (context, showClear, child) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child:
                    showClear
                        ? IconButton(key: const ValueKey('clear-button'), icon: Icon(Icons.clear, size: widget.iconSize), color: iconColor, onPressed: _onClearPressed)
                        : const SizedBox(width: 0), // Maintain consistent width
              );
            },
          ),
        ],
      ),
    );
  }
}

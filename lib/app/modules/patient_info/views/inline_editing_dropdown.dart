import 'dart:async';

import 'package:flutter/material.dart';

class InlineEditingDropdown extends StatefulWidget {
  String initialText;
  final Function(String) onSubmitted;
  final Function(String, bool) onChanged;
  final VoidCallback? toggle;
  final TextStyle? textStyle;

  final FocusNode focusNode;

  InlineEditingDropdown({required this.initialText, required this.onSubmitted, required this.onChanged, required this.focusNode, this.toggle, this.textStyle, Key? key}) : super(key: key);

  @override
  _InlineEditableTextState createState() => _InlineEditableTextState();
}

String cleanString(String input) {
  // Remove leading numbers, periods, and spaces
  String cleaned = input.replaceAll(RegExp(r'^\d+(\.\d+)*\s*'), '').trim();

  // Return the cleaned string
  return cleaned;
}

class _InlineEditableTextState extends State<InlineEditingDropdown> {
  late bool _isEditing;
  late TextEditingController _controller;

  Timer? timer;

  @override
  void initState() {
    super.initState();
    _isEditing = false;
    _controller = TextEditingController(text: widget.initialText);

    widget.focusNode?.addListener(() {
      if (!widget.focusNode!.hasFocus && _isEditing) {
        _submitEdit();
      }
    });
  }

  void didUpdateWidget(covariant InlineEditingDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.text = widget.initialText;
  }

  @override
  void dispose() {
    _controller.dispose();
    // widget.focusNode.dispose();
    super.dispose();
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
    });
    widget.toggle?.call();
    // Future.delayed(Duration(milliseconds: 100), () {
    //   FocusScope.of(context).requestFocus(widget.focusNode);
    // });
  }

  void _submitEdit() {
    setState(() {
      _isEditing = false;
    });
    widget.onSubmitted(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = widget.textStyle ?? TextStyle(fontSize: 18);

    return _isEditing
        ? SizedBox(
          width: textStyle.fontSize! * _controller.text.length * 0.6 + 20,
          child: TextField(
            onTap: () {
              widget.toggle;
            },

            onChanged: (value) {
              timer?.cancel();
              widget.onChanged(cleanString(value), false);

              timer = Timer(const Duration(seconds: 5), () {
                widget.onChanged(cleanString(value), true);
              });
            },
            controller: _controller,
            focusNode: widget.focusNode,
            autofocus: true,
            style: textStyle,
            minLines: 1,
            maxLines: 2,
            cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
            onSubmitted: (_) => _submitEdit(),
          ),
        )
        : GestureDetector(onTap: _startEditing, child: Text(_controller.text, style: textStyle));
  }
}

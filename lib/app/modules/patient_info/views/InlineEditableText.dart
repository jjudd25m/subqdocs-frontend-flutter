import 'package:flutter/material.dart';

class InlineEditableText extends StatefulWidget {
  final String initialText;
  final Function(String) onSubmitted;
  final Function(String) onChanged;
  final TextStyle? textStyle;
  final FocusNode? focusNode;

  const InlineEditableText({
    required this.initialText,
    required this.onSubmitted,
    required this.onChanged,
    this.textStyle,
    super.key,
    this.focusNode,
  });

  @override
  _InlineEditableTextState createState() => _InlineEditableTextState();
}

class _InlineEditableTextState extends State<InlineEditableText> {
  late bool _isEditing;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _isEditing = false;
    _controller = TextEditingController(text: widget.initialText);
    // _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
    });
    widget.onChanged("");
  }

  void _submitEdit() {
    setState(() {
      _isEditing = false;
    });
    widget.onSubmitted(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = widget.textStyle ?? const TextStyle(fontSize: 18);

    return _isEditing
        ? SizedBox(
          width: textStyle.fontSize! * _controller.text.length * 0.6 + 20,
          child: TextField(
            onTap: () {
              widget.onChanged("");
            },
            onChanged: (value) {
              widget.onChanged(value);
            },
            controller: _controller,

            autofocus: true,
            style: textStyle,
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
        : GestureDetector(
          onTap: _startEditing,
          child: Text(_controller.text, style: textStyle),
        );
  }
}

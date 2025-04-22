import 'package:flutter/material.dart';

class InlineEditableText extends StatefulWidget {
  final String initialText;
  final Function(String) onSubmitted;
  final Function(String) onChanged;
  final TextStyle? textStyle;

  const InlineEditableText({required this.initialText, required this.onSubmitted, required this.onChanged, this.textStyle, Key? key}) : super(key: key);

  @override
  _InlineEditableTextState createState() => _InlineEditableTextState();
}

class _InlineEditableTextState extends State<InlineEditableText> {
  late bool _isEditing;
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _isEditing = false;
    _controller = TextEditingController(text: widget.initialText);
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && _isEditing) {
        _submitEdit();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
    });
    Future.delayed(Duration(milliseconds: 100), () {
      FocusScope.of(context).requestFocus(_focusNode);
    });
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
            onChanged: (value) {
              widget.onChanged(value);
            },
            controller: _controller,
            focusNode: _focusNode,
            autofocus: true,
            style: textStyle,
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

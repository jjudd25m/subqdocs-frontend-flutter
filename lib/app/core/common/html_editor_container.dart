import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';

class HtmlEditorViewWidget extends StatefulWidget {
  final HtmlEditorController controller;
  final String? headerText;
  final bool isRequired;
  final String? initialText;

  const HtmlEditorViewWidget({super.key, required this.controller, this.headerText, this.isRequired = false, this.initialText});

  @override
  State<HtmlEditorViewWidget> createState() => _HtmlEditorViewWidgetState();
}

class _HtmlEditorViewWidgetState extends State<HtmlEditorViewWidget> {
  bool isEditing = false;
  late String renderedHtml;
  late WebViewController webViewController;

  @override
  void initState() {
    super.initState();
    renderedHtml = widget.initialText ?? "";

    webViewController =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadHtmlString(renderedHtml);
  }

  void toggleEditing() async {
    if (isEditing) {
      // Save the updated HTML when exiting edit mode
      String? updatedHtml = await widget.controller.getText();
      setState(() {
        renderedHtml = updatedHtml ?? renderedHtml;
        isEditing = false;
        webViewController.loadHtmlString(renderedHtml);
      });
    } else {
      setState(() {
        isEditing = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        if (widget.headerText?.isNotEmpty ?? false)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(widget.headerText ?? "", style: AppFonts.medium(18, AppColors.textPurple)), if (isEditing) TextButton(onPressed: toggleEditing, child: Text('View'))],
          ),
        const SizedBox(height: 10),
        if (isEditing)
          HtmlEditor(
            controller: widget.controller,
            callbacks: Callbacks(
              onInit: () {
                widget.controller.setFullScreen();
              },
            ),
            htmlEditorOptions: HtmlEditorOptions(shouldEnsureVisible: false, androidUseHybridComposition: false, initialText: renderedHtml, autoAdjustHeight: true, adjustHeightForKeyboard: false),
            htmlToolbarOptions: HtmlToolbarOptions(
              gridViewHorizontalSpacing: 0,
              gridViewVerticalSpacing: 0,
              customToolbarButtons: [],
              buttonFillColor: AppColors.borderTable.withOpacity(0.2),
              buttonColor: AppColors.textGrey,
              buttonSelectedColor: AppColors.black,
              buttonHighlightColor: AppColors.borderTable.withOpacity(0.2),
              separatorWidget: const VerticalDivider(color: AppColors.borderTable, width: 1, thickness: 6),
              dropdownBoxDecoration: BoxDecoration(color: AppColors.borderTable.withOpacity(0.2)),
              textStyle: const TextStyle(fontSize: 14, color: AppColors.black),
              defaultToolbarButtons: [
                const FontButtons(clearAll: false, strikethrough: true, superscript: false, subscript: false),
                // const ColorButtons(),
                const FontSettingButtons(fontSizeUnit: false, fontName: false),
                // const ParagraphButtons(alignCenter: true, alignJustify: false, alignLeft: true, alignRight: true, caseConverter: false, decreaseIndent: false, increaseIndent: false, lineHeight: false, textDirection: false),
                const ListButtons(listStyles: false),
                // const OtherButtons(fullscreen: false, codeview: true, undo: false, redo: false, help: false, copy: false, paste: false),
                // const InsertButtons(video: false, audio: false, table: false, hr: false, otherFile: false),
                const StyleButtons(),
              ],
              toolbarType: ToolbarType.nativeScrollable,
            ),
            otherOptions: OtherOptions(height: 800, decoration: const BoxDecoration(color: Colors.white)),
          )
        else
          // Html(data: widget.initialText, style: {}),
          GestureDetector(onTap: toggleEditing, child: Container(child: Padding(padding: const EdgeInsets.all(8.0), child: Html(data: widget.initialText, style: {})))),
      ],
    );
  }
}

import 'dart:async';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html;
import 'package:html/parser.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../utils/app_colors.dart';
import '../../modules/patient_info/model/impresion_and_plan_view_model.dart';

class HtmlEditorViewWidget extends StatefulWidget {
  ImpresionAndPlanViewModel impresionAndPlanViewModel;
  int? index;

  final Function(ImpresionAndPlanViewModel) toggleCallBack;
  final Function(ImpresionAndPlanViewModel, String? content) onUpdateCallBack;

  EdgeInsetsGeometry padding;
  bool isBorder;

  double heightOfTheEditableView;

  HtmlEditorViewWidget({
    super.key,
    required this.impresionAndPlanViewModel,
    required this.toggleCallBack,
    required this.onUpdateCallBack,
    this.index,
    this.isBorder = false,
    this.heightOfTheEditableView = 800,
    this.padding = const EdgeInsets.only(left: 10, right: 10, bottom: 10),
  });

  @override
  State<HtmlEditorViewWidget> createState() => _HtmlEditorViewWidgetState();
}

class _HtmlEditorViewWidgetState extends State<HtmlEditorViewWidget> {
  late String renderedHtml;
  late WebViewController webViewController;
  Timer? timer;

  void onChangeContent(String? content) {
    widget.impresionAndPlanViewModel.htmlContent = content;

    timer?.cancel();
    timer = Timer(const Duration(seconds: 5), () {
      widget.onUpdateCallBack(widget.impresionAndPlanViewModel, content);
    });
  }

  @override
  void initState() {
    renderedHtml = widget.impresionAndPlanViewModel.htmlContent ?? "";

    super.initState();
  }

  void toggleEditing() async {
    if (widget.impresionAndPlanViewModel.isEditing) {
      // Save the updated HTML when exiting edit mode
      String? updatedHtml =
          await widget.impresionAndPlanViewModel.htmlEditorController.getText();

      renderedHtml = updatedHtml ?? renderedHtml;
      widget.impresionAndPlanViewModel.isEditing = false;
      widget.toggleCallBack(widget.impresionAndPlanViewModel);
    } else {
      widget.impresionAndPlanViewModel.isEditing = true;
      widget.toggleCallBack(widget.impresionAndPlanViewModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 2),

        if (widget.impresionAndPlanViewModel.isEditing)
          Padding(
            padding: widget.padding,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: widget.isBorder ? 1 : 0,
                  color: AppColors.borderTable,
                ),
              ),
              child: HtmlEditor(
                controller:
                    widget.impresionAndPlanViewModel.htmlEditorController,

                callbacks: Callbacks(
                  onChangeContent: (content) {
                    onChangeContent(content);
                  },
                  onScroll: () {
                    print("demo  is the called ");
                  },
                  onInit: () {
                    widget.impresionAndPlanViewModel.htmlEditorController
                        .setFullScreen();
                  },
                ),
                htmlEditorOptions: HtmlEditorOptions(
                  autoAdjustHeight: true,
                  shouldEnsureVisible: false,
                  androidUseHybridComposition: false,
                  initialText: widget.impresionAndPlanViewModel.htmlContent,
                  adjustHeightForKeyboard: false,
                ),
                htmlToolbarOptions: HtmlToolbarOptions(
                  gridViewHorizontalSpacing: 0,
                  gridViewVerticalSpacing: 0,
                  toolbarPosition: ToolbarPosition.aboveEditor,
                  dropdownBackgroundColor: Colors.white,

                  customToolbarButtons: [
                    IconButton(
                      icon: Icon(Icons.copy),
                      onPressed: () => _copyToClipboard(context),
                    ),

                    IconButton(
                      icon: Icon(Icons.undo),
                      onPressed: () => _handelUndo(),
                    ),

                    IconButton(
                      icon: Icon(Icons.redo),
                      onPressed: () => _handelRedo(),
                    ),
                  ],
                  buttonFillColor: AppColors.borderTable.withOpacity(0.2),
                  buttonColor: AppColors.textGrey,

                  buttonSelectedColor: AppColors.black,
                  buttonHighlightColor: AppColors.borderTable.withOpacity(0.2),
                  separatorWidget: const VerticalDivider(
                    color: Colors.transparent,
                    width: 0,
                    thickness: 1,
                  ),
                  dropdownBoxDecoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                  ),

                  textStyle: const TextStyle(
                    fontSize: 14,
                    color: AppColors.black,
                  ),
                  defaultToolbarButtons: [
                    const FontSettingButtons(
                      fontSizeUnit: false,
                      fontName: false,

                      fontSize: false,
                    ),
                    const FontButtons(
                      clearAll: false,
                      strikethrough: true,

                      superscript: false,
                      subscript: false,
                    ),
                    // const ColorButtons(),

                    // const ParagraphButtons(alignCenter: true, alignJustify: false, alignLeft: true, alignRight: true, caseConverter: false, decreaseIndent: false, increaseIndent: false, lineHeight: false, textDirection: false),
                    OtherButtons(
                      undo: false,
                      redo: false,

                      paste: false,
                      codeview: false,
                      copy: false,
                      help: false,
                      fullscreen: false,
                    ),
                    const ListButtons(listStyles: false),
                    StyleButtons(),

                    // const OtherButtons(fullscreen: false, codeview: true, undo: false, redo: false, help: false, copy: false, paste: false),
                    // const InsertButtons(video: false, audio: false, table: false, hr: false, otherFile: false),
                  ],
                  customToolbarInsertionIndices: [1],
                  toolbarType: ToolbarType.nativeScrollable,
                ),

                otherOptions: OtherOptions(
                  height: widget.heightOfTheEditableView,
                  decoration: const BoxDecoration(color: Colors.white),
                ),
              ),
            ),
          )
        else
          GestureDetector(
            onTap: toggleEditing,
            child: Container(
              color: Colors.transparent,
              padding: widget.padding,
              child: Html(
                data:
                    (widget.impresionAndPlanViewModel.htmlContent ?? "").isEmpty
                        ? "Note is Empty"
                        : widget.impresionAndPlanViewModel.htmlContent,
                style: {"section": Style(fontSize: FontSize(14))},
              ),
            ),
          ),
      ],
    );
  }

  String _parseHtmlToFormattedText(String htmlString) {
    dom.Document document = html.parse(htmlString);

    // Comprehensive list of block-level elements
    final Set<String> blockElements = {
      'address', 'article', 'aside', 'blockquote', 'canvas', 'dd', 'div',
      'dl', 'dt', 'fieldset', 'figcaption', 'figure', 'footer', 'form', 'h1',
      'h2', 'h3', 'h4', 'h5', 'h6', 'header', 'hr', 'li', 'main', 'nav',
      'noscript', 'ol', 'p', 'pre', 'section', 'table', 'tfoot', 'ul', 'video',
      'br', 'tr', 'td', 'th', 'thead', 'tbody', 'caption', 'colgroup', 'col',
      'article', 'aside', 'details', 'dialog', 'summary', 'menu', 'menuitem',
      'output', 'progress', 'meter', 'legend', 'map', 'object', 'iframe',
      // Deprecated but still seen in legacy HTML
      'center', 'dir', 'isindex', 'listing', 'plaintext', 'xmp',
    };

    void extractText(dom.Node node, StringBuffer buffer) {
      if (node is dom.Text) {
        // Clean up and write text
        final text = node.text.replaceAll(RegExp(r'\s+'), ' ');
        buffer.write(text);
      } else if (node is dom.Element) {
        for (var child in node.nodes) {
          extractText(child, buffer);
          if (child is dom.Element && blockElements.contains(child.localName)) {
            buffer.write('\n');
          }
        }
      }
    }

    final buffer = StringBuffer();
    extractText(document.body ?? document.documentElement!, buffer);

    // Normalize multiple newlines and trim output
    return buffer.toString().replaceAll(RegExp(r'\n\s*\n+'), '\n\n').trim();
  }

  String extractPlainText(String html) {
    dom.Document document = parse(html);
    return document.body?.text ?? '';
  }

  void _copyToClipboard(BuildContext context) async {
    String plainText = _parseHtmlToFormattedText(
      await widget.impresionAndPlanViewModel.htmlEditorController.getText(),
    );

    await FlutterClipboard.copy(plainText);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Content copied to clipboard')));
  }

  void _handelUndo() {
    //for redo
    widget.impresionAndPlanViewModel.htmlEditorController.undo();
  }

  void _handelRedo() {
    widget.impresionAndPlanViewModel.htmlEditorController.redo();
  }
}

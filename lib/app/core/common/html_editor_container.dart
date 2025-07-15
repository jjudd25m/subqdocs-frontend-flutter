import 'dart:async';
import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html;
import 'package:html/parser.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../services/media_picker_services.dart';
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

  HtmlEditorViewWidget({super.key, required this.impresionAndPlanViewModel, required this.toggleCallBack, required this.onUpdateCallBack, this.index, this.isBorder = false, this.heightOfTheEditableView = 800, this.padding = const EdgeInsets.only(left: 10, right: 10, bottom: 10)});

  @override
  State<HtmlEditorViewWidget> createState() => _HtmlEditorViewWidgetState();
}

class _HtmlEditorViewWidgetState extends State<HtmlEditorViewWidget> {
  late WebViewController webViewController;

  String sectionString = """<style>@import url('https://fonts.googleapis.com/css2?family=Poppins&display=swap'); body { font-family: 'Poppins', sans-serif; }</style>
<section style='font-size:16px; font-family: Poppins, sans-serif; color:#757575;'><div>  Type here </div></section>""";
  Timer? timer;

  void onChangeContent(String? content) {
    widget.impresionAndPlanViewModel.htmlContent = ensureSectionHasContent(content ?? sectionString);
    widget.impresionAndPlanViewModel.initialHtmlContent = ensureSectionHasContent(content ?? sectionString);

    timer?.cancel();
    timer = Timer(const Duration(seconds: 5), () {
      widget.onUpdateCallBack(widget.impresionAndPlanViewModel, content);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  String ensureSectionHasContent(String html) {
    final sectionRegex = RegExp(r'<section\b[^>]*>([\s\S]*?)<\/section>', caseSensitive: false);
    final tagRegex = RegExp(r'<[^>]+>'); // Matches all HTML tags

    return html.replaceAllMapped(sectionRegex, (match) {
      final fullSection = match.group(0)!;
      final innerContent = match.group(1) ?? '';

      // Remove all HTML tags and trim whitespace
      final contentWithoutTags = innerContent.replaceAll(tagRegex, '').trim();

      // If there's no actual content, insert the default
      if (contentWithoutTags.isEmpty) {
        const newContent = "<div>Type here</div>";
        return fullSection.replaceFirst(innerContent, newContent);
      }

      return fullSection; // Leave unchanged if content exists
    });
  }

  void _showImageInsertDialog() {
    showDialog(
      context: context,
      builder: (context) {
        // For URL input inside the same dialog
        // final urlController = TextEditingController();

        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: StatefulBuilder(
            builder: (context, setState) {
              // bool showUrlInput = false;
              return Container(
                padding: const EdgeInsets.all(16),
                constraints: const BoxConstraints(maxWidth: 200),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Add Image", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),

                    GestureDetector(
                      onTap: () async {
                        final image = await MediaPickerServices().pickImage(fromCamera: true);
                        if (image != null) {
                          widget.impresionAndPlanViewModel.htmlEditorController.insertNetworkImage(File(image.path).uri.toString());
                        }
                        Navigator.pop(context);
                      },

                      child: const Row(children: [Icon(Icons.camera_alt_outlined), SizedBox(width: 10), Text("Take a Photo")]),
                    ),

                    const SizedBox(height: 10),

                    GestureDetector(
                      onTap: () async {
                        final image = await MediaPickerServices().pickImage(fromCamera: false);
                        if (image != null) {
                          widget.impresionAndPlanViewModel.htmlEditorController.insertNetworkImage(File(image.path).uri.toString());
                        }
                        Navigator.pop(context);
                      },

                      child: const Row(children: [Icon(Icons.photo_library_outlined), SizedBox(width: 10), Text("Pick from Gallery")]),
                    ),

                    const SizedBox(height: 10),

                    TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel", style: TextStyle(color: Colors.grey))),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void toggleEditing() async {
    if (widget.impresionAndPlanViewModel.isEditing) {
      // Save the updated HTML when exiting edit mode

      widget.impresionAndPlanViewModel.isEditing = false;

      widget.impresionAndPlanViewModel.toggleHtmlContent = widget.impresionAndPlanViewModel.htmlContent;

      widget.impresionAndPlanViewModel.initialHtmlContent = widget.impresionAndPlanViewModel.htmlContent;

      widget.toggleCallBack(widget.impresionAndPlanViewModel);
    } else {
      widget.impresionAndPlanViewModel.toggleHtmlContent = widget.impresionAndPlanViewModel.htmlContent;

      widget.impresionAndPlanViewModel.initialHtmlContent = widget.impresionAndPlanViewModel.htmlContent;
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
              decoration: BoxDecoration(border: Border.all(width: widget.isBorder ? 1 : 0, color: AppColors.borderTable)),
              child: HtmlEditor(
                controller: widget.impresionAndPlanViewModel.htmlEditorController,

                callbacks: Callbacks(
                  onChangeContent: (content) {
                    onChangeContent(content);
                  },
                  onScroll: () {},
                  onInit: () {
                    widget.impresionAndPlanViewModel.htmlEditorController.setFullScreen();
                  },
                ),
                htmlEditorOptions: HtmlEditorOptions(autoAdjustHeight: true, shouldEnsureVisible: false, androidUseHybridComposition: false, initialText: (widget.impresionAndPlanViewModel.htmlContent ?? "").isEmpty ? sectionString : ensureSectionHasContent(widget.impresionAndPlanViewModel.htmlContent ?? sectionString), adjustHeightForKeyboard: false),
                htmlToolbarOptions: HtmlToolbarOptions(
                  gridViewHorizontalSpacing: 0,
                  gridViewVerticalSpacing: 0,
                  toolbarPosition: ToolbarPosition.aboveEditor,
                  dropdownBackgroundColor: Colors.white,
                  dropdownIcon: const SizedBox(),

                  customToolbarButtons: [
                    IconButton(icon: const Icon(Icons.copy), onPressed: () => _copyToClipboard(context)),

                    // IconButton(icon: Icon(Icons.image), onPressed: () => _showImageInsertDialog()),
                    IconButton(icon: const Icon(Icons.undo), onPressed: () => _handelUndo()),

                    IconButton(icon: const Icon(Icons.redo), onPressed: () => _handelRedo()),
                  ],
                  buttonFillColor: AppColors.borderTable.withValues(alpha: 0.2),
                  buttonColor: AppColors.textGrey,

                  buttonSelectedColor: AppColors.black,
                  buttonHighlightColor: AppColors.borderTable.withValues(alpha: 0.2),
                  separatorWidget: const VerticalDivider(color: Colors.transparent, width: 0, thickness: 1),
                  dropdownBoxDecoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2)),

                  textStyle: const TextStyle(fontSize: 14, color: AppColors.black),
                  defaultToolbarButtons: [
                    const FontSettingButtons(fontSizeUnit: false, fontName: false, fontSize: false),
                    const FontButtons(clearAll: false, strikethrough: true, superscript: false, subscript: false),
                    // const ColorButtons(),

                    // const ParagraphButtons(alignCenter: true, alignJustify: false, alignLeft: true, alignRight: true, caseConverter: false, decreaseIndent: false, increaseIndent: false, lineHeight: false, textDirection: false),
                    const OtherButtons(undo: false, redo: false, paste: false, codeview: false, copy: false, help: false, fullscreen: false),

                    const InsertButtons(picture: false, audio: false, hr: false, link: false, table: false, otherFile: false, video: false),
                    const ListButtons(listStyles: false),
                    const StyleButtons(),

                    // const OtherButtons(fullscreen: false, codeview: true, undo: false, redo: false, help: false, copy: false, paste: false),
                    // const InsertButtons(video: false, audio: false, table: false, hr: false, otherFile: false),
                  ],
                  customToolbarInsertionIndices: [2, 3, 4, 5],
                  toolbarType: ToolbarType.nativeScrollable,
                ),

                otherOptions: OtherOptions(height: widget.heightOfTheEditableView, decoration: const BoxDecoration(color: Colors.white)),
              ),
            ),
          )
        else
          GestureDetector(onTap: toggleEditing, child: Container(color: Colors.transparent, padding: widget.padding, child: Html(data: (widget.impresionAndPlanViewModel.htmlContent ?? "").isEmpty ? "Note is Empty" : widget.impresionAndPlanViewModel.htmlContent, style: {"section": Style(fontSize: FontSize(16))}))),
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
      'details', 'dialog', 'summary', 'menu', 'menuitem',
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
    String plainText = _parseHtmlToFormattedText(await widget.impresionAndPlanViewModel.htmlEditorController.getText());

    await FlutterClipboard.copy(plainText);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Content copied to clipboard')));
  }

  void _handelUndo() {
    //for redo
    widget.impresionAndPlanViewModel.toggleHtmlContent;

    if (!compareHtmlIgnoringQuotesAndSpaces(widget.impresionAndPlanViewModel.toggleHtmlContent ?? "", widget.impresionAndPlanViewModel.initialHtmlContent ?? "")) {
      widget.impresionAndPlanViewModel.htmlEditorController.undo();
    }
  }

  bool compareHtmlIgnoringQuotesAndSpaces(String html1, String html2) {
    String normalize(String html) {
      return html
          .replaceAll(RegExp(r'\s+'), '') // Remove all whitespace
          .replaceAll('"', "'") // Convert double quotes to single
          .trim();
    }

    return normalize(html1) == normalize(html2);
  }

  void _handelRedo() {
    widget.impresionAndPlanViewModel.htmlEditorController.redo();
  }
}

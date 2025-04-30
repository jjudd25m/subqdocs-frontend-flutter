import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../modules/patient_info/model/impresion_and_plan_view_model.dart';

class HtmlEditorViewWidget extends StatefulWidget {
  ImpresionAndPlanViewModel impresionAndPlanViewModel;
  final Function(ImpresionAndPlanViewModel) toggleCallBack;
  final Function(ImpresionAndPlanViewModel, String? content) onUpdateCallBack;

  double heightOfTheEditableView;

  HtmlEditorViewWidget({super.key, required this.impresionAndPlanViewModel, required this.toggleCallBack, required this.onUpdateCallBack, this.heightOfTheEditableView = 800});

  @override
  State<HtmlEditorViewWidget> createState() => _HtmlEditorViewWidgetState();
}

class _HtmlEditorViewWidgetState extends State<HtmlEditorViewWidget> {
  late String renderedHtml;
  late WebViewController webViewController;
  Timer? timer;

  void onChangeContent(String? content) {
    timer?.cancel();
    timer = Timer(const Duration(seconds: 5), () {
      widget.impresionAndPlanViewModel.htmlContent = content;
      widget.onUpdateCallBack(widget.impresionAndPlanViewModel, content);
    });
  }

  @override
  void initState() {
    super.initState();
    renderedHtml = widget.impresionAndPlanViewModel.htmlContent ?? "";

    webViewController =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadHtmlString(renderedHtml);
  }

  void toggleEditing() async {
    if (widget.impresionAndPlanViewModel.isEditing) {
      // Save the updated HTML when exiting edit mode
      String? updatedHtml = await widget.impresionAndPlanViewModel.htmlEditorController.getText();

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
        const SizedBox(height: 10),
        if (widget.impresionAndPlanViewModel.title?.isNotEmpty ?? false)
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(widget.impresionAndPlanViewModel.title ?? "", style: AppFonts.medium(18, AppColors.textPurple))]),
        const SizedBox(height: 5),
        if (widget.impresionAndPlanViewModel.isEditing)
          HtmlEditor(
            controller: widget.impresionAndPlanViewModel.htmlEditorController,

            callbacks: Callbacks(
              onChangeContent: (content) {
                onChangeContent(content);
              },
              onInit: () {
                widget.impresionAndPlanViewModel.htmlEditorController.setFullScreen();
              },
            ),
            htmlEditorOptions: HtmlEditorOptions(shouldEnsureVisible: false, androidUseHybridComposition: false, initialText: renderedHtml, autoAdjustHeight: true, adjustHeightForKeyboard: false),
            htmlToolbarOptions: HtmlToolbarOptions(
              gridViewHorizontalSpacing: 0,
              gridViewVerticalSpacing: 0,

              dropdownBackgroundColor: Colors.white,

              buttonFillColor: AppColors.borderTable.withOpacity(0.2),
              buttonColor: AppColors.textGrey,
              buttonSelectedColor: AppColors.black,
              buttonHighlightColor: AppColors.borderTable.withOpacity(0.2),
              separatorWidget: const VerticalDivider(color: Colors.transparent, width: 0, thickness: 1),
              dropdownBoxDecoration: BoxDecoration(color: Colors.white.withOpacity(0.2)),
              textStyle: const TextStyle(fontSize: 14, color: AppColors.black),
              defaultToolbarButtons: [
                const FontButtons(clearAll: false, strikethrough: true, superscript: false, subscript: false),
                // const ColorButtons(),
                const FontSettingButtons(fontSizeUnit: false, fontName: false),

                // const ParagraphButtons(alignCenter: true, alignJustify: false, alignLeft: true, alignRight: true, caseConverter: false, decreaseIndent: false, increaseIndent: false, lineHeight: false, textDirection: false),
                const ListButtons(listStyles: true),

                // const OtherButtons(fullscreen: false, codeview: true, undo: false, redo: false, help: false, copy: false, paste: false),
                // const InsertButtons(video: false, audio: false, table: false, hr: false, otherFile: false),
                OtherButtons(undo: true, redo: true, codeview: false, help: false, fullscreen: false, paste: false),
                const StyleButtons(),
              ],
              toolbarType: ToolbarType.nativeScrollable,
            ),
            otherOptions: OtherOptions(height: double.infinity, decoration: const BoxDecoration(color: Colors.white)),
          )
        else
          // Html(data: widget.initialText, style: {}),
          GestureDetector(
            onTap: toggleEditing,
            child: Container(
              child: Html(
                data: widget.impresionAndPlanViewModel.htmlContent,
                style: {"*": Style(margin: Margins.only(left: 2), lineHeight: LineHeight(1.5), fontFamily: "Poppins"), "ul": Style(margin: Margins.only(left: 7), lineHeight: LineHeight(1.5), fontFamily: "Poppins")},
              ),
            ),
          ),
      ],
    );
  }
}

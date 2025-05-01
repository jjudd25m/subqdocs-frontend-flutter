import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
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

  EdgeInsetsGeometry padding;
  bool isBorder;

  double heightOfTheEditableView;

  HtmlEditorViewWidget({
    super.key,
    required this.impresionAndPlanViewModel,
    required this.toggleCallBack,
    required this.onUpdateCallBack,
    this.isBorder = false,
    this.heightOfTheEditableView = 800,
    this.padding = const EdgeInsets.only(left: 20, right: 10, bottom: 10),
  });

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
        const SizedBox(height: 2),
        if (widget.impresionAndPlanViewModel.title?.isNotEmpty ?? false)
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(widget.impresionAndPlanViewModel.title ?? "", style: AppFonts.medium(18, AppColors.textPurple))]),
        const SizedBox(height: 2),
        if (widget.impresionAndPlanViewModel.isEditing)
          Container(
            decoration: BoxDecoration(border: Border.all(width: widget.isBorder ? 1 : 0, color: AppColors.borderTable)),
            child: Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 10, left: 4, right: 4),
              child: HtmlEditor(
                controller: widget.impresionAndPlanViewModel.htmlEditorController,

                callbacks: Callbacks(
                  onChangeContent: (content) {
                    onChangeContent(content);
                  },
                  onScroll: () {
                    print("demo  is the called ");
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

                otherOptions: OtherOptions(height: widget.heightOfTheEditableView, decoration: const BoxDecoration(color: Colors.white)),
              ),
            ),
          )
        else
          GestureDetector(
            onTap: toggleEditing,
            child: Padding(
              padding: widget.padding,
              child: HtmlWidget(
                // the first parameter (`html`) is required
                widget.impresionAndPlanViewModel.htmlContent ?? "",

                customWidgetBuilder: (element) {
                  return null;
                },
              ),
            ),
          ),
      ],
    );
  }
}

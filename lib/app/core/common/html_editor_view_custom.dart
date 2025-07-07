import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:subqdocs/utils/imagepath.dart';
import 'package:subqdocs/widgets/ContainerButton.dart';

class HtmlEditorPage extends StatefulWidget {
  String? initialText;
  String? screenName;
  bool isDisabled;
  Callbacks? callBackFunction;
  final HtmlEditorController htmlController;

  HtmlEditorPage({this.initialText, this.screenName, required this.htmlController, this.isDisabled = false, this.callBackFunction, super.key});

  @override
  State<HtmlEditorPage> createState() => _HtmlEditorPageState();
}

class _HtmlEditorPageState extends State<HtmlEditorPage> {
  int checkboxCount = 0;

  // final htmlEditorViewController = Get.put(HtmlEditorViewController());

  Callbacks? callBackFunction;

  @override
  void initState() {
    super.initState();

    callBackFunction = Callbacks(
      onInit: () async {
        widget.htmlController.setFullScreen();
      },
      onNavigationRequestMobile: (String url) {
        return NavigationActionPolicy.ALLOW;
      },
      onFocus: widget.callBackFunction?.onFocus,
      onChangeSelection: widget.callBackFunction?.onChangeSelection,
      onChangeContent: widget.callBackFunction?.onChangeContent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: () {
        widget.htmlController.clearFocus();
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              ContainerButton(
                onPressed: () {
                  openToolBar(context);
                },
                text: "Text Formatting Tool Bar",
              ),

              const SizedBox(height: 20),
              Expanded(
                child: HtmlEditor(
                  isSelectedText: true,
                  callbacks: callBackFunction,
                  controller: widget.htmlController,
                  htmlEditorOptions: HtmlEditorOptions(
                    hint: "Your text here...",
                    initialText: widget.initialText,
                    disabled: widget.isDisabled,
                    adjustHeightForKeyboard: false,
                    androidUseHybridComposition: false,
                    mobileLongPressDuration: Duration.zero,
                    mobileContextMenu: ContextMenu(
                      options: ContextMenuOptions(hideDefaultSystemContextMenuItems: true),
                      menuItems: [
                        ContextMenuItem(
                          title: "Click and Open Text Formatting Tool Bar",
                          iosId: "1",
                          androidId: 1,
                          action: () {
                            openToolBar(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  otherOptions: OtherOptions(height: 300, decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.black, width: 2), shape: BoxShape.rectangle, color: Colors.red)),
                  htmlToolbarOptions: HtmlToolbarOptions(
                    toolbarType: ToolbarType.nativeGrid,
                    buttonBorderColor: Colors.grey,
                    buttonFillColor: Colors.red,
                    buttonBorderRadius: BorderRadius.circular(10),
                    buttonBorderWidth: 2,
                    buttonSelectedColor: Colors.red,
                    buttonColor: Colors.black,
                    dropdownIcon: Padding(padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10), child: SvgPicture.asset(ImagePath.search, height: 10, width: 10)),
                    dropdownMenuDirection: DropdownMenuDirection.down,
                    gridViewVerticalSpacing: 20,
                    toolbarPosition: ToolbarPosition.custom,
                    textStyle: const TextStyle(fontSize: 10, color: Colors.black),
                    defaultToolbarButtons: [
                      const StyleButtons(),
                      const ColorButtons(),
                      const FontSettingButtons(fontSizeUnit: false),
                      const FontButtons(clearAll: true),
                      const ListButtons(listStyles: false),
                      const ParagraphButtons(textDirection: false, lineHeight: false, caseConverter: false),
                      const InsertButtons(video: false, audio: false, table: false, hr: false, otherFile: false, picture: false),
                      const OtherButtons(redo: true, copy: true, paste: true, undo: true, fullscreen: false, help: false, codeview: false),
                    ],
                    renderBorder: true,
                    dropdownBoxDecoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 2), borderRadius: BorderRadius.circular(10)),
                    customToolbarButtons: [
                      InkWell(
                        onTap: () async {
                          widget.htmlController.insertHtml('''<input type="checkbox" checked>''');
                        },
                        child: Container(padding: const EdgeInsets.all(40), decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), border: Border.all(width: 2, color: Colors.red)), child: SvgPicture.asset(ImagePath.image_attchment)),
                      ),
                    ],
                    dropdownMenuMaxHeight: 40,
                    renderSeparatorWidget: false,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Align(
                alignment: Alignment.centerRight,
                child: ContainerButton(
                  onPressed: () async {
                    widget.initialText = await widget.htmlController.getText();
                    await SystemChannels.textInput.invokeMethod('TextInput.hide');
                    // widget.getXController.update();
                    Get.back();
                  },
                  text: "Text Formatting Tool Bar",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void openToolBar(context) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        //FocusScope.of(context).unfocus();
        return SimpleDialog(
          insetPadding: const EdgeInsets.all(20),
          contentPadding: const EdgeInsets.all(20),
          //titlePadding: const EdgeInsets.only(top: 10),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Text Formatting', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.close),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              child: ToolbarWidget(
                controller: widget.htmlController,
                htmlToolbarOptions: HtmlToolbarOptions(
                  toolbarType: ToolbarType.nativeGrid,
                  buttonBorderColor: Colors.red,
                  buttonFillColor: Colors.white,
                  buttonBorderRadius: BorderRadius.circular(20),
                  buttonBorderWidth: 2,
                  buttonSelectedColor: Colors.white,
                  buttonColor: Colors.black,
                  dropdownIcon: Padding(padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10), child: SvgPicture.asset(ImagePath.search, height: 10, width: 10)),
                  dropdownMenuDirection: DropdownMenuDirection.down,
                  gridViewVerticalSpacing: 20,
                  toolbarPosition: ToolbarPosition.custom,
                  textStyle: const TextStyle(fontSize: 10, color: Colors.black),
                  defaultToolbarButtons: [
                    const StyleButtons(),
                    const ColorButtons(),
                    const FontSettingButtons(fontSizeUnit: false),
                    const FontButtons(clearAll: true),
                    const ListButtons(listStyles: false),
                    const ParagraphButtons(textDirection: false, lineHeight: false, caseConverter: false),
                    const InsertButtons(video: false, audio: false, table: false, hr: false, otherFile: false, picture: false),
                    const OtherButtons(redo: true, copy: true, paste: true, undo: true, fullscreen: false, help: false, codeview: false),
                  ],
                  renderBorder: true,
                  dropdownBoxDecoration: BoxDecoration(border: Border.all(color: Colors.white, width: 2), borderRadius: BorderRadius.circular(10)),
                  customToolbarButtons: [
                    InkWell(
                      onTap: () async {
                        widget.htmlController.insertHtml('''<input type="checkbox" checked>''');
                      },
                      child: Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(width: 2, color: Colors.red)), child: SvgPicture.asset(ImagePath.search)),
                    ),
                  ],
                  dropdownMenuMaxHeight: 20,
                  renderSeparatorWidget: false,
                ),
                callbacks: callBackFunction,
              ),
            ),
          ],
        );
      },
    ).then((value) async {
      widget.htmlController.clearFocus();
      await SystemChannels.textInput.invokeMethod('TextInput.hide');
      widget.htmlController.setFocus();
      // htmlEditorViewController.update();
    });
  }
}

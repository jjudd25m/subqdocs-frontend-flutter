import 'package:html_editor_enhanced/html_editor.dart';

class ImpresionAndPlanViewModel {
  String? title;

  String? htmlContent;
  HtmlEditorController htmlEditorController;

  bool isEditing;

  ImpresionAndPlanViewModel({this.title, this.htmlContent, required this.htmlEditorController, this.isEditing = false});

  Map<String, dynamic> toJson() {
    return {'title': title ?? '', 'content': htmlContent ?? ''};
  }
}

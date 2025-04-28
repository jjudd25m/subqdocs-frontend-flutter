import 'package:html_editor_enhanced/html_editor.dart';

class ImpresionAndPlanViewModel {
  String? title;

  String? htmlContent;
  HtmlEditorController htmlEditorController;

  ImpresionAndPlanViewModel({this.title, this.htmlContent, required this.htmlEditorController});
}

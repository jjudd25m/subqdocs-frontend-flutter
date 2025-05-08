import 'package:html_editor_enhanced/html_editor.dart';
import 'package:subqdocs/app/modules/patient_info/model/patient_fullnote_model.dart';

import '../../visit_main/model/doctor_view_model.dart';

class ImpresionAndPlanViewModel {
  String? title;

  String? htmlContent;
  HtmlEditorController htmlEditorController;

  List<SiblingIcd10>? siblingIcd10;

  List<SiblingIcd10FullNote>? siblingIcd10FullNote;

  bool isEditing;



  ImpresionAndPlanViewModel({this.title, this.htmlContent, required this.htmlEditorController, this.isEditing = false , this.siblingIcd10 , this.siblingIcd10FullNote});

  Map<String, dynamic> toJson() {
    return {'title': title ?? '', 'content': htmlContent ?? ''  ,'sibling_icd_10' :siblingIcd10 };
  }

  Map<String, dynamic> toJsonFullNote() {
    return {'title': title ?? '', 'content': htmlContent ?? ''  ,'sibling_icd_10' :siblingIcd10FullNote };
  }
}

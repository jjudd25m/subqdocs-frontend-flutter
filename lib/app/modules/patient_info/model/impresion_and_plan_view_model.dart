// import 'package:easy_popover/easy_popover.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:html_editor_enhanced/html_editor.dart';
// import 'package:subqdocs/app/modules/patient_info/model/patient_fullnote_model.dart';
//
// import '../../visit_main/model/doctor_view_model.dart';
//
// class ImpresionAndPlanViewModel {
//   String? title;
//
//   String? htmlContent;
//   String? initialHtmlContent;
//   String? toggleHtmlContent;
//
//   HtmlEditorController htmlEditorController;
//
//   List<SiblingIcd10>? siblingIcd10;
//
//   List<SiblingIcd10FullNote>? siblingIcd10FullNote;
//
//   final GlobalKey diagnosisContainerKey = GlobalKey();
//
//   bool isEditing;
//
//   PopoverController popoverController = PopoverController();
//
//   FocusNode focusNode = FocusNode();
//
//   ImpresionAndPlanViewModel({
//     this.title,
//     this.htmlContent,
//     required this.htmlEditorController,
//     this.isEditing = false,
//     this.toggleHtmlContent,
//     this.siblingIcd10,
//     this.siblingIcd10FullNote,
//     this.initialHtmlContent,
//   });
//
//   Map<String, dynamic> toJson() {
//     if (title == null) {
//       return {};
//       // Return an empty map if title is null
//     }
//     return {
//       'title': title ?? '',
//       'content': htmlContent ?? '',
//       'sibling_icd_10': siblingIcd10,
//     };
//   }
//
//   Map<String, dynamic> toJsonFullNote() {
//     if (title == null) {
//       return {};
//       // Return an empty map if title is null
//     }
//     return {
//       'title': title ?? '',
//       'content': htmlContent ?? '',
//       'sibling_icd_10': siblingIcd10FullNote,
//     };
//   }
// }

import 'package:easy_popover/easy_popover.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:subqdocs/app/modules/patient_info/model/patient_fullnote_model.dart';

import '../../visit_main/model/doctor_view_model.dart';

class ImpresionAndPlanViewModel {
  String? title;

  String? htmlContent;
  String? initialHtmlContent;
  String? toggleHtmlContent;

  HtmlEditorController htmlEditorController;

  List<SiblingIcd10>? siblingIcd10;

  List<SiblingIcd10FullNote>? siblingIcd10FullNote;

  final GlobalKey diagnosisContainerKey = GlobalKey();

  bool isEditing;

  PopoverController popoverController = PopoverController();
  SlidableController? slidableController;

  FocusNode focusNode = FocusNode();

  ImpresionAndPlanViewModel({this.title, this.htmlContent, required this.htmlEditorController, this.isEditing = false, this.toggleHtmlContent, this.siblingIcd10, this.siblingIcd10FullNote, this.initialHtmlContent, this.slidableController});

  Map<String, dynamic> toJson() {
    if (title == null) {
      return {};
      // Return an empty map if title is null
    }
    return {'title': title ?? '', 'content': htmlContent ?? '', 'sibling_icd_10': siblingIcd10};
  }

  Map<String, dynamic> toJsonFullNote() {
    if (title == null) {
      return {};
      // Return an empty map if title is null
    }
    return {'title': title ?? '', 'content': htmlContent ?? '', 'sibling_icd_10': siblingIcd10FullNote};
  }
}

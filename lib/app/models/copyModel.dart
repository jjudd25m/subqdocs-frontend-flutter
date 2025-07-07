// class CopyModel{
//
//   String? sectionName;
//
//   List<ContentModel>? contentModel ;
//
//   CopyModel({this.sectionName, this.contentModel});
// }
//
//
// class   ContentModel{
//
//
//     String? label;
//     String? htmlContent;
//
//     ContentModel({this.label, this.htmlContent});
// }

class CopyModel {
  String? sectionName;

  List<ContentModel>? contentModel;

  CopyModel({this.sectionName, this.contentModel});
  // Add commentMore actions
}

class ContentModel {
  String? label;
  String? htmlContent;

  ContentModel({this.label, this.htmlContent});
}

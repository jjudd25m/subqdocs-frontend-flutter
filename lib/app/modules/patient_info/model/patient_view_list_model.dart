class PatientViewListModel {
  ResponseData? responseData;
  String? message;
  bool? toast;
  String? responseType;

  PatientViewListModel({this.responseData, this.message, this.toast, this.responseType});

  PatientViewListModel.fromJson(Map<String, dynamic> json) {
    responseData = json['responseData'] != null ? ResponseData.fromJson(json['responseData']) : null;
    message = json['message'];
    toast = json['toast'];
    responseType = json['response_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (responseData != null) {
      data['responseData'] = responseData!.toJson();
    }
    data['message'] = message;
    data['toast'] = toast;
    data['response_type'] = responseType;
    return data;
  }
}

class ResponseData {
  int? id;
  String? status;
  VisitNoteDetails? visitNoteDetails;
  String? message;

  ResponseData({this.id, this.status, this.visitNoteDetails, this.message});

  ResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    visitNoteDetails = json['visit_note_details'] != null ? VisitNoteDetails.fromJson(json['visit_note_details']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    if (visitNoteDetails != null) {
      data['visit_note_details'] = visitNoteDetails!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class VisitNoteDetails {
  String? patientViewNoteHtml;

  VisitNoteDetails({this.patientViewNoteHtml});

  VisitNoteDetails.fromJson(Map<String, dynamic> json) {
    patientViewNoteHtml = json['patient_view_note_html'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['patient_view_note_html'] = patientViewNoteHtml;
    return data;
  }
}

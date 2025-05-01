class PatientViewListModel {
  ResponseData? responseData;
  String? message;
  bool? toast;
  String? responseType;

  PatientViewListModel({this.responseData, this.message, this.toast, this.responseType});

  PatientViewListModel.fromJson(Map<String, dynamic> json) {
    responseData = json['responseData'] != null ? new ResponseData.fromJson(json['responseData']) : null;
    message = json['message'];
    toast = json['toast'];
    responseType = json['response_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.responseData != null) {
      data['responseData'] = this.responseData!.toJson();
    }
    data['message'] = this.message;
    data['toast'] = this.toast;
    data['response_type'] = this.responseType;
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
    visitNoteDetails = json['visit_note_details'] != null ? new VisitNoteDetails.fromJson(json['visit_note_details']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    if (this.visitNoteDetails != null) {
      data['visit_note_details'] = this.visitNoteDetails!.toJson();
    }
    data['message'] = this.message;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['patient_view_note_html'] = this.patientViewNoteHtml;
    return data;
  }
}

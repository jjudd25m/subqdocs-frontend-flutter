// class PatientFullNoteModel {
//   ResponseData? responseData;
//   String? message;
//   bool? toast;
//   String? responseType;
//
//   PatientFullNoteModel({this.responseData, this.message, this.toast, this.responseType});
//
//   PatientFullNoteModel.fromJson(Map<String, dynamic> json) {
//     responseData = json['responseData'] != null ? ResponseData.fromJson(json['responseData']) : null;
//     message = json['message'];
//     toast = json['toast'];
//     responseType = json['response_type'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (responseData != null) {
//       data['responseData'] = responseData!.toJson();
//     }
//     data['message'] = message;
//     data['toast'] = toast;
//     data['response_type'] = responseType;
//     return data;
//   }
// }
//
// class ResponseData {
//   int? id;
//   String? status;
//   FullNoteDetails? fullNoteDetails;
//
//   ResponseData({this.id, this.status, this.fullNoteDetails});
//
//   ResponseData.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     status = json['status'];
//     fullNoteDetails = json['full_note_details'] != null ? FullNoteDetails.fromJson(json['full_note_details']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['status'] = status;
//     if (fullNoteDetails != null) {
//       data['full_note_details'] = fullNoteDetails!.toJson();
//     }
//     return data;
//   }
// }
//
// class FullNoteDetails {
//   List<String>? cancerHistory;
//   List<String>? skinHistory;
//   List<String>? socialHistory;
//   List<String>? medications;
//   List<String>? allergies;
//   String? chiefComplaint;
//   String? hpi;
//   List<String>? reviewOfSystem;
//   List<String>? exam;
//   List<String>? impressionsAndPlan;
//
//   FullNoteDetails({this.cancerHistory, this.skinHistory, this.socialHistory, this.medications, this.allergies, this.chiefComplaint, this.hpi, this.reviewOfSystem, this.exam, this.impressionsAndPlan});
//
//   FullNoteDetails.fromJson(Map<String, dynamic> json) {
//     cancerHistory = json['cancer_history'].cast<String>();
//     skinHistory = json['skin_history'].cast<String>();
//     socialHistory = json['social_history'].cast<String>();
//     medications = json['medications'].cast<String>();
//     allergies = json['allergies'].cast<String>();
//     chiefComplaint = json['chief_complaint'];
//     hpi = json['hpi'];
//     reviewOfSystem = json['review_of_system'].cast<String>();
//     exam = json['exam'].cast<String>();
//     impressionsAndPlan = json['impressions_and_plan'].cast<String>();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['cancer_history'] = cancerHistory;
//     data['skin_history'] = skinHistory;
//     data['social_history'] = socialHistory;
//     data['medications'] = medications;
//     data['allergies'] = allergies;
//     data['chief_complaint'] = chiefComplaint;
//     data['hpi'] = hpi;
//     data['review_of_system'] = reviewOfSystem;
//     data['exam'] = exam;
//     data['impressions_and_plan'] = impressionsAndPlan;
//     return data;
//   }
// }

class PatientFullNoteModel {
  ResponseData? responseData;
  String? message;
  bool? toast;
  String? responseType;

  PatientFullNoteModel({this.responseData, this.message, this.toast, this.responseType});

  PatientFullNoteModel.fromJson(Map<String, dynamic> json) {
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
  FullNoteDetails? fullNoteDetails;

  ResponseData({this.id, this.status, this.fullNoteDetails});

  ResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    fullNoteDetails = json['full_note_details'] != null ? FullNoteDetails.fromJson(json['full_note_details']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    if (fullNoteDetails != null) {
      data['full_note_details'] = fullNoteDetails!.toJson();
    }
    return data;
  }
}

class FullNoteDetails {
  List<String>? cancerHistory;
  List<String>? skinHistory;
  List<String>? socialHistory;
  List<String>? medications;
  List<String>? allergies;
  String? chiefComplain;
  String? hpi;
  List<String>? reviewOfSystem;
  List<String>? exam;
  List<ImpressionsAndPlan>? impressionsAndPlan;

  FullNoteDetails({this.cancerHistory, this.skinHistory, this.socialHistory, this.medications, this.allergies, this.chiefComplain, this.hpi, this.reviewOfSystem, this.exam, this.impressionsAndPlan});

  FullNoteDetails.fromJson(Map<String, dynamic> json) {
    cancerHistory = json['cancer_history'].cast<String>();
    skinHistory = json['skin_history'].cast<String>();
    socialHistory = json['social_history'].cast<String>();
    medications = json['medications'].cast<String>();
    allergies = json['allergies'].cast<String>();
    chiefComplain = json['chief_complain'];
    hpi = json['hpi'];
    reviewOfSystem = json['review_of_system'].cast<String>();
    exam = json['exam'].cast<String>();
    if (json['impressions_and_plan'] != null) {
      impressionsAndPlan = <ImpressionsAndPlan>[];
      json['impressions_and_plan'].forEach((v) {
        impressionsAndPlan!.add(ImpressionsAndPlan.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cancer_history'] = cancerHistory;
    data['skin_history'] = skinHistory;
    data['social_history'] = socialHistory;
    data['medications'] = medications;
    data['allergies'] = allergies;
    data['chief_complain'] = chiefComplain;
    data['hpi'] = hpi;
    data['review_of_system'] = reviewOfSystem;
    data['exam'] = exam;
    if (impressionsAndPlan != null) {
      data['impressions_and_plan'] = impressionsAndPlan!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ImpressionsAndPlan {
  String? number;
  String? title;
  String? description;

  ImpressionsAndPlan({this.number, this.title, this.description});

  ImpressionsAndPlan.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['number'] = number;
    data['title'] = title;
    data['description'] = description;
    return data;
  }
}

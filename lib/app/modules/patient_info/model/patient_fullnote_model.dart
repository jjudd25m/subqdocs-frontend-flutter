class PatientFullNoteModel {
  ResponseData? responseData;
  String? message;
  bool? toast;
  String? responseType;

  PatientFullNoteModel({this.responseData, this.message, this.toast, this.responseType});

  PatientFullNoteModel.fromJson(Map<String, dynamic> json) {
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
  FullNoteDetails? fullNoteDetails;
  String? message;
  List<Icd10Codes>? icd10Codes;

  ResponseData({this.id, this.status, this.fullNoteDetails, this.message, this.icd10Codes});

  ResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    fullNoteDetails = json['full_note_details'] != null ? new FullNoteDetails.fromJson(json['full_note_details']) : null;
    message = json['message'];
    if (json['icd10Codes'] != null) {
      icd10Codes = <Icd10Codes>[];
      json['icd10Codes'].forEach((v) {
        icd10Codes!.add(new Icd10Codes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    if (this.fullNoteDetails != null) {
      data['full_note_details'] = this.fullNoteDetails!.toJson();
    }
    data['message'] = this.message;
    if (this.icd10Codes != null) {
      data['icd10Codes'] = this.icd10Codes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FullNoteDetails {
  String? cancerHistory;
  String? cancerHistoryHtml;
  String? skinHistory;
  String? skinHistoryWithLocation;
  String? socialHistory;
  String? socialHistoryHtml;
  List<Medications>? medications;
  String? medicationsHtml;
  String? allergies;
  String? chiefComplain;
  String? hpi;
  String? reviewOfSystem;
  String? exam;
  List<ImpressionsAndPlan>? impressionsAndPlan;

  FullNoteDetails({
    this.cancerHistory,
    this.cancerHistoryHtml,
    this.skinHistory,
    this.skinHistoryWithLocation,
    this.socialHistory,
    this.socialHistoryHtml,
    this.medications,
    this.medicationsHtml,
    this.allergies,
    this.chiefComplain,
    this.hpi,
    this.reviewOfSystem,
    this.exam,
    this.impressionsAndPlan,
  });

  FullNoteDetails.fromJson(Map<String, dynamic> json) {
    cancerHistory = json['cancer_history'];
    cancerHistoryHtml = json['cancer_history_html'];
    skinHistory = json['skin_history'];
    skinHistoryWithLocation = json['skin_history_with_location'];
    socialHistory = json['social_history'];
    socialHistoryHtml = json['social_history_html'];
    if (json['medications'] != null) {
      medications = <Medications>[];
      json['medications'].forEach((v) {
        medications!.add(new Medications.fromJson(v));
      });
    }
    medicationsHtml = json['medications_html'];
    allergies = json['allergies'];
    chiefComplain = json['chief_complain'];
    hpi = json['hpi'];
    reviewOfSystem = json['review_of_system'];
    exam = json['exam'];
    if (json['impressions_and_plan'] != null) {
      impressionsAndPlan = <ImpressionsAndPlan>[];
      json['impressions_and_plan'].forEach((v) {
        impressionsAndPlan!.add(new ImpressionsAndPlan.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cancer_history'] = this.cancerHistory;
    data['cancer_history_html'] = this.cancerHistoryHtml;
    data['skin_history'] = this.skinHistory;
    data['skin_history_with_location'] = this.skinHistoryWithLocation;
    data['social_history'] = this.socialHistory;
    data['social_history_html'] = this.socialHistoryHtml;
    if (this.medications != null) {
      data['medications'] = this.medications!.map((v) => v.toJson()).toList();
    }
    data['medications_html'] = this.medicationsHtml;
    data['allergies'] = this.allergies;
    data['chief_complain'] = this.chiefComplain;
    data['hpi'] = this.hpi;
    data['review_of_system'] = this.reviewOfSystem;
    data['exam'] = this.exam;
    if (this.impressionsAndPlan != null) {
      data['impressions_and_plan'] = this.impressionsAndPlan!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Medications {
  String? title;
  String? dosage;
  String? frequency;
  String? route;
  String? purpose;
  bool? diagnosisRelated;
  String? medicineNameWithType;

  Medications({this.title, this.dosage, this.frequency, this.route, this.purpose, this.diagnosisRelated, this.medicineNameWithType});

  Medications.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    dosage = json['dosage'];
    frequency = json['frequency'];
    route = json['route'];
    purpose = json['purpose'];
    diagnosisRelated = json['diagnosis_related'];
    medicineNameWithType = json['medicine_name_with_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['dosage'] = this.dosage;
    data['frequency'] = this.frequency;
    data['route'] = this.route;
    data['purpose'] = this.purpose;
    data['diagnosis_related'] = this.diagnosisRelated;
    data['medicine_name_with_type'] = this.medicineNameWithType;
    return data;
  }
}

class ImpressionsAndPlan {
  String? title;
  String? content;

  ImpressionsAndPlan({this.title, this.content});

  ImpressionsAndPlan.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['content'] = this.content;
    return data;
  }
}

class Icd10Codes {
  String? code;
  String? description;

  Icd10Codes({this.code, this.description});

  Icd10Codes.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['description'] = this.description;
    return data;
  }
}

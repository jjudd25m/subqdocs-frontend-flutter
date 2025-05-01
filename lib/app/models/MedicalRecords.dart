class MedicalRecords {
  ResponseData? responseData;
  String? message;
  bool? toast;
  String? responseType;

  MedicalRecords({this.responseData, this.message, this.toast, this.responseType});

  MedicalRecords.fromJson(Map<String, dynamic> json) {
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
  int? patientId;
  int? visitId;
  String? visitDate;
  FullNoteDetails? fullNoteDetails;
  String? message;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

  ResponseData({this.id, this.status, this.patientId, this.visitId, this.visitDate, this.fullNoteDetails, this.message, this.createdAt, this.updatedAt, this.deletedAt});

  ResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    patientId = json['patient_id'];
    visitId = json['visit_id'];
    visitDate = json['visit_date'];
    fullNoteDetails = json['full_note_details'] != null ? new FullNoteDetails.fromJson(json['full_note_details']) : null;
    message = json['message'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['patient_id'] = this.patientId;
    data['visit_id'] = this.visitId;
    data['visit_date'] = this.visitDate;
    if (this.fullNoteDetails != null) {
      data['full_note_details'] = this.fullNoteDetails!.toJson();
    }
    data['message'] = this.message;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
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

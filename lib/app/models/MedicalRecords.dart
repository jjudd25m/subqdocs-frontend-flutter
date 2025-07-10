class MedicalRecords {
  ResponseData? responseData;
  String? message;
  bool? toast;
  String? responseType;

  MedicalRecords({this.responseData, this.message, this.toast, this.responseType});

  MedicalRecords.fromJson(Map<String, dynamic> json) {
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
  int? patientId;
  int? visitId;
  String? visitDate;
  FullNoteDetails? fullNoteDetails;
  String? message;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  ResponseData({this.id, this.status, this.patientId, this.visitId, this.visitDate, this.fullNoteDetails, this.message, this.createdAt, this.updatedAt, this.deletedAt});

  ResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    patientId = json['patient_id'];
    visitId = json['visit_id'];
    visitDate = json['visit_date'];
    fullNoteDetails = json['full_note_details'] != null ? FullNoteDetails.fromJson(json['full_note_details']) : null;
    message = json['message'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    data['patient_id'] = patientId;
    data['visit_id'] = visitId;
    data['visit_date'] = visitDate;
    if (fullNoteDetails != null) {
      data['full_note_details'] = fullNoteDetails!.toJson();
    }
    data['message'] = message;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
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
  String? newMedicationsHtml;
  String? allergies;
  String? chiefComplain;
  String? hpi;
  String? reviewOfSystem;
  String? exam;

  FullNoteDetails({this.cancerHistory, this.cancerHistoryHtml, this.skinHistory, this.skinHistoryWithLocation, this.socialHistory, this.socialHistoryHtml, this.medications, this.medicationsHtml, this.newMedicationsHtml, this.allergies, this.chiefComplain, this.hpi, this.reviewOfSystem, this.exam});

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
        medications!.add(Medications.fromJson(v));
      });
    }
    medicationsHtml = json['medications_html'];
    newMedicationsHtml = json['new_medications_html'];
    allergies = json['allergies'];
    chiefComplain = json['chief_complain'];
    hpi = json['hpi'];
    reviewOfSystem = json['review_of_system'];
    exam = json['exam'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cancer_history'] = cancerHistory;
    data['cancer_history_html'] = cancerHistoryHtml;
    data['skin_history'] = skinHistory;
    data['skin_history_with_location'] = skinHistoryWithLocation;
    data['social_history'] = socialHistory;
    data['social_history_html'] = socialHistoryHtml;
    if (medications != null) {
      data['medications'] = medications!.map((v) => v.toJson()).toList();
    }
    data['medications_html'] = medicationsHtml;
    data['new_medications_html'] = newMedicationsHtml;
    data['allergies'] = allergies;
    data['chief_complain'] = chiefComplain;
    data['hpi'] = hpi;
    data['review_of_system'] = reviewOfSystem;
    data['exam'] = exam;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['dosage'] = dosage;
    data['frequency'] = frequency;
    data['route'] = route;
    data['purpose'] = purpose;
    data['diagnosis_related'] = diagnosisRelated;
    data['medicine_name_with_type'] = medicineNameWithType;
    return data;
  }
}

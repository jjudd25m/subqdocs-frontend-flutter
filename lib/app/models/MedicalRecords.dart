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
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

  ResponseData(
      {this.id,
      this.status,
      this.patientId,
      this.visitId,
      this.visitDate,
      this.fullNoteDetails,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  ResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    patientId = json['patient_id'];
    visitId = json['visit_id'];
    visitDate = json['visit_date'];
    fullNoteDetails =
        json['full_note_details'] != null ? new FullNoteDetails.fromJson(json['full_note_details']) : null;
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
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

class FullNoteDetails {
  String? cancerHistory;
  String? skinHistory;
  String? socialHistory;
  List<Medications>? medications;
  String? allergies;
  String? chiefComplain;
  String? hpi;
  ReviewOfSystem? reviewOfSystem;
  String? exam;
  List<ImpressionsAndPlan>? impressionsAndPlan;

  FullNoteDetails(
      {this.cancerHistory,
      this.skinHistory,
      this.socialHistory,
      this.medications,
      this.allergies,
      this.chiefComplain,
      this.hpi,
      this.reviewOfSystem,
      this.exam,
      this.impressionsAndPlan});

  FullNoteDetails.fromJson(Map<String, dynamic> json) {
    cancerHistory = json['cancer_history'];
    skinHistory = json['skin_history'];
    socialHistory = json['social_history'];
    if (json['medications'] != null) {
      medications = <Medications>[];
      json['medications'].forEach((v) {
        medications!.add(new Medications.fromJson(v));
      });
    }
    allergies = json['allergies'];
    chiefComplain = json['chief_complain'];
    hpi = json['hpi'];
    reviewOfSystem = json['review_of_system'] != null ? new ReviewOfSystem.fromJson(json['review_of_system']) : null;
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
    data['skin_history'] = this.skinHistory;
    data['social_history'] = this.socialHistory;
    if (this.medications != null) {
      data['medications'] = this.medications!.map((v) => v.toJson()).toList();
    }
    data['allergies'] = this.allergies;
    data['chief_complain'] = this.chiefComplain;
    data['hpi'] = this.hpi;
    if (this.reviewOfSystem != null) {
      data['review_of_system'] = this.reviewOfSystem!.toJson();
    }
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
  String? purpose;

  Medications({this.title, this.dosage, this.purpose});

  Medications.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    dosage = json['dosage'];
    purpose = json['purpose'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['dosage'] = this.dosage;
    data['purpose'] = this.purpose;
    return data;
  }
}

class ReviewOfSystem {
  String? constitutional;
  String? skin;
  String? respiratory;
  String? cardiovascular;
  String? allergicImmunologic;
  String? other;

  ReviewOfSystem(
      {this.constitutional, this.skin, this.respiratory, this.cardiovascular, this.allergicImmunologic, this.other});

  ReviewOfSystem.fromJson(Map<String, dynamic> json) {
    constitutional = json['Constitutional'];
    skin = json['Skin'];
    respiratory = json['Respiratory'];
    cardiovascular = json['Cardiovascular'];
    allergicImmunologic = json['Allergic/Immunologic'];
    other = json['Other'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Constitutional'] = this.constitutional;
    data['Skin'] = this.skin;
    data['Respiratory'] = this.respiratory;
    data['Cardiovascular'] = this.cardiovascular;
    data['Allergic/Immunologic'] = this.allergicImmunologic;
    data['Other'] = this.other;
    return data;
  }
}

class ImpressionsAndPlan {
  String? number;
  String? title;
  String? code;
  String? description;
  Procedure? procedure;
  String? medications;
  String? orders;
  String? counselingAndDiscussion;
  String? followUp;

  ImpressionsAndPlan(
      {this.number,
      this.title,
      this.code,
      this.description,
      this.procedure,
      this.medications,
      this.orders,
      this.counselingAndDiscussion,
      this.followUp});

  ImpressionsAndPlan.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    title = json['title'];
    code = json['code'];
    description = json['description'];
    procedure = json['procedure'] != null ? new Procedure.fromJson(json['procedure']) : null;
    medications = json['medications'];
    orders = json['orders'];
    counselingAndDiscussion = json['counseling_and_discussion'];
    followUp = json['follow_up'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['number'] = this.number;
    data['title'] = this.title;
    data['code'] = this.code;
    data['description'] = this.description;
    if (this.procedure != null) {
      data['procedure'] = this.procedure!.toJson();
    }
    data['medications'] = this.medications;
    data['orders'] = this.orders;
    data['counseling_and_discussion'] = this.counselingAndDiscussion;
    data['follow_up'] = this.followUp;
    return data;
  }
}

class Procedure {
  String? type;
  List<String>? details;

  Procedure({this.type, this.details});

  Procedure.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    details = json['details'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['details'] = this.details;
    return data;
  }
}

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

  ResponseData({this.id, this.status, this.fullNoteDetails, this.message});

  ResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    fullNoteDetails = json['full_note_details'] != null ? new FullNoteDetails.fromJson(json['full_note_details']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    if (this.fullNoteDetails != null) {
      data['full_note_details'] = this.fullNoteDetails!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class FullNoteDetails {
  String? cancerHistory;
  String? skinHistory;
  List<String>? skinHistoryWithLocation;
  String? socialHistory;
  List<Medications>? medications;
  String? allergies;
  String? chiefComplain;
  String? hpi;
  ReviewOfSystem? reviewOfSystem;
  Exam? exam;
  List<ImpressionsAndPlan>? impressionsAndPlan;

  FullNoteDetails({this.cancerHistory, this.skinHistory, this.skinHistoryWithLocation, this.socialHistory, this.medications, this.allergies, this.chiefComplain, this.hpi, this.reviewOfSystem, this.exam, this.impressionsAndPlan});

  FullNoteDetails.fromJson(Map<String, dynamic> json) {
    cancerHistory = json['cancer_history'];
    skinHistory = json['skin_history'];
    skinHistoryWithLocation = json['skin_history_with_location'].cast<String>();
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
    exam = json['exam'] != null ? new Exam.fromJson(json['exam']) : null;
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
    data['skin_history_with_location'] = this.skinHistoryWithLocation;
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
    if (this.exam != null) {
      data['exam'] = this.exam!.toJson();
    }
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

class ReviewOfSystem {
  String? constitutional;
  String? skin;
  String? respiratory;
  String? cardiovascular;
  String? allergicImmunologic;

  ReviewOfSystem({this.constitutional, this.skin, this.respiratory, this.cardiovascular, this.allergicImmunologic});

  ReviewOfSystem.fromJson(Map<String, dynamic> json) {
    constitutional = json['Constitutional'];
    skin = json['Skin'];
    respiratory = json['Respiratory'];
    cardiovascular = json['Cardiovascular'];
    allergicImmunologic = json['Allergic/Immunologic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Constitutional'] = this.constitutional;
    data['Skin'] = this.skin;
    data['Respiratory'] = this.respiratory;
    data['Cardiovascular'] = this.cardiovascular;
    data['Allergic/Immunologic'] = this.allergicImmunologic;
    return data;
  }
}

class Exam {
  String? generalAppearance;
  List<Skin>? skin;
  List<String>? otherSystems;

  Exam({this.generalAppearance, this.skin, this.otherSystems});

  Exam.fromJson(Map<String, dynamic> json) {
    generalAppearance = json['general_appearance'];
    if (json['skin'] != null) {
      skin = <Skin>[];
      json['skin'].forEach((v) {
        skin!.add(new Skin.fromJson(v));
      });
    }
    otherSystems = json['other_systems'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['general_appearance'] = this.generalAppearance;
    if (this.skin != null) {
      data['skin'] = this.skin!.map((v) => v.toJson()).toList();
    }
    data['other_systems'] = this.otherSystems;
    return data;
  }
}

class Skin {
  String? location;
  String? finding;

  Skin({this.location, this.finding});

  Skin.fromJson(Map<String, dynamic> json) {
    location = json['location'];
    finding = json['finding'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['location'] = this.location;
    data['finding'] = this.finding;
    return data;
  }
}

class ImpressionsAndPlan {
  String? number;
  String? title;
  String? code;
  String? description;
  List<Treatments>? treatments;
  Procedure? procedure;
  String? medications;
  String? orders;
  String? counselingAndDiscussion;
  String? followUp;

  ImpressionsAndPlan({this.number, this.title, this.code, this.description, this.treatments, this.procedure, this.medications, this.orders, this.counselingAndDiscussion, this.followUp});

  ImpressionsAndPlan.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    title = json['title'];
    code = json['code'];
    description = json['description'];
    if (json['treatments'] != null) {
      treatments = <Treatments>[];
      json['treatments'].forEach((v) {
        treatments!.add(new Treatments.fromJson(v));
      });
    }
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
    if (this.treatments != null) {
      data['treatments'] = this.treatments!.map((v) => v.toJson()).toList();
    }
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

class Treatments {
  String? type;
  String? name;
  List<dynamic>? specifications;
  List<String>? notes;

  Treatments({this.type, this.name, this.specifications, this.notes});

  Treatments.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    name = json['name'];
    if (json['specifications'] != null) {
      specifications = [];
      json['specifications'].forEach((v) {
        // specifications!.add(new dynamic.fromJson(v));
      });
    }
    notes = json['notes'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['name'] = this.name;
    if (this.specifications != null) {
      data['specifications'] = this.specifications!.map((v) => v.toJson()).toList();
    }
    data['notes'] = this.notes;
    return data;
  }
}

class Procedure {
  String? type;
  String? location;
  String? typeWithLocation;
  Map<String, dynamic>? details;

  Procedure({this.type, this.location, this.typeWithLocation, this.details});

  Procedure.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    location = json['location'];
    typeWithLocation = json['type_with_location'];
    details = details = json['details'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['location'] = this.location;
    data['type_with_location'] = this.typeWithLocation;
    data['details'] = details;
    return data;
  }
}

class Details {
  String? handpiece;
  String? wavelength;
  String? spotSize;
  String? fluence;
  String? passes;
  String? density;
  String? anesthesia;

  Details({this.handpiece, this.wavelength, this.spotSize, this.fluence, this.passes, this.density, this.anesthesia});

  Details.fromJson(Map<String, dynamic> json) {
    handpiece = json['handpiece'];
    wavelength = json['wavelength'];
    spotSize = json['spot_size'];
    fluence = json['fluence'];
    passes = json['passes'];
    density = json['density'];
    anesthesia = json['anesthesia'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['handpiece'] = this.handpiece;
    data['wavelength'] = this.wavelength;
    data['spot_size'] = this.spotSize;
    data['fluence'] = this.fluence;
    data['passes'] = this.passes;
    data['density'] = this.density;
    data['anesthesia'] = this.anesthesia;
    return data;
  }
}

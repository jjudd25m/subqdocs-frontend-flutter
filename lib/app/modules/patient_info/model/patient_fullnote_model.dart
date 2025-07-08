// class PatientFullNoteModel {
//   PatientFullNoteResponseData? responseData;
//   String? message;
//   bool? toast;
//   String? responseType;
//
//   PatientFullNoteModel({this.responseData, this.message, this.toast, this.responseType});
//
//   PatientFullNoteModel.fromJson(Map<String, dynamic> json) {
//     responseData = json['responseData'] != null ? PatientFullNoteResponseData.fromJson(json['responseData']) : null;
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
// class PatientFullNoteResponseData {
//   int? id;
//   String? status;
//   FullNoteDetails? fullNoteDetails;
//   String? message;
//   List<Icd10Codes>? icd10Codes;
//
//   PatientFullNoteResponseData({this.id, this.status, this.fullNoteDetails, this.message, this.icd10Codes});
//
//   PatientFullNoteResponseData.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     status = json['status'];
//     fullNoteDetails = json['full_note_details'] != null ? FullNoteDetails.fromJson(json['full_note_details']) : null;
//     message = json['message'];
//     if (json['icd10Codes'] != null) {
//       icd10Codes = <Icd10Codes>[];
//       json['icd10Codes'].forEach((v) {
//         icd10Codes!.add(Icd10Codes.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['status'] = status;
//     if (fullNoteDetails != null) {
//       data['full_note_details'] = fullNoteDetails!.toJson();
//     }
//     data['message'] = message;
//     if (icd10Codes != null) {
//       data['icd10Codes'] = icd10Codes!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class FullNoteDetails {
//   String? cancerHistory;
//   String? cancerHistoryHtml;
//   String? skinHistory;
//   String? skinHistoryWithLocation;
//   String? socialHistory;
//   String? socialHistoryHtml;
//   List<Medications>? medications;
//   String? medicationsHtml;
//   String? allergies;
//   String? chiefComplain;
//   String? hpi;
//   String? reviewOfSystem;
//   String? exam;
//   List<ImpressionsAndPlan>? impressionsAndPlan;
//   FullNoteError? error;
//
//   FullNoteDetails({this.cancerHistory, this.cancerHistoryHtml, this.skinHistory, this.skinHistoryWithLocation, this.socialHistory, this.socialHistoryHtml, this.medications, this.medicationsHtml, this.allergies, this.chiefComplain, this.hpi, this.reviewOfSystem, this.exam, this.impressionsAndPlan, this.error});
//
//   FullNoteDetails.fromJson(Map<String, dynamic> json) {
//     cancerHistory = json['cancer_history'];
//     cancerHistoryHtml = json['cancer_history_html'];
//     skinHistory = json['skin_history'];
//     skinHistoryWithLocation = json['skin_history_with_location'];
//     socialHistory = json['social_history'];
//     socialHistoryHtml = json['social_history_html'];
//     if (json['medications'] != null) {
//       medications = <Medications>[];
//       json['medications'].forEach((v) {
//         medications!.add(Medications.fromJson(v));
//       });
//     }
//     medicationsHtml = json['medications_html'];
//     allergies = json['allergies'];
//     chiefComplain = json['chief_complain'];
//     hpi = json['hpi'];
//     reviewOfSystem = json['review_of_system'];
//     exam = json['exam'];
//     error = json['error'] != null ? FullNoteError.fromJson(json['error']) : null;
//     if (json['impressions_and_plan'] != null) {
//       impressionsAndPlan = <ImpressionsAndPlan>[];
//       json['impressions_and_plan'].forEach((v) {
//         impressionsAndPlan!.add(ImpressionsAndPlan.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['cancer_history'] = cancerHistory;
//     data['cancer_history_html'] = cancerHistoryHtml;
//     data['skin_history'] = skinHistory;
//     data['skin_history_with_location'] = skinHistoryWithLocation;
//     data['social_history'] = socialHistory;
//     data['social_history_html'] = socialHistoryHtml;
//     if (medications != null) {
//       data['medications'] = medications!.map((v) => v.toJson()).toList();
//     }
//     data['medications_html'] = medicationsHtml;
//     data['allergies'] = allergies;
//     data['chief_complain'] = chiefComplain;
//     data['hpi'] = hpi;
//     data['review_of_system'] = reviewOfSystem;
//     data['exam'] = exam;
//     if (this.error != null) {
//       data['error'] = this.error!.toJson();
//     }
//     if (impressionsAndPlan != null) {
//       data['impressions_and_plan'] = impressionsAndPlan!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Medications {
//   String? title;
//   String? dosage;
//   String? frequency;
//   String? route;
//   String? purpose;
//   bool? diagnosisRelated;
//   String? medicineNameWithType;
//
//   Medications({this.title, this.dosage, this.frequency, this.route, this.purpose, this.diagnosisRelated, this.medicineNameWithType});
//
//   Medications.fromJson(Map<String, dynamic> json) {
//     title = json['title'];
//     dosage = json['dosage'];
//     frequency = json['frequency'];
//     route = json['route'];
//     purpose = json['purpose'];
//     diagnosisRelated = json['diagnosis_related'];
//     medicineNameWithType = json['medicine_name_with_type'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['title'] = title;
//     data['dosage'] = dosage;
//     data['frequency'] = frequency;
//     data['route'] = route;
//     data['purpose'] = purpose;
//     data['diagnosis_related'] = diagnosisRelated;
//     data['medicine_name_with_type'] = medicineNameWithType;
//     return data;
//   }
// }
//
// class ImpressionsAndPlan {
//   String? title;
//   List<SiblingIcd10FullNote>? siblingIcd10;
//   String? content;
//
//   ImpressionsAndPlan({this.title, this.siblingIcd10, this.content});
//
//   ImpressionsAndPlan.fromJson(Map<String, dynamic> json) {
//     title = json['title'];
//     if (json['sibling_icd_10'] != null) {
//       siblingIcd10 = <SiblingIcd10FullNote>[];
//       json['sibling_icd_10'].forEach((v) {
//         siblingIcd10!.add(SiblingIcd10FullNote.fromJson(v));
//       });
//     }
//     content = json['content'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['title'] = title;
//     if (siblingIcd10 != null) {
//       data['sibling_icd_10'] = siblingIcd10!.map((v) => v.toJson()).toList();
//     }
//     data['content'] = content;
//     return data;
//   }
// }
//
// class SiblingIcd10FullNote {
//   String? code;
//   String? name;
//
//   SiblingIcd10FullNote({this.code, this.name});
//
//   SiblingIcd10FullNote.fromJson(Map<String, dynamic> json) {
//     code = json['code'];
//     name = json['name'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['code'] = code;
//     data['name'] = name;
//     return data;
//   }
// }
//
// class Icd10Codes {
//   String? code;
//   String? description;
//
//   Icd10Codes({this.code, this.description});
//
//   Icd10Codes.fromJson(Map<String, dynamic> json) {
//     code = json['code'];
//     description = json['description'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['code'] = code;
//     data['description'] = description;
//     return data;
//   }
// }
//
// class FullNoteError {
//   CancerHistory? cancerHistory;
//   CancerHistory? cancerHistoryHtml;
//   CancerHistory? skinHistory;
//   CancerHistory? skinHistoryWithLocation;
//   CancerHistory? patientSkinHistory;
//   CancerHistory? socialHistory;
//   CancerHistory? socialHistoryHtml;
//   CancerHistory? medications;
//   CancerHistory? medicationsHtml;
//   CancerHistory? newMedicationsHtml;
//   CancerHistory? allergies;
//   CancerHistory? chiefComplain;
//   CancerHistory? hpi;
//   CancerHistory? reviewOfSystem;
//   CancerHistory? exam;
//   CancerHistory? impressionsAndPlan;
//
//   FullNoteError({this.cancerHistory, this.cancerHistoryHtml, this.skinHistory, this.skinHistoryWithLocation, this.patientSkinHistory, this.socialHistory, this.socialHistoryHtml, this.medications, this.medicationsHtml, this.newMedicationsHtml, this.allergies, this.chiefComplain, this.hpi, this.reviewOfSystem, this.exam, this.impressionsAndPlan});
//
//   FullNoteError.fromJson(Map<String, dynamic> json) {
//     cancerHistory = json['cancer_history'] != null ? CancerHistory.fromJson(json['cancer_history']) : null;
//     cancerHistoryHtml = json['cancer_history_html'] != null ? CancerHistory.fromJson(json['cancer_history_html']) : null;
//     skinHistory = json['skin_history'] != null ? CancerHistory.fromJson(json['skin_history']) : null;
//     skinHistoryWithLocation = json['skin_history_with_location'] != null ? CancerHistory.fromJson(json['skin_history_with_location']) : null;
//     patientSkinHistory = json['patient_skin_history'] != null ? CancerHistory.fromJson(json['patient_skin_history']) : null;
//     socialHistory = json['social_history'] != null ? CancerHistory.fromJson(json['social_history']) : null;
//     socialHistoryHtml = json['social_history_html'] != null ? CancerHistory.fromJson(json['social_history_html']) : null;
//     medications = json['medications'] != null ? CancerHistory.fromJson(json['medications']) : null;
//     medicationsHtml = json['medications_html'] != null ? CancerHistory.fromJson(json['medications_html']) : null;
//     newMedicationsHtml = json['new_medications_html'] != null ? CancerHistory.fromJson(json['new_medications_html']) : null;
//     allergies = json['allergies'] != null ? CancerHistory.fromJson(json['allergies']) : null;
//     chiefComplain = json['chief_complain'] != null ? CancerHistory.fromJson(json['chief_complain']) : null;
//     hpi = json['hpi'] != null ? CancerHistory.fromJson(json['hpi']) : null;
//     reviewOfSystem = json['review_of_system'] != null ? CancerHistory.fromJson(json['review_of_system']) : null;
//     exam = json['exam'] != null ? CancerHistory.fromJson(json['exam']) : null;
//     impressionsAndPlan = json['impressions_and_plan'] != null ? CancerHistory.fromJson(json['impressions_and_plan']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     if (cancerHistory != null) {
//       data['cancer_history'] = cancerHistory!.toJson();
//     }
//     if (cancerHistoryHtml != null) {
//       data['cancer_history_html'] = cancerHistoryHtml!.toJson();
//     }
//     if (skinHistory != null) {
//       data['skin_history'] = skinHistory!.toJson();
//     }
//     if (skinHistoryWithLocation != null) {
//       data['skin_history_with_location'] = skinHistoryWithLocation!.toJson();
//     }
//     if (patientSkinHistory != null) {
//       data['patient_skin_history'] = patientSkinHistory!.toJson();
//     }
//     if (socialHistory != null) {
//       data['social_history'] = socialHistory!.toJson();
//     }
//     if (socialHistoryHtml != null) {
//       data['social_history_html'] = socialHistoryHtml!.toJson();
//     }
//     if (medications != null) {
//       data['medications'] = medications!.toJson();
//     }
//     if (medicationsHtml != null) {
//       data['medications_html'] = medicationsHtml!.toJson();
//     }
//     if (newMedicationsHtml != null) {
//       data['new_medications_html'] = newMedicationsHtml!.toJson();
//     }
//     if (allergies != null) {
//       data['allergies'] = allergies!.toJson();
//     }
//     if (chiefComplain != null) {
//       data['chief_complain'] = chiefComplain!.toJson();
//     }
//     if (hpi != null) {
//       data['hpi'] = hpi!.toJson();
//     }
//     if (reviewOfSystem != null) {
//       data['review_of_system'] = reviewOfSystem!.toJson();
//     }
//     if (exam != null) {
//       data['exam'] = exam!.toJson();
//     }
//     if (impressionsAndPlan != null) {
//       data['impressions_and_plan'] = impressionsAndPlan!.toJson();
//     }
//     return data;
//   }
// }
//
// class CancerHistory {
//   String? status;
//   String? message;
//
//   CancerHistory({this.status, this.message});
//
//   CancerHistory.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     data['status'] = status;
//     data['message'] = message;
//     return data;
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:subqdocs/app/core/common/logger.dart';

class PatientFullNoteModel {
  PatientFullNoteResponseData? responseData;
  String? message;
  bool? toast;
  String? responseType;

  PatientFullNoteModel({this.responseData, this.message, this.toast, this.responseType});

  PatientFullNoteModel.fromJson(Map<String, dynamic> json) {
    responseData = json['responseData'] != null ? PatientFullNoteResponseData.fromJson(json['responseData']) : null;
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

class PatientFullNoteResponseData {
  int? id;
  String? status;
  FullNoteDetails? fullNoteDetails;
  String? message;
  List<Icd10Codes>? icd10Codes;

  PatientFullNoteResponseData({this.id, this.status, this.fullNoteDetails, this.message, this.icd10Codes});

  PatientFullNoteResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    fullNoteDetails = json['full_note_details'] != null ? FullNoteDetails.fromJson(json['full_note_details']) : null;
    message = json['message'];
    if (json['icd10Codes'] != null) {
      icd10Codes = <Icd10Codes>[];
      json['icd10Codes'].forEach((v) {
        icd10Codes!.add(Icd10Codes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    if (fullNoteDetails != null) {
      data['full_note_details'] = fullNoteDetails!.toJson();
    }
    data['message'] = message;
    if (icd10Codes != null) {
      data['icd10Codes'] = icd10Codes!.map((v) => v.toJson()).toList();
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
  bool? isImageGenerated;
  FullNoteError? error;

  FullNoteDetails({this.cancerHistory, this.cancerHistoryHtml, this.skinHistory, this.skinHistoryWithLocation, this.socialHistory, this.socialHistoryHtml, this.medications, this.medicationsHtml, this.allergies, this.chiefComplain, this.hpi, this.reviewOfSystem, this.exam, this.impressionsAndPlan, this.error, this.isImageGenerated});

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
    allergies = json['allergies'];
    chiefComplain = json['chief_complain'];
    hpi = json['hpi'];
    reviewOfSystem = json['review_of_system'];
    exam = json['exam'];
    error = json['error'] != null ? FullNoteError.fromJson(json['error']) : null;
    if (json['impressions_and_plan'] != null) {
      impressionsAndPlan = <ImpressionsAndPlan>[];
      json['impressions_and_plan'].forEach((v) {
        impressionsAndPlan!.add(ImpressionsAndPlan.fromJson(v));
      });
    }
    isImageGenerated = json['is_image_generated'];
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
    data['allergies'] = allergies;
    data['chief_complain'] = chiefComplain;
    data['hpi'] = hpi;
    data['review_of_system'] = reviewOfSystem;
    data['exam'] = exam;
    if (error != null) {
      data['error'] = error!.toJson();
    }
    if (impressionsAndPlan != null) {
      data['impressions_and_plan'] = impressionsAndPlan!.map((v) => v.toJson()).toList();
    }
    data['is_image_generated'] = isImageGenerated;

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

// class ImpressionsAndPlan {
//   String? title;
//   List<SiblingIcd10FullNote>? siblingIcd10;
//   String? content;
//   List<FileAttachment>? attachments;
//
//   ImpressionsAndPlan({this.title, this.siblingIcd10, this.content, this.attachments});
//
//   ImpressionsAndPlan.fromJson(Map<String, dynamic> json) {
//     title = json['title'];
//     if (json['sibling_icd_10'] != null) {
//       siblingIcd10 = <SiblingIcd10FullNote>[];
//       json['sibling_icd_10'].forEach((v) {
//         siblingIcd10!.add(SiblingIcd10FullNote.fromJson(v));
//       });
//     }
//     content = json['content'];
//     if (json['attachments'] != null) {
//       attachments = <FileAttachment>[];
//       json['attachments'].forEach((v) {
//         attachments!.add(FileAttachment.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['title'] = title;
//     if (siblingIcd10 != null) {
//       data['sibling_icd_10'] = siblingIcd10!.map((v) => v.toJson()).toList();
//     }
//     data['content'] = content;
//     if (attachments != null) {
//       data['attachments'] = attachments!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

class ImpressionsAndPlan {
  String? title;
  List<SiblingIcd10FullNote>? siblingIcd10;
  String? content;
  List<Attachments>? attachments;

  ImpressionsAndPlan({this.title, this.siblingIcd10, this.content, this.attachments});

  ImpressionsAndPlan.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    if (json['sibling_icd_10'] != null) {
      siblingIcd10 = <SiblingIcd10FullNote>[];
      json['sibling_icd_10'].forEach((v) {
        siblingIcd10!.add(SiblingIcd10FullNote.fromJson(v));
      });
    }
    content = json['content'];
    customPrint("messages: attachment $json");
    if (json['attachments'] != null) {
      attachments = <Attachments>[];
      json['attachments'].forEach((v) {
        customPrint("messages: attachment $v");
        attachments!.add(Attachments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    if (siblingIcd10 != null) {
      data['sibling_icd_10'] = siblingIcd10!.map((v) => v.toJson()).toList();
    }
    data['content'] = content;
    if (attachments != null) {
      data['attachments'] = attachments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SiblingIcd10FullNote {
  String? code;
  String? name;

  SiblingIcd10FullNote({this.code, this.name});

  SiblingIcd10FullNote.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['name'] = name;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['description'] = description;
    return data;
  }
}

class FullNoteError {
  CancerHistory? cancerHistory;
  CancerHistory? cancerHistoryHtml;
  CancerHistory? skinHistory;
  CancerHistory? skinHistoryWithLocation;
  CancerHistory? patientSkinHistory;
  CancerHistory? socialHistory;
  CancerHistory? socialHistoryHtml;
  CancerHistory? medications;
  CancerHistory? medicationsHtml;
  CancerHistory? newMedicationsHtml;
  CancerHistory? allergies;
  CancerHistory? chiefComplain;
  CancerHistory? hpi;
  CancerHistory? reviewOfSystem;
  CancerHistory? exam;
  CancerHistory? impressionsAndPlan;

  FullNoteError({this.cancerHistory, this.cancerHistoryHtml, this.skinHistory, this.skinHistoryWithLocation, this.patientSkinHistory, this.socialHistory, this.socialHistoryHtml, this.medications, this.medicationsHtml, this.newMedicationsHtml, this.allergies, this.chiefComplain, this.hpi, this.reviewOfSystem, this.exam, this.impressionsAndPlan});

  FullNoteError.fromJson(Map<String, dynamic> json) {
    cancerHistory = json['cancer_history'] != null ? CancerHistory.fromJson(json['cancer_history']) : null;
    cancerHistoryHtml = json['cancer_history_html'] != null ? CancerHistory.fromJson(json['cancer_history_html']) : null;
    skinHistory = json['skin_history'] != null ? CancerHistory.fromJson(json['skin_history']) : null;
    skinHistoryWithLocation = json['skin_history_with_location'] != null ? CancerHistory.fromJson(json['skin_history_with_location']) : null;
    patientSkinHistory = json['patient_skin_history'] != null ? CancerHistory.fromJson(json['patient_skin_history']) : null;
    socialHistory = json['social_history'] != null ? CancerHistory.fromJson(json['social_history']) : null;
    socialHistoryHtml = json['social_history_html'] != null ? CancerHistory.fromJson(json['social_history_html']) : null;
    medications = json['medications'] != null ? CancerHistory.fromJson(json['medications']) : null;
    medicationsHtml = json['medications_html'] != null ? CancerHistory.fromJson(json['medications_html']) : null;
    newMedicationsHtml = json['new_medications_html'] != null ? CancerHistory.fromJson(json['new_medications_html']) : null;
    allergies = json['allergies'] != null ? CancerHistory.fromJson(json['allergies']) : null;
    chiefComplain = json['chief_complain'] != null ? CancerHistory.fromJson(json['chief_complain']) : null;
    hpi = json['hpi'] != null ? CancerHistory.fromJson(json['hpi']) : null;
    reviewOfSystem = json['review_of_system'] != null ? CancerHistory.fromJson(json['review_of_system']) : null;
    exam = json['exam'] != null ? CancerHistory.fromJson(json['exam']) : null;
    impressionsAndPlan = json['impressions_and_plan'] != null ? CancerHistory.fromJson(json['impressions_and_plan']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (cancerHistory != null) {
      data['cancer_history'] = cancerHistory!.toJson();
    }
    if (cancerHistoryHtml != null) {
      data['cancer_history_html'] = cancerHistoryHtml!.toJson();
    }
    if (skinHistory != null) {
      data['skin_history'] = skinHistory!.toJson();
    }
    if (skinHistoryWithLocation != null) {
      data['skin_history_with_location'] = skinHistoryWithLocation!.toJson();
    }
    if (patientSkinHistory != null) {
      data['patient_skin_history'] = patientSkinHistory!.toJson();
    }
    if (socialHistory != null) {
      data['social_history'] = socialHistory!.toJson();
    }
    if (socialHistoryHtml != null) {
      data['social_history_html'] = socialHistoryHtml!.toJson();
    }
    if (medications != null) {
      data['medications'] = medications!.toJson();
    }
    if (medicationsHtml != null) {
      data['medications_html'] = medicationsHtml!.toJson();
    }
    if (newMedicationsHtml != null) {
      data['new_medications_html'] = newMedicationsHtml!.toJson();
    }
    if (allergies != null) {
      data['allergies'] = allergies!.toJson();
    }
    if (chiefComplain != null) {
      data['chief_complain'] = chiefComplain!.toJson();
    }
    if (hpi != null) {
      data['hpi'] = hpi!.toJson();
    }
    if (reviewOfSystem != null) {
      data['review_of_system'] = reviewOfSystem!.toJson();
    }
    if (exam != null) {
      data['exam'] = exam!.toJson();
    }
    if (impressionsAndPlan != null) {
      data['impressions_and_plan'] = impressionsAndPlan!.toJson();
    }
    return data;
  }
}

class CancerHistory {
  String? status;
  String? message;

  CancerHistory({this.status, this.message});

  CancerHistory.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}

class Attachments {
  int? id;
  String? fileName;
  String? filePath;
  String? fileType;
  int? fileSize;
  int? uploadedBy;
  String? uploadedAt;
  int? visitId;
  int? patientId;
  bool? isActive;
  String? timestamp;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  FocusNode focusNode = FocusNode();

  Attachments({this.id, this.fileName, this.filePath, this.fileType, this.fileSize, this.uploadedBy, this.uploadedAt, this.visitId, this.patientId, this.isActive, this.timestamp, this.createdAt, this.updatedAt, this.deletedAt});

  Attachments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fileName = json['file_name'];
    filePath = json['file_path'];
    fileType = json['file_type'];
    fileSize = json['file_size'];
    uploadedBy = json['uploaded_by'];
    uploadedAt = json['uploaded_at'];
    visitId = json['visit_id'];
    patientId = json['patient_id'];
    isActive = json['is_active'];
    timestamp = json['timestamp'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['file_name'] = fileName;
    data['file_path'] = filePath;
    data['file_type'] = fileType;
    data['file_size'] = fileSize;
    data['uploaded_by'] = uploadedBy;
    data['uploaded_at'] = uploadedAt;
    data['visit_id'] = visitId;
    data['patient_id'] = patientId;
    data['is_active'] = isActive;
    data['timestamp'] = timestamp;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}

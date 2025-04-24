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
//   String? chiefComplain;
//   String? hpi;
//   List<String>? reviewOfSystem;
//   List<String>? exam;
//   List<ImpressionsAndPlan>? impressionsAndPlan;
//
//   FullNoteDetails({this.cancerHistory, this.skinHistory, this.socialHistory, this.medications, this.allergies, this.chiefComplain, this.hpi, this.reviewOfSystem, this.exam, this.impressionsAndPlan});
//
//   FullNoteDetails.fromJson(Map<String, dynamic> json) {
//     cancerHistory = json['cancer_history'].cast<String>();
//     skinHistory = json['skin_history'].cast<String>();
//     socialHistory = json['social_history'].cast<String>();
//     medications = json['medications'].cast<String>();
//     allergies = json['allergies'].cast<String>();
//     chiefComplain = json['chief_complain'];
//     hpi = json['hpi'];
//     reviewOfSystem = json['review_of_system'].cast<String>();
//     exam = json['exam'].cast<String>();
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
//     data['skin_history'] = skinHistory;
//     data['social_history'] = socialHistory;
//     data['medications'] = medications;
//     data['allergies'] = allergies;
//     data['chief_complain'] = chiefComplain;
//     data['hpi'] = hpi;
//     data['review_of_system'] = reviewOfSystem;
//     data['exam'] = exam;
//     if (impressionsAndPlan != null) {
//       data['impressions_and_plan'] = impressionsAndPlan!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class ImpressionsAndPlan {
//   String? number;
//   String? title;
//   String? code;
//   String? description;
//
//   ImpressionsAndPlan({this.number, this.title, this.code, this.description});
//
//   ImpressionsAndPlan.fromJson(Map<String, dynamic> json) {
//     number = json['number'];
//     title = json['title'];
//     code = json['code'];
//     description = json['description'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['number'] = number;
//     data['title'] = title;
//     data['code'] = code;
//     data['description'] = description;
//     return data;
//   }
// }
//
// class Medications {
//   String? name;
//   String? dosage;
//
//   Medications({this.name, this.dosage});
//
//   Medications.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     dosage = json['dosage'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['name'] = name;
//     data['dosage'] = dosage;
//     return data;
//   }
// }
//
// class Procedures {
//   String? name;
//   String? cptCode;
//
//   Procedures({this.name, this.cptCode});
//
//   Procedures.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     cptCode = json['cpt_code'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['name'] = name;
//     data['cpt_code'] = cptCode;
//     return data;
//   }
// }
//---------------------------------------------------------------------
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
//   List<Medications>? medications;
//   List<String>? allergies;
//   String? chiefComplain;
//   String? hpi;
//   List<String>? reviewOfSystem;
//   List<String>? exam;
//   List<ImpressionsAndPlan>? impressionsAndPlan;
//
//   FullNoteDetails(
//       {this.cancerHistory,
//       this.skinHistory,
//       this.socialHistory,
//       this.medications,
//       this.allergies,
//       this.chiefComplain,
//       this.hpi,
//       this.reviewOfSystem,
//       this.exam,
//       this.impressionsAndPlan});
//
//   FullNoteDetails.fromJson(Map<String, dynamic> json) {
//     if (json['cancer_history'] != null) {
//       cancerHistory = json['cancer_history'].cast<String>();
//       // json['cancer_history'].forEach((v) {
//       //   cancerHistory!.add(new Null.fromJson(v));
//       // });
//     }
//     skinHistory = json['skin_history'].cast<String>();
//     if (json['social_history'] != null) {
//       socialHistory = json['social_history'].cast<String>();
//       // json['social_history'].forEach((v) {
//       //   socialHistory!.add(new Null.fromJson(v));
//       // });
//     }
//     if (json['medications'] != null) {
//       medications = <Medications>[];
//       json['medications'].forEach((v) {
//         medications!.add(Medications.fromJson(v));
//       });
//     }
//     allergies = json['allergies'].cast<String>();
//     chiefComplain = json['chief_complain'];
//     hpi = json['hpi'];
//     reviewOfSystem = json['review_of_system'].cast<String>();
//     exam = json['exam'].cast<String>();
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
//     if (cancerHistory != null) {
//       data['cancer_history'] = cancerHistory;
//     }
//     data['skin_history'] = skinHistory;
//     if (socialHistory != null) {
//       data['social_history'] = socialHistory;
//     }
//     if (medications != null) {
//       data['medications'] = medications!.map((v) => v.toJson()).toList();
//     }
//     data['allergies'] = allergies;
//     data['chief_complain'] = chiefComplain;
//     data['hpi'] = hpi;
//     data['review_of_system'] = reviewOfSystem;
//     data['exam'] = exam;
//     if (impressionsAndPlan != null) {
//       data['impressions_and_plan'] = impressionsAndPlan!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Medications {
//   String? name;
//   String? dosage;
//
//   Medications({this.name, this.dosage});
//
//   Medications.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     dosage = json['dosage'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['name'] = name;
//     data['dosage'] = dosage;
//     return data;
//   }
// }
//
// class ImpressionsAndPlan {
//   String? number;
//   String? title;
//   String? code;
//   String? description;
//
//   ImpressionsAndPlan({this.number, this.title, this.code, this.description});
//
//   ImpressionsAndPlan.fromJson(Map<String, dynamic> json) {
//     number = json['number'];
//     title = json['title'];
//     code = json['code'];
//     description = json['description'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['number'] = number;
//     data['title'] = title;
//     data['code'] = code;
//     data['description'] = description;
//     return data;
//   }
// }
//-----------------------------------------------

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
//   String? message;
//
//   ResponseData({this.id, this.status, this.fullNoteDetails, this.message});
//
//   ResponseData.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     status = json['status'];
//     message = json['message'];
//     fullNoteDetails = json['full_note_details'] != null ? FullNoteDetails.fromJson(json['full_note_details']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['message'] = message;
//     data['status'] = status;
//     if (fullNoteDetails != null) {
//       data['full_note_details'] = fullNoteDetails!.toJson();
//     }
//     return data;
//   }
// }
//
// class FullNoteDetails {
//   String? cancerHistory;
//   String? skinHistory;
//   String? socialHistory;
//   List<Medications>? medications;
//   String? allergies;
//   String? chiefComplain;
//   String? hpi;
//   ReviewOfSystem? reviewOfSystem;
//   String? exam;
//   List<ImpressionsAndPlan>? impressionsAndPlan;
//
//   FullNoteDetails({this.cancerHistory, this.skinHistory, this.socialHistory, this.medications, this.allergies, this.chiefComplain, this.hpi, this.reviewOfSystem, this.exam, this.impressionsAndPlan});
//
//   FullNoteDetails.fromJson(Map<String, dynamic> json) {
//     cancerHistory = json['cancer_history'];
//     skinHistory = json['skin_history'];
//     socialHistory = json['social_history'];
//     if (json['medications'] != null) {
//       medications = <Medications>[];
//       json['medications'].forEach((v) {
//         medications!.add(Medications.fromJson(v));
//       });
//     }
//     allergies = json['allergies'];
//     chiefComplain = json['chief_complain'];
//     hpi = json['hpi'];
//     reviewOfSystem = json['review_of_system'] != null ? ReviewOfSystem.fromJson(json['review_of_system']) : null;
//     exam = json['exam'];
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
//     data['skin_history'] = skinHistory;
//     data['social_history'] = socialHistory;
//     if (medications != null) {
//       data['medications'] = medications!.map((v) => v.toJson()).toList();
//     }
//     data['allergies'] = allergies;
//     data['chief_complain'] = chiefComplain;
//     data['hpi'] = hpi;
//     if (reviewOfSystem != null) {
//       data['review_of_system'] = reviewOfSystem!.toJson();
//     }
//     data['exam'] = exam;
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
//   String? purpose;
//
//   Medications({this.title, this.dosage, this.purpose});
//
//   Medications.fromJson(Map<String, dynamic> json) {
//     title = json['title'];
//     dosage = json['dosage'];
//     purpose = json['purpose'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['title'] = title;
//     data['dosage'] = dosage;
//     data['purpose'] = purpose;
//     return data;
//   }
// }
//
// class ReviewOfSystem {
//   String? constitutional;
//   String? skin;
//   String? respiratory;
//   String? cardiovascular;
//   String? allergicImmunologic;
//   String? other;
//
//   ReviewOfSystem({this.constitutional, this.skin, this.respiratory, this.cardiovascular, this.allergicImmunologic, this.other});
//
//   ReviewOfSystem.fromJson(Map<String, dynamic> json) {
//     constitutional = json['Constitutional'];
//     skin = json['Skin'];
//     respiratory = json['Respiratory'];
//     cardiovascular = json['Cardiovascular'];
//     allergicImmunologic = json['Allergic/Immunologic'];
//     other = json['Other'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['Constitutional'] = constitutional;
//     data['Skin'] = skin;
//     data['Respiratory'] = respiratory;
//     data['Cardiovascular'] = cardiovascular;
//     data['Allergic/Immunologic'] = allergicImmunologic;
//     data['Other'] = other;
//     return data;
//   }
// }
//
// class ImpressionsAndPlan {
//   String? number;
//   String? title;
//   String? code;
//   String? description;
//   Procedure? procedure;
//   String? medications;
//   String? orders;
//   String? counselingAndDiscussion;
//   String? followUp;
//
//   ImpressionsAndPlan({this.number, this.title, this.code, this.description, this.procedure, this.medications, this.orders, this.counselingAndDiscussion, this.followUp});
//
//   ImpressionsAndPlan.fromJson(Map<String, dynamic> json) {
//     number = json['number'];
//     title = json['title'];
//     code = json['code'];
//     description = json['description'];
//     procedure = json['procedure'] != null ? Procedure.fromJson(json['procedure']) : null;
//     medications = json['medications'];
//     orders = json['orders'];
//     counselingAndDiscussion = json['counseling_and_discussion'];
//     followUp = json['follow_up'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['number'] = number;
//     data['title'] = title;
//     data['code'] = code;
//     data['description'] = description;
//     if (procedure != null) {
//       data['procedure'] = procedure!.toJson();
//     }
//     data['medications'] = medications;
//     data['orders'] = orders;
//     data['counseling_and_discussion'] = counselingAndDiscussion;
//     data['follow_up'] = followUp;
//     return data;
//   }
// }
//
// class Procedure {
//   String? type;
//   List<String>? details;
//
//   Procedure({this.type, this.details});
//
//   Procedure.fromJson(Map<String, dynamic> json) {
//     type = json['type'];
//     details = json['details'].cast<String>();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['type'] = type;
//     data['details'] = details;
//     return data;
//   }
// }

//----------------------------------

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
//   String? message;
//
//   ResponseData({this.id, this.status, this.fullNoteDetails, this.message});
//
//   ResponseData.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     status = json['status'];
//     message = json['message'];
//     fullNoteDetails = json['full_note_details'] != null ? FullNoteDetails.fromJson(json['full_note_details']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['message'] = message;
//     data['status'] = status;
//     if (fullNoteDetails != null) {
//       data['full_note_details'] = fullNoteDetails!.toJson();
//     }
//     return data;
//   }
// }
//
// class FullNoteDetails {
//   String? cancerHistory;
//   String? skinHistory;
//   String? socialHistory;
//   List<Medications>? medications;
//   String? allergies;
//   String? chiefComplain;
//   String? hpi;
//   ReviewOfSystem? reviewOfSystem;
//   String? exam;
//   List<ImpressionsAndPlan>? impressionsAndPlan;
//
//   FullNoteDetails({this.cancerHistory, this.skinHistory, this.socialHistory, this.medications, this.allergies, this.chiefComplain, this.hpi, this.reviewOfSystem, this.exam, this.impressionsAndPlan});
//
//   FullNoteDetails.fromJson(Map<String, dynamic> json) {
//     cancerHistory = json['cancer_history'];
//     skinHistory = json['skin_history'];
//     socialHistory = json['social_history'];
//     if (json['medications'] != null) {
//       medications = <Medications>[];
//       json['medications'].forEach((v) {
//         medications!.add(Medications.fromJson(v));
//       });
//     }
//     allergies = json['allergies'];
//     chiefComplain = json['chief_complain'];
//     hpi = json['hpi'];
//     reviewOfSystem = json['review_of_system'] != null ? ReviewOfSystem.fromJson(json['review_of_system']) : null;
//     exam = json['exam'];
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
//     data['skin_history'] = skinHistory;
//     data['social_history'] = socialHistory;
//     if (medications != null) {
//       data['medications'] = medications!.map((v) => v.toJson()).toList();
//     }
//     data['allergies'] = allergies;
//     data['chief_complain'] = chiefComplain;
//     data['hpi'] = hpi;
//     if (reviewOfSystem != null) {
//       data['review_of_system'] = reviewOfSystem!.toJson();
//     }
//     data['exam'] = exam;
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
//   String? purpose;
//
//   Medications({this.title, this.dosage, this.purpose});
//
//   Medications.fromJson(Map<String, dynamic> json) {
//     title = json['title'];
//     dosage = json['dosage'];
//     purpose = json['purpose'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['title'] = title;
//     data['dosage'] = dosage;
//     data['purpose'] = purpose;
//     return data;
//   }
// }
//
// class ReviewOfSystem {
//   String? constitutional;
//   String? skin;
//   String? respiratory;
//   String? cardiovascular;
//   String? allergicImmunologic;
//   String? other;
//
//   ReviewOfSystem({this.constitutional, this.skin, this.respiratory, this.cardiovascular, this.allergicImmunologic, this.other});
//
//   ReviewOfSystem.fromJson(Map<String, dynamic> json) {
//     constitutional = json['Constitutional'];
//     skin = json['Skin'];
//     respiratory = json['Respiratory'];
//     cardiovascular = json['Cardiovascular'];
//     allergicImmunologic = json['Allergic/Immunologic'];
//     other = json['Other'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['Constitutional'] = constitutional;
//     data['Skin'] = skin;
//     data['Respiratory'] = respiratory;
//     data['Cardiovascular'] = cardiovascular;
//     data['Allergic/Immunologic'] = allergicImmunologic;
//     data['Other'] = other;
//     return data;
//   }
// }
//
// class ImpressionsAndPlan {
//   String? number;
//   String? title;
//   String? code;
//   String? description;
//   Procedure? procedure;
//   String? medications;
//   String? orders;
//   String? counselingAndDiscussion;
//   String? followUp;
//
//   ImpressionsAndPlan({this.number, this.title, this.code, this.description, this.procedure, this.medications, this.orders, this.counselingAndDiscussion, this.followUp});
//
//   ImpressionsAndPlan.fromJson(Map<String, dynamic> json) {
//     number = json['number'];
//     title = json['title'];
//     code = json['code'];
//     description = json['description'];
//     procedure = json['procedure'] != null ? Procedure.fromJson(json['procedure']) : null;
//     medications = json['medications'];
//     orders = json['orders'];
//     counselingAndDiscussion = json['counseling_and_discussion'];
//     followUp = json['follow_up'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['number'] = number;
//     data['title'] = title;
//     data['code'] = code;
//     data['description'] = description;
//     if (procedure != null) {
//       data['procedure'] = procedure!.toJson();
//     }
//     data['medications'] = medications;
//     data['orders'] = orders;
//     data['counseling_and_discussion'] = counselingAndDiscussion;
//     data['follow_up'] = followUp;
//     return data;
//   }
// }
//
// class Procedure {
//   String? type;
//   List<String>? details;
//
//   Procedure({this.type, this.details});
//
//   Procedure.fromJson(Map<String, dynamic> json) {
//     type = json['type'];
//     details = json['details'].cast<String>();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['type'] = type;
//     data['details'] = details;
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
  String? message;

  ResponseData({this.id, this.status, this.fullNoteDetails, this.message});

  ResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    fullNoteDetails = json['full_note_details'] != null ? FullNoteDetails.fromJson(json['full_note_details']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    if (fullNoteDetails != null) {
      data['full_note_details'] = fullNoteDetails!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class FullNoteDetails {
  String? cancerHistory;
  String? skinHistory;
  String? socialHistory;

  // List<Null>? medications;
  String? allergies;
  String? chiefComplain;
  String? hpi;
  ReviewOfSystem? reviewOfSystem;
  Exam? exam;
  List<ImpressionsAndPlan>? impressionsAndPlan;

  FullNoteDetails({
    this.cancerHistory,
    this.skinHistory,
    this.socialHistory,
    // this.medications,
    this.allergies,
    this.chiefComplain,
    this.hpi,
    this.reviewOfSystem,
    this.exam,
    this.impressionsAndPlan,
  });

  FullNoteDetails.fromJson(Map<String, dynamic> json) {
    cancerHistory = json['cancer_history'];
    skinHistory = json['skin_history'];
    socialHistory = json['social_history'];
    // if (json['medications'] != null) {
    //   medications = <Null>[];
    //   json['medications'].forEach((v) {
    //     medications!.add(Null.fromJson(v));
    //   });
    // }
    allergies = json['allergies'];
    chiefComplain = json['chief_complain'];
    hpi = json['hpi'];
    reviewOfSystem = json['review_of_system'] != null ? ReviewOfSystem.fromJson(json['review_of_system']) : null;
    exam = json['exam'] != null ? Exam.fromJson(json['exam']) : null;
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
    // if (medications != null) {
    //   data['medications'] = medications!.map((v) => v.toJson()).toList();
    // }
    data['allergies'] = allergies;
    data['chief_complain'] = chiefComplain;
    data['hpi'] = hpi;
    if (reviewOfSystem != null) {
      data['review_of_system'] = reviewOfSystem!.toJson();
    }
    if (exam != null) {
      data['exam'] = exam!.toJson();
    }
    if (impressionsAndPlan != null) {
      data['impressions_and_plan'] = impressionsAndPlan!.map((v) => v.toJson()).toList();
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

  Medications({this.title, this.dosage, this.frequency, this.route, this.purpose, this.diagnosisRelated});

  Medications.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    dosage = json['dosage'];
    frequency = json['frequency'];
    route = json['route'];
    purpose = json['purpose'];
    diagnosisRelated = json['diagnosis_related'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['dosage'] = dosage;
    data['frequency'] = frequency;
    data['route'] = route;
    data['purpose'] = purpose;
    data['diagnosis_related'] = diagnosisRelated;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Constitutional'] = constitutional;
    data['Skin'] = skin;
    data['Respiratory'] = respiratory;
    data['Cardiovascular'] = cardiovascular;
    data['Allergic/Immunologic'] = allergicImmunologic;
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
        skin!.add(Skin.fromJson(v));
      });
    }
    otherSystems = json['other_systems'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['general_appearance'] = generalAppearance;
    if (skin != null) {
      data['skin'] = skin!.map((v) => v.toJson()).toList();
    }
    data['other_systems'] = otherSystems;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['location'] = location;
    data['finding'] = finding;
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
        treatments!.add(Treatments.fromJson(v));
      });
    }
    procedure = json['procedure'] != null ? Procedure.fromJson(json['procedure']) : null;
    medications = json['medications'];
    orders = json['orders'];
    counselingAndDiscussion = json['counseling_and_discussion'];
    followUp = json['follow_up'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['number'] = number;
    data['title'] = title;
    data['code'] = code;
    data['description'] = description;
    if (treatments != null) {
      data['treatments'] = treatments!.map((v) => v.toJson()).toList();
    }
    if (procedure != null) {
      data['procedure'] = procedure!.toJson();
    }
    data['medications'] = medications;
    data['orders'] = orders;
    data['counseling_and_discussion'] = counselingAndDiscussion;
    data['follow_up'] = followUp;
    return data;
  }
}

class Treatments {
  String? type;
  String? name;
  List<String>? specifications;
  List<String>? notes;

  Treatments({this.type, this.name, this.specifications, this.notes});

  Treatments.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    name = json['name'];
    specifications = json['specifications'].cast<String>();
    // if (json['specifications'] != null) {
    //   specifications = <String>[];
    //   json['specifications'].forEach((v) {
    //     specifications!.add(new Null.fromJson(v));
    //   });
    // }
    notes = json['notes'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['name'] = name;
    data['specifications'] = specifications;
    // if (this.specifications != null) {
    //   data['specifications'] = this.specifications!.map((v) => v.toJson()).toList();
    // }
    data['notes'] = notes;
    return data;
  }
}

class Procedure {
  String? type;
  Map<String, dynamic>? details;

  // List<String>? details;

  Procedure({this.type, this.details});

  Procedure.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    details = json['details'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['details'] = details;
    return data;
  }
}

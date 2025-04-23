// // class DoctorViewModel {
// //   DoctorViewResponseData? responseData;
// //   String? message;
// //   bool? toast;
// //   String? responseType;
// //
// //   DoctorViewModel({this.responseData, this.message, this.toast, this.responseType});
// //
// //   DoctorViewModel.fromJson(Map<String, dynamic> json) {
// //     responseData = json['responseData'] != null ? DoctorViewResponseData.fromJson(json['responseData']) : null;
// //     message = json['message'];
// //     toast = json['toast'];
// //     responseType = json['response_type'];
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = <String, dynamic>{};
// //     if (responseData != null) {
// //       data['responseData'] = responseData!.toJson();
// //     }
// //     data['message'] = message;
// //     data['toast'] = toast;
// //     data['response_type'] = responseType;
// //     return data;
// //   }
// // }
// //
// // class DoctorViewResponseData {
// //   int? id;
// //   int? patientId;
// //   int? visitId;
// //   String? status;
// //   String? visitDate;
// //   DiagnosisCodesProcedures? diagnosisCodesProcedures;
// //   Null? impressionsAndPlan;
// //   Null? totalCharges;
// //   String? createdAt;
// //   String? updatedAt;
// //   Null? deletedAt;
// //
// //   DoctorViewResponseData(
// //       {this.id, this.patientId, this.visitId, this.status, this.visitDate, this.diagnosisCodesProcedures, this.impressionsAndPlan, this.totalCharges, this.createdAt, this.updatedAt, this.deletedAt});
// //
// //   DoctorViewResponseData.fromJson(Map<String, dynamic> json) {
// //     id = json['id'];
// //     patientId = json['patient_id'];
// //     visitId = json['visit_id'];
// //     status = json['status'];
// //     visitDate = json['visit_date'];
// //     diagnosisCodesProcedures = json['diagnosis_codes_procedures'] != null ? DiagnosisCodesProcedures.fromJson(json['diagnosis_codes_procedures']) : null;
// //     impressionsAndPlan = json['impressions_and_plan'];
// //     totalCharges = json['total_charges'];
// //     createdAt = json['created_at'];
// //     updatedAt = json['updated_at'];
// //     deletedAt = json['deleted_at'];
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = <String, dynamic>{};
// //     data['id'] = id;
// //     data['patient_id'] = patientId;
// //     data['visit_id'] = visitId;
// //     data['status'] = status;
// //     data['visit_date'] = visitDate;
// //     if (diagnosisCodesProcedures != null) {
// //       data['diagnosis_codes_procedures'] = diagnosisCodesProcedures!.toJson();
// //     }
// //     data['impressions_and_plan'] = impressionsAndPlan;
// //     data['total_charges'] = totalCharges;
// //     data['created_at'] = createdAt;
// //     data['updated_at'] = updatedAt;
// //     data['deleted_at'] = deletedAt;
// //     return data;
// //   }
// // }
// //
// // class DiagnosisCodesProcedures {
// //   List<SubDiagnosisCodesProcedures>? subDiagnosisCodesProcedures;
// //   List<ImpressionsAndPlan>? impressionsAndPlan;
// //   List<Null>? technicalParameters;
// //   FinancialInformation? financialInformation;
// //
// //   DiagnosisCodesProcedures({this.subDiagnosisCodesProcedures, this.impressionsAndPlan, this.technicalParameters, this.financialInformation});
// //
// //   DiagnosisCodesProcedures.fromJson(Map<String, dynamic> json) {
// //     if (json['diagnosis_codes_procedures'] != null) {
// //       subDiagnosisCodesProcedures = <SubDiagnosisCodesProcedures>[];
// //       json['diagnosis_codes_procedures'].forEach((v) {
// //         subDiagnosisCodesProcedures!.add(SubDiagnosisCodesProcedures.fromJson(v));
// //       });
// //     }
// //     if (json['impressions_and_plan'] != null) {
// //       impressionsAndPlan = <ImpressionsAndPlan>[];
// //       json['impressions_and_plan'].forEach((v) {
// //         impressionsAndPlan!.add(ImpressionsAndPlan.fromJson(v));
// //       });
// //     }
// //     // if (json['technical_parameters'] != null) {
// //     //   technicalParameters = <Null>[];
// //     //   json['technical_parameters'].forEach((v) {
// //     //     technicalParameters!.add(new Null.fromJson(v));
// //     //   });
// //     // }
// //     financialInformation = json['financial_information'] != null ? FinancialInformation.fromJson(json['financial_information']) : null;
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = <String, dynamic>{};
// //     if (subDiagnosisCodesProcedures != null) {
// //       data['diagnosis_codes_procedures'] = subDiagnosisCodesProcedures!.map((v) => v.toJson()).toList();
// //     }
// //     if (impressionsAndPlan != null) {
// //       data['impressions_and_plan'] = impressionsAndPlan!.map((v) => v.toJson()).toList();
// //     }
// //     // if (this.technicalParameters != null) {
// //     //   data['technical_parameters'] = this.technicalParameters!.map((v) => v.toJson()).toList();
// //     // }
// //     if (financialInformation != null) {
// //       data['financial_information'] = financialInformation!.toJson();
// //     }
// //     return data;
// //   }
// // }
// //
// // class SubDiagnosisCodesProcedures {
// //   Procedure? procedure;
// //   List<Diagnosis>? diagnosis;
// //   int? units;
// //   dynamic unitCharge;
// //
// //   SubDiagnosisCodesProcedures({this.procedure, this.diagnosis, this.units, this.unitCharge});
// //
// //   SubDiagnosisCodesProcedures.fromJson(Map<String, dynamic> json) {
// //     procedure = json['procedure'] != null ? Procedure.fromJson(json['procedure']) : null;
// //     if (json['diagnosis'] != null) {
// //       diagnosis = <Diagnosis>[];
// //       json['diagnosis'].forEach((v) {
// //         diagnosis!.add(Diagnosis.fromJson(v));
// //       });
// //     }
// //     units = json['units'];
// //     unitCharge = json['unit_charge'];
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = <String, dynamic>{};
// //     if (procedure != null) {
// //       data['procedure'] = procedure!.toJson();
// //     }
// //     if (diagnosis != null) {
// //       data['diagnosis'] = diagnosis!.map((v) => v.toJson()).toList();
// //     }
// //     data['units'] = units;
// //     data['unit_charge'] = unitCharge;
// //     return data;
// //   }
// // }
// //
// // class Procedure {
// //   String? code;
// //   String? description;
// //   String? confidenceScore;
// //   List<Null>? possibleAlternatives;
// //
// //   Procedure({this.code, this.description, this.confidenceScore, this.possibleAlternatives});
// //
// //   Procedure.fromJson(Map<String, dynamic> json) {
// //     code = json['code'];
// //     description = json['description'];
// //     confidenceScore = json['confidence_score'];
// //     // if (json['possible_alternatives'] != null) {
// //     //   possibleAlternatives = <Null>[];
// //     //   json['possible_alternatives'].forEach((v) {
// //     //     possibleAlternatives!.add(new Null.fromJson(v));
// //     //   });
// //     // }
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = <String, dynamic>{};
// //     data['code'] = code;
// //     data['description'] = description;
// //     data['confidence_score'] = confidenceScore;
// //     // if (this.possibleAlternatives != null) {
// //     //   data['possible_alternatives'] = this.possibleAlternatives!.map((v) => v.toJson()).toList();
// //     // }
// //     return data;
// //   }
// // }
// //
// // class Diagnosis {
// //   String? code;
// //   String? description;
// //   String? icd10Code;
// //   String? confidenceScore;
// //   List<Null>? possibleAlternatives;
// //
// //   Diagnosis({this.code, this.description, this.icd10Code, this.confidenceScore, this.possibleAlternatives});
// //
// //   Diagnosis.fromJson(Map<String, dynamic> json) {
// //     code = json['code'];
// //     description = json['description'];
// //     icd10Code = json['icd_10_code'];
// //     confidenceScore = json['confidence_score'];
// //     // if (json['possible_alternatives'] != null) {
// //     //   possibleAlternatives = <Null>[];
// //     //   json['possible_alternatives'].forEach((v) {
// //     //     possibleAlternatives!.add(new Null.fromJson(v));
// //     //   });
// //     // }
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = <String, dynamic>{};
// //     data['code'] = code;
// //     data['description'] = description;
// //     data['icd_10_code'] = icd10Code;
// //     data['confidence_score'] = confidenceScore;
// //     // if (this.possibleAlternatives != null) {
// //     //   data['possible_alternatives'] = this.possibleAlternatives!.map((v) => v.toJson()).toList();
// //     // }
// //     return data;
// //   }
// // }
// //
// // class ImpressionsAndPlan {
// //   String? number;
// //   String? title;
// //   List<Treatments>? treatments;
// //
// //   ImpressionsAndPlan({this.number, this.title, this.treatments});
// //
// //   ImpressionsAndPlan.fromJson(Map<String, dynamic> json) {
// //     number = json['number'];
// //     title = json['title'];
// //     if (json['treatments'] != null) {
// //       treatments = <Treatments>[];
// //       json['treatments'].forEach((v) {
// //         treatments!.add(Treatments.fromJson(v));
// //       });
// //     }
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = <String, dynamic>{};
// //     data['number'] = number;
// //     data['title'] = title;
// //     if (treatments != null) {
// //       data['treatments'] = treatments!.map((v) => v.toJson()).toList();
// //     }
// //     return data;
// //   }
// // }
// //
// // class Treatments {
// //   String? type;
// //   String? name;
// //   List<Specifications>? specifications;
// //   List<String>? notes;
// //
// //   Treatments({this.type, this.name, this.specifications, this.notes});
// //
// //   Treatments.fromJson(Map<String, dynamic> json) {
// //     type = json['type'];
// //     name = json['name'];
// //     if (json['specifications'] != null) {
// //       specifications = <Specifications>[];
// //       json['specifications'].forEach((v) {
// //         specifications!.add(Specifications.fromJson(v));
// //       });
// //     }
// //     notes = json['notes'].cast<String>();
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = <String, dynamic>{};
// //     data['type'] = type;
// //     data['name'] = name;
// //     if (specifications != null) {
// //       data['specifications'] = specifications!.map((v) => v.toJson()).toList();
// //     }
// //     data['notes'] = notes;
// //     return data;
// //   }
// // }
// //
// // class Specifications {
// //   String? parameter;
// //   String? value;
// //
// //   Specifications({this.parameter, this.value});
// //
// //   Specifications.fromJson(Map<String, dynamic> json) {
// //     parameter = json['parameter'];
// //     value = json['value'];
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = <String, dynamic>{};
// //     data['parameter'] = parameter;
// //     data['value'] = value;
// //     return data;
// //   }
// // }
// //
// // class FinancialInformation {
// //   dynamic totalCharges;
// //   List<Breakdown>? breakdown;
// //
// //   FinancialInformation({this.totalCharges, this.breakdown});
// //
// //   FinancialInformation.fromJson(Map<String, dynamic> json) {
// //     totalCharges = json['total_charges'];
// //     if (json['breakdown'] != null) {
// //       breakdown = <Breakdown>[];
// //       json['breakdown'].forEach((v) {
// //         breakdown!.add(Breakdown.fromJson(v));
// //       });
// //     }
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = <String, dynamic>{};
// //     data['total_charges'] = totalCharges;
// //     if (breakdown != null) {
// //       data['breakdown'] = breakdown!.map((v) => v.toJson()).toList();
// //     }
// //     return data;
// //   }
// // }
// //
// // class Breakdown {
// //   String? description;
// //   dynamic cost;
// //
// //   Breakdown({this.description, this.cost});
// //
// //   Breakdown.fromJson(Map<String, dynamic> json) {
// //     description = json['description'];
// //     cost = json['cost'];
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = <String, dynamic>{};
// //     data['description'] = description;
// //     data['cost'] = cost;
// //     return data;
// //   }
// // }
// //---------------------------------------------------------
// // class DoctorViewModel {
// //   DoctorViewResponseData? responseData;
// //   String? message;
// //   bool? toast;
// //   String? responseType;
// //
// //   DoctorViewModel({this.responseData, this.message, this.toast, this.responseType});
// //
// //   DoctorViewModel.fromJson(Map<String, dynamic> json) {
// //     responseData = json['responseData'] != null ? DoctorViewResponseData.fromJson(json['responseData']) : null;
// //     message = json['message'];
// //     toast = json['toast'];
// //     responseType = json['response_type'];
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = <String, dynamic>{};
// //     if (responseData != null) {
// //       data['responseData'] = responseData!.toJson();
// //     }
// //     data['message'] = message;
// //     data['toast'] = toast;
// //     data['response_type'] = responseType;
// //     return data;
// //   }
// // }
// //
// // class DoctorViewResponseData {
// //   int? id;
// //   int? patientId;
// //   int? visitId;
// //   String? status;
// //   String? visitDate;
// //   List<DiagnosisCodesProcedures>? diagnosisCodesProcedures;
// //   List<ImpressionsAndPlan>? impressionsAndPlan;
// //   dynamic totalCharges;
// //   String? createdAt;
// //   String? updatedAt;
// //   Null? deletedAt;
// //
// //   DoctorViewResponseData(
// //       {this.id,
// //       this.patientId,
// //       this.visitId,
// //       this.status,
// //       this.visitDate,
// //       this.diagnosisCodesProcedures,
// //       this.impressionsAndPlan,
// //       this.totalCharges,
// //       this.createdAt,
// //       this.updatedAt,
// //       this.deletedAt});
// //
// //   DoctorViewResponseData.fromJson(Map<String, dynamic> json) {
// //     id = json['id'];
// //     patientId = json['patient_id'];
// //     visitId = json['visit_id'];
// //     status = json['status'];
// //     visitDate = json['visit_date'];
// //     if (json['diagnosis_codes_procedures'] != null) {
// //       diagnosisCodesProcedures = <DiagnosisCodesProcedures>[];
// //       json['diagnosis_codes_procedures'].forEach((v) {
// //         diagnosisCodesProcedures!.add(DiagnosisCodesProcedures.fromJson(v));
// //       });
// //     }
// //     if (json['impressions_and_plan'] != null) {
// //       impressionsAndPlan = <ImpressionsAndPlan>[];
// //       json['impressions_and_plan'].forEach((v) {
// //         impressionsAndPlan!.add(ImpressionsAndPlan.fromJson(v));
// //       });
// //     }
// //     totalCharges = json['total_charges'];
// //     createdAt = json['created_at'];
// //     updatedAt = json['updated_at'];
// //     deletedAt = json['deleted_at'];
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = <String, dynamic>{};
// //     data['id'] = id;
// //     data['patient_id'] = patientId;
// //     data['visit_id'] = visitId;
// //     data['status'] = status;
// //     data['visit_date'] = visitDate;
// //     if (diagnosisCodesProcedures != null) {
// //       data['diagnosis_codes_procedures'] = diagnosisCodesProcedures!.map((v) => v.toJson()).toList();
// //     }
// //     if (impressionsAndPlan != null) {
// //       data['impressions_and_plan'] = impressionsAndPlan!.map((v) => v.toJson()).toList();
// //     }
// //     data['total_charges'] = totalCharges;
// //     data['created_at'] = createdAt;
// //     data['updated_at'] = updatedAt;
// //     data['deleted_at'] = deletedAt;
// //     return data;
// //   }
// // }
// //
// // class DiagnosisCodesProcedures {
// //   DiagnosisCodesProceduresProcedure? diagnosisCodesProceduresProcedure;
// //   List<Diagnosis>? diagnosis;
// //   dynamic units;
// //   dynamic unitCharge;
// //
// //   DiagnosisCodesProcedures({this.diagnosisCodesProceduresProcedure, this.diagnosis, this.units, this.unitCharge});
// //
// //   DiagnosisCodesProcedures.fromJson(Map<String, dynamic> json) {
// //     diagnosisCodesProceduresProcedure =
// //         json['procedure'] != null ? DiagnosisCodesProceduresProcedure.fromJson(json['procedure']) : null;
// //     if (json['diagnosis'] != null) {
// //       diagnosis = <Diagnosis>[];
// //       json['diagnosis'].forEach((v) {
// //         diagnosis!.add(Diagnosis.fromJson(v));
// //       });
// //     }
// //     units = json['units'];
// //     unitCharge = json['unit_charge'];
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = <String, dynamic>{};
// //     if (diagnosisCodesProceduresProcedure != null) {
// //       data['procedure'] = diagnosisCodesProceduresProcedure!.toJson();
// //     }
// //     if (diagnosis != null) {
// //       data['diagnosis'] = diagnosis!.map((v) => v.toJson()).toList();
// //     }
// //     data['units'] = units;
// //     data['unit_charge'] = unitCharge;
// //     return data;
// //   }
// // }
// //
// // class DiagnosisCodesProceduresProcedure {
// //   String? code;
// //   String? description;
// //   String? confidenceScore;
// //   List<Null>? possibleAlternatives;
// //
// //   DiagnosisCodesProceduresProcedure({this.code, this.description, this.confidenceScore, this.possibleAlternatives});
// //
// //   DiagnosisCodesProceduresProcedure.fromJson(Map<String, dynamic> json) {
// //     code = json['code'];
// //     description = json['description'];
// //     confidenceScore = json['confidence_score'];
// //     // if (json['possible_alternatives'] != null) {
// //     //   possibleAlternatives = <Null>[];
// //     //   json['possible_alternatives'].forEach((v) {
// //     //     possibleAlternatives!.add(new Null.fromJson(v));
// //     //   });
// //     // }
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = <String, dynamic>{};
// //     data['code'] = code;
// //     data['description'] = description;
// //     data['confidence_score'] = confidenceScore;
// //     // if (this.possibleAlternatives != null) {
// //     //   data['possible_alternatives'] =
// //     //       this.possibleAlternatives!.map((v) => v.toJson()).toList();
// //     // }
// //     return data;
// //   }
// // }
// //
// // class Diagnosis {
// //   String? code;
// //   String? description;
// //   String? icd10Code;
// //   String? confidenceScore;
// //   List<Null>? possibleAlternatives;
// //
// //   Diagnosis({this.code, this.description, this.icd10Code, this.confidenceScore, this.possibleAlternatives});
// //
// //   Diagnosis.fromJson(Map<String, dynamic> json) {
// //     code = json['code'];
// //     description = json['description'];
// //     icd10Code = json['icd_10_code'];
// //     confidenceScore = json['confidence_score'];
// //     // if (json['possible_alternatives'] != null) {
// //     //   possibleAlternatives = <Null>[];
// //     //   json['possible_alternatives'].forEach((v) {
// //     //     possibleAlternatives!.add(new Null.fromJson(v));
// //     //   });
// //     // }
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = <String, dynamic>{};
// //     data['code'] = code;
// //     data['description'] = description;
// //     data['icd_10_code'] = icd10Code;
// //     data['confidence_score'] = confidenceScore;
// //     // if (this.possibleAlternatives != null) {
// //     //   data['possible_alternatives'] =
// //     //       this.possibleAlternatives!.map((v) => v.toJson()).toList();
// //     // }
// //     return data;
// //   }
// // }
// //
// // class ImpressionsAndPlan {
// //   String? number;
// //   String? title;
// //   String? description;
// //   List<Treatments>? treatments;
// //   Procedure? procedure;
// //   List? medications;
// //   List? orders;
// //   List? counselingAndDiscussion;
// //   String? followUp;
// //
// //   ImpressionsAndPlan(
// //       {this.number,
// //       this.title,
// //       this.description,
// //       this.treatments,
// //       this.procedure,
// //       this.medications,
// //       this.orders,
// //       this.counselingAndDiscussion,
// //       this.followUp});
// //
// //   ImpressionsAndPlan.fromJson(Map<String, dynamic> json) {
// //     number = json['number'];
// //     title = json['title'];
// //     description = json['description'];
// //     if (json['treatments'] != null) {
// //       treatments = <Treatments>[];
// //       json['treatments'].forEach((v) {
// //         treatments!.add(Treatments.fromJson(v));
// //       });
// //     }
// //     procedure = json['procedure'] != null ? Procedure.fromJson(json['procedure']) : null;
// //     if (json['medications'] != null) {
// //       medications = [];
// //       json['medications'].forEach((v) {
// //         medications!.add(v);
// //       });
// //     }
// //     if (json['orders'] != null) {
// //       orders = [];
// //       json['orders'].forEach((v) {
// //         orders!.add(v);
// //       });
// //     }
// //     if (json['counseling_and_discussion'] != null) {
// //       counselingAndDiscussion = [];
// //       json['counseling_and_discussion'].forEach((v) {
// //         counselingAndDiscussion!.add(v);
// //       });
// //     }
// //     followUp = json['follow_up'];
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = <String, dynamic>{};
// //     data['number'] = number;
// //     data['title'] = title;
// //     data['description'] = description;
// //     if (treatments != null) {
// //       data['treatments'] = treatments!.map((v) => v.toJson()).toList();
// //     }
// //     if (procedure != null) {
// //       data['procedure'] = procedure!.toJson();
// //     }
// //     // if (this.medications != null) {
// //     //   data['medications'] = this.medications!.map((v) => v.toJson()).toList();
// //     // }
// //     // if (this.orders != null) {
// //     //   data['orders'] = this.orders!.map((v) => v.toJson()).toList();
// //     // }
// //     // if (this.counselingAndDiscussion != null) {
// //     //   data['counseling_and_discussion'] =
// //     //       this.counselingAndDiscussion!.map((v) => v.toJson()).toList();
// //     // }
// //     data['follow_up'] = followUp;
// //     return data;
// //   }
// // }
// //
// // class Treatments {
// //   String? type;
// //   String? name;
// //   List<Specifications>? specifications;
// //   List<String>? notes;
// //
// //   Treatments({this.type, this.name, this.specifications, this.notes});
// //
// //   Treatments.fromJson(Map<String, dynamic> json) {
// //     type = json['type'];
// //     name = json['name'];
// //     if (json['specifications'] != null) {
// //       specifications = <Specifications>[];
// //       json['specifications'].forEach((v) {
// //         specifications!.add(Specifications.fromJson(v));
// //       });
// //     }
// //     if (json['notes'] != null) {
// //       notes = <String>[];
// //       // json['notes'].forEach((v) {
// //       //   notes!.add(new Null.fromJson(v));
// //       // });
// //     }
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = <String, dynamic>{};
// //     data['type'] = type;
// //     data['name'] = name;
// //     if (specifications != null) {
// //       data['specifications'] = specifications!.map((v) => v.toJson()).toList();
// //     }
// //     // if (this.notes != null) {
// //     //   data['notes'] = this.notes!.map((v) => v.toJson()).toList();
// //     // }
// //     return data;
// //   }
// // }
// //
// // class Specifications {
// //   String? parameter;
// //   String? value;
// //
// //   Specifications({this.parameter, this.value});
// //
// //   Specifications.fromJson(Map<String, dynamic> json) {
// //     parameter = json['parameter'];
// //     value = json['value'];
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = <String, dynamic>{};
// //     data['parameter'] = parameter;
// //     data['value'] = value;
// //     return data;
// //   }
// // }
// //
// // class Procedure {
// //   String? type;
// //   List? details;
// //
// //   Procedure({this.type, this.details});
// //
// //   Procedure.fromJson(Map<String, dynamic> json) {
// //     type = json['type'];
// //     if (json['details'] != null) {
// //       details = [];
// //       json['details'].forEach((v) {
// //         details!.add(v);
// //       });
// //     }
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = <String, dynamic>{};
// //     data['type'] = type;
// //     // if (this.details != null) {
// //     //   data['details'] = this.details!.map((v) => v.toJson()).toList();
// //     // }
// //     return data;
// //   }
// // }
//
// class DoctorViewModel {
//   DoctorViewResponseData? responseData;
//   String? message;
//   bool? toast;
//   String? responseType;
//
//   DoctorViewModel({this.responseData, this.message, this.toast, this.responseType});
//
//   DoctorViewModel.fromJson(Map<String, dynamic> json) {
//     responseData = json['responseData'] != null ? DoctorViewResponseData.fromJson(json['responseData']) : null;
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
// class DoctorViewResponseData {
//   int? id;
//   int? patientId;
//   int? visitId;
//   String? status;
//   String? visitDate;
//   List<DiagnosisCodesProcedures>? diagnosisCodesProcedures;
//   List<ImpressionsAndPlan>? impressionsAndPlan;
//   dynamic totalCharges;
//   String? createdAt;
//   String? updatedAt;
//   String? deletedAt;
//   String? message;
//
//   DoctorViewResponseData({
//     this.id,
//     this.patientId,
//     this.visitId,
//     this.status,
//     this.visitDate,
//     this.diagnosisCodesProcedures,
//     this.impressionsAndPlan,
//     this.totalCharges,
//     this.createdAt,
//     this.updatedAt,
//     this.deletedAt,
//     this.message,
//   });
//
//   DoctorViewResponseData.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     message = json['message'];
//     patientId = json['patient_id'];
//     visitId = json['visit_id'];
//     status = json['status'];
//     visitDate = json['visit_date'];
//     if (json['diagnosis_codes_procedures'] != null) {
//       diagnosisCodesProcedures = <DiagnosisCodesProcedures>[];
//       json['diagnosis_codes_procedures'].forEach((v) {
//         diagnosisCodesProcedures!.add(DiagnosisCodesProcedures.fromJson(v));
//       });
//     }
//     if (json['impressions_and_plan'] != null) {
//       impressionsAndPlan = <ImpressionsAndPlan>[];
//       json['impressions_and_plan'].forEach((v) {
//         impressionsAndPlan!.add(ImpressionsAndPlan.fromJson(v));
//       });
//     }
//     totalCharges = json['total_charges'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     deletedAt = json['deleted_at'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['message'] = message;
//     data['patient_id'] = patientId;
//     data['visit_id'] = visitId;
//     data['status'] = status;
//     data['visit_date'] = visitDate;
//     if (diagnosisCodesProcedures != null) {
//       data['diagnosis_codes_procedures'] = diagnosisCodesProcedures!.map((v) => v.toJson()).toList();
//     }
//     if (impressionsAndPlan != null) {
//       data['impressions_and_plan'] = impressionsAndPlan!.map((v) => v.toJson()).toList();
//     }
//     data['total_charges'] = totalCharges;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     data['deleted_at'] = deletedAt;
//     return data;
//   }
// }
//
// class DiagnosisCodesProcedures {
//   DiagnosisCodesProceduresProcedure? procedure;
//   List<Diagnosis>? diagnosis;
//   dynamic units;
//   dynamic unitCharge;
//
//   DiagnosisCodesProcedures({this.procedure, this.diagnosis, this.units, this.unitCharge});
//
//   DiagnosisCodesProcedures.fromJson(Map<String, dynamic> json) {
//     procedure = json['procedure'] != null ? DiagnosisCodesProceduresProcedure.fromJson(json['procedure']) : null;
//     if (json['diagnosis'] != null) {
//       diagnosis = <Diagnosis>[];
//       json['diagnosis'].forEach((v) {
//         diagnosis!.add(Diagnosis.fromJson(v));
//       });
//     }
//     units = json['units'];
//     unitCharge = json['unit_charge'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (procedure != null) {
//       data['procedure'] = procedure!.toJson();
//     }
//     if (diagnosis != null) {
//       data['diagnosis'] = diagnosis!.map((v) => v.toJson()).toList();
//     }
//     data['units'] = units;
//     data['unit_charge'] = unitCharge;
//     return data;
//   }
// }
//
// class DiagnosisCodesProceduresProcedure {
//   String? code;
//   String? description;
//   String? confidenceScore;
//   List<Null>? possibleAlternatives;
//
//   DiagnosisCodesProceduresProcedure({this.code, this.description, this.confidenceScore, this.possibleAlternatives});
//
//   DiagnosisCodesProceduresProcedure.fromJson(Map<String, dynamic> json) {
//     code = json['code'];
//     description = json['description'];
//     confidenceScore = json['confidence_score'];
//     // if (json['possible_alternatives'] != null) {
//     //   possibleAlternatives = <Null>[];
//     //   json['possible_alternatives'].forEach((v) {
//     //     possibleAlternatives!.add(Null.fromJson(v));
//     //   });
//     // }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['code'] = code;
//     data['description'] = description;
//     data['confidence_score'] = confidenceScore;
//     // if (possibleAlternatives != null) {
//     //   data['possible_alternatives'] = possibleAlternatives!.map((v) => v.toJson()).toList();
//     // }
//     return data;
//   }
// }
//
// class Diagnosis {
//   String? code;
//   String? description;
//   String? icd10Code;
//   String? confidenceScore;
//   List<Null>? possibleAlternatives;
//
//   Diagnosis({this.code, this.description, this.icd10Code, this.confidenceScore, this.possibleAlternatives});
//
//   Diagnosis.fromJson(Map<String, dynamic> json) {
//     code = json['code'];
//     description = json['description'];
//     icd10Code = json['icd_10_code'];
//     confidenceScore = json['confidence_score'];
//     // if (json['possible_alternatives'] != null) {
//     //   possibleAlternatives = <Null>[];
//     //   json['possible_alternatives'].forEach((v) {
//     //     possibleAlternatives!.add(Null.fromJson(v));
//     //   });
//     // }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['code'] = code;
//     data['description'] = description;
//     data['icd_10_code'] = icd10Code;
//     data['confidence_score'] = confidenceScore;
//     // if (possibleAlternatives != null) {
//     //   data['possible_alternatives'] = possibleAlternatives!.map((v) => v.toJson()).toList();
//     // }
//     return data;
//   }
// }
//
// class ImpressionsAndPlan {
//   String? number;
//   String? title;
//   String? code;
//   String? description;
//   List<Treatments>? treatments;
//   Procedure? procedure;
//   String? medications;
//   String? orders;
//   String? counselingAndDiscussion;
//   String? followUp;
//
//   ImpressionsAndPlan({this.number, this.title, this.code, this.description, this.treatments, this.procedure, this.medications, this.orders, this.counselingAndDiscussion, this.followUp});
//
//   ImpressionsAndPlan.fromJson(Map<String, dynamic> json) {
//     number = json['number'];
//     title = json['title'];
//     code = json['code'];
//     description = json['description'];
//     if (json['treatments'] != null) {
//       treatments = <Treatments>[];
//       json['treatments'].forEach((v) {
//         treatments!.add(Treatments.fromJson(v));
//       });
//     }
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
//     if (treatments != null) {
//       data['treatments'] = treatments!.map((v) => v.toJson()).toList();
//     }
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
// class Treatments {
//   String? type;
//   String? name;
//   List<Specifications>? specifications;
//   List<String>? notes;
//
//   Treatments({this.type, this.name, this.specifications, this.notes});
//
//   Treatments.fromJson(Map<String, dynamic> json) {
//     type = json['type'];
//     name = json['name'];
//     if (json['specifications'] != null) {
//       specifications = <Specifications>[];
//       json['specifications'].forEach((v) {
//         specifications!.add(Specifications.fromJson(v));
//       });
//     }
//     notes = json['notes'].cast<String>();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['type'] = type;
//     data['name'] = name;
//     if (specifications != null) {
//       data['specifications'] = specifications!.map((v) => v.toJson()).toList();
//     }
//     data['notes'] = notes;
//     return data;
//   }
// }
//
// class Specifications {
//   String? parameter;
//   String? value;
//
//   Specifications({this.parameter, this.value});
//
//   Specifications.fromJson(Map<String, dynamic> json) {
//     parameter = json['parameter'];
//     value = json['value'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['parameter'] = parameter;
//     data['value'] = value;
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
//--------------------------------------------
// class DoctorViewModel {
//   ResponseData? responseData;
//   String? message;
//   bool? toast;
//   String? responseType;
//
//   DoctorViewModel({this.responseData, this.message, this.toast, this.responseType});
//
//   DoctorViewModel.fromJson(Map<String, dynamic> json) {
//     responseData = json['responseData'] != null ? new ResponseData.fromJson(json['responseData']) : null;
//     message = json['message'];
//     toast = json['toast'];
//     responseType = json['response_type'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.responseData != null) {
//       data['responseData'] = this.responseData!.toJson();
//     }
//     data['message'] = this.message;
//     data['toast'] = this.toast;
//     data['response_type'] = this.responseType;
//     return data;
//   }
// }
//
// class ResponseData {
//   int? id;
//   int? patientId;
//   int? visitId;
//   String? status;
//   String? visitDate;
//   List<DiagnosisCodesProcedures>? diagnosisCodesProcedures;
//   List<ImpressionsAndPlan>? impressionsAndPlan;
//   Null? totalCharges;
//   String? message;
//   String? createdAt;
//   String? updatedAt;
//   Null? deletedAt;
//
//   ResponseData({
//     this.id,
//     this.patientId,
//     this.visitId,
//     this.status,
//     this.visitDate,
//     this.diagnosisCodesProcedures,
//     this.impressionsAndPlan,
//     this.totalCharges,
//     this.message,
//     this.createdAt,
//     this.updatedAt,
//     this.deletedAt,
//   });
//
//   ResponseData.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     patientId = json['patient_id'];
//     visitId = json['visit_id'];
//     status = json['status'];
//     visitDate = json['visit_date'];
//     if (json['diagnosis_codes_procedures'] != null) {
//       diagnosisCodesProcedures = <DiagnosisCodesProcedures>[];
//       json['diagnosis_codes_procedures'].forEach((v) {
//         diagnosisCodesProcedures!.add(new DiagnosisCodesProcedures.fromJson(v));
//       });
//     }
//     if (json['impressions_and_plan'] != null) {
//       impressionsAndPlan = <ImpressionsAndPlan>[];
//       json['impressions_and_plan'].forEach((v) {
//         impressionsAndPlan!.add(new ImpressionsAndPlan.fromJson(v));
//       });
//     }
//     totalCharges = json['total_charges'];
//     message = json['message'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     deletedAt = json['deleted_at'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['patient_id'] = this.patientId;
//     data['visit_id'] = this.visitId;
//     data['status'] = this.status;
//     data['visit_date'] = this.visitDate;
//     if (this.diagnosisCodesProcedures != null) {
//       data['diagnosis_codes_procedures'] = this.diagnosisCodesProcedures!.map((v) => v.toJson()).toList();
//     }
//     if (this.impressionsAndPlan != null) {
//       data['impressions_and_plan'] = this.impressionsAndPlan!.map((v) => v.toJson()).toList();
//     }
//     data['total_charges'] = this.totalCharges;
//     data['message'] = this.message;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     data['deleted_at'] = this.deletedAt;
//     return data;
//   }
// }
//
// class DiagnosisCodesProcedures {
//   Procedure? procedure;
//   List<Diagnosis>? diagnosis;
//   String? units;
//   String? unitCharge;
//   Null? modifier;
//   String? totalCharge;
//
//   DiagnosisCodesProcedures({this.procedure, this.diagnosis, this.units, this.unitCharge, this.modifier, this.totalCharge});
//
//   DiagnosisCodesProcedures.fromJson(Map<String, dynamic> json) {
//     procedure = json['procedure'] != null ? new Procedure.fromJson(json['procedure']) : null;
//     if (json['diagnosis'] != null) {
//       diagnosis = <Diagnosis>[];
//       json['diagnosis'].forEach((v) {
//         diagnosis!.add(new Diagnosis.fromJson(v));
//       });
//     }
//     units = json['units'];
//     unitCharge = json['unit_charge'];
//     modifier = json['modifier'];
//     totalCharge = json['total_charge'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.procedure != null) {
//       data['procedure'] = this.procedure!.toJson();
//     }
//     if (this.diagnosis != null) {
//       data['diagnosis'] = this.diagnosis!.map((v) => v.toJson()).toList();
//     }
//     data['units'] = this.units;
//     data['unit_charge'] = this.unitCharge;
//     data['modifier'] = this.modifier;
//     data['total_charge'] = this.totalCharge;
//     return data;
//   }
// }
//
// class Procedure {
//   String? code;
//   String? description;
//   String? confidenceScore;
//   List<PossibleAlternatives>? possibleAlternatives;
//
//   Procedure({this.code, this.description, this.confidenceScore, this.possibleAlternatives});
//
//   Procedure.fromJson(Map<String, dynamic> json) {
//     code = json['code'];
//     description = json['description'];
//     confidenceScore = json['confidence_score'];
//     if (json['possible_alternatives'] != null) {
//       possibleAlternatives = <PossibleAlternatives>[];
//       json['possible_alternatives'].forEach((v) {
//         possibleAlternatives!.add(new PossibleAlternatives.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['code'] = this.code;
//     data['description'] = this.description;
//     data['confidence_score'] = this.confidenceScore;
//     if (this.possibleAlternatives != null) {
//       data['possible_alternatives'] = this.possibleAlternatives!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class PossibleAlternatives {
//   String? code;
//   String? description;
//
//   PossibleAlternatives({this.code, this.description});
//
//   PossibleAlternatives.fromJson(Map<String, dynamic> json) {
//     code = json['code'];
//     description = json['description'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['code'] = this.code;
//     data['description'] = this.description;
//     return data;
//   }
// }
//
// class Diagnosis {
//   String? code;
//   String? description;
//   String? icd10Code;
//   String? confidenceScore;
//   List<PossibleAlternatives>? possibleAlternatives;
//
//   Diagnosis({this.code, this.description, this.icd10Code, this.confidenceScore, this.possibleAlternatives});
//
//   Diagnosis.fromJson(Map<String, dynamic> json) {
//     code = json['code'];
//     description = json['description'];
//     icd10Code = json['icd_10_code'];
//     confidenceScore = json['confidence_score'];
//     if (json['possible_alternatives'] != null) {
//       possibleAlternatives = <PossibleAlternatives>[];
//       json['possible_alternatives'].forEach((v) {
//         possibleAlternatives!.add(new PossibleAlternatives.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['code'] = this.code;
//     data['description'] = this.description;
//     data['icd_10_code'] = this.icd10Code;
//     data['confidence_score'] = this.confidenceScore;
//     if (this.possibleAlternatives != null) {
//       data['possible_alternatives'] = this.possibleAlternatives!.map((v) => v.toJson()).toList();
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
//   List<Treatments>? treatments;
//   ProcedureSecond? procedure;
//   String? medications;
//   String? orders;
//   String? counselingAndDiscussion;
//   String? followUp;
//
//   ImpressionsAndPlan({this.number, this.title, this.code, this.description, this.treatments, this.procedure, this.medications, this.orders, this.counselingAndDiscussion, this.followUp});
//
//   ImpressionsAndPlan.fromJson(Map<String, dynamic> json) {
//     number = json['number'];
//     title = json['title'];
//     code = json['code'];
//     description = json['description'];
//     if (json['treatments'] != null) {
//       treatments = <Treatments>[];
//       json['treatments'].forEach((v) {
//         treatments!.add(new Treatments.fromJson(v));
//       });
//     }
//     procedure = json['procedure'] != null ? new ProcedureSecond.fromJson(json['procedure']) : null;
//     medications = json['medications'];
//     orders = json['orders'];
//     counselingAndDiscussion = json['counseling_and_discussion'];
//     followUp = json['follow_up'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['number'] = this.number;
//     data['title'] = this.title;
//     data['code'] = this.code;
//     data['description'] = this.description;
//     if (this.treatments != null) {
//       data['treatments'] = this.treatments!.map((v) => v.toJson()).toList();
//     }
//     if (this.procedure != null) {
//       data['procedure'] = this.procedure!.toJson();
//     }
//     data['medications'] = this.medications;
//     data['orders'] = this.orders;
//     data['counseling_and_discussion'] = this.counselingAndDiscussion;
//     data['follow_up'] = this.followUp;
//     return data;
//   }
// }
//
// class Treatments {
//   String? type;
//   String? name;
//   List<Specifications>? specifications;
//   List<String>? notes;
//
//   Treatments({this.type, this.name, this.specifications, this.notes});
//
//   Treatments.fromJson(Map<String, dynamic> json) {
//     type = json['type'];
//     name = json['name'];
//     if (json['specifications'] != null) {
//       specifications = <Specifications>[];
//       json['specifications'].forEach((v) {
//         specifications!.add(new Specifications.fromJson(v));
//       });
//     }
//     notes = json['notes'].cast<String>();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['type'] = this.type;
//     data['name'] = this.name;
//     if (this.specifications != null) {
//       data['specifications'] = this.specifications!.map((v) => v.toJson()).toList();
//     }
//     data['notes'] = this.notes;
//     return data;
//   }
// }
//
// class Specifications {
//   String? parameter;
//   String? value;
//
//   Specifications({this.parameter, this.value});
//
//   Specifications.fromJson(Map<String, dynamic> json) {
//     parameter = json['parameter'];
//     value = json['value'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['parameter'] = this.parameter;
//     data['value'] = this.value;
//     return data;
//   }
// }
//
// class ProcedureSecond {
//   String? type;
//   List<String>? details;
//
//   ProcedureSecond({this.type, this.details});
//
//   ProcedureSecond.fromJson(Map<String, dynamic> json) {
//     type = json['type'];
//     // details = json['details'].cast<String>();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['type'] = this.type;
//     data['details'] = this.details;
//     return data;
//   }
// }

// class DoctorViewModel {
//   final ResponseDataModel responseData;
//   final String message;
//   final bool toast;
//   final String responseType;
//
//   DoctorViewModel({required this.responseData, required this.message, required this.toast, required this.responseType});
//
//   factory DoctorViewModel.fromJson(Map<String, dynamic> json) {
//     return DoctorViewModel(responseData: ResponseDataModel.fromJson(json['responseData']), message: json['message'], toast: json['toast'], responseType: json['response_type']);
//   }
//
//   Map<String, dynamic> toJson() => {'responseData': responseData.toJson(), 'message': message, 'toast': toast, 'response_type': responseType};
// }
//
// class ResponseDataModel {
//   final int id;
//   final int patientId;
//   final int visitId;
//   final String status;
//   final DateTime visitDate;
//   final DiagnosisProcedureList diagnosisCodesProcedures;
//   final List<ImpressionPlanModel> impressionsAndPlan;
//   final dynamic totalCharges;
//   final String message;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final dynamic deletedAt;
//
//   ResponseDataModel({
//     required this.id,
//     required this.patientId,
//     required this.visitId,
//     required this.status,
//     required this.visitDate,
//     required this.diagnosisCodesProcedures,
//     required this.impressionsAndPlan,
//     required this.totalCharges,
//     required this.message,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.deletedAt,
//   });
//
//   factory ResponseDataModel.fromJson(Map<String, dynamic> json) {
//     return ResponseDataModel(
//       id: json['id'],
//       patientId: json['patient_id'],
//       visitId: json['visit_id'],
//       status: json['status'],
//       visitDate: DateTime.parse(json['visit_date']),
//       diagnosisCodesProcedures: DiagnosisProcedureList.fromJson(json['diagnosis_codes_procedures']),
//       impressionsAndPlan: (json['impressions_and_plan'] as List).map((e) => ImpressionPlanModel.fromJson(e)).toList(),
//       totalCharges: json['total_charges'],
//       message: json['message'],
//       createdAt: DateTime.parse(json['created_at']),
//       updatedAt: DateTime.parse(json['updated_at']),
//       deletedAt: json['deleted_at'],
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'patient_id': patientId,
//     'visit_id': visitId,
//     'status': status,
//     'visit_date': visitDate.toIso8601String(),
//     'diagnosis_codes_procedures': diagnosisCodesProcedures.toJson(),
//     'impressions_and_plan': impressionsAndPlan.map((e) => e.toJson()).toList(),
//     'total_charges': totalCharges,
//     'message': message,
//     'created_at': createdAt.toIso8601String(),
//     'updated_at': updatedAt.toIso8601String(),
//     'deleted_at': deletedAt,
//   };
// }
//
// class DiagnosisProcedureList {
//   final List<DiagnosisProcedureModel> diagnosisCodesProcedures;
//   final List<DiagnosisProcedureModel> possibleDiagnosisCodesProcedures;
//
//   DiagnosisProcedureList({required this.diagnosisCodesProcedures, required this.possibleDiagnosisCodesProcedures});
//
//   factory DiagnosisProcedureList.fromJson(Map<String, dynamic> json) {
//     return DiagnosisProcedureList(
//       diagnosisCodesProcedures: (json['diagnosis_codes_procedures'] as List).map((e) => DiagnosisProcedureModel.fromJson(e)).toList(),
//       possibleDiagnosisCodesProcedures: (json['possible_diagnosis_codes_procedures'] as List).map((e) => DiagnosisProcedureModel.fromJson(e)).toList(),
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     'diagnosis_codes_procedures': diagnosisCodesProcedures.map((e) => e.toJson()).toList(),
//     'possible_diagnosis_codes_procedures': possibleDiagnosisCodesProcedures.map((e) => e.toJson()).toList(),
//   };
// }
//
// class DiagnosisProcedureModel {
//   final ProcedureModel procedure;
//   final List<DiagnosisModel> diagnosis;
//   final String units;
//   final String unitCharge;
//   final String totalCharge;
//
//   DiagnosisProcedureModel({required this.procedure, required this.diagnosis, required this.units, required this.unitCharge, required this.totalCharge});
//
//   factory DiagnosisProcedureModel.fromJson(Map<String, dynamic> json) {
//     return DiagnosisProcedureModel(
//       procedure: ProcedureModel.fromJson(json['procedure']),
//       diagnosis: (json['diagnosis'] as List).map((e) => DiagnosisModel.fromJson(e)).toList(),
//       units: json['units'],
//       unitCharge: json['unit_charge'],
//       totalCharge: json['total_charge'],
//     );
//   }
//
//   Map<String, dynamic> toJson() => {'procedure': procedure.toJson(), 'diagnosis': diagnosis.map((e) => e.toJson()).toList(), 'units': units, 'unit_charge': unitCharge, 'total_charge': totalCharge};
// }
//
// class ProcedureModel {
//   final String code;
//   final String description;
//   final String? modifier;
//   final String confidenceScore;
//   final List<ProcedureAlternative>? possibleAlternatives;
//
//   ProcedureModel({required this.code, required this.description, this.modifier, required this.confidenceScore, this.possibleAlternatives});
//
//   factory ProcedureModel.fromJson(Map<String, dynamic> json) {
//     return ProcedureModel(
//       code: json['code'],
//       description: json['description'],
//       modifier: json['modifier'],
//       confidenceScore: json['confidence_score'] ?? '',
//       possibleAlternatives: json['possible_alternatives'] != null ? (json['possible_alternatives'] as List).map((e) => ProcedureAlternative.fromJson(e)).toList() : null,
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     'code': code,
//     'description': description,
//     'modifier': modifier,
//     'confidence_score': confidenceScore,
//     'possible_alternatives': possibleAlternatives?.map((e) => e.toJson()).toList(),
//   };
// }
//
// class ProcedureAlternative {
//   final String code;
//   final String description;
//   final String? modifier;
//
//   ProcedureAlternative({required this.code, required this.description, this.modifier});
//
//   factory ProcedureAlternative.fromJson(Map<String, dynamic> json) {
//     return ProcedureAlternative(code: json['code'], description: json['description'], modifier: json['modifier']);
//   }
//
//   Map<String, dynamic> toJson() => {'code': code, 'description': description, 'modifier': modifier};
// }
//
// class DiagnosisModel {
//   final String code;
//   final String description;
//   final String icd10Code;
//   final String confidenceScore;
//   final List<DiagnosisAlternative>? possibleAlternatives;
//
//   DiagnosisModel({required this.code, required this.description, required this.icd10Code, required this.confidenceScore, this.possibleAlternatives});
//
//   factory DiagnosisModel.fromJson(Map<String, dynamic> json) {
//     return DiagnosisModel(
//       code: json['code'],
//       description: json['description'],
//       icd10Code: json['icd_10_code'],
//       confidenceScore: json['confidence_score'] ?? '',
//       possibleAlternatives: json['possible_alternatives'] != null ? (json['possible_alternatives'] as List).map((e) => DiagnosisAlternative.fromJson(e)).toList() : null,
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     'code': code,
//     'description': description,
//     'icd_10_code': icd10Code,
//     'confidence_score': confidenceScore,
//     'possible_alternatives': possibleAlternatives?.map((e) => e.toJson()).toList(),
//   };
// }
//
// class DiagnosisAlternative {
//   final String code;
//   final String description;
//
//   DiagnosisAlternative({required this.code, required this.description});
//
//   factory DiagnosisAlternative.fromJson(Map<String, dynamic> json) {
//     return DiagnosisAlternative(code: json['code'], description: json['description']);
//   }
//
//   Map<String, dynamic> toJson() => {'code': code, 'description': description};
// }
//
// class ImpressionPlanModel {
//   final String number;
//   final String title;
//   final String code;
//   final String description;
//   final List<TreatmentModel> treatments;
//   final ImpressionProcedureModel procedure;
//   final String medications;
//   final String orders;
//   final String counselingAndDiscussion;
//   final String followUp;
//
//   ImpressionPlanModel({
//     required this.number,
//     required this.title,
//     required this.code,
//     required this.description,
//     required this.treatments,
//     required this.procedure,
//     required this.medications,
//     required this.orders,
//     required this.counselingAndDiscussion,
//     required this.followUp,
//   });
//
//   factory ImpressionPlanModel.fromJson(Map<String, dynamic> json) {
//     return ImpressionPlanModel(
//       number: json['number'],
//       title: json['title'],
//       code: json['code'],
//       description: json['description'],
//       treatments: (json['treatments'] as List).map((e) => TreatmentModel.fromJson(e)).toList(),
//       procedure: ImpressionProcedureModel.fromJson(json['procedure']),
//       medications: json['medications'],
//       orders: json['orders'],
//       counselingAndDiscussion: json['counseling_and_discussion'],
//       followUp: json['follow_up'],
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     'number': number,
//     'title': title,
//     'code': code,
//     'description': description,
//     'treatments': treatments.map((e) => e.toJson()).toList(),
//     'procedure': procedure.toJson(),
//     'medications': medications,
//     'orders': orders,
//     'counseling_and_discussion': counselingAndDiscussion,
//     'follow_up': followUp,
//   };
// }
//
// class TreatmentModel {
//   final String type;
//   final String name;
//   final List<String> specifications;
//   final List<String> notes;
//
//   TreatmentModel({required this.type, required this.name, required this.specifications, required this.notes});
//
//   factory TreatmentModel.fromJson(Map<String, dynamic> json) {
//     return TreatmentModel(type: json['type'], name: json['name'], specifications: List<String>.from(json['specifications']), notes: List<String>.from(json['notes']));
//   }
//
//   Map<String, dynamic> toJson() => {'type': type, 'name': name, 'specifications': specifications, 'notes': notes};
// }
//
// class ImpressionProcedureModel {
//   final String type;
//   final List<String> details;
//
//   ImpressionProcedureModel({required this.type, required this.details});
//
//   factory ImpressionProcedureModel.fromJson(Map<String, dynamic> json) {
//     return ImpressionProcedureModel(type: json['type'], details: List<String>.from(json['details']));
//   }
//
//   Map<String, dynamic> toJson() => {'type': type, 'details': details};
// }

class DoctorViewModel {
  DoctorViewResponseData? responseData;
  String? message;
  bool? toast;
  String? responseType;

  DoctorViewModel({this.responseData, this.message, this.toast, this.responseType});

  DoctorViewModel.fromJson(Map<String, dynamic> json) {
    responseData = json['responseData'] != null ? DoctorViewResponseData.fromJson(json['responseData']) : null;
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

class DoctorViewResponseData {
  int? id;
  int? patientId;
  int? visitId;
  String? status;
  String? visitDate;
  List<ImpressionsAndPlan>? impressionsAndPlan;
  MainDiagnosisCodesProcedures? mainDiagnosisCodesProcedures;
  dynamic? totalCharges;
  String? message;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  DoctorViewResponseData({
    this.id,
    this.patientId,
    this.visitId,
    this.status,
    this.visitDate,
    this.mainDiagnosisCodesProcedures,
    this.impressionsAndPlan,
    this.totalCharges,
    this.message,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  DoctorViewResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientId = json['patient_id'];
    visitId = json['visit_id'];
    status = json['status'];
    visitDate = json['visit_date'];
    mainDiagnosisCodesProcedures = json['diagnosis_codes_procedures'] != null ? new MainDiagnosisCodesProcedures.fromJson(json['diagnosis_codes_procedures']) : null;
    if (json['impressions_and_plan'] != null) {
      impressionsAndPlan = <ImpressionsAndPlan>[];
      json['impressions_and_plan'].forEach((v) {
        impressionsAndPlan!.add(ImpressionsAndPlan.fromJson(v));
      });
    }
    totalCharges = json['total_charges'];
    message = json['message'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['patient_id'] = patientId;
    data['visit_id'] = visitId;
    data['status'] = status;
    data['visit_date'] = visitDate;

    if (mainDiagnosisCodesProcedures != null) {
      data['diagnosis_codes_procedures'] = mainDiagnosisCodesProcedures!.toJson();
    }

    if (impressionsAndPlan != null) {
      data['impressions_and_plan'] = impressionsAndPlan!.map((v) => v.toJson()).toList();
    }
    data['total_charges'] = totalCharges;
    data['message'] = message;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}

class ImpressionsAndPlan {
  String? number;
  String? title;
  String? code;
  String? description;
  List<ImpressionsAndPlanTreatments>? treatments;
  ImpressionsAndPlanProcedure? procedure;
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
      treatments = <ImpressionsAndPlanTreatments>[];
      json['treatments'].forEach((v) {
        treatments!.add(ImpressionsAndPlanTreatments.fromJson(v));
      });
    }
    procedure = json['procedure'] != null ? ImpressionsAndPlanProcedure.fromJson(json['procedure']) : null;
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

class ImpressionsAndPlanTreatments {
  String? type;
  String? name;
  List<String>? specifications;
  List<String>? notes;

  ImpressionsAndPlanTreatments({this.type, this.name, this.specifications, this.notes});

  ImpressionsAndPlanTreatments.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    name = json['name'];
    specifications = json['specifications'].cast<String>();
    notes = json['notes'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['name'] = name;
    data['specifications'] = specifications;
    data['notes'] = notes;
    return data;
  }
}

class ImpressionsAndPlanProcedure {
  String? type;
  Map<String, dynamic>? details;

  ImpressionsAndPlanProcedure({this.type, this.details});

  ImpressionsAndPlanProcedure.fromJson(Map<String, dynamic> json) {
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

class MainDiagnosisCodesProcedures {
  List<MainDiagnosisCodesProceduresDiagnosisCodesProcedures>? diagnosisCodesProcedures;
  List<PossibleDiagnosisCodesProcedures>? possibleDiagnosisCodesProcedures;

  MainDiagnosisCodesProcedures({this.diagnosisCodesProcedures, this.possibleDiagnosisCodesProcedures});

  MainDiagnosisCodesProcedures.fromJson(Map<String, dynamic> json) {
    if (json['diagnosis_codes_procedures'] != null) {
      diagnosisCodesProcedures = <MainDiagnosisCodesProceduresDiagnosisCodesProcedures>[];
      json['diagnosis_codes_procedures'].forEach((v) {
        diagnosisCodesProcedures!.add(new MainDiagnosisCodesProceduresDiagnosisCodesProcedures.fromJson(v));
      });
    }
    if (json['possible_diagnosis_codes_procedures'] != null) {
      possibleDiagnosisCodesProcedures = <PossibleDiagnosisCodesProcedures>[];
      json['possible_diagnosis_codes_procedures'].forEach((v) {
        possibleDiagnosisCodesProcedures!.add(new PossibleDiagnosisCodesProcedures.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (diagnosisCodesProcedures != null) {
      data['diagnosis_codes_procedures'] = diagnosisCodesProcedures!.map((v) => v.toJson()).toList();
    }
    if (possibleDiagnosisCodesProcedures != null) {
      data['possible_diagnosis_codes_procedures'] = possibleDiagnosisCodesProcedures!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MainDiagnosisCodesProceduresDiagnosisCodesProcedures {
  Procedure? procedure;
  List<Diagnosis>? diagnosis;
  String? units;
  String? unitCharge;
  String? totalCharge;

  MainDiagnosisCodesProceduresDiagnosisCodesProcedures({this.procedure, this.diagnosis, this.units, this.unitCharge, this.totalCharge});

  MainDiagnosisCodesProceduresDiagnosisCodesProcedures.fromJson(Map<String, dynamic> json) {
    procedure = json['procedure'] != null ? new Procedure.fromJson(json['procedure']) : null;
    if (json['diagnosis'] != null) {
      diagnosis = <Diagnosis>[];
      json['diagnosis'].forEach((v) {
        diagnosis!.add(new Diagnosis.fromJson(v));
      });
    }
    units = json['units'];
    unitCharge = json['unit_charge'];
    totalCharge = json['total_charge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (procedure != null) {
      data['procedure'] = procedure!.toJson();
    }
    if (diagnosis != null) {
      data['diagnosis'] = diagnosis!.map((v) => v.toJson()).toList();
    }
    data['units'] = units;
    data['unit_charge'] = unitCharge;
    data['total_charge'] = totalCharge;
    return data;
  }
}

class Procedure {
  String? code;
  String? description;
  String? modifier;
  String? confidenceScore;
  List<ProcedurePossibleAlternatives>? procedurePossibleAlternatives;

  Procedure({this.code, this.description, this.modifier, this.confidenceScore, this.procedurePossibleAlternatives});

  Procedure.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    description = json['description'];
    modifier = json['modifier'];
    confidenceScore = json['confidence_score'];
    if (json['possible_alternatives'] != null) {
      procedurePossibleAlternatives = <ProcedurePossibleAlternatives>[];
      json['possible_alternatives'].forEach((v) {
        procedurePossibleAlternatives!.add(new ProcedurePossibleAlternatives.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['description'] = description;
    data['modifier'] = modifier;
    data['confidence_score'] = confidenceScore;
    if (procedurePossibleAlternatives != null) {
      data['possible_alternatives'] = procedurePossibleAlternatives!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProcedurePossibleAlternatives {
  String? code;
  String? description;
  String? modifier;

  ProcedurePossibleAlternatives({this.code, this.description, this.modifier});

  ProcedurePossibleAlternatives.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    description = json['description'];
    modifier = json['modifier'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['description'] = description;
    data['modifier'] = modifier;
    return data;
  }
}

class Diagnosis {
  String? code;
  String? description;
  String? icd10Code;
  String? confidenceScore;
  List<DiagnosisPossibleAlternatives>? diagnosisPossibleAlternatives;

  Diagnosis({this.code, this.description, this.icd10Code, this.confidenceScore, this.diagnosisPossibleAlternatives});

  Diagnosis.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    description = json['description'];
    icd10Code = json['icd_10_code'];
    confidenceScore = json['confidence_score'];
    if (json['possible_alternatives'] != null) {
      diagnosisPossibleAlternatives = <DiagnosisPossibleAlternatives>[];
      json['possible_alternatives'].forEach((v) {
        diagnosisPossibleAlternatives!.add(new DiagnosisPossibleAlternatives.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['description'] = description;
    data['icd_10_code'] = icd10Code;
    data['confidence_score'] = confidenceScore;
    if (diagnosisPossibleAlternatives != null) {
      data['possible_alternatives'] = diagnosisPossibleAlternatives!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DiagnosisPossibleAlternatives {
  String? code;
  String? description;

  DiagnosisPossibleAlternatives({this.code, this.description});

  DiagnosisPossibleAlternatives.fromJson(Map<String, dynamic> json) {
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

// class Procedure {
//   String? code;
//   String? description;
//   Null? modifier;
//   String? confidenceScore;
//
//   Procedure({this.code, this.description, this.modifier, this.confidenceScore});
//
//   Procedure.fromJson(Map<String, dynamic> json) {
//     code = json['code'];
//     description = json['description'];
//     modifier = json['modifier'];
//     confidenceScore = json['confidence_score'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['code'] = code;
//     data['description'] = description;
//     data['modifier'] = modifier;
//     data['confidence_score'] = confidenceScore;
//     return data;
//   }
// }

// class Diagnosis {
//   String? code;
//   String? description;
//   String? icd10Code;
//   String? confidenceScore;
//
//   Diagnosis({this.code, this.description, this.icd10Code, this.confidenceScore});
//
//   Diagnosis.fromJson(Map<String, dynamic> json) {
//     code = json['code'];
//     description = json['description'];
//     icd10Code = json['icd_10_code'];
//     confidenceScore = json['confidence_score'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['code'] = code;
//     data['description'] = description;
//     data['icd_10_code'] = icd10Code;
//     data['confidence_score'] = confidenceScore;
//     return data;
//   }
// }

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
    // if (specifications != null) {
    //   data['specifications'] = specifications!.map((v) => v.toJson()).toList();
    // }
    data['notes'] = notes;
    return data;
  }
}

class PossibleDiagnosisCodesProcedures {
  Procedure? procedure;
  List<Diagnosis>? diagnosis;
  String? units;
  String? unitCharge;
  String? totalCharge;

  PossibleDiagnosisCodesProcedures({this.procedure, this.diagnosis, this.units, this.unitCharge, this.totalCharge});

  PossibleDiagnosisCodesProcedures.fromJson(Map<String, dynamic> json) {
    procedure = json['procedure'] != null ? new Procedure.fromJson(json['procedure']) : null;
    if (json['diagnosis'] != null) {
      diagnosis = <Diagnosis>[];
      json['diagnosis'].forEach((v) {
        diagnosis!.add(new Diagnosis.fromJson(v));
      });
    }
    units = json['units'];
    unitCharge = json['unit_charge'];
    totalCharge = json['total_charge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (procedure != null) {
      data['procedure'] = procedure!.toJson();
    }
    if (diagnosis != null) {
      data['diagnosis'] = diagnosis!.map((v) => v.toJson()).toList();
    }
    data['units'] = units;
    data['unit_charge'] = unitCharge;
    data['total_charge'] = totalCharge;
    return data;
  }
}

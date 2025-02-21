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
//   DiagnosisCodesProcedures? diagnosisCodesProcedures;
//   dynamic impressionsAndPlan;
//   dynamic totalCharges;
//   String? createdAt;
//   String? updatedAt;
//   dynamic deletedAt;
//
//   DoctorViewResponseData(
//       {this.id, this.patientId, this.visitId, this.status, this.visitDate, this.diagnosisCodesProcedures, this.impressionsAndPlan, this.totalCharges, this.createdAt, this.updatedAt, this.deletedAt});
//
//   DoctorViewResponseData.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     patientId = json['patient_id'];
//     visitId = json['visit_id'];
//     status = json['status'];
//     visitDate = json['visit_date'];
//     diagnosisCodesProcedures = json['diagnosis_codes_procedures'] != null ? DiagnosisCodesProcedures.fromJson(json['diagnosis_codes_procedures']) : null;
//     impressionsAndPlan = json['impressions_and_plan'];
//     totalCharges = json['total_charges'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     deletedAt = json['deleted_at'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['patient_id'] = patientId;
//     data['visit_id'] = visitId;
//     data['status'] = status;
//     data['visit_date'] = visitDate;
//     if (diagnosisCodesProcedures != null) {
//       data['diagnosis_codes_procedures'] = diagnosisCodesProcedures!.toJson();
//     }
//     data['impressions_and_plan'] = impressionsAndPlan;
//     data['total_charges'] = totalCharges;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     data['deleted_at'] = deletedAt;
//     return data;
//   }
// }
//
// class DiagnosisCodesProcedures {
//   List<DiagnosisCodesProcedures>? diagnosisCodesProcedures;
//   List<ImpressionsAndPlan>? impressionsAndPlan;
//   List<TechnicalParameters>? technicalParameters;
//   FinancialInformation? financialInformation;
//
//   DiagnosisCodesProcedures({this.diagnosisCodesProcedures, this.impressionsAndPlan, this.technicalParameters, this.financialInformation});
//
//   DiagnosisCodesProcedures.fromJson(Map<String, dynamic> json) {
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
//     if (json['technical_parameters'] != null) {
//       technicalParameters = <TechnicalParameters>[];
//       json['technical_parameters'].forEach((v) {
//         technicalParameters!.add(TechnicalParameters.fromJson(v));
//       });
//     }
//     financialInformation = json['financial_information'] != null ? FinancialInformation.fromJson(json['financial_information']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (diagnosisCodesProcedures != null) {
//       data['diagnosis_codes_procedures'] = diagnosisCodesProcedures!.map((v) => v.toJson()).toList();
//     }
//     if (impressionsAndPlan != null) {
//       data['impressions_and_plan'] = impressionsAndPlan!.map((v) => v.toJson()).toList();
//     }
//     if (technicalParameters != null) {
//       data['technical_parameters'] = technicalParameters!.map((v) => v.toJson()).toList();
//     }
//     if (financialInformation != null) {
//       data['financial_information'] = financialInformation!.toJson();
//     }
//     return data;
//   }
// }
//
// // class DiagnosisCodesProcedures {
// //   Procedure? procedure;
// //   List<Diagnosis>? diagnosis;
// //   int? units;
// //   double? unitCharge;
// //
// //   DiagnosisCodesProcedures(
// //       {this.procedure, this.diagnosis, this.units, this.unitCharge});
// //
// //   DiagnosisCodesProcedures.fromJson(Map<String, dynamic> json) {
// //     procedure = json['procedure'] != null
// //         ? new Procedure.fromJson(json['procedure'])
// //         : null;
// //     if (json['diagnosis'] != null) {
// //       diagnosis = <Diagnosis>[];
// //       json['diagnosis'].forEach((v) {
// //         diagnosis!.add(new Diagnosis.fromJson(v));
// //       });
// //     }
// //     units = json['units'];
// //     unitCharge = json['unit_charge'];
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = new Map<String, dynamic>();
// //     if (this.procedure != null) {
// //       data['procedure'] = this.procedure!.toJson();
// //     }
// //     if (this.diagnosis != null) {
// //       data['diagnosis'] = this.diagnosis!.map((v) => v.toJson()).toList();
// //     }
// //     data['units'] = this.units;
// //     data['unit_charge'] = this.unitCharge;
// //     return data;
// //   }
// // }
//
// class Procedure {
//   String? code;
//   String? description;
//
//   Procedure({this.code, this.description});
//
//   Procedure.fromJson(Map<String, dynamic> json) {
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
// class ImpressionsAndPlan {
//   String? number;
//   String? description;
//   List<Treatments>? treatments;
//
//   ImpressionsAndPlan({this.number, this.description, this.treatments});
//
//   ImpressionsAndPlan.fromJson(Map<String, dynamic> json) {
//     number = json['number'];
//     description = json['description'];
//     if (json['treatments'] != null) {
//       treatments = <Treatments>[];
//       json['treatments'].forEach((v) {
//         treatments!.add(Treatments.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['number'] = number;
//     data['description'] = description;
//     if (treatments != null) {
//       data['treatments'] = treatments!.map((v) => v.toJson()).toList();
//     }
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
// class TechnicalParameters {
//   String? equipment;
//   String? wavelength;
//   String? spotSize;
//   String? fluence;
//   String? passes;
//   String? density;
//
//   TechnicalParameters({this.equipment, this.wavelength, this.spotSize, this.fluence, this.passes, this.density});
//
//   TechnicalParameters.fromJson(Map<String, dynamic> json) {
//     equipment = json['equipment'];
//     wavelength = json['wavelength'];
//     spotSize = json['spot_size'];
//     fluence = json['fluence'];
//     passes = json['passes'];
//     density = json['density'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['equipment'] = equipment;
//     data['wavelength'] = wavelength;
//     data['spot_size'] = spotSize;
//     data['fluence'] = fluence;
//     data['passes'] = passes;
//     data['density'] = density;
//     return data;
//   }
// }
//
// class FinancialInformation {
//   double? totalCharges;
//   List<Breakdown>? breakdown;
//
//   FinancialInformation({this.totalCharges, this.breakdown});
//
//   FinancialInformation.fromJson(Map<String, dynamic> json) {
//     totalCharges = json['total_charges'];
//     if (json['breakdown'] != null) {
//       breakdown = <Breakdown>[];
//       json['breakdown'].forEach((v) {
//         breakdown!.add(Breakdown.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['total_charges'] = totalCharges;
//     if (breakdown != null) {
//       data['breakdown'] = breakdown!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Breakdown {
//   String? description;
//   double? cost;
//
//   Breakdown({this.description, this.cost});
//
//   Breakdown.fromJson(Map<String, dynamic> json) {
//     description = json['description'];
//     cost = json['cost'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['description'] = description;
//     data['cost'] = cost;
//     return data;
//   }
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
  DiagnosisCodesProcedures? diagnosisCodesProcedures;
  Null? impressionsAndPlan;
  Null? totalCharges;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

  DoctorViewResponseData(
      {this.id, this.patientId, this.visitId, this.status, this.visitDate, this.diagnosisCodesProcedures, this.impressionsAndPlan, this.totalCharges, this.createdAt, this.updatedAt, this.deletedAt});

  DoctorViewResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientId = json['patient_id'];
    visitId = json['visit_id'];
    status = json['status'];
    visitDate = json['visit_date'];
    diagnosisCodesProcedures = json['diagnosis_codes_procedures'] != null ? DiagnosisCodesProcedures.fromJson(json['diagnosis_codes_procedures']) : null;
    impressionsAndPlan = json['impressions_and_plan'];
    totalCharges = json['total_charges'];
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
    if (diagnosisCodesProcedures != null) {
      data['diagnosis_codes_procedures'] = diagnosisCodesProcedures!.toJson();
    }
    data['impressions_and_plan'] = impressionsAndPlan;
    data['total_charges'] = totalCharges;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}

class DiagnosisCodesProcedures {
  List<SubDiagnosisCodesProcedures>? subDiagnosisCodesProcedures;
  List<ImpressionsAndPlan>? impressionsAndPlan;
  List<TechnicalParameters>? technicalParameters;
  FinancialInformation? financialInformation;

  DiagnosisCodesProcedures({this.subDiagnosisCodesProcedures, this.impressionsAndPlan, this.technicalParameters, this.financialInformation});

  DiagnosisCodesProcedures.fromJson(Map<String, dynamic> json) {
    if (json['diagnosis_codes_procedures'] != null) {
      subDiagnosisCodesProcedures = <SubDiagnosisCodesProcedures>[];
      json['diagnosis_codes_procedures'].forEach((v) {
        subDiagnosisCodesProcedures!.add(SubDiagnosisCodesProcedures.fromJson(v));
      });
    }
    if (json['impressions_and_plan'] != null) {
      impressionsAndPlan = <ImpressionsAndPlan>[];
      json['impressions_and_plan'].forEach((v) {
        impressionsAndPlan!.add(ImpressionsAndPlan.fromJson(v));
      });
    }
    if (json['technical_parameters'] != null) {
      technicalParameters = <TechnicalParameters>[];
      json['technical_parameters'].forEach((v) {
        technicalParameters!.add(TechnicalParameters.fromJson(v));
      });
    }
    financialInformation = json['financial_information'] != null ? FinancialInformation.fromJson(json['financial_information']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (subDiagnosisCodesProcedures != null) {
      data['diagnosis_codes_procedures'] = subDiagnosisCodesProcedures!.map((v) => v.toJson()).toList();
    }
    if (impressionsAndPlan != null) {
      data['impressions_and_plan'] = impressionsAndPlan!.map((v) => v.toJson()).toList();
    }
    if (technicalParameters != null) {
      data['technical_parameters'] = technicalParameters!.map((v) => v.toJson()).toList();
    }
    if (financialInformation != null) {
      data['financial_information'] = financialInformation!.toJson();
    }
    return data;
  }
}

class SubDiagnosisCodesProcedures {
  Procedure? procedure;
  List<Procedure>? diagnosis;
  int? units;
  dynamic unitCharge;

  SubDiagnosisCodesProcedures({this.procedure, this.diagnosis, this.units, this.unitCharge});

  SubDiagnosisCodesProcedures.fromJson(Map<String, dynamic> json) {
    procedure = json['procedure'] != null ? Procedure.fromJson(json['procedure']) : null;
    if (json['diagnosis'] != null) {
      diagnosis = <Procedure>[];
      json['diagnosis'].forEach((v) {
        diagnosis!.add(Procedure.fromJson(v));
      });
    }
    units = json['units'];
    unitCharge = json['unit_charge'];
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
    return data;
  }
}

class Procedure {
  String? code;
  String? description;

  Procedure({this.code, this.description});

  Procedure.fromJson(Map<String, dynamic> json) {
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

class ImpressionsAndPlan {
  String? number;
  String? description;
  List<Treatments>? treatments;

  ImpressionsAndPlan({this.number, this.description, this.treatments});

  ImpressionsAndPlan.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    description = json['description'];
    if (json['treatments'] != null) {
      treatments = <Treatments>[];
      json['treatments'].forEach((v) {
        treatments!.add(Treatments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['number'] = number;
    data['description'] = description;
    if (treatments != null) {
      data['treatments'] = treatments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Treatments {
  String? type;
  String? title;
  List<Specifications>? specifications;
  // List<String>? notes;

  Treatments({
    this.type,
    this.title,
    this.specifications,
  });

  Treatments.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    title = json['title'];
    if (json['specifications'] != null) {
      specifications = <Specifications>[];
      json['specifications'].forEach((v) {
        specifications!.add(Specifications.fromJson(v));
      });
    }
    // notes = json['notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['title'] = title;
    if (specifications != null) {
      data['specifications'] = specifications!.map((v) => v.toJson()).toList();
    }
    // data['notes'] = notes;
    return data;
  }
}

class Specifications {
  String? parameter;
  String? value;

  Specifications({this.parameter, this.value});

  Specifications.fromJson(Map<String, dynamic> json) {
    parameter = json['parameter'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['parameter'] = parameter;
    data['value'] = value;
    return data;
  }
}

class TechnicalParameters {
  String? equipment;
  String? wavelength;
  String? spotSize;
  String? fluence;
  String? passes;
  String? density;

  TechnicalParameters({this.equipment, this.wavelength, this.spotSize, this.fluence, this.passes, this.density});

  TechnicalParameters.fromJson(Map<String, dynamic> json) {
    equipment = json['equipment'];
    wavelength = json['wavelength'];
    spotSize = json['spot_size'];
    fluence = json['fluence'];
    passes = json['passes'];
    density = json['density'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['equipment'] = equipment;
    data['wavelength'] = wavelength;
    data['spot_size'] = spotSize;
    data['fluence'] = fluence;
    data['passes'] = passes;
    data['density'] = density;
    return data;
  }
}

class FinancialInformation {
  dynamic totalCharges;
  List<Breakdown>? breakdown;

  FinancialInformation({this.totalCharges, this.breakdown});

  FinancialInformation.fromJson(Map<String, dynamic> json) {
    totalCharges = json['total_charges'];
    if (json['breakdown'] != null) {
      breakdown = <Breakdown>[];
      json['breakdown'].forEach((v) {
        breakdown!.add(Breakdown.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_charges'] = totalCharges;
    if (breakdown != null) {
      data['breakdown'] = breakdown!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Breakdown {
  String? description;
  dynamic cost;

  Breakdown({this.description, this.cost});

  Breakdown.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    cost = json['cost'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['description'] = description;
    data['cost'] = cost;
    return data;
  }
}

class VisitMainPatientDetails {
  ResponseData? responseData;
  String? message;
  bool? toast;
  String? responseType;

  VisitMainPatientDetails({this.responseData, this.message, this.toast, this.responseType});

  VisitMainPatientDetails.fromJson(Map<String, dynamic> json) {
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
  int? visitId;
  String? thirdPartyId;
  String? visitDate;
  String? visitTime;
  String? visitStatus;
  int? id;
  String? patientId;
  String? patientFirstName;
  String? patientMiddleName;
  String? patientLastName;
  String? profileImage;
  int? age;
  String? gender;
  String? doctorName;
  String? medicalAssistantName;
  int? doctorId;
  int? medicalAssistantId;
  List<dynamic>? attachments;
  List<PastVisit>? pastVisitsList;
  PersonalNote? personalNote;
  VisitSnapshot? visitSnapshot;

  ResponseData({this.visitId, this.visitDate, this.visitTime, this.visitStatus, this.id, this.patientId, this.patientFirstName, this.patientMiddleName, this.patientLastName, this.profileImage, this.age, this.gender, this.doctorName, this.medicalAssistantName, this.doctorId, this.medicalAssistantId, this.attachments, this.pastVisitsList, this.personalNote, this.visitSnapshot, this.thirdPartyId});

  ResponseData.fromJson(Map<String, dynamic> json) {
    visitId = json['visit_id'];
    thirdPartyId = json['third_party_id'];
    visitDate = json['visit_date'];
    visitTime = json['visit_time'];
    visitStatus = json['visit_status'];
    id = json['id'];
    patientId = json['patient_id']?.toString();
    patientFirstName = json['patient_first_name'];
    patientMiddleName = json['patient_middle_name'];
    patientLastName = json['patient_last_name'];
    profileImage = json['profile_image'];
    age = json['age'];
    gender = json['gender'];
    doctorName = json['doctorName'];
    medicalAssistantName = json['medicalAssistantName'];
    doctorId = json['doctor_id'];
    medicalAssistantId = json['medical_assistant_id'];
    attachments = json['attachments'] ?? [];

    if (json['pastVisitsList'] != null) {
      pastVisitsList = <PastVisit>[];
      json['pastVisitsList'].forEach((v) {
        pastVisitsList!.add(PastVisit.fromJson(v));
      });
    }

    personalNote = json['personal_note'] != null ? PersonalNote.fromJson(json['personal_note']) : null;

    visitSnapshot = json['visit_snapshot'] != null ? VisitSnapshot.fromJson(json['visit_snapshot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['visit_id'] = visitId;
    data['third_party_id'] = thirdPartyId;
    data['visit_date'] = visitDate;
    data['visit_time'] = visitTime;
    data['visit_status'] = visitStatus;
    data['id'] = id;
    data['patient_id'] = patientId;
    data['patient_first_name'] = patientFirstName;
    data['patient_middle_name'] = patientMiddleName;
    data['patient_last_name'] = patientLastName;
    data['profile_image'] = profileImage;
    data['age'] = age;
    data['gender'] = gender;
    data['doctorName'] = doctorName;
    data['medicalAssistantName'] = medicalAssistantName;
    data['doctor_id'] = doctorId;
    data['medical_assistant_id'] = medicalAssistantId;
    data['attachments'] = attachments;
    if (pastVisitsList != null) {
      data['pastVisitsList'] = pastVisitsList!.map((v) => v.toJson()).toList();
    }
    if (personalNote != null) {
      data['personal_note'] = personalNote!.toJson();
    }
    if (visitSnapshot != null) {
      data['visit_snapshot'] = visitSnapshot!.toJson();
    }
    return data;
  }
}

class PastVisit {
  int? id;
  String? visitDate;
  String? visitTime;
  String? visitStatus;

  PastVisit({this.id, this.visitDate, this.visitTime, this.visitStatus});

  PastVisit.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    visitDate = json['visit_date'];
    visitTime = json['visit_time'];
    visitStatus = json['visit_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['visit_date'] = visitDate;
    data['visit_time'] = visitTime;
    data['visit_status'] = visitStatus;
    return data;
  }
}

class PersonalNote {
  int? id;
  String? visitDate;
  String? personalNote;

  PersonalNote({this.id, this.visitDate, this.personalNote});

  PersonalNote.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    visitDate = json['visit_date'];

    if (json['personal_note'] is String) personalNote = json['personal_note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['visit_date'] = visitDate;

    data['personal_note'] = personalNote;
    return data;
  }
}

class VisitSnapshot {
  int? id;
  String? visitDate;
  String? visitSnapshot;

  VisitSnapshot({this.id, this.visitDate, this.visitSnapshot});

  VisitSnapshot.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    visitDate = json['visit_date'];
    if (json['visit_snapshot'] is String) visitSnapshot = json['visit_snapshot'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['visit_date'] = visitDate;
    data['visit_snapshot'] = visitSnapshot;
    return data;
  }
}

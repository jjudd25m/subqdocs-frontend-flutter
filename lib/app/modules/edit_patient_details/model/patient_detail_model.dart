class PatientDetailModel {
  ResponseData? responseData;
  String? message;
  bool? toast;
  String? responseType;

  PatientDetailModel({this.responseData, this.message, this.toast, this.responseType});

  PatientDetailModel.fromJson(Map<String, dynamic> json) {
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
  String? patientId;
  int? doctorId;
  int? medicalAssistantId;
  String? firstName;
  String? lastName;
  String? contactNumber;
  String? middleName;
  String? dateOfBirth;
  int? age;
  String? email;
  String? gender;
  dynamic profileImage;
  List<ScheduledVisits>? scheduledVisits;
  List<PastVisits>? pastVisits;
  String? visitDate;
  String? visitTime;

  ResponseData({this.id, this.doctorId, this.medicalAssistantId, this.patientId, this.firstName, this.lastName, this.middleName, this.contactNumber, this.dateOfBirth, this.age, this.email, this.visitDate, this.visitTime, this.gender, this.profileImage, this.scheduledVisits, this.pastVisits});

  ResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    doctorId = json['doctor_id'];
    medicalAssistantId = json['medical_assistant_id'];
    patientId = json['patient_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    contactNumber = json['contact_no'];
    middleName = json['middle_name'];
    dateOfBirth = json['date_of_birth'];
    age = json['age'];
    email = json['email'];
    gender = json['gender'];
    visitDate = json['visit_date'];
    visitTime = json['visit_time'];
    profileImage = json['profile_image'];
    if (json['scheduledVisits'] != null) {
      scheduledVisits = <ScheduledVisits>[];
      json['scheduledVisits'].forEach((v) {
        scheduledVisits!.add(ScheduledVisits.fromJson(v));
      });
    }
    if (json['pastVisits'] != null) {
      pastVisits = <PastVisits>[];
      json['pastVisits'].forEach((v) {
        pastVisits!.add(PastVisits.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['doctor_id'] = doctorId;
    data['medical_assistant_id'] = medicalAssistantId;
    data['patient_id'] = patientId;
    data['first_name'] = firstName;
    data['contact_no'] = contactNumber;
    data['last_name'] = lastName;
    data['middle_name'] = middleName;
    data['date_of_birth'] = dateOfBirth;
    data['age'] = age;
    data['email'] = email;
    data['gender'] = gender;

    if (visitDate != null) {
      data['visit_date'] = visitDate;
    }

    if (visitDate != null) {
      data['visit_time'] = visitTime;
    }
    data['profile_image'] = profileImage;
    if (scheduledVisits != null) {
      data['scheduledVisits'] = scheduledVisits!.map((v) => v.toJson()).toList();
    }
    if (pastVisits != null) {
      data['pastVisits'] = pastVisits!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ScheduledVisits {
  String? visitDate;
  String? visitTime;
  int? doctorId;
  int? medicalAssistantId;
  int? id;
  String? thirdPartyId;
  String? doctorName;
  String? medicalAssistantName;

  ScheduledVisits({this.visitDate, this.visitTime, this.doctorId, this.medicalAssistantId, this.id, this.thirdPartyId, this.doctorName, this.medicalAssistantName});

  ScheduledVisits.fromJson(Map<String, dynamic> json) {
    visitDate = json['visit_date'];
    visitTime = json['visit_time'];
    doctorId = json['doctor_id'];
    medicalAssistantId = json['medical_assistant_id'];
    id = json['id'];
    thirdPartyId = json['third_party_id'];
    doctorName = json['doctorName'];
    medicalAssistantName = json['medicalAssistantName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['visit_date'] = this.visitDate;
    data['visit_time'] = this.visitTime;
    data['doctor_id'] = this.doctorId;
    data['medical_assistant_id'] = this.medicalAssistantId;
    data['id'] = this.id;
    data['third_party_id'] = this.thirdPartyId;
    data['doctorName'] = this.doctorName;
    data['medicalAssistantName'] = this.medicalAssistantName;
    return data;
  }
}

// class ScheduledVisits {
//   String? visitDate;
//   String? visitTime;
//   String? visitStatus;
//   int? id;
//
//   ScheduledVisits({this.visitDate, this.visitTime, this.visitStatus, this.id});
//
//   ScheduledVisits.fromJson(Map<String, dynamic> json) {
//     visitDate = json['visit_date'];
//     visitTime = json['visit_time'];
//     visitStatus = json['visit_status'];
//     id = json['id'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['visit_date'] = visitDate;
//     data['visit_time'] = visitTime;
//     data['visit_status'] = visitStatus;
//     data['id'] = id;
//     return data;
//   }
// }

class PastVisits {
  String? visitDate;
  String? visitTime;
  String? visitStatus;
  int? id;
  dynamic summary;

  PastVisits({this.visitDate, this.visitTime, this.visitStatus, this.id, this.summary});

  PastVisits.fromJson(Map<String, dynamic> json) {
    visitDate = json['visit_date'];
    visitTime = json['visit_time'];
    visitStatus = json['visit_status'];
    id = json['id'];
    summary = json['summary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['visit_date'] = visitDate;
    data['visit_time'] = visitTime;
    data['visit_status'] = visitStatus;
    data['id'] = id;
    data['summary'] = summary;
    return data;
  }
}

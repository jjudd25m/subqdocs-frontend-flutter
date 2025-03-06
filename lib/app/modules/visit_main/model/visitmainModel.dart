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
  String? doctorFirstName;
  String? doctorLastName;
  int? visitId;
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
  // List<Null>? attachments;
  PersonalNote? personalNote;

  ResponseData(
      {this.doctorFirstName,
      this.doctorLastName,
      this.visitId,
      this.visitDate,
      this.visitTime,
      this.visitStatus,
      this.id,
      this.patientId,
      this.patientFirstName,
      this.patientMiddleName,
      this.patientLastName,
      this.profileImage,
      this.age,
      this.gender,
      // this.attachments,
      this.personalNote});

  ResponseData.fromJson(Map<String, dynamic> json) {
    doctorFirstName = json['doctor_first_name'];
    doctorLastName = json['doctor_last_name'];
    visitId = json['visit_id'];
    visitDate = json['visit_date'];
    visitTime = json['visit_time'];
    visitStatus = json['visit_status'];
    id = json['id'];
    patientId = json['patient_id'];
    patientFirstName = json['patient_first_name'];
    patientMiddleName = json['patient_middle_name'];
    patientLastName = json['patient_last_name'];
    profileImage = json['profile_image'];
    age = json['age'];
    gender = json['gender'];

    // if (json['attachments'] != null) {
    //   attachments = <Null>[];
    //   json['attachments'].forEach((v) {});
    // }
    personalNote = json['personal_note'] != null ? PersonalNote.fromJson(json['personal_note']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['doctor_first_name'] = doctorFirstName;
    data['doctor_last_name'] = doctorLastName;
    data['visit_id'] = visitId;
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
    if (personalNote != null) {
      data['personal_note'] = personalNote!.toJson();
    }
    return data;
  }
}

class PersonalNote {
  int? id;
  String? visitDate;
  List<dynamic>? personalNote;

  PersonalNote({this.id, this.visitDate, this.personalNote});

  PersonalNote.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    visitDate = json['visit_date'];
    personalNote = json['personal_note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['visit_date'] = visitDate;
    data['personal_note'] = personalNote;
    return data;
  }
}

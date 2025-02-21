class VisitMainPatientDetails {
  ResponseData? responseData;
  String? message;
  bool? toast;
  String? responseType;

  VisitMainPatientDetails({this.responseData, this.message, this.toast, this.responseType});

  VisitMainPatientDetails.fromJson(Map<String, dynamic> json) {
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
  Null? profileImage;
  int? age;
  String? gender;
  List<Null>? attachments;

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
      this.attachments});

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
    if (json['attachments'] != null) {
      attachments = <Null>[];
      json['attachments'].forEach((v) {});
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doctor_first_name'] = this.doctorFirstName;
    data['doctor_last_name'] = this.doctorLastName;
    data['visit_id'] = this.visitId;
    data['visit_date'] = this.visitDate;
    data['visit_time'] = this.visitTime;
    data['visit_status'] = this.visitStatus;
    data['id'] = this.id;
    data['patient_id'] = this.patientId;
    data['patient_first_name'] = this.patientFirstName;
    data['patient_middle_name'] = this.patientMiddleName;
    data['patient_last_name'] = this.patientLastName;
    data['profile_image'] = this.profileImage;
    data['age'] = this.age;
    data['gender'] = this.gender;

    return data;
  }
}

import 'package:flutter/foundation.dart';

import '../../../data/provider/api_provider.dart';
import '../model/patient_list_model.dart';
import '../model/schedule_visit_list_model.dart';

class HomeRepository {
  Future<PatientListModel> getPatient({required Map<String, dynamic> param}) async {
    var response = await ApiProvider.instance.callGet("patient", queryParameters: param);
    print("getPatient API  internal response $response");
    return PatientListModel.fromJson(response);
  }

  Future<ScheduleVisitListModel> getScheduleVisit({required Map<String, dynamic> param}) async {
    var response = await ApiProvider.instance.callGet("patient?");
    print("getScheduleVisit API  internal response $response");
    return ScheduleVisitListModel.fromJson(response);
  }

  Future<ScheduleVisitListModel> getPastVisit({required Map<String, dynamic> param}) async {
    var response = await ApiProvider.instance.callGet("patient?");
    print("getScheduleVisit API  internal response $response");
    return ScheduleVisitListModel.fromJson(response);
  }
}

import 'package:get/get.dart';
import '../../modules/home/model/home_past_patient_list_sorting_model.dart';
import '../../modules/home/model/home_patient_list_sorting_model.dart';
import '../../modules/home/model/home_schedule_list_sorting_model.dart';
import 'app_preferences.dart';

class GlobalController extends GetxController {
  RxInt homeTabIndex = RxInt(0);

  List<Map<String, dynamic>> sortingPastPatient = [
    {"id": "first_name", "desc": true},
    {"id": "appointmentTime", "desc": true},
    {"id": "age", "desc": true},
    {"id": "gender", "desc": true},
    {"id": "previousVisitCount", "desc": true},
    {"id": "status", "desc": true},
  ];

  List<Map<String, dynamic>> sortingSchedulePatient = [
    {"id": "first_name", "desc": true},
    {"id": "appointmentTime", "desc": true},
    {"id": "age", "desc": true},
    {"id": "gender", "desc": true},
    {"id": "previousVisitCount", "desc": true},
  ];

  List<Map<String, dynamic>> sortingPatientList = [
    {"id": "first_name", "desc": true},
    {"id": "lastVisitDate", "desc": true},
    {"id": "age", "desc": true},
    {"id": "gender", "desc": true},
    {"id": "visitCount", "desc": true},
  ];

  List<Map<String, dynamic>> patientListSelectedSorting = [];
  List<Map<String, dynamic>> scheduleVisitSelectedSorting = [
    {"id": "appointmentTime", "desc": false}
  ];

  List<Map<String, dynamic>> pastVisitSelectedSorting = [
    {"id": "appointmentTime", "desc": "true"}
  ];

  Rxn<HomePastPatientListSortingModel> homePastPatientListSortingModel = Rxn();
  Rxn<HomePatientListSortingModel> homePatientListSortingModel = Rxn();
  Rxn<HomeScheduleListSortingModel> homeScheduleListSortingModel = Rxn();

  @override
  void onInit() async {
    super.onInit();

    // homePastPatientListSortingModel.listen(
    //   (p0) {
    //     print("updated val:- ${p0}");
    //   },
    // );
    //
    // homePatientListSortingModel.listen(
    //   (p0) {
    //     print("updated val:- ${p0}");
    //   },
    // );
    //
    // homeScheduleListSortingModel.listen(
    //   (p0) {
    //     print("updated val:- ${p0}");
    //   },
    // );

    HomePastPatientListSortingModel? homePastPatientData = await AppPreference.instance.getHomePastPatientListSortingModel();
    if (homePastPatientData != null) {
      homePastPatientListSortingModel.value = homePastPatientData;
      print("existing HomePastPatientListSortingModel:- ${homePastPatientData.toJson()}");
    } else {
      Map<String, dynamic> json = <String, dynamic>{};
      json['sortingPastPatient'] = sortingPastPatient;
      json['pastVisitSelectedSorting'] = pastVisitSelectedSorting;
      json['colIndex'] = 1;
      json['isAscending'] = true;
      homePastPatientListSortingModel.value = HomePastPatientListSortingModel.fromJson(json);
      print("first initialize homePastPatientListSortingModel :- $json");
    }

    HomePatientListSortingModel? homePatientListData = await AppPreference.instance.getHomePatientListSortingModel();
    if (homePatientListData != null) {
      homePatientListSortingModel.value = homePatientListData;
      print("existing HomePatientListSortingModel:- ${homePatientListData.toJson()}");
    } else {
      Map<String, dynamic> json = <String, dynamic>{};
      json['sortingPatientList'] = sortingPatientList;
      json['patientListSelectedSorting'] = patientListSelectedSorting;
      json['colIndex'] = -1;
      json['isAscending'] = true;
      homePatientListSortingModel.value = HomePatientListSortingModel.fromJson(json);
      print("first initialize homePatientListSortingModel :- $json");
    }

    HomeScheduleListSortingModel? homeScheduleListData = await AppPreference.instance.getHomeScheduleListSortingModel();
    if (homeScheduleListData != null) {
      homeScheduleListSortingModel.value = homeScheduleListData;
      print("existing HomeScheduleListSortingModel:- ${homeScheduleListData.toJson()}");
    } else {
      Map<String, dynamic> json = <String, dynamic>{};
      json['scheduleVisitSelectedSorting'] = scheduleVisitSelectedSorting;
      json['sortingSchedulePatient'] = sortingSchedulePatient;
      json['colIndex'] = 1;
      json['isAscending'] = true;
      homeScheduleListSortingModel.value = HomeScheduleListSortingModel.fromJson(json);
      print("first initialize homeScheduleListSortingModel :- $json");
    }

    // HomePastPatientListSortingModel? retrievedModel = await AppPreference.instance.getHomePastPatientListSortingModel();
    // if (retrievedModel != null) {
    //   homePastPatientListSortingModel.value = retrievedModel;
    // } else {}
    //
    // HomePastPatientListSortingModel? retrievedModel = await AppPreference.instance.getHomePastPatientListSortingModel();
    // if (retrievedModel != null) {
    //   homePastPatientListSortingModel.value = retrievedModel;
    // } else {}

    // patientListSelectedSorting = await AppPreference.instance.getListMap(AppString.prefKeyPatientListSelectedSorting);
    // scheduleVisitSelectedSorting = await AppPreference.instance.getListMap(AppString.prefKeyScheduleVisitSelectedSorting);
    // pastVisitSelectedSorting = await AppPreference.instance.getListMap(AppString.prefKeyPastVisitSelectedSorting);
  }

  Future<void> saveHomePastPatientData() async {
    AppPreference.instance.setHomePastPatientListSortingModel(homePastPatientListSortingModel.value!);
  }

  Future<void> saveHomePatientListData() async {
    AppPreference.instance.setHomePatientListSortingModel(homePatientListSortingModel.value!);
  }

  Future<void> saveHomeScheduleListData() async {
    AppPreference.instance.setHomeScheduleListSortingModel(homeScheduleListSortingModel.value!);
  }
}

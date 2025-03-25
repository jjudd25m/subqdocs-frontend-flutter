import 'package:get/get.dart';
import '../../modules/home/model/FilterListingModel.dart';
import '../../modules/home/model/home_past_patient_list_sorting_model.dart';
import '../../modules/home/model/home_patient_list_sorting_model.dart';
import '../../modules/home/model/home_schedule_list_sorting_model.dart';
import '../../routes/app_pages.dart';
import 'app_preferences.dart';

class GlobalController extends GetxController {
  RxInt homeTabIndex = RxInt(0);
  // var breadcrumbHistory = <String>[];

  Map<String, String> breadcrumbs = {
    Routes.HOME: 'Patients & Visits',
    Routes.ADD_PATIENT: 'Add New',
    Routes.EDIT_PATENT_DETAILS: 'Edit Patient Information',
    Routes.VISIT_MAIN: 'Patient Medical Record',
    Routes.PATIENT_INFO: 'Patient Visit Record',
    Routes.PATIENT_PROFILE: 'Patient Profile',
    Routes.ALL_ATTACHMENT: 'View All Attachments',
  };



  int closeFormState = 0;




  void popUntilRoute(String targetRoute) {
    int targetIndex = breadcrumbHistory.indexOf(targetRoute);
    if (targetIndex != -1) {
      // Pop screens above the target route
      breadcrumbHistory.removeRange(targetIndex + 1, breadcrumbHistory.length); // Remove all screens above the target route
      breadcrumbHistory.refresh();
      print('Popped screens above: $targetRoute');
      // Optionally, navigate to the target route after popping
      // Get.toNamed(targetRoute);
    } else {
      print('Target route not found in history');
      breadcrumbHistory.refresh();
    }
  }
  RxList<String> breadcrumbHistory = RxList([]);


  // as of now dont use furher this  function
  void addRoute(String route) {
    // breadcrumbHistory.add(breadcrumbs[route] ?? route);

  }

  void  addRouteInit(String route) {
    closeFormState = 1;

    breadcrumbHistory.add(breadcrumbs[route] ?? route);

  }

  String getKeyByValue(String value) {
    // Iterate over the map and check for a match
    return breadcrumbs.keys.firstWhere((key) => breadcrumbs[key] == value, orElse: () => 'Not Found');
  }

  // Pop the last route from the stack
  void popRoute() {

    if(closeFormState == 1) {
      if (breadcrumbHistory.isNotEmpty) {
        var poppedRoute = breadcrumbHistory.removeLast();
        print('Popped Route: $poppedRoute');
      } else {
        print('Route stack is empty!');
      }
    }
  }

  // Get the current route stack
  List<String> getRouteStack() {
    return breadcrumbHistory;
  }

  // Optionally, clear the entire stack
  void clearStack() {
    breadcrumbHistory.clear();
    print('Cleared route stack');
  }






  List<Map<String, dynamic>> sortingPastPatient = [
    {"id": "first_name", "desc": true},
    {"id": "appointmentTime", "desc": true},
    {"id": "age", "desc": true},
    {"id": "gender", "desc": true},
    {"id": "previousVisitCount", "desc": true},
    {"id": "status", "desc": true},
  ];

  RxList<FilterListingModel> pastFilterListingModel = RxList([]);
  RxList<FilterListingModel> scheduleFilterListingModel = RxList([]);

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
      json['selectedStatusIndex'] = ["Pending"];
      json['selectedDateValue'] = [];
      json['startDate'] = "";
      json['endDate'] = "";
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
      json['selectedDateValue'] = [];
      json['startDate'] = "";
      json['endDate'] = "";
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
      json['isAscending'] = false;
      json['selectedDateValue'] = [];
      json['startDate'] = "";
      json['endDate'] = "";
      homeScheduleListSortingModel.value = HomeScheduleListSortingModel.fromJson(json);
      print("first initialize homeScheduleListSortingModel :- $json");
    }

    setPastListingModel();
    setScheduleListingModel();
  }

  void setPastListingModel() {
    pastFilterListingModel.clear();

    if ((homePastPatientListSortingModel.value?.selectedStatusIndex ?? []).isNotEmpty) {
      pastFilterListingModel.add(FilterListingModel(filterName: "Status", filterValue: homePastPatientListSortingModel.value!.selectedStatusIndex!.join(",")));
    }

    if ((homePastPatientListSortingModel.value?.startDate ?? "").isNotEmpty && (homePastPatientListSortingModel.value?.endDate ?? "").isNotEmpty) {
      pastFilterListingModel.add(FilterListingModel(filterName: "Visit Date", filterValue: "${homePastPatientListSortingModel.value?.startDate} - ${homePastPatientListSortingModel.value?.endDate} "));
    }
  }

  void setScheduleListingModel() {
    scheduleFilterListingModel.clear();

    if ((homeScheduleListSortingModel.value?.startDate ?? "").isNotEmpty && (homeScheduleListSortingModel.value?.endDate ?? "").isNotEmpty) {
      scheduleFilterListingModel.add(FilterListingModel(filterName: "Visit Date", filterValue: "${homeScheduleListSortingModel.value?.startDate} - ${homeScheduleListSortingModel.value?.endDate} "));
    }
  }

  void removePastFilter({String? keyName}) {
    if (keyName != null) {
      if (keyName == "Visit Date") {
        homePastPatientListSortingModel.value?.startDate = "";
        homePastPatientListSortingModel.value?.endDate = "";
        homePastPatientListSortingModel.value?.selectedDateValue = [];
      }

      if (keyName == "Status") {
        homePastPatientListSortingModel.value?.selectedStatusIndex = [];
      }
      saveHomePastPatientData();
    } else {
      homePastPatientListSortingModel.value?.startDate = "";
      homePastPatientListSortingModel.value?.endDate = "";
      homePastPatientListSortingModel.value?.selectedStatusIndex = [];
      homePastPatientListSortingModel.value?.selectedDateValue = [];
      saveHomePastPatientData();
    }
  }

  void removeScheduleFilter({String? keyName}) {
    if (keyName != null) {
      if (keyName == "Visit Date") {
        homeScheduleListSortingModel.value?.startDate = "";
        homeScheduleListSortingModel.value?.endDate = "";
        homeScheduleListSortingModel.value?.selectedDateValue = [];
      }

      saveHomeScheduleListData();
    } else {
      homeScheduleListSortingModel.value?.startDate = "";
      homeScheduleListSortingModel.value?.endDate = "";
      homeScheduleListSortingModel.value?.selectedDateValue = [];

      saveHomeScheduleListData();
    }
  }

  Future<void> saveHomePastPatientData() async {
    setPastListingModel();
    AppPreference.instance.setHomePastPatientListSortingModel(homePastPatientListSortingModel.value!);
  }

  Future<void> saveHomePatientListData() async {
    AppPreference.instance.setHomePatientListSortingModel(homePatientListSortingModel.value!);
  }

  Future<void> saveHomeScheduleListData() async {
    setScheduleListingModel();

    AppPreference.instance.setHomeScheduleListSortingModel(homeScheduleListSortingModel.value!);
  }
}

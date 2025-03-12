import 'package:get/get.dart';

class HomeScheduleListSortingModel {
  List<Map<String, dynamic>>? scheduleVisitSelectedSorting;
  List<Map<String, dynamic>>? sortingSchedulePatient;

  // RxInt colIndex = RxInt(-1);
  // RxBool isAscending = RxBool(true);
  int colIndex = -1;
  bool isAscending = true;

  // Constructor
  HomeScheduleListSortingModel({
    this.scheduleVisitSelectedSorting,
    this.sortingSchedulePatient,
    // int? colIndex,
    this.colIndex = -1,
    // bool? isAscending,
    this.isAscending = true,
  });

  // fromJson method to create an instance from a Map (JSON)
  factory HomeScheduleListSortingModel.fromJson(Map<String, dynamic> json) {
    return HomeScheduleListSortingModel(
      scheduleVisitSelectedSorting: json['scheduleVisitSelectedSorting'] != null ? List<Map<String, dynamic>>.from(json['scheduleVisitSelectedSorting']) : null,
      sortingSchedulePatient: json['sortingSchedulePatient'] != null ? List<Map<String, dynamic>>.from(json['sortingSchedulePatient']) : null,
      colIndex: json['colIndex'] ?? -1,
      isAscending: json['isAscending'] ?? true,
    );
  }

  // toJson method to convert the instance into a Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'scheduleVisitSelectedSorting': scheduleVisitSelectedSorting,
      'sortingSchedulePatient': sortingSchedulePatient,
      'colIndex': colIndex,
      'isAscending': isAscending,
    };
  }
}

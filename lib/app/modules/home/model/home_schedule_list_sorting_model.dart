import 'package:get/get.dart';

class HomeScheduleListSortingModel {
  List<Map<String, dynamic>>? scheduleVisitSelectedSorting;
  List<Map<String, dynamic>>? sortingSchedulePatient;

  // RxInt colIndex = RxInt(-1);
  // RxBool isAscending = RxBool(true);
  int colIndex = -1;
  bool isAscending = true;
  List<DateTime>? selectedDateValue = [DateTime.now()];
  String? startDate;
  String? endDate;

  // Constructor
  HomeScheduleListSortingModel({
    this.scheduleVisitSelectedSorting,
    this.sortingSchedulePatient,
    // int? colIndex,
    this.colIndex = -1,
    // bool? isAscending,
    this.isAscending = true,
    this.selectedDateValue,
    this.startDate,
    this.endDate,
  });

  // fromJson method to create an instance from a Map (JSON)
  factory HomeScheduleListSortingModel.fromJson(Map<String, dynamic> json) {
    return HomeScheduleListSortingModel(
      scheduleVisitSelectedSorting: json['scheduleVisitSelectedSorting'] != null ? List<Map<String, dynamic>>.from(json['scheduleVisitSelectedSorting']) : null,
      sortingSchedulePatient: json['sortingSchedulePatient'] != null ? List<Map<String, dynamic>>.from(json['sortingSchedulePatient']) : null,
      colIndex: json['colIndex'] ?? -1,
      isAscending: json['isAscending'] ?? true,
      selectedDateValue: json['selectedDateValue'] != null ? (json['selectedDateValue'] as List).map((e) => DateTime.parse(e)).toList() : [DateTime.now()], // Default to the current date
      startDate: json['startDate'],
      endDate: json['endDate'],
    );
  }

  // toJson method to convert the instance into a Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'scheduleVisitSelectedSorting': scheduleVisitSelectedSorting,
      'sortingSchedulePatient': sortingSchedulePatient,
      'colIndex': colIndex,
      'isAscending': isAscending,
      'selectedDateValue': selectedDateValue?.map((e) => e.toIso8601String()).toList(),
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}

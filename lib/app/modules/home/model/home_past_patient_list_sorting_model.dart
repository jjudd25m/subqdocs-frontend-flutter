import 'package:get/get.dart';

class HomePastPatientListSortingModel {
  List<Map<String, dynamic>>? sortingPastPatient;
  List<Map<String, dynamic>>? pastVisitSelectedSorting;
  int colIndex = -1;
  bool isAscending = true;
  List<int>? selectedStatusIndex = RxList();
  List<DateTime>? selectedDateValue = [DateTime.now()];
  String? startDate;
  String? endDate;

  // Constructor
  HomePastPatientListSortingModel({
    this.sortingPastPatient,
    this.pastVisitSelectedSorting,
    this.colIndex = -1,
    this.isAscending = true,
    this.selectedStatusIndex,
    this.selectedDateValue,
    this.startDate,
    this.endDate,
  });

  // fromJson method to create an instance from a Map (JSON)
  factory HomePastPatientListSortingModel.fromJson(Map<String, dynamic> json) {
    return HomePastPatientListSortingModel(
      sortingPastPatient: json['sortingPastPatient'] != null ? List<Map<String, dynamic>>.from(json['sortingPastPatient']) : null,
      pastVisitSelectedSorting: json['pastVisitSelectedSorting'] != null ? List<Map<String, dynamic>>.from(json['pastVisitSelectedSorting']) : null,
      colIndex: json['colIndex'] ?? -1,
      isAscending: json['isAscending'] ?? true,
      selectedStatusIndex: json['selectedStatusIndex'] != null ? List<int>.from(json['selectedStatusIndex']) : [], // Default to empty List<int>
      selectedDateValue: json['selectedDateValue'] != null ? (json['selectedDateValue'] as List).map((e) => DateTime.parse(e)).toList() : [DateTime.now()], // Default to the current date
      startDate: json['startDate'],
      endDate: json['endDate'],
    );
  }

  // toJson method to convert the instance into a Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'sortingPastPatient': sortingPastPatient,
      'pastVisitSelectedSorting': pastVisitSelectedSorting,
      'colIndex': colIndex,
      'isAscending': isAscending,
      'selectedStatusIndex': selectedStatusIndex,
      'selectedDateValue': selectedDateValue?.map((e) => e.toIso8601String()).toList(),
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}

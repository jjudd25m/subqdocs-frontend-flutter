// class HomePatientListSortingModel {
//   List<Map<String, dynamic>>? sortingPatientList;
//   List<Map<String, dynamic>>? patientListSelectedSorting;
//   int colIndex = -1;
//   bool isAscending = true;
//   List<DateTime>? selectedDateValue = [DateTime.now()];
//   String? startDate;
//   String? endDate;
//
//   // Constructor
//   HomePatientListSortingModel({this.sortingPatientList, this.patientListSelectedSorting, this.colIndex = -1, this.isAscending = true, this.selectedDateValue, this.startDate, this.endDate});
//
//   // fromJson method to create an instance from a Map (JSON)
//   factory HomePatientListSortingModel.fromJson(Map<String, dynamic> json) {
//     return HomePatientListSortingModel(
//       sortingPatientList: json['sortingPatientList'] != null ? List<Map<String, dynamic>>.from(json['sortingPatientList']) : null,
//       patientListSelectedSorting: json['patientListSelectedSorting'] != null ? List<Map<String, dynamic>>.from(json['patientListSelectedSorting']) : null,
//       colIndex: json['colIndex'] ?? -1,
//       isAscending: json['isAscending'] ?? true,
//     );
//   }
//
//   // toJson method to convert the instance into a Map (JSON)
//   Map<String, dynamic> toJson() {
//     return {
//       'sortingPatientList': sortingPatientList,
//       'patientListSelectedSorting': patientListSelectedSorting,
//       'colIndex': colIndex,
//       'isAscending': isAscending,
//     };
//   }
// }

class HomePatientListSortingModel {
  List<Map<String, dynamic>>? sortingPatientList;
  List<Map<String, dynamic>>? patientListSelectedSorting;
  int colIndex = -1;
  bool isAscending = true;
  List<DateTime>? selectedDateValue = [DateTime.now()];
  String? startDate;
  String? endDate;

  // Constructor
  HomePatientListSortingModel({
    this.sortingPatientList,
    this.patientListSelectedSorting,
    this.colIndex = -1,
    this.isAscending = true,
    this.selectedDateValue,
    this.startDate,
    this.endDate,
  });

  // fromJson method to create an instance from a Map (JSON)
  factory HomePatientListSortingModel.fromJson(Map<String, dynamic> json) {
    return HomePatientListSortingModel(
      sortingPatientList: json['sortingPatientList'] != null ? List<Map<String, dynamic>>.from(json['sortingPatientList']) : null,
      patientListSelectedSorting: json['patientListSelectedSorting'] != null ? List<Map<String, dynamic>>.from(json['patientListSelectedSorting']) : null,
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
      'sortingPatientList': sortingPatientList,
      'patientListSelectedSorting': patientListSelectedSorting,
      'colIndex': colIndex,
      'isAscending': isAscending,
      'selectedDateValue': selectedDateValue?.map((e) => e.toIso8601String()).toList(),
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}

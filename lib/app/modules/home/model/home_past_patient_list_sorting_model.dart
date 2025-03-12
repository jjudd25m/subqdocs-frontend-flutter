class HomePastPatientListSortingModel {
  List<Map<String, dynamic>>? sortingPastPatient;
  List<Map<String, dynamic>>? pastVisitSelectedSorting;
  int colIndex = -1;
  bool isAscending = true;

  // Constructor
  HomePastPatientListSortingModel({
    this.sortingPastPatient,
    this.pastVisitSelectedSorting,
    this.colIndex = -1,
    this.isAscending = true,
  });

  // fromJson method to create an instance from a Map (JSON)
  factory HomePastPatientListSortingModel.fromJson(Map<String, dynamic> json) {
    return HomePastPatientListSortingModel(
      sortingPastPatient: json['sortingPastPatient'] != null ? List<Map<String, dynamic>>.from(json['sortingPastPatient']) : null,
      pastVisitSelectedSorting: json['pastVisitSelectedSorting'] != null ? List<Map<String, dynamic>>.from(json['pastVisitSelectedSorting']) : null,
      colIndex: json['colIndex'] ?? -1,
      isAscending: json['isAscending'] ?? true,
    );
  }

  // toJson method to convert the instance into a Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'sortingPastPatient': sortingPastPatient,
      'pastVisitSelectedSorting': pastVisitSelectedSorting,
      'colIndex': colIndex,
      'isAscending': isAscending,
    };
  }
}

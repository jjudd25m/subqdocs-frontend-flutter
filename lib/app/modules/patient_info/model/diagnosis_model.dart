// Model class representing a diagnosis with optional description, code, confidence, and alternatives
import '../../visit_main/model/doctor_view_model.dart';

class DiagnosisModel {
  String? description; // optional description of the diagnosis
  String? code; // optional code representing the diagnosis
  String? confidence; // optional confidence level for the diagnosis

  List<DiagnosisPossibleAlternatives>? diagnosisPossibleAlternatives; // optional list of alternative diagnoses

  DiagnosisModel({this.description, this.code, this.confidence, this.diagnosisPossibleAlternatives}); // constructor with named optional parameters
}

// Model class representing a single cell with procedure and diagnosis details
class SingleCellModel {
  String? description; // optional description of the procedure
  String? code; // optional code representing the procedure
  String? unit; // optional unit related to the procedure
  String? modifiers; // optional modifiers for the procedure

  List<ProcedurePossibleAlternatives>? procedurePossibleAlternatives; // optional list of alternative procedures

  List<DiagnosisModel>? diagnosisModelList; // optional list of associated diagnoses

  String? unitPrice; // optional price per unit for the procedure

  SingleCellModel({this.description, this.code, this.unit, this.modifiers, this.procedurePossibleAlternatives, this.unitPrice, this.diagnosisModelList}); // constructor with named optional parameters
}

// Model class representing a table cell containing a list of single cell items
class TableCellModel {
  List<SingleCellModel> items; // list of single cell models in the table cell

  TableCellModel({required this.items}); // constructor with required items parameter
}

// Model class representing a table row containing a list of table cells
class TableRowModel {
  List<TableCellModel> cells; // list of table cell models in the table row

  TableRowModel({required this.cells}); // constructor with required cells parameter
}

// Class representing the model for the table
class TableModel {
  List<TableRowModel> rows;

  TableModel({required this.rows});

  void addRow() {
    rows.add(
      TableRowModel(
        cells: List.generate(
          4,
          (index) => TableCellModel(
            items: [
              SingleCellModel(code: "0", unit: "0", description: "select item ", unitPrice: "0", diagnosisModelList: [DiagnosisModel(description: "selected item ", code: "", confidence: "high ")]),
            ],
          ),
        ),
      ),
    );
  }

  void addItemAtIndex(int row, int col, int index) {
    rows[row].cells[1].items[0].diagnosisModelList?.add(DiagnosisModel(description: "selected item ", code: "", confidence: "high "));
  }

  void addItem(int row, int col) {
    rows[row].cells[col].items.add(SingleCellModel(code: "", unit: "0", description: "select item ", unitPrice: "0"));
  }

  void swapDiagnosisItems({required int fromRow, required int fromCol, required int fromItemIndex, required int fromDiagnosisIndex, required int toRow, required int toCol, required int toItemIndex}) {
    // print("fromRow is :- ${fromRow}");
    // print("fromCol is :- ${fromCol}");
    // print("fromItemIndex is :- ${fromItemIndex}");
    // print("fromDiagnosisIndex is :- ${fromDiagnosisIndex}");
    // print("---------------------------");
    // print("toRow is :- ${toRow}");
    // print("toCol is :- ${toCol}");
    // print("toItemIndex is :- ${toItemIndex}");

    final fromItem = rows[fromRow].cells[fromCol].items[fromItemIndex];
    final toItem = rows[toRow].cells[toCol].items[toItemIndex];

    final fromList = fromItem.diagnosisModelList;
    if (fromList == null || fromList.length <= fromDiagnosisIndex) return;

    final diagnosis = fromList.removeAt(fromDiagnosisIndex);

    toItem.diagnosisModelList ??= [];

    // print("toItem length :- ${toItem.diagnosisModelList?.length ?? 0}");

    if (toItem.diagnosisModelList?.isEmpty ?? true) {
      toItem.diagnosisModelList!.add(diagnosis);
    } else {
      // print("toItemIndex is :- ${toItemIndex}");
      toItem.diagnosisModelList?.insert(toItemIndex, diagnosis);
    }
  }

  void deleteItem(int row, int col, int itemIndex) {
    print("row is :- $row col is:- $col and item index:- $itemIndex");
    rows[row].cells[1].items[0].diagnosisModelList?.removeAt(itemIndex);
  }

  void swapRows(int fromRowIndex, int toRowIndex) {
    print("it's me swapRows");
    final row = rows.removeAt(fromRowIndex);
    rows.insert(toRowIndex, row);
  }

  void swapItems(int row, int col, int fromIndex, int toIndex) {
    print("it's me");

    final item = rows[row].cells[col].items.removeAt(fromIndex);
    rows[row].cells[col].items.insert(toIndex, item);
  }

  void moveDiagnosisItem({required int fromRow, required int fromCol, required int fromItemIndex, required int fromDiagnosisIndex, required int toRow, required int toCol, required int toItemIndex}) {
    final fromList = rows[fromRow].cells[fromCol].items[fromItemIndex].diagnosisModelList;
    if (fromList == null || fromList.length <= fromDiagnosisIndex) return;

    final diagnosis = fromList.removeAt(fromDiagnosisIndex);
    final toList = rows[toRow].cells[toCol].items[toItemIndex].diagnosisModelList ??= [];
    toList.add(diagnosis);
  }

  void moveItem(int fromRow, int fromCol, int itemIndex, int toRow, int toCol) {
    print("it's me moveItem");
    final item = rows[fromRow].cells[fromCol].items.removeAt(itemIndex);
    rows[toRow].cells[toCol].items.add(item);
  }

  void moveCell(int fromRow, int fromCol, int toRow, int toCol) {
    print("it's me moveCell");
    final temp = rows[toRow].cells[toCol];
    rows[toRow].cells[toCol] = rows[fromRow].cells[fromCol];
    rows[fromRow].cells[fromCol] = temp;
  }
}

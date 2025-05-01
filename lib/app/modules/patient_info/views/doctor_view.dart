import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../../visit_main/model/doctor_view_model.dart';
import '../controllers/patient_info_controller.dart';
import '../model/diagnosis_model.dart';
import 'CustomTableDragDemo.dart';
import 'impression_and_plan_docote_view.dart';

class DoctorView extends StatelessWidget {
  DoctorView({super.key});

  PatientInfoController controller = Get.find<PatientInfoController>(tag: Get.arguments["unique_tag"]);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          if (controller.isDoctorViewLoading.value || controller.doctorViewList.value?.responseData == null) ...[
            Center(child: Column(children: [Lottie.asset('assets/lottie/loader.json', width: 200, height: 200, fit: BoxFit.fill), Text(controller.isDoctorViewLoadText.value)])),
          ] else ...[
            if (controller.doctorViewList.value?.responseData?.status == "Failure") ...[
              Center(child: Text(controller.doctorViewList.value?.responseData?.message ?? "", textAlign: TextAlign.center)),
            ] else ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6), bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)),
                    color: AppColors.white,
                    border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 1),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                          color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                          border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Text(textAlign: TextAlign.center, "Diagnosis codes / Procedures", style: AppFonts.medium(16, AppColors.textPurple)),
                                Spacer(),
                                SvgPicture.asset(ImagePath.edit_outline, height: 28, width: 28),
                              ],
                            ),
                            SizedBox(height: 5),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 16),
                      //   child: SingleChildScrollView(
                      //     padding: EdgeInsets.zero,
                      //     child: Column(
                      //       children: [
                      //         Table(
                      //           border: TableBorder.all(
                      //             color: AppColors.buttonBackgroundGrey,
                      //             // Table border color
                      //             width: 1,
                      //             // Border width
                      //             borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)), // Optional rounded corners
                      //           ),
                      //           columnWidths: {
                      //             0: FractionColumnWidth(0.33),
                      //             // Fixed width for "Procedure" column
                      //             1: FractionColumnWidth(0.33),
                      //             // Fixed width for "Diagnosis" column
                      //             2: FractionColumnWidth(0.15),
                      //             // Flexible width for "Unit" column (20% of screen)
                      //             3: FractionColumnWidth(0.19),
                      //             // Flexible width for "Unit charges" column (40% of screen)
                      //           },
                      //           children: controller.doctorViewList.value?.responseData != null ? _getTableRows(controller.doctorViewList.value!.responseData!) : [],
                      //         ),
                      //         Table(
                      //           border: TableBorder.all(
                      //             color: AppColors.buttonBackgroundGrey,
                      //             // Table border color
                      //             width: 1,
                      //             // Border width
                      //             borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)), // Optional rounded corners
                      //           ),
                      //           columnWidths: {
                      //             0: FractionColumnWidth(0.81),
                      //             // Fixed width for "Procedure" column
                      //             1: FractionColumnWidth(0.19),
                      //             // Fixed width for "Diagnosis" column
                      //           },
                      //           children: [
                      //             TableRow(
                      //               decoration: BoxDecoration(
                      //                 color: AppColors.white, // Header row background color
                      //               ),
                      //               children: [_headerBuildTableCell('Total'), _headerBuildTableCell("\$${controller.totalUnitCost.value.toStringAsFixed(2)}")],
                      //             ),
                      //             // Add more rows if needed
                      //           ],
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      SizedBox(height: 10),
                      Obx(() {
                        return IntrinsicHeight(
                          child: NestedDraggableTable(
                            possibleDignosisProcedureTableModel:
                                controller.possibleDignosisProcedureTableModel.value ??
                                TableModel(
                                  rows: [
                                    TableRowModel(
                                      cells: [
                                        TableCellModel(items: [SingleCellModel(code: "40", unit: "0", description: "this the  procedure code", unitPrice: "0")]),
                                        TableCellModel(items: [SingleCellModel(code: "10", unit: "0", description: "this is the Diagnosis", unitPrice: "0")]),
                                        TableCellModel(items: [SingleCellModel(unit: "10")]),
                                        TableCellModel(items: [SingleCellModel(unitPrice: "20")]),
                                      ],
                                    ),
                                  ],
                                ),
                            tableModel:
                                controller.tableModel.value ??
                                TableModel(
                                  rows: [
                                    TableRowModel(
                                      cells: [
                                        TableCellModel(items: [SingleCellModel(code: "40", unit: "0", description: "this the  procedure code", unitPrice: "0")]),
                                        TableCellModel(items: [SingleCellModel(code: "10", unit: "0", description: "this is the Diagnosis", unitPrice: "0")]),
                                        TableCellModel(items: [SingleCellModel(unit: "10")]),
                                        TableCellModel(items: [SingleCellModel(unitPrice: "20")]),
                                      ],
                                    ),
                                  ],
                                ),
                            updateResponse: (List<Map<String, dynamic>> updatedMap, List<Map<String, dynamic>> possibleAlternativeUpdatedMap) {
                              List<Map<String, dynamic>> possibleDiagnosisCodesProcedures = [];

                              for (PossibleDiagnosisCodesProcedures item in controller.doctorViewList.value?.responseData?.mainDiagnosisCodesProcedures?.possibleDiagnosisCodesProcedures ?? []) {
                                possibleDiagnosisCodesProcedures.add(item.toJson());
                              }

                              final Map<String, dynamic> apiPayload = {
                                "diagnosis_codes_procedures": {"diagnosis_codes_procedures": updatedMap, "possible_diagnosis_codes_procedures": possibleAlternativeUpdatedMap},
                              };

                              print("API Payload is:- ${apiPayload}");
                              // print("apiPayload is :- ${controller.doctorViewList.value?.responseData?.id.toString()}");

                              controller.updateDoctorViewAPI(controller.doctorViewList.value?.responseData?.id.toString() ?? "", apiPayload);

                              // print("API Payload is:- ${apiPayload}");
                            },
                            controller: controller,
                          ),
                        );
                      }),

                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              //after table
              SizedBox(height: 10),
              ImpressionAndPlanDoctorView(doctorViewList: controller.doctorViewList),
            ],
          ],
        ],
      );
    });
  }

  Widget _headerBuildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text(text, textAlign: TextAlign.left, style: AppFonts.medium(14, AppColors.black))],
      ),
    );
  }

  Widget _buildTableCell(String text, bool isTotal) {
    return Padding(padding: const EdgeInsets.all(8.0), child: Text(text, style: isTotal ? AppFonts.medium(14, AppColors.black) : AppFonts.regular(14, AppColors.textGrey)));
  }

  List<TableRow> _getTableRows(DoctorViewResponseData patients) {
    List<TableRow> rows = [];

    rows.add(
      TableRow(
        decoration: BoxDecoration(
          color: AppColors.white, // Header row background color
        ),
        children: [_headerBuildTableCell('Procedure'), _headerBuildTableCell('Diagnosis'), _headerBuildTableCell('Unit'), _headerBuildTableCell('Unit charges')],
      ),
    );

    // print("procedure List is :- ${patients.mainDiagnosisCodesProcedures.diagnosisCodesProcedures}");

    controller.totalUnitCost.value = 0;
    // Iterate over each diagnosis procedure data
    for (MainDiagnosisCodesProceduresDiagnosisCodesProcedures diagnosis in patients.mainDiagnosisCodesProcedures?.diagnosisCodesProcedures ?? []) {
      // Ensure each row has exactly 4 children

      String unitChargeStr = diagnosis.unitCharge.toString().replaceAll("\$", "").replaceAll(",", "");

      if (double.tryParse(unitChargeStr) != null) {
        controller.totalUnitCost.value += double.parse(unitChargeStr);
      }
      rows.add(
        TableRow(
          decoration: BoxDecoration(
            color: AppColors.white, // Background color for row (you can alternate rows if needed)
          ),
          children: [
            _buildTableCell("${diagnosis.procedure?.code ?? 'No code'} \n ${diagnosis.procedure?.description ?? 'No description'}", false),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder:
                    (context, index) => InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    width: double.maxFinite,
                                    child: Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(text: "${diagnosis.diagnosis?[index].code} ", recognizer: TapGestureRecognizer()..onTap = () {}, style: AppFonts.semiBold(14, AppColors.black)),
                                          TextSpan(
                                            text: "${diagnosis.diagnosis?[index].description} ",
                                            recognizer: TapGestureRecognizer()..onTap = () {},
                                            style: AppFonts.regular(14, AppColors.black),
                                          ),
                                          if (diagnosis.diagnosis?[index].confidenceScore != "-" && (diagnosis.diagnosis?[index].confidenceScore != "")) ...[
                                            WidgetSpan(
                                              alignment: PlaceholderAlignment.middle,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: AppColors.lightgreenPastVisit,
                                                  // Background color
                                                  borderRadius: BorderRadius.circular(8), // Corner radius
                                                ),
                                                child: Text(
                                                  diagnosis.diagnosis?[index].confidenceScore ?? "",
                                                  style: AppFonts.regular(14, AppColors.greenPastVisit), // Text color
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                itemCount: diagnosis.diagnosis?.length ?? 0,
              ),
            ),
            _buildTableCell(diagnosis.units?.toString() ?? '0', false),
            // Default to '0' if null
            _buildTableCell("${diagnosis.unitCharge?.toString()}", false),
            // Default to '0' if null
          ],
        ),
      );
    }

    return rows;
  }
}

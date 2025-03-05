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

class DoctorView extends GetView<PatientInfoController> {
  const DoctorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          if (controller.isDoctorViewLoading.value || controller.doctorViewList.value?.responseData == null) ...[
            Center(
                child: Column(
              children: [
                Lottie.asset(
                  'assets/lottie/loader.json',
                  width: 200,
                  height: 200,
                  fit: BoxFit.fill,
                ),
                Text(controller.isDoctorViewLoadText.value)
              ],
            ))
          ] else ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                      color: AppColors.white,
                      border: Border.all(color: AppColors.backgroundLightGrey, width: 1)),
                  child: Column(
                    children: [
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                            color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                            border: Border.all(color: AppColors.borderTable, width: 1)),
                        // color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  textAlign: TextAlign.center,
                                  "Diagnosis codes / Procedures",
                                  style: AppFonts.medium(16, AppColors.textPurple),
                                ),
                                Spacer(),
                                SvgPicture.asset(
                                  ImagePath.edit_outline,
                                  height: 28,
                                  width: 28,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.zero,
                          child: Column(
                            children: [
                              Table(
                                border: TableBorder.all(
                                  color: AppColors.buttonBackgroundGrey, // Table border color
                                  width: 1, // Border width
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)), // Optional rounded corners
                                ),
                                columnWidths: {
                                  0: FractionColumnWidth(0.35), // Fixed width for "Procedure" column
                                  1: FractionColumnWidth(0.35), // Fixed width for "Diagnosis" column
                                  2: FractionColumnWidth(0.15), // Flexible width for "Unit" column (20% of screen)
                                  3: FractionColumnWidth(0.15), // Flexible width for "Unit charges" column (40% of screen)
                                },
                                children: controller.doctorViewList.value?.responseData != null ? _getTableRows(controller.doctorViewList.value!.responseData!) : [],
                              ),
                              Table(
                                border: TableBorder.all(
                                  color: AppColors.buttonBackgroundGrey, // Table border color
                                  width: 1, // Border width
                                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)), // Optional rounded corners
                                ),
                                columnWidths: {
                                  0: FractionColumnWidth(0.85), // Fixed width for "Procedure" column
                                  1: FractionColumnWidth(0.15), // Fixed width for "Diagnosis" column
                                },
                                children: [
                                  TableRow(
                                    decoration: BoxDecoration(
                                      color: AppColors.white, // Header row background color
                                    ),
                                    children: [
                                      _headerBuildTableCell('Total'),
                                      _headerBuildTableCell("\$${controller.doctorViewList.value?.responseData?.totalCharges}"),
                                    ],
                                  ),
                                  // Add more rows if needed
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  )),
            ),
            //after table
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                      color: AppColors.white,
                      border: Border.all(color: AppColors.backgroundLightGrey, width: 1)),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                            color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                            border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 1)),
                        // color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  textAlign: TextAlign.center,
                                  "Impressions and Plan",
                                  style: AppFonts.medium(16, AppColors.textPurple),
                                ),
                                Spacer(),
                                SvgPicture.asset(
                                  ImagePath.edit_outline,
                                  height: 28,
                                  width: 28,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ReorderableListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          onReorder: (oldIndex, newIndex) {
                            // setState(() {
                            if (newIndex > oldIndex) {
                              newIndex = newIndex - 1;
                            }
                            // });
                            final task = controller.tasks.removeAt(oldIndex);
                            controller.tasks.insert(newIndex, task);
                          },
                          children: [
                            for (ImpressionsAndPlan task in controller.doctorViewList.value?.responseData?.impressionsAndPlan ?? [])
                              Container(
                                key: ValueKey(task),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          ImagePath.reorder,
                                          height: 15,
                                          width: 10,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          textAlign: TextAlign.center,
                                          "${task.number} ${task.title}",
                                          style: AppFonts.medium(14, AppColors.textPurple),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        for (Treatments treatments in task.treatments ?? [])
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      textAlign: TextAlign.center,
                                                      " ${treatments.type} ${treatments.name} \n",
                                                      style: AppFonts.regular(14, AppColors.black),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    for (Specifications specifications in treatments.specifications ?? [])
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              textAlign: TextAlign.start,
                                                              "${specifications.parameter}: ${specifications.value}",
                                                              style: AppFonts.regular(14, AppColors.black),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    SizedBox(height: 10),
                                                    for (String note in treatments.notes ?? [])
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 0),
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  textAlign: TextAlign.left,
                                                                  "•",
                                                                  style: AppFonts.regular(14, AppColors.black),
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    maxLines: 2,
                                                                    textAlign: TextAlign.left,
                                                                    " $note ",
                                                                    style: AppFonts.regular(14, AppColors.black),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 13,
                                    ),
                                  ],
                                ),
                              )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  )),
            ),
          ]
        ],
      );
    });
  }

  Widget _headerBuildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Text(
        text,
        style: AppFonts.medium(14, AppColors.black),
      ),
    );
  }

  Widget _buildTableCell(String text, bool isTotal) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text, style: isTotal ? AppFonts.medium(14, AppColors.black) : AppFonts.regular(14, AppColors.textGrey)),
    );
  }

  List<TableRow> _getTableRows(DoctorViewResponseData patients) {
    List<TableRow> rows = [];

    rows.add(TableRow(
      decoration: BoxDecoration(
        color: AppColors.white, // Header row background color
      ),
      children: [
        _headerBuildTableCell('Procedure'),
        _headerBuildTableCell('Diagnosis'),
        _headerBuildTableCell('Unit'),
        _headerBuildTableCell('Unit charges'),
      ],
    ));

    // Iterate over each diagnosis procedure data
    for (DiagnosisCodesProcedures diagnosis in patients.diagnosisCodesProcedures ?? []) {
      // Ensure each row has exactly 4 children
      rows.add(
        TableRow(
          decoration: BoxDecoration(
            color: AppColors.white, // Background color for row (you can alternate rows if needed)
          ),
          children: [
            _buildTableCell("${diagnosis.diagnosisCodesProceduresProcedure?.code ?? 'No code'} \n ${diagnosis.diagnosisCodesProceduresProcedure?.description ?? 'No description'}", false),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => InkWell(
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
                                            TextSpan(
                                              text: "${diagnosis.diagnosis?[index].code} ",
                                              recognizer: TapGestureRecognizer()..onTap = () {},
                                              style: AppFonts.semiBold(14, AppColors.black),
                                            ),
                                            TextSpan(
                                              text: "${diagnosis.diagnosis?[index].description} ",
                                              recognizer: TapGestureRecognizer()..onTap = () {},
                                              style: AppFonts.regular(14, AppColors.black),
                                            ),
                                            WidgetSpan(
                                              alignment: PlaceholderAlignment.middle,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: AppColors.lightgreenPastVisit, // Background color
                                                  borderRadius: BorderRadius.circular(8), // Corner radius
                                                ),
                                                child: Text(
                                                  diagnosis.diagnosis?[index].confidenceScore ?? "",
                                                  style: AppFonts.regular(14, AppColors.greenPastVisit), // Text color
                                                ),
                                              ),
                                            ),
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
                  itemCount: diagnosis.diagnosis?.length ?? 0),
            ),
            _buildTableCell(diagnosis.units?.toString() ?? '0', false), // Default to '0' if null
            _buildTableCell("\$${diagnosis.unitCharge?.toString()}", false), // Default to '0' if null
          ],
        ),
      );
    }

    return rows;
  }
}

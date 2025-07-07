import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../../../core/common/logger.dart';
import '../../visit_main/model/doctor_view_model.dart';
import '../controllers/patient_info_controller.dart';
import '../model/diagnosis_model.dart';
import 'CustomTableDragDemo.dart';
import 'impression_and_plan_docote_view.dart';

class DoctorView extends StatelessWidget {
  DoctorView({super.key, required this.controller});

  PatientInfoController controller;

  // Get.find<PatientInfoController>(tag: Get.arguments["unique_tag"]);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          // if (controller.isDoctorViewLoading.value || controller.doctorViewList.value?.responseData == null) ...[
          //   Center(child: Column(children: [Lottie.asset('assets/lottie/loader.json', width: 200, height: 200, fit: BoxFit.fill), Text(controller.isDoctorViewLoadText.value)])),
          // ] else ...[
          if (controller.doctorViewList.value?.responseType == "error") ...[
            Center(child: Padding(padding: const EdgeInsets.all(20), child: Text(controller.doctorViewList.value?.message ?? "No data found", textAlign: TextAlign.start, style: AppFonts.medium(14, AppColors.textBlack)))),
          ] else if (controller.doctorViewList.value?.responseData?.status?.toLowerCase() == "failure") ...[
            Center(child: Padding(padding: const EdgeInsets.all(20), child: Text(controller.doctorViewList.value?.responseData?.message ?? "No data found", textAlign: TextAlign.start, style: AppFonts.medium(14, AppColors.textBlack)))),
          ] else ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Text(textAlign: TextAlign.left, "Patient Medical Record", style: AppFonts.medium(20, AppColors.textBlack)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      controller.loadDoctorviewPDF(controller.visitId);
                    },
                    child: SvgPicture.asset(ImagePath.download_pdf, width: 30, height: 30),
                  ),
                  const SizedBox(width: 5),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Divider(height: 1, color: AppColors.textGrey.withValues(alpha: 0.2)),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 0),
                decoration: BoxDecoration(borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6), bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)), color: AppColors.white, border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 1)),
                child: Column(
                  children: [
                    Container(
                      height: 40,
                      decoration: BoxDecoration(borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)), color: AppColors.backgroundPurple.withValues(alpha: 0.2), border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 0)),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Text(textAlign: TextAlign.center, "Diagnosis codes & Procedures", style: AppFonts.medium(16, AppColors.textPurple)),
                              const Spacer(),
                              // SvgPicture.asset(ImagePath.edit_outline, height: 28, width: 28),
                            ],
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const SizedBox(height: 10),
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
                                      TableCellModel(
                                        items: [
                                          SingleCellModel(code: "10", unit: "0", description: "this is the Diagnosis", unitPrice: "0", diagnosisModelList: [DiagnosisModel(code: "0", confidence: "0", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s")]),
                                        ],
                                      ),
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
                                      TableCellModel(
                                        items: [
                                          SingleCellModel(code: "10", unit: "0", description: "this is the Diagnosis", unitPrice: "0", diagnosisModelList: [DiagnosisModel(code: "0", confidence: "0", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s")]),
                                        ],
                                      ),
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

                            customPrint("API Payload is:- $apiPayload");
                            // print("apiPayload is :- ${controller.doctorViewList.value?.responseData?.id.toString()}");

                            controller.updateDoctorViewAPI(controller.doctorViewList.value?.responseData?.id.toString() ?? "", apiPayload);

                            // print("API Payload is:- ${apiPayload}");
                          },
                          controller: controller,
                        ),
                      );
                    }),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            //after table
            const SizedBox(height: 10),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: ImpressionAndPlanDoctorView(controller: controller)),
          ],
          // ],
        ],
      );
    });
  }
}

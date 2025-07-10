import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../controllers/patient_info_controller.dart';
import 'EditableViews/patient_view_editable.dart';

class PatientView extends StatelessWidget {
  const PatientView({super.key, required this.controller});

  final PatientInfoController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Stack(
        children: [
          // if (controller.isPatientViewLoading.value || controller.patientViewListModel.value?.responseData == null) ...[
          //   if (controller.isPatientViewLoadText.value.toLowerCase() == "failure") ...[
          //     const Center(child: Column(children: [SizedBox(height: 90), Text("An error occurred while processing the patient view")])),
          //   ] else ...[
          //     Center(child: Column(children: [const SizedBox(height: 90), Lottie.asset('assets/lottie/loader.json', width: 200, height: 200, fit: BoxFit.fill), Text(controller.isPatientViewLoadText.value)])),
          //   ],
          // ] else ...[
          // if (controller.patientViewListModel.value?.responseType == "error") ...[
          //   Center(child: Padding(padding: const EdgeInsets.all(20), child: Text(controller.patientFullNoteModel.value?.message ?? "No data found", textAlign: TextAlign.start, style: AppFonts.medium(14, AppColors.textBlack)))),
          // ] else
          //
          if (controller.patientViewListModel.value?.responseData?.status?.toLowerCase() == "failure") ...[
            Center(child: Padding(padding: const EdgeInsets.all(20), child: Text(controller.patientViewListModel.value?.responseData?.message ?? "No data found", textAlign: TextAlign.start, style: AppFonts.medium(14, AppColors.textBlack)))),
          ] else ...[
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Text(textAlign: TextAlign.left, "Patient Medical Record", style: AppFonts.medium(20, AppColors.textBlack)),
                      const Spacer(),

                      GestureDetector(
                        onTap: () {
                          controller.copyPatientViewSection();
                          // controller.copyAllSection();
                        },
                        child: const Icon(Icons.copy, color: Colors.grey),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          controller.loadPatientNotePDF(controller.visitId);
                        },
                        child: SvgPicture.asset(ImagePath.download_pdf, width: 30, height: 30),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Divider(height: 1, color: AppColors.textGrey.withValues(alpha: 0.2)),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    decoration: BoxDecoration(borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6), bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)), color: AppColors.white, border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 1)),
                    child: Column(
                      children: [
                        Container(
                          height: 40,
                          decoration: BoxDecoration(borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)), color: AppColors.backgroundPurple.withValues(alpha: 0.2), border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 0.01)),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              const SizedBox(height: 5),
                              Row(children: [Text(textAlign: TextAlign.center, "Note", style: AppFonts.medium(16, AppColors.textPurple)), const Spacer()]),
                              const SizedBox(height: 5),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        if (controller.editableDataForPatientView.isEmpty) ...[
                          const Skeletonizer(
                            enabled: true,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                              child: Column(
                                spacing: 10,
                                children: [
                                  Row(children: [Expanded(child: Text("You came in for treatment of bothersome small growths on your right hand and a lesion on your right inner calf."))]),
                                  Row(children: [Expanded(child: Text("You came in for treatment of bothersome small growths on your right hand and a lesion on your right inner calf."))]),
                                  Row(children: [Expanded(child: Text("You came in for treatment of bothersome small growths on your right hand and a lesion on your right inner calf."))]),
                                  Row(children: [Expanded(child: Text("You came in for treatment of bothersome small growths on your right hand and a lesion on your right inner calf."))]),
                                ],
                              ),
                            ),
                          ),
                        ] else ...[
                          PatientViewEditable(controller: controller),
                        ],
                        const SizedBox(height: 0),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ],
          // ],
        ],
      );
    });
  }
}

// import 'package:flutter/cupertino.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get_rx/src/rx_types/rx_types.dart';
//
// import '../../../../utils/app_colors.dart';
// import '../../../../utils/app_fonts.dart';
// import '../../../../utils/imagepath.dart';
// import '../../visit_main/model/doctor_view_model.dart';
//
// class ImpressionAndPlanDoctorView extends StatelessWidget {
//   Rxn<DoctorViewModel> doctorViewList = Rxn();
//   ImpressionAndPlanDoctorView({super.key, required this.doctorViewList});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 10),
//       child: Container(
//         width: double.infinity,
//         padding: EdgeInsets.symmetric(horizontal: 0),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6), bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)),
//           color: AppColors.white,
//           border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 1),
//         ),
//         child: Column(children: [_headerSection(), SizedBox(height: 12), _taskListSection(), SizedBox(height: 5)]),
//       ),
//     );
//   }
//
//   Widget _headerSection() {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
//         color: AppColors.backgroundPurple.withValues(alpha: 0.2),
//         border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 0.01),
//       ),
//       padding: EdgeInsets.symmetric(horizontal: 10),
//       child: Column(
//         children: [
//           SizedBox(height: 5),
//           Row(children: [Text("Impressions and Plan", textAlign: TextAlign.center, style: AppFonts.medium(16, AppColors.textPurple)), Spacer(), SvgPicture.asset(ImagePath.edit_outline, height: 28, width: 28)]),
//           SizedBox(height: 5),
//         ],
//       ),
//     );
//   }
//
//   Widget _taskListSection() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: ListView(shrinkWrap: true, physics: NeverScrollableScrollPhysics(), children: [for (ImpressionsAndPlan task in doctorViewList.value?.responseData?.impressionsAndPlan ?? []) _taskSection(task)]),
//     );
//   }
//
//   Widget _taskSection(ImpressionsAndPlan task) {
//     return Container(
//       key: ValueKey(task),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _taskHeader(task),
//           _taskDescription(task),
//           _treatmentsSection(task),
//           _procedureSection(task),
//           _medicationsSection(task),
//           _ordersSection(task),
//           _counselingSection(task),
//           _followUpSection(task),
//           SizedBox(height: 7),
//         ],
//       ),
//     );
//   }
//
//   Widget _taskHeader(ImpressionsAndPlan task) {
//     return Row(children: [Text("${task.number}. ${task.title} (${task.code})", style: AppFonts.medium(14, AppColors.textPurple))]);
//   }
//
//   Widget _taskDescription(ImpressionsAndPlan task) {
//     return Padding(padding: const EdgeInsets.only(left: 25), child: Text(task.description ?? "", style: AppFonts.regular(14, AppColors.black)));
//   }
//
//   Widget _treatmentsSection(ImpressionsAndPlan task) {
//     if ((task.treatments ?? []).isEmpty) return SizedBox.shrink();
//     return Padding(
//       padding: const EdgeInsets.only(left: 25),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Treatments:", style: AppFonts.bold(15, AppColors.textBlack)), ...task.treatments!.map((treatment) => _treatmentItem(treatment)).toList()]),
//     );
//   }
//
//   Widget _treatmentItem(ImpressionsAndPlanTreatments treatment) {
//     if (treatment.type?.isEmpty ?? true) return SizedBox.shrink();
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(children: [SizedBox(width: 10), Expanded(child: Text("${treatment.type} ${treatment.name}", style: AppFonts.regular(14, AppColors.textBlack)))]),
//         ...treatment.specifications?.map((spec) => _treatmentSpecification(spec)).toList() ?? [],
//         ...treatment.notes?.map((note) => _treatmentNoteSection(note)).toList() ?? [],
//         SizedBox(height: 5),
//       ],
//     );
//   }
//
//   Widget _treatmentSpecification(String spec) {
//     return Row(children: [SizedBox(width: 5), Expanded(child: Text("• $spec", style: AppFonts.regular(14, AppColors.black)))]);
//   }
//
//   Widget _treatmentNoteSection(String note) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 15),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("Notes:", style: AppFonts.bold(14, AppColors.black)),
//           Row(children: [SizedBox(width: 55), Text("•", style: AppFonts.regular(14, AppColors.black)), SizedBox(width: 5), Expanded(child: Text(note, style: AppFonts.regular(14, AppColors.black)))]),
//         ],
//       ),
//     );
//   }
//
//   Widget _procedureSection(ImpressionsAndPlan task) {
//     if (task.procedure == null || (task.procedure?.details?.isEmpty ?? true)) return SizedBox.shrink();
//     return Padding(
//       padding: const EdgeInsets.only(left: 25),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (task.procedure?.type?.isNotEmpty ?? false) Text("${task.procedure?.type}:", style: AppFonts.bold(16, AppColors.black)),
//           if (task.procedure?.location?.isNotEmpty ?? false) _procedureLocationSection(task),
//           ..._procedureDetailsSection(task),
//         ],
//       ),
//     );
//   }
//
//   Widget _procedureLocationSection(ImpressionsAndPlan task) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 5),
//       child: Row(
//         children: [
//           Padding(padding: const EdgeInsets.only(left: 35), child: Text("• Location:", style: AppFonts.bold(14, AppColors.textBlack))),
//           Expanded(child: Text(task.procedure?.location ?? "", style: AppFonts.regular(14, AppColors.black))),
//         ],
//       ),
//     );
//   }
//
//   List<Widget> _procedureDetailsSection(ImpressionsAndPlan task) {
//     return (task.procedure?.details ?? {}).entries
//         .where((entry) => entry.value != null && entry.value.toString().trim().isNotEmpty)
//         .map(
//           (entry) => Padding(
//             padding: const EdgeInsets.only(left: 35),
//             child: Row(children: [Text("• ${entry.key}:", style: AppFonts.bold(14, AppColors.black)), Expanded(child: Text(" ${entry.value}", style: AppFonts.regular(14, AppColors.black)))]),
//           ),
//         )
//         .toList();
//   }
//
//   Widget _medicationsSection(ImpressionsAndPlan task) {
//     if (task.medications == null || task.medications == "-" || task.medications == "") return SizedBox.shrink();
//     return Padding(
//       padding: const EdgeInsets.only(left: 25),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("Medications:", style: AppFonts.bold(15, AppColors.black)),
//           Row(children: [SizedBox(width: 25), Expanded(child: Text("${task.medications}", style: AppFonts.regular(14, AppColors.textBlack)))]),
//           SizedBox(height: 5),
//         ],
//       ),
//     );
//   }
//
//   Widget _ordersSection(ImpressionsAndPlan task) {
//     if (task.orders == null || task.orders == "-" || task.orders == "") return SizedBox.shrink();
//     return Padding(
//       padding: const EdgeInsets.only(left: 25),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("Orders:", style: AppFonts.bold(15, AppColors.black)),
//           Row(children: [SizedBox(width: 25), Expanded(child: Text("${task.orders}", style: AppFonts.regular(14, AppColors.textBlack)))]),
//         ],
//       ),
//     );
//   }
//
//   Widget _counselingSection(ImpressionsAndPlan task) {
//     if (task.counselingAndDiscussion == null || task.counselingAndDiscussion == "-" || task.counselingAndDiscussion == "") return SizedBox.shrink();
//     return Padding(
//       padding: const EdgeInsets.only(left: 25),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("Counseling and Discussion:", style: AppFonts.bold(15, AppColors.black)),
//           Row(children: [SizedBox(width: 25), Expanded(child: Text("${task.counselingAndDiscussion}", style: AppFonts.regular(14, AppColors.textBlack)))]),
//         ],
//       ),
//     );
//   }
//
//   Widget _followUpSection(ImpressionsAndPlan task) {
//     if (task.followUp == null || task.followUp == "-" || task.followUp == "") return SizedBox.shrink();
//     return Padding(
//       padding: const EdgeInsets.only(left: 25),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("Follow Up:", style: AppFonts.bold(15, AppColors.black)),
//           Row(children: [SizedBox(width: 25), Expanded(child: Text("${task.followUp}", style: AppFonts.regular(14, AppColors.textBlack)))]),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:html_editor_enhanced/html_editor.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_fonts.dart';
import '../../../../../utils/imagepath.dart';
import '../../../../core/common/html_editor_container.dart';
import '../../../visit_main/model/doctor_view_model.dart';
import '../../controllers/patient_info_controller.dart';
import '../../model/impresion_and_plan_view_model.dart';

class skinHistoryEditableView extends StatelessWidget {
  PatientInfoController controller = Get.find<PatientInfoController>(tag: Get.arguments["unique_tag"]);
  skinHistoryEditableView({super.key});

  @override
  Widget build(BuildContext context) {
    return _taskListSection();
  }

  // Widget _taskListSection() {
  Widget _taskListSection() {
    return Obx(() {
      return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: controller.editableDataForSkinHistory.length,
        itemBuilder: (context, index) {
          return HtmlEditorViewWidget(
            padding: const EdgeInsets.only(left: 10, right: 10),
            heightOfTheEditableView: 300,
            impresionAndPlanViewModel: controller.editableDataForSkinHistory[index],
            onUpdateCallBack: (impressionModel, content) {
              controller.editableDataForSkinHistory[index] = impressionModel;
              controller.editableDataForSkinHistory.refresh();
              controller.updateFullNote("skin_history_with_location", controller.editableDataForSkinHistory);

              // controller.updateImpressionAndPlan();
            },
            toggleCallBack: (impressionModel) {
              controller.resetImpressionAndPlanList();
              impressionModel.isEditing = true;
              controller.editableDataForSkinHistory[index] = impressionModel;
              controller.editableDataForSkinHistory.refresh();
            },
          );
        },
      );
    });
  }
}

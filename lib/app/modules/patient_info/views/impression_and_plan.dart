import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../model/patient_fullnote_model.dart';

class ImpressionAndPlan extends StatelessWidget {
  final Rxn<PatientFullNoteModel> patientFullNoteModel;
  final List<String> tasks = ["A Task"];

  ImpressionAndPlan({required this.patientFullNoteModel, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: AppColors.white, border: Border.all(color: AppColors.backgroundPurple.withOpacity(0.2), width: 1)),
      child: Column(
        children: [
          _buildHeader(),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ReorderableListView(
              buildDefaultDragHandles: false,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              onReorder: (oldIndex, newIndex) {},
              children: [for (final task in tasks) Container(key: ValueKey(task), child: _buildNoteContent())],
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 60,
      decoration: BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(6)), color: AppColors.backgroundPurple.withOpacity(0.2)),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          SizedBox(height: 10),
          Row(children: [Text("Impressions and Plan", style: AppFonts.medium(16, AppColors.textPurple)), Spacer(), SvgPicture.asset(ImagePath.edit_outline, height: 40, width: 40)]),
        ],
      ),
    );
  }

  Widget _buildNoteContent() {
    final plans = patientFullNoteModel.value?.responseData?.fullNoteDetails?.impressionsAndPlan ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 20),
          child: ListView.builder(shrinkWrap: true, physics: NeverScrollableScrollPhysics(), itemCount: plans.length, itemBuilder: (context, index) => _buildPlanItem(plans[index], index)),
        ),
      ],
    );
  }

  Widget _buildPlanItem(ImpressionsAndPlan plan, int index) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Text("${plan.number}.", style: AppFonts.bold(14, AppColors.textPurple)), SizedBox(width: 5), Expanded(child: Text("${plan.title} (${plan.code})", style: AppFonts.regular(14, AppColors.textPurple)))]),
            SizedBox(height: 5),
            Html(data: plan.description ?? "", style: {"body": Style(margin: Margins.all(0), fontFamily: "Poppins", fontSize: FontSize(14.0))}),
            if ((plan.treatments ?? []).isNotEmpty) _buildTreatments(plan.treatments!),
            if (plan.procedure?.type != null && plan.procedure?.type != "-") _buildProcedure(plan),
            if (plan.medications != null && plan.medications != "-") _buildTextBlock("Medications", plan.medications!),
            if (plan.orders != null && plan.orders != "-") _buildTextBlock("Orders", plan.orders!),
            _buildTextBlock("Counseling and Discussion", plan.counselingAndDiscussion),
            if (plan.followUp?.isNotEmpty ?? false) _buildTextBlock("Follow up", plan.followUp!),
          ],
        ),
      ),
    );
  }

  Widget _buildTreatments(List<Treatments> treatments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text("Treatments:", style: AppFonts.bold(15, AppColors.textBlack)),
        for (final t in treatments)
          if (t.type?.isNotEmpty ?? false)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  Text(" ${t.type} ${t.name}", style: AppFonts.regular(14, AppColors.textBlack)),
                  for (String spec in t.specifications ?? []) Text("• $spec", style: AppFonts.regular(14, AppColors.black)),
                  if ((t.notes ?? []).isNotEmpty) ...[
                    SizedBox(height: 5),
                    Text("Notes:", style: AppFonts.bold(14, AppColors.black)),
                    for (String note in t.notes!) Padding(padding: const EdgeInsets.only(left: 50), child: Text("• $note", maxLines: 2, style: AppFonts.regular(14, AppColors.black))),
                  ],
                ],
              ),
            ),
      ],
    );
  }

  Widget _buildProcedure(ImpressionsAndPlan plan) {
    final procedure = plan.procedure;

    if (procedure == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (procedure.type != null && procedure.type!.trim().isNotEmpty) Text("${procedure.type}:", style: AppFonts.bold(14, AppColors.textBlack)),
        if (procedure.location != null && procedure.location!.trim().isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Row(
              children: [
                Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Text("• Location:", style: AppFonts.bold(14, AppColors.textBlack))),
                Expanded(child: Text(procedure.location!, style: AppFonts.regular(14, AppColors.black))),
              ],
            ),
          ),
        const SizedBox(height: 3),
        if (procedure.details != null)
          ...procedure.details!.entries
              .where((entry) => entry.value != null && entry.value.toString().trim().isNotEmpty)
              .map(
                (entry) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("• ${entry.key}:", style: AppFonts.bold(14, AppColors.black), textAlign: TextAlign.left),
                      Expanded(child: Text(" ${entry.value}", style: AppFonts.regular(14, AppColors.black), textAlign: TextAlign.left)),
                    ],
                  ),
                ),
              ),
      ],
    );
  }

  Widget _buildTextBlock(String title, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [SizedBox(height: 10), Text("$title:", style: AppFonts.bold(14, AppColors.textBlack)), Text(value ?? "", style: AppFonts.regular(14, AppColors.textBlack))],
    );
  }
}

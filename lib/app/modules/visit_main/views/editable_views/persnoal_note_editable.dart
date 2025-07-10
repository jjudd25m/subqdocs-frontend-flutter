import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../core/common/html_editor_container.dart';
import '../../controllers/visit_main_controller.dart';

class PersnoalNoteEditable extends StatelessWidget {
  VisitMainController controller;
  PersnoalNoteEditable({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return _taskListSection();
  }

  // Widget _taskListSection() {
  Widget _taskListSection() {
    return Obx(() {
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: controller.editablePersnoalNote.length,
        itemBuilder: (context, index) {
          return HtmlEditorViewWidget(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            heightOfTheEditableView: 400,
            impresionAndPlanViewModel: controller.editablePersnoalNote[index],
            onUpdateCallBack: (impressionModel, content) {
              controller.editablePersnoalNote[index] = impressionModel;
              controller.editablePersnoalNote.refresh();
              controller.updatePatientVisit("personal_note", controller.editablePersnoalNote, controller.patientData.value.responseData?.personalNote?.id);
            },
            toggleCallBack: (impressionModel) {
              controller.resetImpressionAndPlanList();
              impressionModel.isEditing = true;

              controller.editablePersnoalNote[index] = impressionModel;
              controller.editablePersnoalNote.refresh();
            },
          );
        },
      );
    });
  }
}

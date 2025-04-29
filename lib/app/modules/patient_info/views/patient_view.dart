import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:lottie/lottie.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../controllers/patient_info_controller.dart';
import 'EditableViews/exam_editable.dart';
import 'EditableViews/patient_view_editable.dart';

class PatientView extends StatelessWidget {
  PatientView({super.key});
  PatientInfoController controller = Get.find<PatientInfoController>(tag: Get.arguments["unique_tag"]);
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Stack(
        children: [
          if (controller.isPatientViewLoading.value || controller.patientViewListModel.value?.responseData == null) ...[
            if (controller.isPatientViewLoadText.value.toLowerCase() == "failure") ...[
              Center(child: Column(children: [SizedBox(height: 90), Text("An error occurred while processing the patient view")])),
            ] else ...[
              Center(child: Column(children: [SizedBox(height: 90), Lottie.asset('assets/lottie/loader.json', width: 200, height: 200, fit: BoxFit.fill), Text(controller.isPatientViewLoadText.value)])),
            ],
          ] else ...[
            if (controller.patientViewListModel.value?.responseData?.status == "Failure") ...[
              Center(child: Text(controller.patientViewListModel.value?.responseData?.message ?? "No data found", textAlign: TextAlign.center)),
            ] else ...[
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
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
                              border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 0.01),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              children: [
                                SizedBox(height: 5),
                                Row(children: [Text(textAlign: TextAlign.center, "Note", style: AppFonts.medium(16, AppColors.textPurple)), Spacer(), SvgPicture.asset(ImagePath.edit_outline, height: 28, width: 28)]),
                                SizedBox(height: 5),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),

                          PatientViewEditable(),
                          SizedBox(height: 0),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                ],
              ),
            ],
          ],
        ],
      );
    });
  }
}

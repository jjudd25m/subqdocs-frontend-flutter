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

class VisitDataView extends StatelessWidget {
  VisitDataView({super.key});
  PatientInfoController controller = Get.find<PatientInfoController>(tag: Get.arguments["unique_tag"]);
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                    color: AppColors.white,
                    border: Border.all(color: AppColors.backgroundLightGrey, width: 1),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                          color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                          border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 1),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Text(textAlign: TextAlign.center, "Visit Note", style: AppFonts.medium(16, AppColors.textPurple)),
                                Spacer(),
                                SvgPicture.asset(ImagePath.edit_outline, height: 28, width: 28),
                              ],
                            ),
                            SizedBox(height: 5),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.zero,
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder:
                                      (context, index) => InkWell(
                                        onTap: () {},
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    textAlign: TextAlign.left,
                                                    controller.patientDoctorVisitDataModel.value?.responseData?.visitNoteDetails.dynamicData.keys
                                                            .elementAt(index)
                                                            .replaceAll("_", " ")
                                                            .capitalizeFirst ??
                                                        '',
                                                    style: AppFonts.medium(14, AppColors.textBlack),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                              ListView.builder(
                                                shrinkWrap: true,
                                                physics: NeverScrollableScrollPhysics(),
                                                itemCount:
                                                    controller
                                                        .patientDoctorVisitDataModel
                                                        .value
                                                        ?.responseData!
                                                        .visitNoteDetails
                                                        .dynamicData[controller.patientDoctorVisitDataModel.value?.responseData?.visitNoteDetails.dynamicData.keys.elementAt(index)]
                                                        ?.length ??
                                                    0, // Number of items
                                                itemBuilder: (context, subIndex) {
                                                  return Row(
                                                    children: [
                                                      if (controller.patientDoctorVisitDataModel.value?.responseData?.visitNoteDetails.dynamicData.keys.toList()[index] == "personal_note") ...[
                                                        Text(textAlign: TextAlign.left, "• ", style: AppFonts.semiBold(16, AppColors.textGrey)),
                                                      ],
                                                      Expanded(
                                                        child: Text(
                                                          textAlign: TextAlign.left,
                                                          controller.patientDoctorVisitDataModel.value?.responseData!.visitNoteDetails.dynamicData[controller
                                                                  .patientDoctorVisitDataModel
                                                                  .value
                                                                  ?.responseData
                                                                  ?.visitNoteDetails
                                                                  .dynamicData
                                                                  .keys
                                                                  .elementAt(index)]?[subIndex] ??
                                                              "",
                                                          style: AppFonts.regular(14, AppColors.textGrey),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                              SizedBox(height: 20),
                                            ],
                                          ),
                                        ),
                                      ),
                                  itemCount: controller.patientDoctorVisitDataModel.value?.responseData?.visitNoteDetails.dynamicData.values.length ?? 0,
                                ),
                                //
                              ),
                              SizedBox(height: 10),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 0),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5),
            ],
          ),
          if (controller.isVisitDataLoading.value || controller.patientDoctorVisitDataModel.value?.responseData == null) ...[
            if (controller.isVisitDataLoadText.value.toLowerCase() == "failure") ...[
              Center(child: Column(children: [SizedBox(height: 90), Text("An error occurred while processing the patient view")])),
            ] else ...[
              Center(child: Column(children: [SizedBox(height: 90), Lottie.asset('assets/lottie/loader.json', width: 200, height: 200, fit: BoxFit.fill), Text(controller.isVisitDataLoadText.value)])),
            ],
          ],
        ],
      );
    });
  }
}

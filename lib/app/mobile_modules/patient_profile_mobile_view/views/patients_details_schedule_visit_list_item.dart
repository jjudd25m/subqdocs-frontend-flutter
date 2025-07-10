import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subqdocs/app/mobile_modules/patient_profile_mobile_view/controllers/patient_profile_mobile_view_controller.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/utils/app_fonts.dart';

import '../../../modules/edit_patient_details/model/patient_detail_model.dart';
import '../../../modules/home/views/reschedule_patient_mobile_dialog.dart';
import '../../../modules/visit_main/views/delete_schedule_visit.dart';
import '../../../routes/app_pages.dart';

class PatientDetailsScheduleVisitItem extends GetView<PatientProfileMobileViewController> {
  ScheduledVisits? data;
  bool isAccessible = false;

  PatientDetailsScheduleVisitItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    isAccessible = (controller.globalController.getEMAOrganizationDetailModel.value?.responseData?.isEmaIntegration ?? false) && (data?.thirdPartyId != null);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(10), border: Border.all(width: 1, color: AppColors.black.withAlpha(25))),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), decoration: BoxDecoration(color: AppColors.lightpurpule, borderRadius: BorderRadius.circular(6)), child: Text(controller.getScheduleDate(data?.visitDate ?? ""), style: AppFonts.medium(14, AppColors.textPurple))),
                const SizedBox(width: 10),
                Text("Visit Time:", style: AppFonts.regular(14, AppColors.black)),
                const SizedBox(width: 4),
                Text(controller.getScheduleTime(data?.visitTime ?? ""), style: AppFonts.regular(14, AppColors.textDarkGrey)),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 25,
              width: double.maxFinite,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Start Visit Now
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.ADD_RECORDING_MOBILE_VIEW, arguments: {"patientId": controller.patientId, "visitId": data?.id.toString()});
                    },
                    child: Text("Start visit now", style: AppFonts.medium(14, AppColors.textPurple)),
                  ),
                  const SizedBox(
                    // Wrapped VerticalDivider in SizedBox
                    height: 20,
                    child: VerticalDivider(),
                  ),

                  // Reschedule
                  IgnorePointer(
                    ignoring: isAccessible,
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            return ReschedulePatientMobileDialog(
                              receiveParam: (p0, p1) {
                                controller.reScheduleVisit(param: {"visit_date": p1, "visit_time": p0}, visitId: data?.id.toString() ?? "-1");
                              },
                            );
                          },
                        );
                      },
                      child: Text("Reschedule", style: AppFonts.medium(14, isAccessible ? AppColors.textPurple.withValues(alpha: 0.5) : AppColors.textPurple)),
                    ),
                  ),
                  const SizedBox(
                    // Wrapped VerticalDivider in SizedBox
                    height: 20,
                    child: VerticalDivider(),
                  ),

                  // Cancel Visit
                  IgnorePointer(
                    ignoring: isAccessible,
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            return DeleteScheduleVisit(
                              onDelete: () {
                                controller.changeStatus("Cancelled", data?.id.toString() ?? "-1");
                              },
                            );
                          },
                        );
                      },
                      child: Text("Cancel visit", style: AppFonts.medium(14, isAccessible ? AppColors.textPurple.withValues(alpha: 0.5) : AppColors.textPurple)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

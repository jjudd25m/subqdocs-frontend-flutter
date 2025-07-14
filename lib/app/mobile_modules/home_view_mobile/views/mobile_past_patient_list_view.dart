import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subqdocs/app/mobile_modules/home_view_mobile/controllers/home_view_mobile_controller.dart';
import 'package:subqdocs/app/routes/app_pages.dart';
import 'package:subqdocs/widgets/custom_animated_button.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../widget/base_image_view.dart';
import '../../../../widgets/empty_patient_mobile_screen.dart';
import '../../../../app/core/common/logger.dart';

class MobilePastPatientListView extends GetView<HomeViewMobileController> {
  const MobilePastPatientListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.all(0.0),
        child:
            controller.isHomePastPatientListLoading.value
                ? const Padding(padding: EdgeInsets.symmetric(vertical: 150, horizontal: 10), child: Center(child: CircularProgressIndicator()))
                : controller.pastVisitList.isEmpty
                ? Padding(padding: const EdgeInsets.all(10), child: EmptyPatientMobileScreen(onBtnPress: () async {}, title: "No Past Visit", description: "Start by adding your first patient to manage appointments, view medical history, and keep track of visits—all in one place"))
                : RefreshIndicator(
                  color: Colors.white,
                  backgroundColor: AppColors.backgroundPurple,
                  strokeWidth: 2.5,
                  displacement: 60.0,
                  onRefresh: () async {
                    controller.pagePast = 1;

                    controller.getPastVisitList();
                    customPrint("refresh patient list view");
                  },
                  child: NotificationListener<ScrollEndNotification>(
                    onNotification: (notification) {
                      if (notification.metrics.atEdge) {
                        customPrint("notification.metrics.atEdge");
                      }

                      // If user reaches the bottom and no data is being loaded
                      if (notification.metrics.extentBefore == notification.metrics.maxScrollExtent && !controller.isLoading.value) {
                        customPrint("notification.metrics.extentBefore == notification.metrics.maxScrollExtent && !isLoading");

                        controller.getPastVisitListFetchMore();
                      }
                      return false; // Allow other notifications to propagate
                    },
                    child: GetBuilder<HomeViewMobileController>(
                      builder:
                          (controller) => ListView.builder(
                            controller: controller.scrollControllerPastPatientList,
                            padding: const EdgeInsets.only(bottom: 80.0),
                            // Adjust based on FAB height,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount:
                                controller.pastVisitList.length +
                                (controller.noMoreDataPastPatientList.value
                                    ? 1
                                    : controller.isLoading.value
                                    ? 1
                                    : 0),
                            itemBuilder: (context, index) {
                              if (index == controller.pastVisitList.length && controller.noMoreDataPastPatientList.value) {
                                return Center(child: Padding(padding: const EdgeInsets.all(8.0), child: Text("No more records to load", style: AppFonts.bold(13, AppColors.textGrey))));
                              } else {
                                if (index == controller.pastVisitList.length && controller.isLoading.value) {
                                  // Show loading spinner at the bottom when loading
                                  return const Center(child: CircularProgressIndicator(color: AppColors.buttonBackgroundGrey));
                                } else {
                                  // Build and return the actual table row

                                  return Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), child: patientListCard(context, index));
                                }
                              }
                            },
                          ),
                    ),
                  ),
                ),
      );
    });
  }

  Widget patientListCard(BuildContext context, int rowIndex) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.PATIENT_INFO_MOBILE_VIEW, arguments: {"patientId": controller.pastVisitList[rowIndex].id.toString(), "visitId": controller.pastVisitList[rowIndex].visitId.toString()});
        controller.updateTabbar();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black.withValues(alpha: 0.1), width: 1.5), borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            // Patient Info Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Patient Avatar and Name
                Expanded(
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25.0),
                        child: BaseImageView(
                          imageUrl: controller.pastVisitList[rowIndex].profileImage ?? "",
                          width: 50,
                          height: 50,
                          nameLetters:
                              "${controller.pastVisitList[rowIndex].firstName?.trim() ?? ""} "
                              "${controller.pastVisitList[rowIndex].lastName?.trim() ?? ""}",
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Patient Name and Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${controller.pastVisitList[rowIndex].firstName?.trim() ?? ""} "
                              "${controller.pastVisitList[rowIndex].lastName?.trim() ?? ""}",
                              style: AppFonts.medium(14, AppColors.textBlackDark),
                            ),
                            const SizedBox(height: 4),

                            if (controller.pastVisitList[rowIndex].age != null && controller.pastVisitList[rowIndex].age != 0) ...[
                              Text("${controller.pastVisitList[rowIndex].age} | ${controller.pastVisitList[rowIndex].gender?.capitalizeFirst}", style: AppFonts.medium(12, AppColors.textDarkGrey)),
                            ] else ...[
                              if (controller.pastVisitList[rowIndex].gender != null) ...[Text("${controller.pastVisitList[rowIndex].gender?.capitalizeFirst}", style: AppFonts.medium(12, AppColors.textDarkGrey))],
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Container(
                    decoration: BoxDecoration(color: controller.getStatusColor(controller.pastVisitList[rowIndex].visitStatus ?? "").withValues(alpha: 0.2), borderRadius: BorderRadius.circular(16)),
                    child: Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), child: Text(controller.pastVisitList[rowIndex].visitStatus ?? "", maxLines: 2, overflow: TextOverflow.visible, textAlign: TextAlign.center, style: AppFonts.medium(13, controller.getStatusColor(controller.pastVisitList[rowIndex].visitStatus ?? "")))),
                  ),
                ),
                // Three-dots Menu
                // GestureDetector(
                //   onTap: () {
                //     // Add menu tap functionality
                //   },
                //   child: Container(color: AppColors.white, padding: const EdgeInsets.only(bottom: 20, left: 20, right: 10, top: 5), child: SvgPicture.asset("assets/images/logo_threedots.svg", height: 15, width: 15)),
                // ),
              ],
            ),
            const SizedBox(height: 15),
            // Visits Info Row
            Row(
              children: [
                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), decoration: BoxDecoration(color: AppColors.lightpurpule, borderRadius: BorderRadius.circular(6)), child: Text(controller.getScheduleDate(controller.pastVisitList[rowIndex].visitDate ?? ""), style: AppFonts.medium(14, AppColors.textPurple))),
                const SizedBox(width: 10),
                Text(controller.getScheduleTime(controller.pastVisitList[rowIndex].visitTime ?? ""), style: AppFonts.regular(14, AppColors.textDarkGrey)),
                const Spacer(),
                // Text("Visits: ", softWrap: true, style: AppFonts.medium(12, AppColors.textBlackDark)),
                // Expanded(child: Text(maxLines: 1, "${controller.pastVisitList[rowIndex].previousVisitCount ?? "0"} Past", overflow: TextOverflow.clip, style: AppFonts.medium(12, AppColors.textDarkGrey))),
                if (controller.globalController.getEMAOrganizationDetailModel.value?.responseData?.isEmaIntegration == false) ...[
                  SizedBox(
                    width: 120,
                    child: CustomAnimatedButton(
                      onPressed: () {
                        customPrint("patient id :- ${controller.pastVisitList[rowIndex].id}");
                        controller.createVisit(controller.pastVisitList[rowIndex].id ?? 0);
                      },
                      height: 40,
                      text: "Record Now",
                      enabledTextColor: AppColors.textPurple,
                      isOutline: true,
                      outlineColor: AppColors.filterBorder,
                      enabledColor: AppColors.ScreenBackGround,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

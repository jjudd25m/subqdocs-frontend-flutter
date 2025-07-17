import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subqdocs/app/mobile_modules/home_view_mobile/controllers/home_view_mobile_controller.dart';
import 'package:subqdocs/widgets/custom_tab_button.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../widget/base_image_view.dart';
import '../../../../widgets/empty_patient_mobile_screen.dart';
import '../../../routes/app_pages.dart';

class MobileScheduleListView extends GetView<HomeViewMobileController> {
  const MobileScheduleListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.all(0.0),
        child:
            controller.isHomeScheduleListLoading.value
                ? const Padding(padding: EdgeInsets.symmetric(vertical: 150, horizontal: 10), child: Center(child: CircularProgressIndicator()))
                : controller.scheduleVisitList.isEmpty
                ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: EmptyPatientMobileScreen(
                    buttonTitle: " Schedule Patient ",
                    onBtnPress: () async {
                      await Get.toNamed(Routes.ADD_PATIENT_MOBILE_VIEW);
                      controller.updateTabbar();
                    },
                    title: "No patients Scheduled",
                    description: "Start by adding your first patient to manage appointments, view medical history, and keep track of visits—all in one place",
                  ),
                )
                : RefreshIndicator(
                  color: Colors.white,
                  backgroundColor: AppColors.backgroundPurple,
                  strokeWidth: 2.5,
                  displacement: 60.0,
                  onRefresh: () async {
                    controller.pageSchedule = 1;

                    controller.getScheduleVisitList();
                  },
                  child: NotificationListener<ScrollEndNotification>(
                    onNotification: (notification) {
                      if (notification.metrics.atEdge) {}

                      // If user reaches the bottom and no data is being loaded
                      if (notification.metrics.extentBefore == notification.metrics.maxScrollExtent && !controller.isLoading.value) {
                        controller.getScheduleVisitListFetchMore();
                      }
                      return false; // Allow other notifications to propagate
                    },
                    child: GetBuilder<HomeViewMobileController>(
                      builder:
                          (controller) => ListView.builder(
                            controller: controller.scrollControllerSchedulePatientList,
                            padding: const EdgeInsets.only(bottom: 80.0),
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount:
                                controller.scheduleVisitList.length +
                                (controller.noMoreDataSchedulePatientList.value
                                    ? 1
                                    : controller.isLoading.value
                                    ? 1
                                    : 0),
                            itemBuilder: (context, index) {
                              if (index == controller.scheduleVisitList.length && controller.noMoreDataSchedulePatientList.value) {
                                return Center(child: Padding(padding: const EdgeInsets.all(8.0), child: Text("No more records to load", style: AppFonts.bold(13, AppColors.textGrey))));
                              } else {
                                if (index == controller.scheduleVisitList.length && controller.isLoading.value) {
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
      onTap: () async {
        await Get.toNamed(Routes.PATIENT_PROFILE_MOBILE_VIEW, arguments: {"patientId": controller.scheduleVisitList[rowIndex].id.toString()});
        controller.updateTabbar();
        // Add onTap functionality here
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
                          imageUrl: controller.scheduleVisitList[rowIndex].profileImage ?? "",
                          width: 50,
                          height: 50,
                          nameLetters:
                              "${controller.scheduleVisitList[rowIndex].firstName?.trim() ?? ""} "
                              "${controller.scheduleVisitList[rowIndex].lastName?.trim() ?? ""}",
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Patient Name and Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${controller.scheduleVisitList[rowIndex].firstName?.trim() ?? ""} "
                              "${controller.scheduleVisitList[rowIndex].lastName?.trim() ?? ""}",
                              style: AppFonts.medium(14, AppColors.textBlackDark),
                            ),
                            const SizedBox(height: 4),
                            if (controller.scheduleVisitList[rowIndex].age != null && controller.scheduleVisitList[rowIndex].age != 0) ...[
                              Text("${controller.scheduleVisitList[rowIndex].age} | ${controller.scheduleVisitList[rowIndex].gender?.capitalizeFirst}", style: AppFonts.medium(12, AppColors.textDarkGrey)),
                            ] else ...[
                              if (controller.scheduleVisitList[rowIndex].gender != null) ...[Text("${controller.scheduleVisitList[rowIndex].gender?.capitalizeFirst}", style: AppFonts.medium(12, AppColors.textDarkGrey))],
                            ],
                          ],
                        ),
                      ),
                    ],
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
                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), decoration: BoxDecoration(color: AppColors.lightpurpule, borderRadius: BorderRadius.circular(6)), child: Text(controller.getScheduleDate(controller.scheduleVisitList[rowIndex].visitDate ?? ""), style: AppFonts.medium(14, AppColors.textPurple))),
                const SizedBox(width: 10),
                Text(controller.getScheduleTime(controller.scheduleVisitList[rowIndex].visitTime ?? ""), style: AppFonts.regular(14, AppColors.textDarkGrey)),
                const Spacer(),
                // Text("Visits: ", softWrap: true, style: AppFonts.medium(14, AppColors.textBlackDark)),
                // Expanded(child: Text(maxLines: 1, "${controller.scheduleVisitList[rowIndex].previousVisitCount ?? "0"} Past", overflow: TextOverflow.clip, style: AppFonts.medium(14, AppColors.textDarkGrey))),
                SizedBox(
                  width: 120,
                  child: CustomTabButton(
                    onPressed: () async {
                      await Get.toNamed(Routes.ADD_RECORDING_MOBILE_VIEW, arguments: {"patientId": controller.scheduleVisitList[rowIndex].id.toString(), "visitId": controller.scheduleVisitList[rowIndex].visitId.toString()});
                      controller.updateTabbar();
                    },
                    height: 40,
                    text: "Record Now",
                    enabledTextColor: AppColors.textPurple,
                    isOutline: true,
                    outlineColor: AppColors.filterBorder,
                    enabledColor: AppColors.ScreenBackGround,
                    borderRadius: 10,
                    outlineWidth: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

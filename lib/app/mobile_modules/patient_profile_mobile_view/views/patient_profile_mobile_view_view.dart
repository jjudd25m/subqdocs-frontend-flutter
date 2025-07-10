import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:subqdocs/app/mobile_modules/patient_profile_mobile_view/views/patients_details_schedule_visit_list_item.dart';
import 'package:subqdocs/app/mobile_modules/patient_profile_mobile_view/views/patients_details_visit_recaps_list_item.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../../../../widget/base_image_view.dart';
import '../../../../widgets/base_screen_mobile.dart';
import '../../../../widgets/custom_tab_button.dart';
import '../../../routes/app_pages.dart';
import '../controllers/patient_profile_mobile_view_controller.dart';

class PatientProfileMobileViewView extends StatefulWidget {
  const PatientProfileMobileViewView({super.key});

  @override
  State<PatientProfileMobileViewView> createState() => _PatientProfileMobileViewViewState();
}

class _PatientProfileMobileViewViewState extends State<PatientProfileMobileViewView> {
  PatientProfileMobileViewController controller = Get.put(PatientProfileMobileViewController());

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BaseScreenMobile(
      showDrawer: false,
      onItemSelected: (index) async {},
      body: Stack(
        children: [
          RefreshIndicator(
            backgroundColor: AppColors.white,
            onRefresh: () async {
              controller.getPatient(controller.patientId);
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverAppBar(
                  surfaceTintColor: AppColors.backgroundMobileAppbar,
                  backgroundColor: AppColors.backgroundMobileAppbar,
                  pinned: true,
                  floating: false,
                  expandedHeight: 150,
                  // We'll handle the appbar separately
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: Container(
                      color: AppColors.backgroundMobileAppbar,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          spacing: 15,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 40),
                            Obx(() {
                              return Row(
                                children: [
                                  controller.patientDetailModel.value?.responseData?.id == -1
                                      ? ClipRRect(borderRadius: BorderRadius.circular(20.0), child: Image.asset(fit: BoxFit.cover, ImagePath.user, height: 40, width: 40))
                                      : GestureDetector(
                                        onTap: () async {},
                                        child: ClipRRect(borderRadius: BorderRadius.circular(40.0), child: BaseImageView(imageUrl: controller.patientDetailModel.value?.responseData?.profileImage ?? "", width: 75, height: 75, nameLetters: "${controller.patientDetailModel.value?.responseData?.firstName?.trim() ?? ""} ${controller.patientDetailModel.value?.responseData?.lastName?.trim() ?? ""}")),
                                      ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [Text("${controller.patientDetailModel.value?.responseData?.firstName ?? ""} ${controller.patientDetailModel.value?.responseData?.lastName ?? ""}", style: AppFonts.medium(18, AppColors.black)), const SizedBox(height: 4), Text(controller.patientDetailModel.value?.responseData?.email ?? "", style: AppFonts.medium(12, AppColors.textDarkGrey))],
                                    ),
                                  ),
                                  // GestureDetector(
                                  //   onTap: () {
                                  //     // Add menu tap functionality
                                  //   },
                                  //   child: Container(color: AppColors.clear, padding: const EdgeInsets.only(bottom: 20, left: 20, right: 10, top: 5), child: SvgPicture.asset("assets/images/logo_threedots.svg", height: 20, width: 20)),
                                  // ),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: IconButton(
                      highlightColor: Colors.transparent,
                      icon: SvgPicture.asset(ImagePath.back_arrow_mobile, height: 20, width: 20),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ),
                  centerTitle: true,
                  title: Text("Medical Record", style: AppFonts.medium(15.0, AppColors.textBlackDark)),
                  actions: const [SizedBox()],
                ),

                SliverPersistentHeader(
                  pinned: true,
                  delegate: _StickyTabBarDelegate(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      color: AppColors.backgroundMobileAppbar,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SingleChildScrollView(
                            controller: controller.scrollController,
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              spacing: 24,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  key: controller.tabKeys[0],
                                  onTap: () {
                                    setState(() => _selectedIndex = 0);
                                    _scrollToSelectedTab();
                                  },
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(padding: const EdgeInsets.only(bottom: 12.0), child: Text('Scheduled Visits', style: TextStyle(color: _selectedIndex == 0 ? AppColors.textPurple : AppColors.textDarkGrey, fontWeight: FontWeight.w500))),
                                      Container(height: 3.0, width: _getTextWidth('Scheduled Visits', const TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0)), decoration: BoxDecoration(color: _selectedIndex == 0 ? AppColors.textPurple : Colors.transparent, borderRadius: BorderRadius.circular(1.5))),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  key: controller.tabKeys[1],
                                  onTap: () {
                                    setState(() => _selectedIndex = 1);
                                    _scrollToSelectedTab();
                                  },
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(padding: const EdgeInsets.only(bottom: 12.0), child: Text('Visit Recaps', style: TextStyle(color: _selectedIndex == 1 ? AppColors.textPurple : AppColors.textDarkGrey, fontWeight: FontWeight.w500))),
                                      Container(height: 3.0, width: _getTextWidth('Visit Recaps', const TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0)), decoration: BoxDecoration(color: _selectedIndex == 1 ? AppColors.textPurple : Colors.transparent, borderRadius: BorderRadius.circular(1.5))),
                                    ],
                                  ),
                                ),
                                // GestureDetector(
                                //   key: controller.tabKeys[2],
                                //   onTap: () {
                                //     setState(() => _selectedIndex = 2);
                                //     _scrollToSelectedTab();
                                //   },
                                //   child: Column(
                                //     mainAxisSize: MainAxisSize.min,
                                //     children: [
                                //       Padding(padding: const EdgeInsets.only(bottom: 12.0), child: Text('More Documents', style: TextStyle(color: _selectedIndex == 2 ? AppColors.textPurple : AppColors.textDarkGrey, fontWeight: FontWeight.w500))),
                                //       Container(
                                //         height: 3.0,
                                //         width: _getTextWidth('More Documents', const TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0)),
                                //         decoration: BoxDecoration(color: _selectedIndex == 2 ? AppColors.textPurple : Colors.transparent, borderRadius: BorderRadius.circular(1.5)),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          Container(height: 2.0, width: double.infinity, decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.0), color: AppColors.backgroundPurple.withValues(alpha: 0.1))),
                        ],
                      ),
                    ),
                  ),
                ),

                if (_selectedIndex == 0) ...[
                  Obx(() {
                    return (controller.patientDetailModel.value?.responseData?.scheduledVisits?.isNotEmpty ?? false)
                        ? SliverList(
                          delegate: SliverChildBuilderDelegate((context, index) {
                            return PatientDetailsScheduleVisitItem(data: controller.patientDetailModel.value?.responseData?.scheduledVisits![index]);
                          }, childCount: controller.patientDetailModel.value?.responseData?.scheduledVisits?.length ?? 0),
                        )
                        : SliverFillRemaining(
                          hasScrollBody: false,
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 40),
                                SvgPicture.asset(ImagePath.no_data_found_mobile, width: MediaQuery.of(context).size.width * 0.7),
                                const SizedBox(height: 10),
                                SvgPicture.asset(ImagePath.divider_medical_note, width: MediaQuery.of(context).size.width * 0.6),
                                const SizedBox(height: 10),
                                Center(child: Text("No data found!", textAlign: TextAlign.center, style: AppFonts.regular(16.0, AppColors.black))),
                                const SizedBox(height: 10),
                              ],
                              // ... your existing column children
                            ),
                          ),
                        );
                  }),
                ] else if (_selectedIndex == 1) ...[
                  Obx(() {
                    return (controller.patientDetailModel.value?.responseData?.pastVisits?.isNotEmpty ?? false)
                        ? SliverList(
                          delegate: SliverChildBuilderDelegate((context, index) {
                            return PatientDetailsVisitRecapsItem(data: controller.patientDetailModel.value?.responseData?.pastVisits![index]);
                          }, childCount: controller.patientDetailModel.value?.responseData?.pastVisits?.length ?? 0),
                        )
                        : SliverFillRemaining(
                          hasScrollBody: false,
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 40),
                                SvgPicture.asset(ImagePath.no_data_found_mobile, width: MediaQuery.of(context).size.width * 0.7),
                                const SizedBox(height: 10),
                                SvgPicture.asset(ImagePath.divider_medical_note, width: MediaQuery.of(context).size.width * 0.6),
                                const SizedBox(height: 10),
                                Center(child: Text("No data found!", textAlign: TextAlign.center, style: AppFonts.regular(16.0, AppColors.black))),
                                const SizedBox(height: 10),
                              ],
                              // ... your existing column children
                            ),
                          ),
                        );
                  }),
                ] else ...[
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 50),
                                    SvgPicture.asset(ImagePath.no_data_power_view, width: MediaQuery.of(context).size.width * 0.5),
                                    const SizedBox(height: 10),
                                    SvgPicture.asset(ImagePath.divider_medical_note, width: MediaQuery.of(context).size.width * 0.6),
                                    const SizedBox(height: 10),
                                    Center(child: Text("Want to review this note on your computer?", textAlign: TextAlign.center, style: AppFonts.regular(16.0, AppColors.black))),
                                    const SizedBox(height: 10),
                                    const Center(child: SizedBox(width: 150, child: CustomTabButton(text: "Email links", height: 45, isOutline: true, outlineColor: AppColors.backgroundPurple, enabledColor: AppColors.clear, enabledTextColor: AppColors.backgroundPurple, outlineWidth: 1))),
                                  ],
                                  // ... your existing column children
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }, childCount: 1),
                  ),
                ],
              ],
            ),
          ),

          if (controller.globalController.getEMAOrganizationDetailModel.value?.responseData?.isEmaIntegration == false) ...[
            Positioned(
              right: 30,
              bottom: 20,
              child: GestureDetector(
                onTap: () async {
                  await Get.toNamed(Routes.ADD_PATIENT_MOBILE_VIEW);
                  controller.getPatient(controller.patientId);
                },
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColors.backgroundPurple, boxShadow: [BoxShadow(color: AppColors.backgroundPurple.withValues(alpha: 0.2), spreadRadius: 5, blurRadius: 9, offset: const Offset(0, 3))]),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(children: [SvgPicture.asset(ImagePath.quick_start, height: 20, width: 20), const SizedBox(width: 5), Text("Quick Start", softWrap: true, style: AppFonts.medium(16, AppColors.white))]),
                ),
              ),
            ),
          ],
        ],
      ),
      globalKey: _key,
    );
  }

  void _scrollToSelectedTab() {
    final keyContext = controller.tabKeys[_selectedIndex].currentContext;
    if (keyContext != null) {
      final box = keyContext.findRenderObject() as RenderBox;
      final position = box.localToGlobal(Offset.zero);
      final viewportWidth = MediaQuery.of(keyContext).size.width;
      final tabWidth = box.size.width;

      // Calculate the offset needed to center the tab
      double offset = position.dx - (viewportWidth / 2) + (tabWidth / 2);

      // Ensure the offset stays within valid bounds
      offset = offset.clamp(0.0, controller.scrollController.position.maxScrollExtent);

      controller.scrollController.animateTo(offset, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  double _getTextWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(text: TextSpan(text: text, style: style), maxLines: 1, textDirection: TextDirection.ltr)..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.width;
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyTabBarDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50; // Height of your tab bar

  @override
  double get minExtent => 50; // Same as maxExtent to make it fixed height

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return true;
  }
}

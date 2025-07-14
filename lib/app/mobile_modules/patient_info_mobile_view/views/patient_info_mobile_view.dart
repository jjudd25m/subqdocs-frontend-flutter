import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:subqdocs/app/core/common/mobile_html_note_item.dart';
import 'package:subqdocs/app/mobile_modules/patient_info_mobile_view/views/EditableViews/patient_view_editable_mobile_view.dart';
import 'package:subqdocs/widgets/custom_tab_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../../../../widget/base_image_view.dart';
import '../../../../widgets/base_screen_mobile.dart';
import '../../../models/SelectedDoctorMedicationModel.dart';
import '../../../modules/patient_info/views/full_note_view.dart';
import '../../../modules/sign_finalize_authenticate_view/controllers/sign_finalize_authenticate_view_controller.dart';
import '../../../modules/sign_finalize_authenticate_view/views/sign_finalize_authenticate_view_view.dart';
import '../../../routes/app_pages.dart';
import '../controllers/patient_info_mobile_view_controller.dart';
import 'EditableViews/alergies_editable_mobile_view.dart';
import 'EditableViews/cancer_history_editable_mobile_view.dart';
import 'EditableViews/chief_complaint_mobile_view.dart';
import 'EditableViews/exam_editable_mobile_view.dart';
import 'EditableViews/hpi_editable_mobile_view.dart';
import 'EditableViews/impression_and_plan_mobile_view.dart';
import 'EditableViews/medication_editable_mobile_view.dart';
import 'EditableViews/review_of_systems_mobile_view.dart';
import 'EditableViews/skin_history_editable_mobile_view.dart';
import 'EditableViews/social_history_editable_mobile_view.dart';

class PatientInfoMobileView extends StatefulWidget {
  const PatientInfoMobileView({super.key});

  @override
  State<PatientInfoMobileView> createState() => _PatientInfoMobileViewState();
}

class _PatientInfoMobileViewState extends State<PatientInfoMobileView> {
  PatientInfoMobileViewController controller = Get.find<PatientInfoMobileViewController>();

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BaseScreenMobile(
      showDrawer: false,
      onItemSelected: (index) async {},
      body: RefreshIndicator(
        onRefresh: () async {
          if (controller.fromRecording == null) {
            if (controller.patientData.value?.responseData?.visitStatus == "In-Exam") {
              controller.getSocketEventData();
            } else {
              controller.getInitData();
            }
          }
        },
        child: GestureDetector(
          onTap: () {
            controller.closeAllProcedureDiagnosisPopover();
            controller.resetImpressionAndPlanList();
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
                  background: Obx(() {
                    return Container(
                      color: AppColors.backgroundMobileAppbar,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          spacing: 15,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 40),
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(25.0),
                                  child: BaseImageView(
                                    imageUrl: controller.patientData.value?.responseData?.profileImage ?? "",
                                    width: 75,
                                    height: 75,
                                    nameLetters:
                                        "${controller.patientData.value?.responseData?.patientFirstName?.trim() ?? ""} "
                                        "${controller.patientData.value?.responseData?.patientLastName?.trim() ?? ""}",
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("${controller.patientData.value?.responseData?.patientFirstName ?? ""} ${controller.patientData.value?.responseData?.patientLastName ?? ""}", style: AppFonts.medium(18, AppColors.black)),
                                      const SizedBox(height: 4),
                                      if (controller.patientData.value?.responseData?.age != null && controller.patientData.value?.responseData?.age != 0) ...[
                                        Text("${controller.patientData.value?.responseData?.age} | ${controller.patientData.value?.responseData?.gender?.capitalizeFirst}", style: AppFonts.medium(12, AppColors.textDarkGrey)),
                                      ] else ...[
                                        if (controller.patientData.value?.responseData?.gender != null) ...[Text("${controller.patientData.value?.responseData?.gender?.capitalizeFirst}", style: AppFonts.medium(12, AppColors.textDarkGrey))],
                                      ],
                                      // Text("${controller.patientData.value?.responseData?.age ?? '0'} | ${controller.patientData.value?.responseData?.gender?.capitalizeFirst ?? ''}", style: AppFonts.medium(12, AppColors.textDarkGrey)),
                                    ],
                                  ),
                                ),

                                PullDownButton(
                                  routeTheme: const PullDownMenuRouteTheme(backgroundColor: AppColors.white),
                                  itemBuilder:
                                      (context) => [
                                        PullDownMenuItem(
                                          title: 'Medical Record',
                                          onTap: () async {
                                            await Get.toNamed(Routes.PATIENT_PROFILE_MOBILE_VIEW, arguments: {"patientId": controller.patientData.value?.responseData?.id.toString()});
                                          },
                                        ),
                                      ],
                                  buttonBuilder: (context, showMenu) => CupertinoButton(onPressed: showMenu, padding: EdgeInsets.zero, child: SvgPicture.asset("assets/images/logo_threedots.svg", width: 20, height: 20)),
                                ),

                                // PopupMenuButton<String>(
                                //   offset: const Offset(0, 8),
                                //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                //   color: AppColors.white,
                                //   position: PopupMenuPosition.under,
                                //   padding: EdgeInsetsDirectional.zero,
                                //   menuPadding: EdgeInsetsDirectional.zero,
                                //   onSelected: (value) {},
                                //   style: const ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsetsDirectional.zero), tapTargetSize: MaterialTapTargetSize.shrinkWrap, maximumSize: WidgetStatePropertyAll(Size.zero), visualDensity: VisualDensity(horizontal: 0, vertical: 0)),
                                //   itemBuilder:
                                //       (context) => [
                                //         PopupMenuItem(
                                //           padding: EdgeInsets.zero,
                                //           onTap: () async {
                                //             await Get.toNamed(Routes.PATIENT_PROFILE_MOBILE_VIEW, arguments: {"patientId": controller.patientData.value?.responseData?.id.toString()});
                                //           },
                                //           value: "",
                                //           child: Padding(padding: const EdgeInsets.all(8.0), child: Text("Medical Record", style: AppFonts.regular(14, AppColors.textBlack))),
                                //         ),
                                //       ],
                                //   child: Container(color: AppColors.clear, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3), child: SvgPicture.asset("assets/images/logo_threedots.svg", width: 20, height: 20))),
                                // ),
                                // GestureDetector(
                                //   onTapDown: (TapDownDetails details) {
                                //     HapticFeedback.selectionClick(); // iOS tap feedback
                                //   },
                                //   child: Container(color: AppColors.clear, padding: const EdgeInsets.only(bottom: 20, left: 20, right: 10, top: 5), child: SvgPicture.asset("assets/images/logo_threedots.svg", height: 20, width: 20)),
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                leading: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: IconButton(
                    highlightColor: Colors.transparent,
                    icon: SvgPicture.asset(ImagePath.back_arrow_mobile, height: 20, width: 20),
                    onPressed: () {
                      Get.until((route) => Get.currentRoute == Routes.HOME_VIEW_MOBILE);
                      // Get.back();
                    },
                  ),
                ),
                centerTitle: true,
                title: Text("Visit Documents", style: AppFonts.medium(15.0, AppColors.textBlackDark)),
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
                        Container(
                          width: double.infinity,
                          child: SingleChildScrollView(
                            controller: controller.scrollController,
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              spacing: 24,
                              children: [
                                // _buildTab(3, 'Transcript'),
                                _buildTab(0, 'Full Note'), _buildTab(1, 'Patient Note'), _buildTab(2, 'More Documents'),
                              ],
                            ),
                          ),
                        ),
                        Container(height: 2.0, width: double.infinity, decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.0), color: AppColors.backgroundPurple.withValues(alpha: 0.1))),
                      ],
                    ),
                  ),
                ),
              ),
              if (_selectedIndex == 0 || _selectedIndex == 1) ...[
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.only(left: 0, right: 0, bottom: 20),
                    // padding: const EdgeInsets.all(10),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(color: (_selectedIndex == 0 || _selectedIndex == 1) ? AppColors.white : AppColors.clear, borderRadius: BorderRadius.circular(6)),
                    child: Column(
                      children: [
                        if (_selectedIndex == 0) ...[
                          Obx(() {
                            if (controller.patientFullNoteModel.value?.responseData?.status == "Failure") {
                              return Padding(padding: const EdgeInsets.symmetric(vertical: 100), child: Text(controller.patientFullNoteModel.value?.responseData?.message ?? "No data found", textAlign: TextAlign.center));
                            }
                            return Column(
                              spacing: 16,
                              children: [
                                Container(
                                  // decoration: BoxDecoration(border: Border.all(width: 1, color: AppColors.black.withAlpha(25)), borderRadius: BorderRadius.circular(6)),
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    spacing: 16,
                                    children: [
                                      FullNoteCommonContainer(title: "Chief Complaint", child: controller.editableChiefView.isEmpty ? const FullNoteSectionSkeleton() : ChiefComplaintMobileView(controller: controller)),
                                      FullNoteCommonContainer(title: "HPI", child: controller.editableDataHpiView.isEmpty ? const FullNoteSectionSkeleton() : HpiEditableMobileView(controller: controller)),
                                      FullNoteCommonContainer(title: "Review of Systems", child: controller.editableDataForReviewOfSystems.isEmpty ? const FullNoteSectionSkeleton() : ReviewOfSystemsMobileView(controller: controller)),
                                      FullNoteCommonContainer(title: "Exam", child: controller.editableDataForExam.isEmpty ? const FullNoteSectionSkeleton() : ExamEditableMobileView(controller: controller)),
                                      ImpressionAndPlanMobileView(controller: controller),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  // decoration: BoxDecoration(border: Border.all(width: 1, color: AppColors.black.withAlpha(25)), borderRadius: BorderRadius.circular(6)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    spacing: 16,
                                    children: [
                                      FullNoteCommonContainer(title: "Cancer History", child: controller.editableDataForCancerHistory.isEmpty ? const FullNoteSectionSkeleton() : CancerHistoryEditableMobileView(controller: controller)),
                                      FullNoteCommonContainer(title: "Skin History", child: controller.editableDataForSkinHistory.isEmpty ? const FullNoteSectionSkeleton() : SkinHistoryEditableMobileView(controller: controller)),
                                      FullNoteCommonContainer(title: "Social History", child: controller.editableDataForSocialHistory.isEmpty ? const FullNoteSectionSkeleton() : SocialHistoryEditableMobileView(controller: controller)),
                                      FullNoteCommonContainer(title: "Medications", child: controller.editableDataForMedication.isEmpty ? const FullNoteSectionSkeleton() : MedicationEditableMobileView(controller: controller)),
                                      FullNoteCommonContainer(title: "Allergies", child: controller.editableDataForAllergies.isEmpty ? const FullNoteSectionSkeleton() : AlergiesEditableMobileView(controller: controller)),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),
                        ] else if (_selectedIndex == 1) ...[
                          Obx(() {
                            if (controller.patientViewListModel.value?.responseData?.status == "Failure") {
                              return Padding(padding: const EdgeInsets.symmetric(vertical: 100), child: Text(controller.patientViewListModel.value?.responseData?.message ?? "No data found", textAlign: TextAlign.center));
                            } else {
                              String data = controller.patientViewListModel.value?.responseData?.visitNoteDetails?.patientViewNoteHtml ?? "";
                              return controller.editableDataForPatientView.isEmpty
                                  ? const Skeletonizer(
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
                                  )
                                  : PatientViewEditableMobileView(controller: controller);
                            }
                            // }
                          }),
                        ],
                      ],
                    ),
                  ),
                ),
              ] else ...[
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              Center(child: Text("These are the documents that will be available on the iPad or the web:", textAlign: TextAlign.center, style: AppFonts.regular(14.0, AppColors.textDarkGrey))),
                              const SizedBox(height: 20),
                              Center(child: Text(" Power View, Full transcript, Billing form, and Requisition ", textAlign: TextAlign.center, style: AppFonts.regular(16.0, AppColors.textPurple))),
                              const SizedBox(height: 20),
                              Center(
                                child: SizedBox(
                                  width: 150,
                                  child: CustomTabButton(
                                    onPressed: () async {
                                      if (!await launchUrl(Uri.https("app.subqdocs.ai"), mode: LaunchMode.externalApplication)) {
                                        throw Exception('Could not launch');
                                      }
                                    },
                                    borderRadius: 10,
                                    text: "Email links",
                                    height: 45,
                                    isOutline: true,
                                    outlineColor: AppColors.backgroundPurple,
                                    enabledColor: AppColors.clear,
                                    enabledTextColor: AppColors.backgroundPurple,
                                    outlineWidth: 1,
                                  ),
                                ),
                              ),
                            ],
                            // ... your existing column children
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(() {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom, left: 20.0, right: 20.0, top: 10),
          // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child:
              (_selectedIndex == 0 || _selectedIndex == 1)
                  ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        spacing: 10,
                        children: [
                          if (_selectedIndex == 0 && controller.patientFullNoteModel.value?.responseData != null) ...[
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  controller.copyAllSection();
                                },
                                child: Container(height: 46, alignment: Alignment.center, decoration: BoxDecoration(border: Border.all(color: AppColors.textPurple, width: 1), borderRadius: BorderRadius.circular(10)), child: Text("Copy", style: AppFonts.medium(16, AppColors.textPurple))),
                              ),
                            ),
                          ],
                          if (_selectedIndex == 1 && controller.patientViewListModel.value?.responseData != null) ...[
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  controller.copyPatientViewSection();
                                },
                                child: Container(height: 46, alignment: Alignment.center, decoration: BoxDecoration(border: Border.all(color: AppColors.textPurple, width: 1), borderRadius: BorderRadius.circular(10)), child: Text("Copy", style: AppFonts.medium(16, AppColors.textPurple))),
                              ),
                            ),
                          ],
                          // if (controller.patientData.value?.responseData?.visitStatus == "Pending") ...[
                          //   Expanded(
                          //     child: InkWell(
                          //       onTap: () {
                          //         if (controller.loginData.value?.responseData?.user?.role?.toLowerCase() == "doctor") {
                          //           showDialog(
                          //             context: context,
                          //             barrierDismissible: true,
                          //             builder: (BuildContext context) {
                          //               return ConfirmFinalizeDialog(
                          //                 onDelete: () {
                          //                   Map<String, dynamic> param = {};
                          //                   param['status'] = "Finalized";
                          //
                          //                   controller.changeStatus(param);
                          //                 },
                          //               );
                          //             },
                          //           );
                          //         } else {
                          //           showSignFinalizeAutheticateViewDialog();
                          //         }
                          //
                          //         // showDialog(
                          //         //   context: context,
                          //         //   barrierDismissible: true,
                          //         //   builder: (BuildContext context) {
                          //         //     return ConfirmFinalizeDialog(
                          //         //       onDelete: () {
                          //         //         controller.changeStatus();
                          //         //       },
                          //         //     );
                          //         //   },
                          //         // );
                          //       },
                          //       child: Container(height: 46, alignment: Alignment.center, decoration: BoxDecoration(color: AppColors.backgroundPurple, borderRadius: BorderRadius.circular(10)), child: Text("Sign and Finalize", style: AppFonts.medium(16, AppColors.white))),
                          //     ),
                          //   ),
                          // ],
                        ],
                      ),
                      if (Platform.isAndroid) ...[const SizedBox(height: 20)],
                    ],
                  )
                  : const SizedBox(),
        );
      }),
      globalKey: _key,
    );
  }

  Widget _buildTab(int index, String text) {
    return GestureDetector(
      key: controller.tabKeys[index],
      onTap: () {
        setState(() => _selectedIndex = index);
        _scrollToSelectedTab();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(padding: const EdgeInsets.only(bottom: 12.0), child: Text(text, style: TextStyle(color: _selectedIndex == index ? AppColors.textPurple : AppColors.textDarkGrey, fontWeight: FontWeight.w500))),
          Container(height: 3.0, width: _getTextWidth(text, const TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0)), decoration: BoxDecoration(color: _selectedIndex == index ? AppColors.textPurple : Colors.transparent, borderRadius: BorderRadius.circular(1.5))),
        ],
      ),
    );
  }

  void _scrollToSelectedTab() {
    // Get the render box of the selected tab
    final renderBox = controller.tabKeys[_selectedIndex].currentContext?.findRenderObject() as RenderBox?;

    if (renderBox == null) return;

    // Get the position of the tab relative to the SingleChildScrollView
    final position = renderBox.localToGlobal(Offset.zero);
    final scrollPosition = position.dx;

    // Get viewport and tab dimensions
    final viewportWidth = MediaQuery.of(context).size.width;
    final tabWidth = renderBox.size.width;

    // Calculate the target scroll offset
    double targetOffset = scrollPosition - (viewportWidth / 2) + (tabWidth / 2);

    // Clamp the offset to valid range
    targetOffset = targetOffset.clamp(0.0, controller.scrollController.position.maxScrollExtent);

    // Animate to the calculated position
    controller.scrollController.animateTo(targetOffset, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  PopupMenuItem<String> _buildMenuItem(BuildContext context, String value, String text, IconData icon, {bool isDestructive = false}) {
    return PopupMenuItem<String>(value: value, height: 36, child: Row(children: [Icon(icon, size: 20, color: isDestructive ? CupertinoColors.destructiveRed : CupertinoColors.label.resolveFrom(context)), const SizedBox(width: 12), Text(text, style: TextStyle(fontSize: 16, color: isDestructive ? CupertinoColors.destructiveRed : CupertinoColors.label.resolveFrom(context)))]));
  }

  void _handleMedicalRecord() {
    debugPrint('Medical Record selected');
  }

  void _handleShare() {
    debugPrint('Share selected');
  }

  void _handleDelete() {
    debugPrint('Delete selected');
  }

  void _handleMedicalRecordAction() {
    // Implement your medical record functionality here
    // You might navigate to a medical record screen or show a dialog
  }

  double _getTextWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(text: TextSpan(text: text, style: style), maxLines: 1, textDirection: TextDirection.ltr)..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.width;
  }

  void showSignFinalizeAutheticateViewDialog() {
    showGeneralDialog(
      context: Get.context!,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation1, animation2) {
        SignFinalizeAuthenticateViewController con = Get.put(SignFinalizeAuthenticateViewController());
        con.visitId = controller.visitId;
        con.selectedDoctorValueModel = Rxn(SelectedDoctorModel(name: controller.patientData.value?.responseData?.doctorName, id: controller.patientData.value?.responseData?.doctorId, profileImage: null));
        con.selectedDoctorValue.value = controller.patientData.value?.responseData?.doctorName ?? "";

        con.isThirdParty = controller.patientData.value?.responseData?.thirdPartyId ?? "";

        con.setThirdParty(controller.patientData.value?.responseData?.thirdPartyId ?? "");

        return ScaleTransition(
          scale: CurvedAnimation(parent: animation1, curve: Curves.fastOutSlowIn),
          child: FadeTransition(
            opacity: animation1,
            child: Dialog(
              backgroundColor: AppColors.backgroundMobileAppbar,
              surfaceTintColor: AppColors.backgroundMobileAppbar,
              insetPadding: const EdgeInsets.all(20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
                child: ClipRRect(
                  // Additional clipping for safety
                  borderRadius: BorderRadius.circular(16.0),
                  child: IntrinsicHeight(child: SignFinalizeAuthenticateViewView(controller: con)),
                ),
              ),
            ),
          ),
        );
      },
    ).then((value) async {
      await Get.delete<SignFinalizeAuthenticateViewController>();
    });
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

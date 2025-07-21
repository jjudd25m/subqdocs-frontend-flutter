import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:subqdocs/app/modules/patient_info/views/doctor_view.dart';
import 'package:subqdocs/app/modules/patient_info/views/full_note_view.dart';
import 'package:subqdocs/app/modules/patient_info/views/patient_view.dart';
import 'package:subqdocs/app/modules/patient_info/views/visit_data_view.dart';
import 'package:subqdocs/app/modules/sign_finalize_authenticate_view/controllers/sign_finalize_authenticate_view_controller.dart';
import 'package:subqdocs/widgets/base_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../../../../widget/appbar.dart';
import '../../../../widget/base_image_view.dart';
import '../../../../widget/bredcums.dart';
import '../../../../widget/custom_animated_button.dart';
import '../../../../widgets/base_dropdown2.dart';
import '../../../models/SelectedDoctorMedicationModel.dart';
import '../../../routes/app_pages.dart';
import '../../doctor_to_doctor_sign_finalize_authenticate_view/controllers/doctor_to_doctor_sign_finalize_authenticate_view_controller.dart';
import '../../doctor_to_doctor_sign_finalize_authenticate_view/views/doctor_to_doctor_sign_finalize_authenticate_view_view.dart';
import '../../sign_finalize_authenticate_view/views/sign_finalize_authenticate_view_view.dart';
import '../controllers/patient_info_controller.dart';
import 'chatbot_widget.dart';
import 'confirm_finalize_dialog.dart';
import 'full_transcript_view.dart';

class PatientInfoView extends StatefulWidget {
  const PatientInfoView({super.key});

  @override
  State<PatientInfoView> createState() => _PatientInfoViewState();
}

class _PatientInfoViewState extends State<PatientInfoView> {
  // MARK: - Controllers and State Variables
  final PatientInfoController controller = Get.find<PatientInfoController>(tag: Get.arguments["unique_tag"]);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final ScrollController scrollController = ScrollController();

  // MARK: - Lifecycle Methods
  @override
  void initState() {
    super.initState();
    // Initialization logic can be added here if needed
  }

  // MARK: - Helper Methods

  /// Formats date and time strings into a readable format
  String formatDateTime({required String firstDate, required String secondDate}) {
    if (firstDate.isEmpty || secondDate.isEmpty) return "";

    final firstDateTime = DateTime.parse(firstDate);
    final secondDateTime = DateTime.parse(secondDate);

    final formattedDate = DateFormat('MM/dd/yyyy').format(firstDateTime);
    final formattedTime = DateFormat('h:mm a').format(secondDateTime.toLocal());

    return '$formattedDate $formattedTime';
  }

  /// Builds the patient header section
  Widget _buildPatientHeader() {
    return Obx(() {
      return Theme(
        data: ThemeData(splashColor: Colors.transparent, highlightColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          onExpansionChanged: (value) => controller.closeAllProcedureDiagnosisPopover(),
          collapsedShape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
          shape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
          backgroundColor: AppColors.backgroundWhite,
          collapsedBackgroundColor: AppColors.backgroundWhite,
          title: Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children: [_buildBackButton(), _buildPatientAvatar(), const SizedBox(width: 10), _buildPatientInfoText(), const Spacer()])),
          children: [Container(width: double.infinity, height: 1, color: AppColors.appbarBorder), const SizedBox(height: 10), _buildPatientDetailsRow(), const SizedBox(height: 10)],
        ),
      );
    });
  }

  Widget _buildBackButton() {
    return InkWell(
      onTap: () {
        Get.until((route) => Get.currentRoute == Routes.HOME);
        controller.globalController.breadcrumbHistory.clear();
        controller.globalController.addRoute(Routes.HOME);

        // final globalController = controller.globalController;
        // final breadcrumbs = globalController.breadcrumbHistory;
        // final lastBreadcrumb = breadcrumbs.isNotEmpty ? breadcrumbs.last : null;
        // final targetRoute = lastBreadcrumb != null ? globalController.getKeyByValue(lastBreadcrumb) : null;
        //
        // // If going to HOME, trigger refresh
        // if (targetRoute == Routes.VISIT_MAIN) {
        //   // Optionally, handle VISIT_MAIN navigation/refresh here
        //   if (Get.currentRoute != Routes.VISIT_MAIN) {

        // }
        // else{
        //   Get.offAllNamed(targetRoute ?? Routes.HOME);
        // }
        // customPrint("message:PatientView");
        // controller.isNavigatingFromBreadcrumb.value = true;
        // final globalController = controller.globalController;
        // final breadcrumbs = globalController.breadcrumbHistory;
        // if (breadcrumbs.isNotEmpty) {
        //   globalController.popRoute();
        // }
        // if (breadcrumbs.isNotEmpty) {
        //   final targetBreadcrumb = breadcrumbs.last;
        //   controller.breadCrumbNavigation(targetBreadcrumb);
        // }
      },
      child: Container(color: AppColors.white, padding: const EdgeInsets.only(left: 10.0, top: 20.0, bottom: 20.0, right: 20.0), child: SvgPicture.asset(ImagePath.logo_back, height: 20, width: 20)),
    );
  }

  Widget _buildPatientAvatar() {
    return ClipRRect(borderRadius: BorderRadius.circular(30), child: BaseImageView(imageUrl: controller.patientData.value?.responseData?.profileImage ?? "", height: 60, width: 60, nameLetters: "${controller.patientData.value?.responseData?.patientFirstName ?? ""} ${controller.patientData.value?.responseData?.patientLastName ?? ""}", fontSize: 14));
  }

  Widget _buildPatientInfoText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Text("${controller.patientData.value?.responseData?.patientFirstName ?? ""} ${controller.patientData.value?.responseData?.patientLastName ?? ""}", style: AppFonts.medium(16, AppColors.textBlack)), const SizedBox(width: 15), Text(controller.patientData.value?.responseData?.patientId ?? "", style: AppFonts.regular(11, AppColors.textGrey))],
    );
  }

  Widget _buildPatientDetailsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align all items at the top
        children: [
          _buildDetailColumn("Age", (controller.patientData.value?.responseData?.age.toString() ?? "") == "null" ? "N/A" : controller.patientData.value?.responseData?.age.toString() ?? ""),
          const Spacer(),
          _buildDetailColumn("Gender", controller.patientData.value?.responseData?.gender ?? "N/A"),
          const Spacer(),
          _buildDetailColumn("Visit Date & Time", formatDateTime(firstDate: controller.patientData.value?.responseData?.visitDate ?? "-", secondDate: controller.patientData.value?.responseData?.visitTime ?? "")),
          const Spacer(),
          _buildDetailColumn("Medical Assistant", controller.medicationValue.value),
          const Spacer(),
          _buildDoctorDropdown(),
        ],
      ),
    );
  }

  Widget _buildDetailColumn(String title, String value) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [Text(title, style: AppFonts.regular(12, AppColors.textBlack)), const SizedBox(height: 6), Text(value, style: AppFonts.regular(14, AppColors.textGrey))]);
  }

  Widget _buildDoctorDropdown() {
    return IgnorePointer(
      ignoring: controller.patientData.value?.responseData?.thirdPartyId != null || controller.patientData.value?.responseData?.visitStatus?.toLowerCase() == "finalized",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Doctor", style: AppFonts.regular(12, AppColors.textBlack)),
          const SizedBox(height: 6),
          SizedBox(
            height: 25,
            child: Obx(() {
              return BaseDropdown2<SelectedDoctorModel>(
                isRequired: true,
                width: 170,
                onTapUpOutside: (p0) {
                  if (controller.selectedDoctorValueModel.value != null) {
                    controller.doctorController.clear();
                    controller.doctorValue.refresh();
                  } else {
                    controller.doctorValue.value = "N/A";
                    controller.doctorController.clear();
                    controller.doctorValue.refresh();
                  }
                },
                focusNode: controller.doctorFocusNode,
                controller: controller.doctorController,
                scrollController: scrollController,
                direction: VerticalDirection.down,
                inputDecoration: InputDecoration(
                  suffixIcon: const Padding(padding: EdgeInsets.all(0), child: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textDarkGrey)),
                  fillColor: AppColors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  hintText: controller.doctorValue.value.isEmpty ? "Select" : controller.doctorValue.value,
                  hintStyle: controller.doctorValue.value.isEmpty ? AppFonts.regular(14, AppColors.textDarkGrey) : AppFonts.regular(14, AppColors.textBlack),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(width: 0, color: AppColors.white)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(width: 0, color: AppColors.white)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(width: 0, color: AppColors.white)),
                ),
                valueAsString: (SelectedDoctorModel? model) => model?.name ?? "",
                items: controller.globalController.selectedDoctorModel.toList(),
                selectedValue: controller.selectedDoctorValueModel.value,
                itemBuilder: (p0) {
                  return Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Padding(padding: const EdgeInsets.only(left: 10), child: ClipRRect(borderRadius: BorderRadius.circular(16), child: BaseImageView(height: 32, width: 32, nameLetters: p0.name ?? "", fontSize: 12, imageUrl: p0.profileImage ?? ""))),
                        const SizedBox(width: 10),
                        Expanded(child: Container(color: AppColors.white, child: Text(p0.name ?? "", style: AppFonts.medium(14, AppColors.black)))),
                      ],
                    ),
                  );
                },
                onChanged: (SelectedDoctorModel? model) {
                  print("selectedDoctorValueModel name:- ${controller.selectedDoctorValueModel.value?.name}");

                  controller.doctorValue.value = model?.name ?? "";
                  controller.doctorValue.refresh();
                  if (model != null) {
                    controller.updateDoctorView(model.id ?? -1);
                  }
                },
                selectText: controller.doctorValue.value,
                isSearchable: true,
              );
            }),
          ),
        ],
      ),
    );
  }

  /// Builds the tab navigation buttons
  Widget _buildTabNavigation() {
    return Obx(() {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.white),
        height: 45,
        child: SingleChildScrollView(physics: const BouncingScrollPhysics(), scrollDirection: Axis.horizontal, child: Row(children: [_buildTabButton("Power View", 0), _buildTabButton("Full Note", 3), _buildTabButton("Patient Note", 2), _buildTabButton("Full Transcript", 1)])),
      );
    });
  }

  Widget _buildTabButton(String text, int tabIndex) {
    return IntrinsicWidth(
      child: CustomAnimatedButton(
        onPressed: () => _handleTabChange(tabIndex),
        text: text,
        isOutline: true,
        paddingText: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        fontSize: 14,
        enabledTextColor: controller.tabIndex.value == tabIndex ? AppColors.backgroundPurple : AppColors.textGrey,
        enabledColor: controller.tabIndex.value == tabIndex ? AppColors.buttonPurpleLight : AppColors.clear,
        outLineEnabledColor: AppColors.textGrey,
        outlineColor: controller.tabIndex.value == tabIndex ? AppColors.backgroundPurple : AppColors.clear,
      ),
    );
  }

  void _handleTabChange(int tabIndex) {
    controller.closeAllProcedureDiagnosisPopover();
    controller.resetImpressionAndPlanList();

    if (tabIndex == 0 || tabIndex == 3) {
      Future.delayed(const Duration(milliseconds: 200), () {
        controller.tabIndex.value = tabIndex;
      });
    } else {
      controller.tabIndex.value = tabIndex;
    }
  }

  /// Builds the main content area based on selected tab
  Widget _buildContentArea() {
    return Obx(() {
      return Column(
        children: [
          const SizedBox(height: 20),
          if (controller.tabIndex.value == 0) ...[DoctorView(controller: controller)],
          if (controller.tabIndex.value == 1) ...[FullTranscriptView(controller: controller)],
          if (controller.tabIndex.value == 2) ...[PatientView(controller: controller)],
          if (controller.tabIndex.value == 3) ...[FullNoteView(controller: controller)],
          if (controller.tabIndex.value == 6) ...[VisitDataView(controller: controller)],
          const SizedBox(height: 20),
        ],
      );
    });
  }

  /// Builds the footer section
  Widget _buildFooter() {
    return Obx(() {
      if (controller.keyboardController.isKeyboardOpen.value) return const SizedBox.shrink();

      return Container(color: AppColors.ScreenBackGround1, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.backgroundWhite), padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), child: _buildFooterContent()));
    });
  }

  Widget _buildFooterContent() {
    if (controller.isSignatureDone.value) {
      return _buildSignedFooter();
    } else {
      return _buildUnsignedFooter();
    }
  }

  Widget _buildSignedFooter() {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Container(
            height: 95,
            decoration: BoxDecoration(border: Border.all(color: AppColors.backgroundPurple), color: AppColors.backgroundPurple, borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(ImagePath.signature, height: 30, width: 30),
                    const SizedBox(height: 10),
                    Text("Digitally Signed by Dr.${controller.patientData.value?.responseData?.doctorName}", style: AppFonts.medium(16, AppColors.textWhite)),
                    Text(formatDateTime(firstDate: controller.patientData.value?.responseData?.finalize_date_time ?? "", secondDate: controller.patientData.value?.responseData?.finalize_date_time ?? ""), style: AppFonts.medium(16, AppColors.textWhite)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text("Amend Note", style: AppFonts.medium(15, AppColors.textGrey).copyWith(decoration: TextDecoration.underline)),
        ],
      ),
    );
  }

  Widget _buildUnsignedFooter() {
    return Row(
      spacing: 15,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(child: _buildAddPhotoButton()),
        if (controller.patientData.value?.responseData?.visitStatus == "Pending") ...[Expanded(child: _buildSignAndFinalizeButton())],
      ],
    );
  }

  Widget _buildAddPhotoButton() {
    return GestureDetector(
      onTap: () => controller.closeDoctorPopOverController(),
      child: Container(
        height: 81,
        decoration: BoxDecoration(border: Border.all(color: AppColors.textGrey.withValues(alpha: 0.5)), color: AppColors.backgroundLightGrey, borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [SvgPicture.asset(ImagePath.add_photo, height: 30, width: 30), const SizedBox(height: 10), Text("Add Photo or Document", style: AppFonts.medium(16, AppColors.textBlack))]),
          ],
        ),
      ),
    );
  }

  Widget _buildSignAndFinalizeButton() {
    return GestureDetector(
      onTap: () async {
        controller.closeDoctorPopOverController();

        if (controller.globalController.getEMAOrganizationDetailModel.value?.responseData?.isEmaIntegration ?? false) {
          //

          if (controller.loginData.value?.responseData?.user?.role?.toLowerCase() != "doctor") {
            bool isThirdParty = controller.patientData.value?.responseData?.thirdPartyId != null ? true : false;

            if (isThirdParty) {
              dynamic encounterModel = await controller.hasEncounter(id: controller.visitId);
              if (encounterModel["response_type"] == "Failure") {
                Map<String, dynamic> responseData = encounterModel["responseData"];

                String modeMedUrl = responseData["url"];
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return HasEncounterDialog(
                      onCounter: () async {
                        final url = modeMedUrl;
                        if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(Uri.parse(url));
                          Get.back();
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                    );
                  },
                );
              } else {
                showDoctorToDoctorSignFinalizeAutheticateViewDialog();
              }
            } else {
              showDoctorToDoctorSignFinalizeAutheticateViewDialog();
            }
          } else {
            if (controller.loginData.value?.responseData?.user?.id == controller.patientData.value?.responseData?.doctorId) {
              if (controller.patientData.value?.responseData?.thirdPartyId != null) {
                dynamic encounterModel = await controller.hasEncounter(id: controller.visitId);

                if (encounterModel["response_type"] == "Failure") {
                  Map<String, dynamic> responseData = encounterModel["responseData"];

                  String modeMedUrl = responseData["url"];
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return HasEncounterDialog(
                        onCounter: () async {
                          final url = modeMedUrl;
                          if (await canLaunchUrl(Uri.parse(url))) {
                            await launchUrl(Uri.parse(url));
                            Get.back();
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                      );
                    },
                  );
                } else {
                  showDoctorToDoctorSignFinalizeAutheticateViewDialog();
                }
              } else {
                showDoctorToDoctorSignFinalizeAutheticateViewDialog();
              }
            } else {
              if (controller.patientData.value?.responseData?.thirdPartyId != null) {
                showDoctorToDoctorSignFinalizeAutheticateViewDialog();
                // CustomToastification().showToast("You don't have permission to finalize this visit!", type: ToastificationType.error);
              } else {
                showDoctorToDoctorSignFinalizeAutheticateViewDialog();
              }
            }
          }
        } else {
          // For Non-EMA

          if (controller.loginData.value?.responseData?.user?.role?.toLowerCase() == "doctor") {
            showDoctorToDoctorSignFinalizeAutheticateViewDialog();
          } else {
            showSignFinalizeAutheticateViewDialog();
          }
        }
      },
      child: Container(
        height: 81,
        decoration: BoxDecoration(border: Border.all(color: AppColors.backgroundPurple), color: AppColors.backgroundPurple, borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [SvgPicture.asset(ImagePath.signature, height: 30, width: 30), const SizedBox(height: 10), Text("Sign and Finalize", style: AppFonts.medium(16, AppColors.textWhite))]),
          ],
        ),
      ),
    );
  }

  // MARK: - Main Build Method
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BaseScreen(
          onPopCallBack: () {
            if (controller.globalController.getKeyByValue(controller.globalController.breadcrumbHistory.last) == Routes.PATIENT_INFO) {
              controller.globalController.popRoute();
            }
          },
          onDrawerChanged: (status) {
            if (status) {
              controller.closeAllProcedureDiagnosisPopover();
            }
          },
          resizeToAvoidBottomInset: true,
          onItemSelected: (index) async {
            await _handleDrawerItemSelection(index);
          },
          body: SafeArea(
            child: GestureDetector(
              onTap: () {
                controller.doctorFocusNode.unfocus();
                controller.closeAllProcedureDiagnosisPopover();
                controller.resetImpressionAndPlanList();

                print("doctor name:- ${controller.doctorValue.value}");
                print("gesture selectedDoctorValueModel name:- ${controller.selectedDoctorValueModel.value?.name}");

                // controller.selectedDoctorValueModel.value?.name = controller.doctorValue.value;
                // controller.selectedDoctorValueModel.refresh();
                // controller.doctorValue.refresh();
              },
              child: Obx(() {
                return Column(
                  children: [
                    if (!controller.isKeyboardVisible.value) CustomAppBar(drawerkey: _scaffoldKey),
                    Expanded(
                      child: Container(
                        color: AppColors.ScreenBackGround1,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: RefreshIndicator(
                          onRefresh: controller.onRefresh,
                          child: SingleChildScrollView(
                            controller: controller.scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                _buildBreadcrumb(),
                                const SizedBox(height: 10),
                                Column(children: [_buildHeaderTitle(), const SizedBox(height: 15.0), _buildPatientHeader(), const SizedBox(height: 10), _buildTabNavigation(), const SizedBox(height: 10), _buildContentContainer(), const SizedBox(height: 20)]),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    _buildFooter(),
                  ],
                );
              }),
            ),
          ),
          globalKey: _scaffoldKey,
        ),
        const ChatBotWidget(),
      ],
    );
  }

  Widget _buildBreadcrumb() {
    return BreadcrumbWidget(
      breadcrumbHistory: controller.globalController.breadcrumbHistory.toList(),
      onBack: (breadcrumb) {
        controller.globalController.popUntilRoute(breadcrumb);
        // Get.offAllNamed(globalController.getKeyByValue(breadcrumb));

        while (Get.currentRoute != controller.globalController.getKeyByValue(breadcrumb)) {
          Get.back(); // Pop the current screen
        }
      },
    );
  }

  Widget _buildHeaderTitle() {
    return Container(width: double.infinity, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)), child: Padding(padding: const EdgeInsets.all(14), child: Text("Patient Visit Record", style: AppFonts.regular(17, AppColors.textBlack))));
  }

  Widget _buildContentContainer() {
    return Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.backgroundWhite), child: _buildContentArea());
  }

  Future<void> _handleDrawerItemSelection(int index) async {
    switch (index) {
      case 0:
        final _ = await Get.toNamed(Routes.ADD_PATIENT);
        _scaffoldKey.currentState!.closeDrawer();
        break;
      case 1:
        Get.offNamed(Routes.HOME, arguments: {"tabIndex": 1});
        _scaffoldKey.currentState!.closeDrawer();
        break;
      case 2:
        Get.offNamed(Routes.HOME, arguments: {"tabIndex": 2});
        _scaffoldKey.currentState!.closeDrawer();
        break;
      case 3:
        Get.offNamed(Routes.HOME, arguments: {"tabIndex": 0});
        _scaffoldKey.currentState!.closeDrawer();
        break;
      case 4:
        _scaffoldKey.currentState!.closeDrawer();
        final _ = await Get.toNamed(Routes.PERSONAL_SETTING);
        break;
    }
  }

  void showSignFinalizeAutheticateViewDialog() {
    SignFinalizeAuthenticateViewController con = Get.put(SignFinalizeAuthenticateViewController());
    con.visitId = controller.visitId;

    con.selectedDoctorValueModel = Rxn(SelectedDoctorModel(name: controller.patientData.value?.responseData?.doctorName, id: controller.patientData.value?.responseData?.doctorId, profileImage: null));
    con.selectedDoctorValue.value = controller.patientData.value?.responseData?.doctorName ?? "";
    con.isThirdParty = controller.patientData.value?.responseData?.thirdPartyId ?? "";

    con.setDoctor(Rxn(SelectedDoctorModel(name: controller.patientData.value?.responseData?.doctorName, id: controller.patientData.value?.responseData?.doctorId, profileImage: null)));

    con.setThirdParty(controller.patientData.value?.responseData?.thirdPartyId ?? "");
    // con.getDoctorList();

    showGeneralDialog(
      context: Get.context!,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation1, animation2) {
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
      controller.getPatientDetails();
    });
  }

  void showDoctorToDoctorSignFinalizeAutheticateViewDialog() {
    DoctorToDoctorSignFinalizeAuthenticateViewController con = Get.put(DoctorToDoctorSignFinalizeAuthenticateViewController());
    con.visitId = controller.visitId;

    con.selectedDoctorValueModel = Rxn(SelectedDoctorModel(name: controller.patientData.value?.responseData?.doctorName, id: controller.patientData.value?.responseData?.doctorId, profileImage: null));
    con.selectedDoctorValue.value = controller.patientData.value?.responseData?.doctorName ?? "";

    con.isThirdParty = controller.patientData.value?.responseData?.thirdPartyId ?? "";

    con.setDoctor(Rxn(SelectedDoctorModel(name: controller.patientData.value?.responseData?.doctorName, id: controller.patientData.value?.responseData?.doctorId, profileImage: null)));
    con.setThirdParty(controller.patientData.value?.responseData?.thirdPartyId ?? "");
    // con.getDoctorList();

    showGeneralDialog(
      context: Get.context!,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation1, animation2) {
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
                  child: IntrinsicHeight(child: DoctorToDoctorSignFinalizeAuthenticateView()),
                ),
              ),
            ),
          ),
        );
      },
    ).then((value) async {
      await Get.delete<DoctorToDoctorSignFinalizeAuthenticateViewController>();
      controller.getPatientDetails();
    });
  }
}

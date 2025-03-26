import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:subqdocs/widgets/custom_animated_button.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../../../../widget/appbar.dart';
import '../../../../widget/base_image_view.dart';
import '../../../../widgets/ContainerButton.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_table.dart';
import '../../../../widgets/empty_patient_screen.dart';
import '../../../core/common/common_service.dart';
import '../../../routes/app_pages.dart';
import '../../custom_drawer/views/custom_drawer_view.dart';
import '../../home/model/patient_list_model.dart';
import '../../patient_profile/widgets/common_patient_data.dart';
import '../controllers/personal_setting_controller.dart';
import '../model/get_user_detail_model.dart';
import 'invite_user_dialog.dart';
import 'organization_edit_dialog.dart';
import 'organization_use_edit_dialog.dart';

class PersonalSettingView extends GetView<PersonalSettingController> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  PersonalSettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      drawer: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5.0,
          sigmaY: 5.0,
        ),
        child: CustomDrawerView(
          onItemSelected: (index) async {
            if (index == 0) {
              // final result = await Get.toNamed(Routes.ADD_PATIENT);
              //
              // if (result == 1) {
              //   controller.getPastVisitList(isFist: true);
              //   controller.getScheduleVisitList(isFist: true);
              //   controller.getPatientList();
              // }
              // _key.currentState!.closeDrawer();
            } else if (index == 1) {
              // controller.tabIndex.value = 1;
              // controller.globalController.homeTabIndex.value = 1;
              // _key.currentState!.closeDrawer();
            } else if (index == 2) {
              // controller.tabIndex.value = 2;
              // controller.globalController.homeTabIndex.value = 2;
              // _key.currentState!.closeDrawer();
            } else if (index == 3) {
              // controller.tabIndex.value = 0;
              // controller.globalController.homeTabIndex.value = 3;
              // _key.currentState!.closeDrawer();
            } else {
              final result = await Get.toNamed(Routes.PERSONAL_SETTING);
            }
          },
        ),
      ),
      body: GestureDetector(
        onTap: removeFocus,
        child: SafeArea(
          child: Container(
            color: AppColors.ScreenBackGround,
            child: Obx(() {
              return Column(
                children: [
                  CustomAppBar(drawerkey: _key),
                  Expanded(
                      child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            width: double.infinity,
                            color: AppColors.ScreenBackGround,
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                // Personal account
                                Theme(
                                  data: ThemeData(
                                    splashColor: Colors.transparent, // Remove splash color
                                    highlightColor: Colors.transparent, // Remove highlight color
                                  ),
                                  child: ExpansionTile(
                                    initiallyExpanded: true,
                                    childrenPadding: EdgeInsets.all(0),
                                    collapsedShape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                                    shape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                                    backgroundColor: AppColors.backgroundWhite,
                                    collapsedBackgroundColor: AppColors.backgroundWhite,
                                    title: Row(
                                      children: [
                                        Text(
                                          textAlign: TextAlign.center,
                                          "Personal Setting",
                                          style: AppFonts.regular(16, AppColors.textBlack),
                                        ),
                                        Spacer(),
                                      ],
                                    ),
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                                        child: Container(
                                            decoration: BoxDecoration(
                                              // border: Border.all(color: AppColors.textGrey.withValues(alpha: 0.5)),
                                              color: AppColors.backgroundWhite,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    // InkWell(
                                                    //   onTap: () {
                                                    //     Get.back();
                                                    //   },
                                                    //   child: Container(
                                                    //     color: AppColors.white,
                                                    //     padding: EdgeInsets.only(left: 10.0, top: 20.0, bottom: 20.0, right: 20.0),
                                                    //     child: SvgPicture.asset(
                                                    //       ImagePath.logo_back,
                                                    //       height: 20,
                                                    //       width: 20,
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                    // SizedBox(
                                                    //   width: 11,
                                                    // ),
                                                    ClipRRect(
                                                        borderRadius: BorderRadius.circular(30),
                                                        child: BaseImageView(
                                                          imageUrl: "",
                                                          height: 60,
                                                          width: 60,
                                                          nameLetters: "Adrian Tinajoro",
                                                          fontSize: 14,
                                                        )),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          textAlign: TextAlign.center,
                                                          "${controller.loginData.value?.responseData?.user?.firstName} ${controller.loginData.value?.responseData?.user?.lastName}",
                                                          style: AppFonts.medium(16, AppColors.textBlack),
                                                        ),
                                                        SizedBox(
                                                          width: 15,
                                                        ),
                                                        // Text(
                                                        //   textAlign: TextAlign.center,
                                                        //   controller.patientData.value?.responseData?.patientId ?? "",
                                                        //   style: AppFonts.regular(11, AppColors.textGrey),
                                                        // ),
                                                      ],
                                                    ),
                                                    Spacer(),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        controller.setUserDetail();

                                                        showDialog(
                                                          context: context,
                                                          barrierDismissible: true, // Allows dismissing the dialog by tapping outside
                                                          builder: (BuildContext context) {
                                                            return OrganizationUseEditDialog(
                                                              receiveParam: (p0) {
                                                                controller.updateUserDetail(p0);
                                                              },
                                                            ); // Our custom dialog
                                                          },
                                                        );

                                                        // final result = await Get.toNamed(Routes.EDIT_PATENT_DETAILS,
                                                        //     arguments: {"patientData": controller.patientId, "visitId": controller.visitId, "fromSchedule": true});
                                                        //
                                                        // controller.onReady();
                                                      },
                                                      child: SvgPicture.asset(
                                                        ImagePath.edit,
                                                        width: 26,
                                                        height: 26,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    SizedBox(
                                                      width: 100,
                                                      child: CustomAnimatedButton(
                                                        text: "Logout",
                                                        height: 35,
                                                        isOutline: true,
                                                        enabledColor: AppColors.redText,
                                                        outlineColor: AppColors.redText,
                                                        enabledTextColor: AppColors.white,
                                                        outLineEnabledColor: AppColors.redText,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(height: 20),
                                                Row(
                                                  children: [
                                                    Text(
                                                      textAlign: TextAlign.center,
                                                      "Personal Information",
                                                      style: AppFonts.medium(16, AppColors.backgroundPurple),
                                                    ),
                                                    Spacer()
                                                  ],
                                                ),
                                                SizedBox(height: 20),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Expanded(
                                                      child: CommonPatientData(
                                                        label: "First Name",
                                                        data: controller.getUserDetailModel.value?.responseData?.firstName ?? "-",
                                                      ),
                                                    ),
                                                    Expanded(
                                                        child: CommonPatientData(
                                                      label: "Last Name",
                                                      data: controller.getUserDetailModel.value?.responseData?.lastName ?? "-",
                                                    )),
                                                    Expanded(child: SizedBox()),
                                                    Expanded(child: SizedBox()),
                                                  ],
                                                ),
                                                SizedBox(height: 20),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: CommonPatientData(
                                                        label: "Organization",
                                                        data: controller.getOrganizationDetailModel.value?.responseData?.name ?? "-",
                                                      ),
                                                    ),
                                                    Expanded(child: SizedBox()),
                                                    Expanded(child: SizedBox()),
                                                    Expanded(child: SizedBox()),
                                                  ],
                                                ),
                                                //------------------ Contact
                                                SizedBox(height: 20),
                                                Row(
                                                  children: [
                                                    Text(
                                                      textAlign: TextAlign.center,
                                                      "Contact",
                                                      style: AppFonts.medium(16, AppColors.backgroundPurple),
                                                    ),
                                                    Spacer()
                                                  ],
                                                ),
                                                SizedBox(height: 20),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                        child: CommonPatientData(
                                                      label: "Email ID",
                                                      data: controller.getUserDetailModel.value?.responseData?.email ?? "-",
                                                    )),
                                                    Expanded(
                                                        child: CommonPatientData(
                                                      label: "Phone Number",
                                                      data: controller.getUserDetailModel.value?.responseData?.contactNo ?? "-",
                                                    )),
                                                    Expanded(child: SizedBox()),
                                                    Expanded(child: SizedBox()),
                                                  ],
                                                ),
                                                SizedBox(height: 20),
                                                //------------------ Address
                                                SizedBox(height: 20),
                                                Row(
                                                  children: [
                                                    Text(
                                                      textAlign: TextAlign.center,
                                                      "Address",
                                                      style: AppFonts.medium(16, AppColors.backgroundPurple),
                                                    ),
                                                    Spacer()
                                                  ],
                                                ),
                                                SizedBox(height: 20),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                        child: CommonPatientData(
                                                      label: "Country",
                                                      data: controller.getUserDetailModel.value?.responseData?.country ?? "-",
                                                    )),
                                                    Expanded(
                                                        child: CommonPatientData(
                                                      label: "State",
                                                      data: controller.getUserDetailModel.value?.responseData?.state ?? "-",
                                                    )),
                                                    Expanded(
                                                        child: CommonPatientData(
                                                      label: "City",
                                                      data: controller.getUserDetailModel.value?.responseData?.city ?? "-",
                                                    )),
                                                    Expanded(child: SizedBox()),
                                                  ],
                                                ),
                                                SizedBox(height: 20),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                        child: CommonPatientData(
                                                      label: "Street Name",
                                                      data: controller.getUserDetailModel.value?.responseData?.streetName ?? "-",
                                                    )),
                                                    Expanded(
                                                        child: CommonPatientData(
                                                      label: "Postal Code",
                                                      data: controller.getUserDetailModel.value?.responseData?.postalCode ?? "-",
                                                    )),
                                                    Expanded(child: SizedBox()),
                                                    Expanded(child: SizedBox()),
                                                  ],
                                                ),
                                                SizedBox(height: 20),
                                              ],
                                            )),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                // Organization management
                                Theme(
                                  data: ThemeData(
                                    splashColor: Colors.transparent, // Remove splash color
                                    highlightColor: Colors.transparent, // Remove highlight color
                                  ),
                                  child: ExpansionTile(
                                    initiallyExpanded: true,
                                    childrenPadding: EdgeInsets.all(0),
                                    collapsedShape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                                    shape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                                    backgroundColor: AppColors.backgroundWhite,
                                    collapsedBackgroundColor: AppColors.backgroundWhite,
                                    title: Row(
                                      children: [
                                        Text(
                                          textAlign: TextAlign.center,
                                          "Organization Management",
                                          style: AppFonts.regular(16, AppColors.textBlack),
                                        ),
                                        Spacer(),
                                      ],
                                    ),
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                                        child: Container(
                                            decoration: BoxDecoration(
                                              // border: Border.all(color: AppColors.textGrey.withValues(alpha: 0.5)),
                                              color: AppColors.backgroundWhite,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    ClipRRect(
                                                        borderRadius: BorderRadius.circular(30),
                                                        child: BaseImageView(
                                                          imageUrl: "",
                                                          height: 60,
                                                          width: 60,
                                                          nameLetters: "Adrian Tinajoro",
                                                          fontSize: 14,
                                                        )),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          textAlign: TextAlign.center,
                                                          controller.getOrganizationDetailModel.value?.responseData?.name ?? "-",
                                                          style: AppFonts.medium(16, AppColors.textBlack),
                                                        ),
                                                        SizedBox(
                                                          width: 15,
                                                        ),
                                                        // Text(
                                                        //   textAlign: TextAlign.center,
                                                        //   controller.patientData.value?.responseData?.patientId ?? "",
                                                        //   style: AppFonts.regular(11, AppColors.textGrey),
                                                        // ),
                                                      ],
                                                    ),
                                                    Spacer(),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        controller.setOrganizationData();

                                                        showDialog(
                                                          context: context,
                                                          barrierDismissible: true, // Allows dismissing the dialog by tapping outside
                                                          builder: (BuildContext context) {
                                                            return OrganizationEditDialog(
                                                              receiveParam: (p0) {
                                                                controller.updateOrganization(p0);
                                                                // controller.userInvite(p0);
                                                              },
                                                            ); // Our custom dialog
                                                          },
                                                        );

                                                        // final result = await Get.toNamed(Routes.EDIT_PATENT_DETAILS,
                                                        //     arguments: {"patientData": controller.patientId, "visitId": controller.visitId, "fromSchedule": true});
                                                        //
                                                        // controller.onReady();
                                                      },
                                                      child: SvgPicture.asset(
                                                        ImagePath.edit,
                                                        width: 26,
                                                        height: 26,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    // SizedBox(
                                                    //   width: 100,
                                                    //   child: CustomAnimatedButton(
                                                    //     text: "Logout",
                                                    //     height: 45,
                                                    //     isOutline: true,
                                                    //     enabledColor: AppColors.redText,
                                                    //     outlineColor: AppColors.redText,
                                                    //     enabledTextColor: AppColors.white,
                                                    //     outLineEnabledColor: AppColors.redText,
                                                    //   ),
                                                    // )
                                                  ],
                                                ),
                                                SizedBox(height: 20),
                                                Row(
                                                  children: [
                                                    Text(
                                                      textAlign: TextAlign.center,
                                                      "Organization Information",
                                                      style: AppFonts.medium(16, AppColors.backgroundPurple),
                                                    ),
                                                    Spacer()
                                                  ],
                                                ),
                                                SizedBox(height: 20),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                        child: CommonPatientData(
                                                      label: "Name",
                                                      data: controller.getOrganizationDetailModel.value?.responseData?.name ?? "-",
                                                    )),
                                                    Expanded(
                                                        child: CommonPatientData(
                                                      label: "No. of Providers",
                                                      data: controller.getOrganizationDetailModel.value?.responseData?.employeesCount.toString() ?? "-",
                                                    )),
                                                    Expanded(child: SizedBox()),
                                                    Expanded(child: SizedBox()),
                                                  ],
                                                ),
                                                SizedBox(height: 20),
                                                //------------------ Contact
                                                SizedBox(height: 20),
                                                Row(
                                                  children: [
                                                    Text(
                                                      textAlign: TextAlign.center,
                                                      "Contact",
                                                      style: AppFonts.medium(16, AppColors.backgroundPurple),
                                                    ),
                                                    Spacer()
                                                  ],
                                                ),
                                                SizedBox(height: 20),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                        child: CommonPatientData(
                                                      label: "Email ID",
                                                      data: controller.getOrganizationDetailModel.value?.responseData?.email ?? "-",
                                                    )),
                                                    Expanded(
                                                        child: CommonPatientData(
                                                      label: "Phone Number",
                                                      data: controller.getOrganizationDetailModel.value?.responseData?.contactNo ?? "-",
                                                    )),
                                                    Expanded(child: SizedBox()),
                                                    Expanded(child: SizedBox()),
                                                  ],
                                                ),
                                                SizedBox(height: 20),
                                                //------------------ Address
                                                SizedBox(height: 20),
                                                Row(
                                                  children: [
                                                    Text(
                                                      textAlign: TextAlign.center,
                                                      "Address",
                                                      style: AppFonts.medium(16, AppColors.backgroundPurple),
                                                    ),
                                                    Spacer()
                                                  ],
                                                ),
                                                SizedBox(height: 20),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                        child: CommonPatientData(
                                                      label: "Address 1",
                                                      data: controller.getOrganizationDetailModel.value?.responseData?.address1 ?? "-",
                                                    )),
                                                    Expanded(
                                                        child: CommonPatientData(
                                                      label: "Address 2",
                                                      data: controller.getOrganizationDetailModel.value?.responseData?.address2 ?? "-",
                                                    )),
                                                    Expanded(
                                                        child: CommonPatientData(
                                                      label: "City",
                                                      data: controller.getOrganizationDetailModel.value?.responseData?.city ?? "-",
                                                    )),
                                                    Expanded(child: SizedBox()),
                                                  ],
                                                ),
                                                SizedBox(height: 20),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                        child: CommonPatientData(
                                                      label: "State",
                                                      data: controller.getOrganizationDetailModel.value?.responseData?.state ?? "-",
                                                    )),
                                                    Expanded(
                                                        child: CommonPatientData(
                                                      label: "Postal Code",
                                                      data: controller.getOrganizationDetailModel.value?.responseData?.postalCode ?? "-",
                                                    )),
                                                    Expanded(
                                                        child: CommonPatientData(
                                                      label: "Country",
                                                      data: controller.getOrganizationDetailModel.value?.responseData?.country ?? "-",
                                                    )),
                                                    Expanded(child: SizedBox()),
                                                  ],
                                                ),
                                                SizedBox(height: 20),
                                              ],
                                            )),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.white),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "User Management",
                                                style: AppFonts.medium(16, AppColors.black),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                                              decoration: BoxDecoration(
                                                border: Border.all(color: AppColors.textGrey.withValues(alpha: 0.5)),
                                                // color: AppColors.backgroundWhite,
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    ImagePath.search,
                                                    height: 25,
                                                    width: 25,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  SizedBox(
                                                    width: 130,
                                                    child: TextFormField(
                                                      // controller: controller.searchController,
                                                      onChanged: (value) {
                                                        // controller.tabIndex.value == 0
                                                        //     ? controller.getPatientList()
                                                        //     : controller.tabIndex.value == 1
                                                        //     ? controller.getScheduleVisitList()
                                                        //     : controller.getPastVisitList();
                                                      },
                                                      maxLines: 1, //or null

                                                      decoration: InputDecoration.collapsed(hintText: "Search", hintStyle: AppFonts.regular(14, AppColors.textGrey)).copyWith(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              width: 140,
                                              child: CustomButton(
                                                hight: 40,
                                                navigate: () async {
                                                  showDialog(
                                                    context: context,
                                                    barrierDismissible: true, // Allows dismissing the dialog by tapping outside
                                                    builder: (BuildContext context) {
                                                      return InviteUserDialog(
                                                        receiveParam: (p0) {
                                                          controller.userInvite(p0);
                                                        },
                                                      ); // Our custom dialog
                                                    },
                                                  );
                                                },
                                                label: "Invite User",
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                        child: SizedBox(
                                          height: ((controller.getUserOrganizationListModel.value?.responseData?.length ?? 0) + 1) * 68,
                                          child: controller.getUserOrganizationListModel.value?.responseData!.isEmpty ?? false
                                              ? Padding(
                                                  padding: const EdgeInsets.all(10),
                                                  child: EmptyPatientScreen(onBtnPress: () async {}, title: "No data found", description: ""),
                                                )
                                              : Obx(() {
                                                  return CustomTable(
                                                    // scrollController: controller.scrollControllerPatientList,
                                                    physics: NeverScrollableScrollPhysics(),
                                                    onRefresh: () async {},
                                                    rows: _getTableRows(controller.getUserOrganizationListModel.value?.responseData ?? []),
                                                    columnCount: 6,
                                                    cellBuilder: _buildTableCell,
                                                    context: context,
                                                    onRowSelected: (rowIndex, rowData) {},
                                                    onLoadMore: () async {},
                                                    columnWidths: [0.16, 0.22, 0.25, 0.13, 0.15, 0.08],
                                                    headerBuilder: (context, colIndex) {
                                                      List<String> headers = ['First Name', 'Email Address', 'Role', 'Admin', 'Last Login Date', 'Action'];
                                                      return GestureDetector(
                                                        onTap: () {
                                                          if (colIndex != 5) {
                                                            // controller.patientSorting(colIndex: colIndex, cellData: headers[colIndex]);
                                                          }
                                                          // customPrint(cellData);
                                                        },
                                                        child: Container(
                                                          color: AppColors.backgroundWhite,
                                                          height: 40,
                                                          child: Row(
                                                            mainAxisAlignment: colIndex == 0 ? MainAxisAlignment.start : MainAxisAlignment.center,
                                                            children: [
                                                              Text(
                                                                headers[colIndex],
                                                                textAlign: colIndex == 0 ? TextAlign.start : TextAlign.center,
                                                                style: AppFonts.medium(12, AppColors.black),
                                                                softWrap: true, // Allows text to wrap
                                                                overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
                                                              ),
                                                              // colIndex == controller.globalController.homePatientListSortingModel.value?.colIndex &&
                                                              //     controller.globalController.homePatientListSortingModel.value!.isAscending &&
                                                              //     colIndex != 5
                                                              //     ? Icon(
                                                              //   CupertinoIcons.down_arrow,
                                                              //   size: 15,
                                                              // )
                                                              //     : colIndex == controller.globalController.homePatientListSortingModel.value?.colIndex &&
                                                              //     !controller.globalController.homePatientListSortingModel.value!.isAscending &&
                                                              //     colIndex != 5
                                                              //     ? Icon(
                                                              //   CupertinoIcons.up_arrow,
                                                              //   size: 15,
                                                              // )
                                                              //     : SizedBox()
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    isLoading: false,
                                                  );
                                                }),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ))
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  // This function creates rows from the API model
  List<List<String>> _getTableRows(List<GetUserOrganizationListResponseData> patients) {
    List<List<String>> rows = [];

    // Add header row first
    // rows.add(['Patient Name', 'Age', 'Gender', 'Last Visit Date', 'Previous Visits', 'Action']);

    // Iterate over each patient and extract data for each row
    for (var patient in patients) {
      rows.add([
        "${patient.name}", // Patient Name
        patient.email ?? "", // Gender
        patient.role ?? "", // Gender
        patient.isAdmin == true ? "Yes" : "No", // Last Visit Date
        patient.lastLoginDate != null ? DateFormat('MM/dd/yyyy').format(DateTime.parse(patient.lastLoginDate.toString())) : "-", // Previous Visits
        "Action",
      ]);
    }
    return rows;
  }

  // This is the cell builder function where you can customize how each cell is built.
  Widget _buildTableCell(BuildContext context, int rowIndex, int colIndex, String cellData, String profileImage) {
    return colIndex == 0
        ? GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                // Checkbox(
                //   value: true,
                //   onChanged: (value) {},
                // ),
                // SizedBox(
                //   width: 0,
                // ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      // if (rowIndex != 0) {
                      // await Get.toNamed(Routes.PATIENT_PROFILE, arguments: {"patientData": controller.patientList[rowIndex].id.toString(), "visitId": "", "fromSchedule": false});

                      // controller.getPatientList();
                      // }
                    },
                    child: Text(
                      cellData,
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      style: AppFonts.regular(14, AppColors.textDarkGrey),
                      softWrap: true,
                      // Allows text to wrap
                      overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
                    ),
                  ),
                ),
              ],
            ),
          )
        : colIndex == 5
            ? PopupMenuButton<String>(
                offset: const Offset(0, 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                color: AppColors.white,
                position: PopupMenuPosition.under,
                padding: EdgeInsetsDirectional.zero,
                menuPadding: EdgeInsetsDirectional.zero,
                onSelected: (value) {},
                style: const ButtonStyle(
                    padding: WidgetStatePropertyAll(EdgeInsetsDirectional.zero),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    maximumSize: WidgetStatePropertyAll(Size.zero),
                    visualDensity: VisualDensity(horizontal: 0, vertical: 0)),
                itemBuilder: (context) => [
                      PopupMenuItem(
                          padding: EdgeInsets.zero,
                          onTap: () async {
                            // customPrint(" patient id is ${controller.patientList[rowIndex].id}");
                            // await Get.toNamed(Routes.PATIENT_PROFILE, arguments: {"patientData": controller.patientList[rowIndex].id.toString(), "visitId": "", "fromSchedule": false});
                            // controller.getPatientList();
                          },
                          // value: "",
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Patient Details",
                              style: AppFonts.regular(14, AppColors.textBlack),
                            ),
                          )),
                      // if (controller.patientList[rowIndex].visitId != null)
                      //   PopupMenuItem(
                      //       padding: EdgeInsets.zero,
                      //       // value: "",
                      //       onTap: () async {
                      //         dynamic response = await Get.toNamed(Routes.VISIT_MAIN, arguments: {
                      //           "visitId": controller.patientList[rowIndex].visitId.toString(),
                      //           "patientId": controller.patientList[rowIndex].id.toString(),
                      //           "unique_tag": DateTime.now().toString(),
                      //         });
                      //         controller.getPatientList();
                      //         print("back from response");
                      //       },
                      //       child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           Container(
                      //             width: double.infinity,
                      //             height: 1,
                      //             color: AppColors.appbarBorder,
                      //           ),
                      //           Padding(
                      //             padding: const EdgeInsets.all(8.0),
                      //             child: Text(
                      //               "Medical record",
                      //               style: AppFonts.regular(14, AppColors.textBlack),
                      //             ),
                      //           ),
                      //         ],
                      //       )),
                      // PopupMenuItem(
                      //     padding: EdgeInsets.zero,
                      //     // value: "",
                      //     onTap: () {
                      //       showDialog(
                      //         context: context,
                      //         barrierDismissible: true, // Allows dismissing the dialog by tapping outside
                      //         builder: (BuildContext context) {
                      //           return SchedulePatientDialog(
                      //             receiveParam: (p0, p1) {
                      //               customPrint("p0 is $p0 p1 is $p1");
                      //               controller.patientScheduleCreate(param: {"patient_id": controller.patientList[rowIndex].id.toString(), "visit_date": p1, "visit_time": p0});
                      //             },
                      //           ); // Our custom dialog
                      //         },
                      //       );
                      //     },
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Container(
                      //           width: double.infinity,
                      //           height: 1,
                      //           color: AppColors.appbarBorder,
                      //         ),
                      //         Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: Text(
                      //             "Schedule",
                      //             style: AppFonts.regular(14, AppColors.textBlack),
                      //           ),
                      //         ),
                      //       ],
                      //     )),
                      PopupMenuItem(
                          padding: EdgeInsets.zero,
                          onTap: () {
                            // if (rowIndex != 0) {
                            // showDialog(
                            //   context: context,
                            //   barrierDismissible: true, // Allows dismissing the dialog by tapping outside
                            //   builder: (BuildContext context) {
                            //     return DeletePatientDialog(
                            //       title: "Are you sure want to delete patient",
                            //       onDelete: () {
                            //         print("delete id is :- ${controller.patientList[rowIndex].id}");
                            //         Get.back();
                            //         controller.deletePatientById(controller.patientList[rowIndex].id);
                            //       },
                            //       header: "Delete Patient",
                            //     ); // Our custom dialog
                            //   },
                            // );
                            // }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 1,
                                color: AppColors.appbarBorder,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Delete",
                                  style: AppFonts.regular(14, AppColors.textBlack),
                                ),
                              ),
                            ],
                          ))
                    ],
                child: SvgPicture.asset(
                  "assets/images/logo_threedots.svg",
                  width: 20,
                  height: 20,
                ))
            : colIndex == 3
                ? SizedBox(
                    height: 30,
                    child: Transform.scale(
                      scale: 0.7,
                      child: Switch(
                        padding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        splashRadius: 0,
                        // This bool value toggles the switch.
                        value: cellData == "Yes" ? true : false,
                        activeColor: AppColors.backgroundPurple,
                        onChanged: (bool value) {
                          controller.updateRoleAndAdminControll(controller.getUserOrganizationListModel.value?.responseData?[rowIndex].id.toString() ?? "",
                              controller.getUserOrganizationListModel.value?.responseData?[rowIndex].role ?? "", value, rowIndex);

                          // This is called when the user toggles the switch.
                          // setState(() {
                          //   light = value;
                          // });
                        },
                      ),
                    ),
                  )
                : colIndex == 2
                    ? PopupMenuButton<String>(
                        offset: const Offset(0, 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        color: AppColors.white,
                        position: PopupMenuPosition.under,
                        padding: EdgeInsetsDirectional.zero,
                        menuPadding: EdgeInsetsDirectional.zero,
                        onSelected: (value) {},
                        style: const ButtonStyle(
                            padding: WidgetStatePropertyAll(EdgeInsetsDirectional.zero),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            maximumSize: WidgetStatePropertyAll(Size.zero),
                            visualDensity: VisualDensity(horizontal: 0, vertical: 0)),
                        itemBuilder: (context) => [
                              for (var item in controller.userRolesModel.value?.responseData ?? [])
                                PopupMenuItem(
                                    padding: EdgeInsets.zero,
                                    onTap: () async {
                                      controller.updateRoleAndAdminControll(controller.getUserOrganizationListModel.value?.responseData?[rowIndex].id.toString() ?? "", item,
                                          controller.getUserOrganizationListModel.value?.responseData?[rowIndex].isAdmin ?? false, rowIndex);
                                    },
                                    // value: "",
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        item,
                                        style: AppFonts.regular(14, AppColors.textBlack),
                                      ),
                                    )),
                            ],
                        child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.dropdownBackgroundColor,
                              border: Border.all(color: AppColors.dropdownBorderColor, width: 2),
                              borderRadius: BorderRadius.all(Radius.circular(23.0) //                 <--- border radius here
                                  ),
                            ),
                            width: 100,
                            height: 38,
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                Text(
                                  cellData,
                                  textAlign: TextAlign.start,
                                  style: AppFonts.regular(14, AppColors.textDarkGrey),
                                  softWrap: true, // Allows text to wrap
                                  overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
                                ),
                                Spacer(),
                                SvgPicture.asset(
                                  ImagePath.down_arrow,
                                  width: 20,
                                  height: 20,
                                ),
                                SizedBox(width: 10),
                              ],
                            )))
                    : Text(
                        cellData,
                        textAlign: colIndex == 0 ? TextAlign.start : TextAlign.center,
                        style: AppFonts.regular(14, AppColors.textDarkGrey),
                        softWrap: true, // Allows text to wrap
                        overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
                      );
  }
}

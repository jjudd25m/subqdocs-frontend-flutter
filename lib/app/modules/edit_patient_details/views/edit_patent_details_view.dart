import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:subqdocs/widget/appbar.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_diamentions.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../../../../widgets/base_dropdown.dart';
import '../../../../widgets/base_image_view.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_textfiled.dart';
import '../../../../widgets/rounded_image_widget.dart';
import '../controllers/edit_patent_details_controller.dart';

class EditPatentDetailsView extends GetView<EditPatentDetailsController> {
  EditPatentDetailsView({super.key});

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Column(
            children: [
              CustomAppBar(drawerkey: _key),
              // Padding(
              //   padding: const EdgeInsets.only(
              //     top: 25,
              //   ),
              //   child: Container(
              //     height: 68,
              //     decoration: BoxDecoration(
              //       color: Colors.white,
              //     ),
              //     child: Padding(
              //       padding: const EdgeInsets.all(15),
              //       child: Row(
              //         children: [
              //           SvgPicture.asset("assets/images/logo_drawer.svg"),
              //           SizedBox(
              //             width: 15,
              //           ),
              //           Image.asset("assets/images/log_subQdocs.png"),
              //           Spacer(),
              //           RoundedImageWidget(
              //             size: 50,
              //             imagePath: "assets/images/user.png",
              //           ),
              //           SizedBox(
              //             width: 8,
              //           ),
              //           Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Text(
              //                 "Adrian Tinajero",
              //                 style: AppFonts.medium(14, AppColors.backgroundBlack),
              //               ),
              //               Text(
              //                 "DO, FAAD",
              //                 style: AppFonts.medium(12, AppColors.textDarkGrey),
              //               ),
              //             ],
              //           ),
              //           SizedBox(
              //             width: 15,
              //           ),
              //           SvgPicture.asset("assets/images/logo_signout.svg")
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              Expanded(
                  child: Container(
                color: AppColors.ScreenBackGround,
                child: Padding(
                  padding: EdgeInsets.only(top: Dimen.margin20, right: Dimen.margin16, left: Dimen.margin16),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(Dimen.margin16),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: AppColors.white),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: SvgPicture.asset(
                                    ImagePath.arrowLeft,
                                    fit: BoxFit.cover,
                                    width: Dimen.margin24,
                                    height: Dimen.margin24,
                                  ),
                                ),
                                SizedBox(
                                  width: Dimen.margin8,
                                ),
                                Text(
                                  "Patient Details",
                                  style: AppFonts.regular(18, AppColors.textBlack),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: Dimen.margin24,
                            ),
                            Row(
                              children: [
                                RoundedImageWidget(
                                  size: 60,
                                  imagePath: ImagePath.user,
                                ),
                                SizedBox(
                                  width: 14,
                                ),
                                SizedBox(
                                  width: 100,
                                  child: CustomButton(
                                    hight: 35.0,
                                    navigate: () {},
                                    label: "Choose File",
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                SizedBox(
                                  width: 85,
                                  child: CustomButton(
                                    navigate: () {},
                                    backGround: Colors.white,
                                    textColor: AppColors.redText,
                                    hight: 35.0,
                                    label: "Remove",
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: Dimen.margin16,
                            ),
                            // Row(
                            //   children: [
                            //     Expanded(
                            //       child: TextFormFiledWidget(
                            //         label: "Patient ID",
                            //         controller: controller.patientIdController,
                            //         hint: "12345678",
                            //       ),
                            //     ),
                            //     SizedBox(
                            //       width: Dimen.margin10,
                            //     ),
                            //     Expanded(child: SizedBox()),
                            //     SizedBox(
                            //       width: Dimen.margin10,
                            //     ),
                            //     Expanded(
                            //       child: SizedBox(),
                            //     )
                            //   ],
                            // ),
                            SizedBox(
                              height: Dimen.margin16,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormFiledWidget(
                                    label: "First Name",
                                    // isImportant: true,
                                    isValid: true,
                                    controller: controller.firstNameController,
                                    hint: "Don",
                                  ),
                                ),
                                SizedBox(
                                  width: Dimen.margin10,
                                ),
                                Expanded(
                                  child: TextFormFiledWidget(
                                    label: "Middle Name",
                                    controller: controller.middleNameController,
                                    hint: "Joseph",
                                  ),
                                ),
                                SizedBox(
                                  width: Dimen.margin10,
                                ),
                                Expanded(
                                  child: TextFormFiledWidget(
                                    label: "Last Name",
                                    isValid: true,
                                    // isImportant: true,
                                    controller: controller.lastNameController,
                                    hint: "Jones",
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: Dimen.margin16,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormFiledWidget(
                                    label: "Date of birth",
                                    readOnly: true,
                                    onTap: () {
                                      controller.showDOBCupertinoDatePicker(context, controller.dobController);
                                    },
                                    controller: controller.dobController,
                                    hint: "12/1/1972",
                                    suffixIcon: SvgPicture.asset(ImagePath.calendar),
                                  ),
                                ),
                                SizedBox(
                                  width: Dimen.margin10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Sex",
                                        style: AppFonts.regular(14, AppColors.textBlack),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Obx(() {
                                        return BaseDropdown<String>(
                                          valueAsString: (value) => value ?? "",
                                          items: controller.sex,
                                          selectedValue: controller.selectedSexValue.value,
                                          onChanged: (value) {
                                            controller.selectedSexValue.value = value;
                                          },
                                          selectText: "Male",
                                        );
                                      })
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: Dimen.margin10,
                                ),
                                Expanded(
                                  child: TextFormFiledWidget(
                                    label: "Email Address",
                                    controller: controller.emailAddressController,
                                    hint: "donjones@example.com",
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: Dimen.margin16,
                            ),
                            Row(
                              spacing: 10,
                              children: [
                                Expanded(
                                  child: TextFormFiledWidget(
                                    label: "Visit Date",
                                    readOnly: true,
                                    onTap: () {
                                      controller.showVisitDateCupertinoDatePicker(context, controller.visitDateController);
                                    },
                                    controller: controller.visitDateController,
                                    hint: "10/12/2024",
                                    suffixIcon: SvgPicture.asset(ImagePath.calendar),
                                  ),
                                ),
                                // SizedBox(
                                //   width: Dimen.margin10,
                                // ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Visit Time",
                                        style: AppFonts.regular(14, AppColors.textBlack),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Obx(() {
                                        return BaseDropdown<String>(
                                          valueAsString: (value) => value ?? "",
                                          items: controller.visitTime,
                                          selectedValue: controller.selectedVisitTimeValue.value,
                                          onChanged: (value) {
                                            controller.selectedVisitTimeValue.value = value ?? "";
                                          },
                                          selectText: "11 PM",
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                                // SizedBox(
                                //   width: Dimen.margin10,
                                // ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Patient Type",
                                        style: AppFonts.regular(14, AppColors.textBlack),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Obx(() {
                                        return BaseDropdown<String>(
                                          valueAsString: (value) => value ?? "",
                                          items: controller.patientType,
                                          selectedValue: controller.selectedPatientValue.value,
                                          onChanged: (value) {
                                            controller.selectedPatientValue.value = value;
                                          },
                                          selectText: "New Patient",
                                        );
                                      })
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Spacer(),
                                Container(
                                  width: 80,
                                  child: CustomButton(
                                    navigate: () {},
                                    isTrue: false,
                                    textColor: AppColors.backgroundPurple,
                                    backGround: Colors.white,
                                    label: "Cancel",
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Container(
                                  width: 70,
                                  child: CustomButton(
                                      navigate: () {
                                        controller.addPatient();
                                      },
                                      label: "Save"),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ))
            ],
          ),
        ));
  }
}

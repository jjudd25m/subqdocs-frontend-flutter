import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../../../../utils/validation_service.dart';
import '../../../../widget/base_image_view.dart';
import '../../../../widgets/base_dropdown2.dart';
import '../../../../widgets/custom_tab_button.dart';
import '../../../../widgets/custom_textfiled.dart';
import '../../../../widgets/custom_toastification.dart';
import '../../patient_info/model/get_doctor_list_by_role_model.dart';
import '../controllers/doctor_to_doctor_sign_finalize_authenticate_view_controller.dart';

class DoctorToDoctorSignFinalizeAuthenticateView extends GetView<DoctorToDoctorSignFinalizeAuthenticateViewController> {
  // DoctorToDoctorSignFinalizeAuthenticateViewController controller;

  DoctorToDoctorSignFinalizeAuthenticateView({super.key});

  // DoctorToDoctorSignFinalizeAuthenticateView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: AppColors.backgroundPurple,
          child: Row(
            children: [
              Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), child: Text("Authenticate", style: AppFonts.medium(14, Colors.white))),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(padding: const EdgeInsets.all(15), color: AppColors.clear, child: SvgPicture.asset("assets/images/cross_white.svg", width: 15)),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Form(
              key: controller.formKey,
              child: Container(
                width: double.infinity,
                color: AppColors.backgroundMobileAppbar,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Obx(() {
                    return Column(
                      spacing: 0,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        Center(child: SvgPicture.asset(ImagePath.confirm_check, width: 70, height: 70)),
                        const SizedBox(height: 20),
                        if (controller.selectedDoctorValueModel.value?.id == controller.loginData.value?.responseData?.user?.id) ...[
                          Row(children: [Expanded(child: Text("Are you sure you want to finalize?", textAlign: TextAlign.center, style: AppFonts.medium(17, AppColors.textBlack)))]),
                          const SizedBox(height: 10),
                        ] else ...[
                          Row(children: [Expanded(child: Text("Are you sign and finalize as Dr. ${controller.selectedDoctorValueModel.value?.name ?? ""}", style: AppFonts.regular(16, AppColors.black), textAlign: TextAlign.center))]),
                          const SizedBox(height: 10),
                        ],
                        IgnorePointer(
                          ignoring: controller.isDisableView,
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Obx(() {
                                      return Row(children: [Expanded(child: Text(controller.checkPinResponse.value?.message == "Doctor Has Not Set Pin" ? "Please login to the selected doctor's account and set Pin from Personal setting" : "", style: AppFonts.regular(14, AppColors.redText)))]);
                                    }),
                                    const SizedBox(height: 10),

                                    if (controller.checkPinResponse.value?.message == "Doctor Has Not Set Pin") ...[
                                      Row(children: [Text("Doctor Name", style: AppFonts.regular(14, AppColors.textBlack))]),
                                      const SizedBox(height: 8),
                                    ],
                                    Obx(() {
                                      return BaseDropdown2<GetDoctorListByRoleResponseData>(
                                        isRequired: true,
                                        fillColor: AppColors.clear,
                                        direction: VerticalDirection.up,
                                        controller: TextEditingController(),
                                        scrollController: controller.scrollController,
                                        valueAsString: (p) => p?.name ?? "",
                                        items: controller.doctorList.toList(),

                                        selectedValue: controller.selectedDoctorValueModel.value,

                                        itemBuilder: (model) {
                                          return Container(
                                            color: Colors.white,
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Padding(padding: const EdgeInsets.only(left: 10), child: ClipRRect(borderRadius: BorderRadius.circular(14), child: BaseImageView(height: 32, width: 32, nameLetters: model.name ?? "", fontSize: 12, imageUrl: model.profileImage ?? ""))),
                                                const SizedBox(width: 10),
                                                Expanded(child: Container(color: AppColors.white, child: Text(model.name ?? "", style: AppFonts.medium(14, AppColors.black)))),
                                              ],
                                            ),
                                          );
                                        },

                                        onChanged: (model) {
                                          controller.checkDoctorPIN(model?.id.toString() ?? "");

                                          controller.selectedDoctorValueModel.value = model;
                                          controller.selectedDoctorValue.value = model?.name ?? "";
                                          controller.selectedDoctorValue.refresh();
                                          controller.selectedDoctorValueModel.refresh();
                                        },

                                        selectText: controller.selectedDoctorValue.value,
                                        isSearchable: true,
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (controller.selectedDoctorValueModel.value?.id != controller.loginData.value?.responseData?.user?.id) ...[
                          Row(
                            children: [
                              Expanded(
                                child: Obx(() {
                                  return TextFormFiledWidget(
                                    label: "Sign and Finalize PIN",
                                    isValid: true,
                                    fillColor: AppColors.clear,
                                    format: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                                    type: TextInputType.number,
                                    visibility: controller.userPinVisibility.value,
                                    controller: controller.userPINController,
                                    suffixIcon:
                                        !controller.userPinVisibility.value
                                            ? GestureDetector(
                                              onTap: () {
                                                controller.changeUserPinVisiblity();
                                              },
                                              child: SvgPicture.asset(ImagePath.eyeLogoOpen, height: 5, width: 5),
                                            )
                                            : GestureDetector(
                                              onTap: () {
                                                controller.changeUserPinVisiblity();
                                              },
                                              child: const Icon(CupertinoIcons.eye_slash_fill, color: AppColors.textDarkGrey),
                                            ),
                                    checkValidation: (value) {
                                      return Validation.validateFourDigitNumber(value);
                                    },
                                  );
                                }),
                              ),
                            ],
                          ),
                        ],
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            spacing: 10,
            children: [
              Expanded(
                child: CustomTabButton(
                  onPressed: () async {
                    Get.back();
                  },
                  text: "Cancel",
                  isOutline: true,
                  enabledTextColor: AppColors.backgroundPurple,
                  outlineColor: AppColors.backgroundPurple,
                  enabledColor: AppColors.clear,
                  borderRadius: 10,
                ),
              ),
              Expanded(
                child: CustomTabButton(
                  onPressed: () async {
                    // Get.back();

                    print(controller.selectedDoctorValue.value);
                    if (controller.selectedDoctorValue.value == null) {
                      CustomToastification().showToast("Please select Doctor", type: ToastificationType.error);
                    } else {
                      if (controller.formKey.currentState!.validate()) {
                        controller.changeStatus();
                      }
                    }
                  },
                  text: "Finalize",
                  enabledColor: AppColors.backgroundPurple,
                  borderRadius: 10,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

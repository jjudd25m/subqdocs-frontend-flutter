import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/utils/app_fonts.dart';
import 'package:subqdocs/widgets/custom_button.dart';
import 'package:subqdocs/widgets/custom_toastification.dart';
import 'package:toastification/toastification.dart';

import '../../../../utils/imagepath.dart';
import '../../../../utils/validation_service.dart';
import '../../../../widgets/base_dropdown.dart';
import '../../../../widgets/base_dropdown2.dart';
import '../../../../widgets/custom_textfiled.dart';
import '../controllers/personal_setting_controller.dart';

class IntegrateEmaDialog extends GetView<PersonalSettingController> {
  // final void Function(Map<String, dynamic>) receiveParam;
  final void Function(bool) receiveParam;

  RxBool visiblity = RxBool(true);

  IntegrateEmaDialog({super.key, required this.receiveParam});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 16,
      child: Form(
        key: controller.formKey,
        child: Container(
          constraints: BoxConstraints(maxHeight: Get.height * .80, maxWidth: Get.width * .80),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: ListView(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            children: [
              Container(
                width: 360,
                decoration: BoxDecoration(color: AppColors.backgroundPurple, borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), child: Text("Integrate EMA", style: AppFonts.medium(14, Colors.white))),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          // controller.list.clear();
                        },
                        child: Container(padding: EdgeInsets.all(15), color: AppColors.clear, child: SvgPicture.asset("assets/images/cross_white.svg", width: 15)),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 360,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    spacing: 10,
                    children: [
                      Row(
                        spacing: 10,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [Text("EMA Vendor", style: AppFonts.regular(14, AppColors.textBlack))]),
                                SizedBox(height: 8),
                                Obx(() {
                                  return BaseDropdown<String>(
                                    valueAsString: (value) => value ?? "",
                                    items: controller.emaVenderList,
                                    selectedValue: controller.selectedEmaVender.value,
                                    onChanged: (value) {
                                      controller.selectedEmaVender.value = value;
                                    },
                                    selectText: controller.selectedEmaVender.value,
                                  );
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        spacing: 10,
                        children: [
                          Expanded(
                            child: TextFormFiledWidget(
                              label: "Base URL",
                              // isImportant: true,
                              // isValid: controller.isValid.value,
                              // format: [CustomTextInputFormatter()],
                              controller: controller.emaBaseUrlController,
                              hint: "http://www.google.com",
                              isSuffixIconVisible: false,
                              isFirst: true,
                              onTap: () {
                                controller.emaBaseUrlController.clear();
                              },
                              suffixIcon: Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                              checkValidation: (value) {
                                return Validation.requiredFiled(value);
                              },
                            ),
                          ),
                          // Expanded(
                          //   child: TextFormFiledWidget(
                          //     format: [CustomTextInputFormatter()],
                          //     label: "Last Name",
                          //     isValid: controller.isValid.value,
                          //     controller: controller.lastNameController,
                          //     isSuffixIconVisible: false,
                          //     isFirst: true,
                          //     hint: "Jones",
                          //     onTap: () {
                          //       controller.lastNameController.clear();
                          //     },
                          //     suffixIcon: Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                          //     checkValidation: (value) {
                          //       return Validation.requiredFiled(value);
                          //     },
                          //   ),
                          // ),
                        ],
                      ),
                      // Row(
                      //   spacing: 10,
                      //   children: [
                      //     Expanded(
                      //       child: TextFormFiledWidget(
                      //         label: "Firm URL Prefix",
                      //         // isImportant: true,
                      //         // isValid: controller.isValid.value,
                      //         format: [CustomTextInputFormatter()],
                      //         controller: controller.emaFirmURLPrefixController,
                      //         hint: "",
                      //         isSuffixIconVisible: false,
                      //         isFirst: true,
                      //         onTap: () {
                      //           controller.emaFirmURLPrefixController.clear();
                      //         },
                      //         suffixIcon: Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                      //         checkValidation: (value) {
                      //           return Validation.requiredFiled(value);
                      //         },
                      //       ),
                      //     ),
                      //     // Expanded(
                      //     //   child: TextFormFiledWidget(
                      //     //     format: [CustomTextInputFormatter()],
                      //     //     label: "Last Name",
                      //     //     isValid: controller.isValid.value,
                      //     //     controller: controller.lastNameController,
                      //     //     isSuffixIconVisible: false,
                      //     //     isFirst: true,
                      //     //     hint: "Jones",
                      //     //     onTap: () {
                      //     //       controller.lastNameController.clear();
                      //     //     },
                      //     //     suffixIcon: Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                      //     //     checkValidation: (value) {
                      //     //       return Validation.requiredFiled(value);
                      //     //     },
                      //     //   ),
                      //     // ),
                      //   ],
                      // ),
                      Row(
                        spacing: 10,
                        children: [
                          Expanded(
                            child: TextFormFiledWidget(
                              label: "API Key",
                              // isImportant: true,
                              // isValid: controller.isValid.value,
                              // format: [CustomTextInputFormatter()],
                              controller: controller.emaAPIKeyController,
                              hint: "",
                              isSuffixIconVisible: false,
                              isFirst: true,
                              onTap: () {
                                controller.emaAPIKeyController.clear();
                              },
                              suffixIcon: Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                              checkValidation: (value) {
                                return Validation.requiredFiled(value);
                              },
                            ),
                          ),
                          // Expanded(
                          //   child: TextFormFiledWidget(
                          //     format: [CustomTextInputFormatter()],
                          //     label: "Last Name",
                          //     isValid: controller.isValid.value,
                          //     controller: controller.lastNameController,
                          //     isSuffixIconVisible: false,
                          //     isFirst: true,
                          //     hint: "Jones",
                          //     onTap: () {
                          //       controller.lastNameController.clear();
                          //     },
                          //     suffixIcon: Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                          //     checkValidation: (value) {
                          //       return Validation.requiredFiled(value);
                          //     },
                          //   ),
                          // ),
                        ],
                      ),
                      Row(
                        spacing: 10,
                        children: [
                          Expanded(
                            child: TextFormFiledWidget(
                              label: "API User name",
                              // isImportant: true,
                              // isValid: controller.isValid.value,
                              // format: [CustomTextInputFormatter()],
                              controller: controller.emaAPIUsernameController,
                              hint: "",
                              isSuffixIconVisible: false,
                              isFirst: true,
                              onTap: () {
                                controller.emaAPIUsernameController.clear();
                              },
                              suffixIcon: Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                              checkValidation: (value) {
                                return Validation.requiredFiled(value);
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        spacing: 10,
                        children: [
                          Expanded(
                            child: Obx(() {
                              return TextFormFiledWidget(
                                label: "API Password",
                                hint: "",
                                visibility: visiblity.value,
                                controller: controller.emaAPIPasswordController,
                                suffixIcon:
                                    !visiblity.value
                                        ? GestureDetector(
                                          onTap: () {
                                            changeVisiblity();
                                          },
                                          child: SvgPicture.asset(ImagePath.eyeLogoOpen, height: 5, width: 5),
                                        )
                                        : GestureDetector(
                                          onTap: () {
                                            changeVisiblity();
                                          },
                                          child: Icon(CupertinoIcons.eye_slash_fill, color: AppColors.textDarkGrey),
                                        ),
                              );
                            }),
                          ),
                        ],
                      ),
                      SizedBox(height: 0),
                      if (controller.globalController.getEMAOrganizationDetailModel.value?.responseData?.has_ema_configs ?? false) ...[
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [Text("Appointment Type", style: AppFonts.regular(14, AppColors.textBlack))]),
                                  const SizedBox(height: 8),
                                  Obx(() {
                                    return BaseDropdown2<String>(
                                      isRequired: false,
                                      direction: VerticalDirection.up,
                                      controller: TextEditingController(),
                                      valueAsString: (value) => value ?? "",
                                      items: controller.getAvailableVisitTypes.value?.responseData?.map((e) => e.display ?? "").toList() ?? [],
                                      selectedValue: controller.selectedAppointmentTypeValue.value,
                                      onChanged: (value) {
                                        controller.selectedAppointmentTypeValue.value = value;
                                      },
                                      selectText: controller.selectedAppointmentTypeValue.value,
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 100,
                            child: CustomButton(
                              navigate: () {
                                Navigator.pop(context);
                                // controller.list.clear();
                              },
                              label: "Cancel",
                              backGround: Colors.white,
                              isTrue: false,
                              textColor: AppColors.backgroundPurple,
                            ),
                          ),
                          SizedBox(width: 12),
                          SizedBox(
                            width: 100,
                            child: CustomButton(
                              navigate: () async {
                                if (controller.formKey.currentState!.validate()) {
                                  Map<String, dynamic> response = Map<String, dynamic>();

                                  print("appointment val:- ${controller.selectedAppointmentTypeValue.value}");

                                  if (controller.globalController.getEMAOrganizationDetailModel.value?.responseData?.has_ema_configs ?? false) {
                                    if (controller.selectedAppointmentTypeValue.value == null) {
                                      CustomToastification().showToast("Appointment type is require", type: ToastificationType.error);
                                      return;
                                    }
                                  }

                                  if (controller.globalController.getEMAOrganizationDetailModel.value?.responseData?.has_ema_configs ?? false) {
                                    String appointmentValue = controller.getAvailableVisitTypes.value?.responseData?.firstWhere((element) => element.display == controller.selectedAppointmentTypeValue.value).code ?? "";
                                    response = {
                                      "vendor": "MODMED",
                                      "appointment_type": {"label": controller.selectedAppointmentTypeValue.value, "value": appointmentValue},
                                      "ema_configs": [
                                        {"key": "base_url", "value": controller.emaBaseUrlController.text},
                                        {"key": "api_key", "value": controller.emaAPIKeyController.text},
                                        {"key": "api_username", "value": controller.emaAPIUsernameController.text},
                                        {"key": "api_password", "value": controller.emaAPIPasswordController.text},
                                      ],
                                    };
                                  } else {
                                    response = {
                                      "vendor": "MODMED",
                                      // "appointment_type": {"label": controller.selectedAppointmentTypeValue.value, "value": appointmentValue},
                                      "ema_configs": [
                                        {"key": "base_url", "value": controller.emaBaseUrlController.text},
                                        {"key": "api_key", "value": controller.emaAPIKeyController.text},
                                        {"key": "api_username", "value": controller.emaAPIUsernameController.text},
                                        {"key": "api_password", "value": controller.emaAPIPasswordController.text},
                                      ],
                                    };
                                  }

                                  // receiveParam(response);

                                  bool data = await controller.saveEmaConfig(response);
                                  // receiveParam(data);
                                  Navigator.pop(context);

                                  if (data) {
                                    final model = controller.globalController.getEMAOrganizationDetailModel.value?.responseData;
                                    if (model?.has_ema_configs == true && model?.appointmentType == null) {
                                      // showAppointmentTypeDialog(context);
                                      receiveParam(true);
                                    }
                                  }
                                }
                              },
                              label: "Save",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void changeVisiblity() {
    visiblity.value = visiblity == true ? false : true;
    visiblity.refresh();
  }
}

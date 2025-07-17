import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/utils/app_fonts.dart';
import 'package:subqdocs/widgets/custom_button.dart';

import '../../../../utils/no_space_lowercase.dart';
import '../../../../utils/validation_service.dart';
import '../../../../widgets/base_dropdown.dart';
import '../../../../widgets/custom_textfiled.dart';
import '../controllers/personal_setting_controller.dart';

class InviteUserDialog extends GetView<PersonalSettingController> {
  final void Function(Map<String, dynamic>) receiveParam;

  const InviteUserDialog({super.key, required this.receiveParam});

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
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            children: [
              Container(
                width: 360,
                decoration: const BoxDecoration(color: AppColors.backgroundPurple, borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), child: Text("Invite", style: AppFonts.medium(14, Colors.white))),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          // controller.list.clear();
                        },
                        child: Container(padding: const EdgeInsets.all(15), color: AppColors.clear, child: SvgPicture.asset("assets/images/cross_white.svg", width: 15)),
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
                        children: [
                          Expanded(
                            child: TextFormFiledWidget(
                              format: [NoSpaceLowercaseTextFormatter()],
                              label: "Email Address",
                              controller: controller.emailAddressController,
                              isValid: controller.isValid.value,
                              isSuffixIconVisible: false,
                              isFirst: true,
                              hint: "donjones@example.com",
                              onTap: () {
                                controller.emailAddressController.clear();
                              },
                              suffixIcon: const Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                              checkValidation: (value) {
                                return Validation.emailValidateRequired(value);
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        spacing: 10,
                        children: [
                          Expanded(
                            child: TextFormFiledWidget(
                              label: "First Name",
                              // isImportant: true,
                              isValid: controller.isValid.value,
                              format: [CustomTextInputFormatter()],
                              controller: controller.firstNameController,
                              hint: "Don",
                              isSuffixIconVisible: false,
                              isFirst: true,
                              onTap: () {
                                controller.firstNameController.clear();
                              },
                              suffixIcon: const Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                              checkValidation: (value) {
                                return Validation.requiredFiled(value);
                              },
                            ),
                          ),
                          Expanded(
                            child: TextFormFiledWidget(
                              format: [CustomTextInputFormatter()],
                              label: "Last Name",
                              isValid: controller.isValid.value,
                              controller: controller.lastNameController,
                              isSuffixIconVisible: false,
                              isFirst: true,
                              hint: "Jones",
                              onTap: () {
                                controller.lastNameController.clear();
                              },
                              suffixIcon: const Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                              checkValidation: (value) {
                                return Validation.requiredFiled(value);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        spacing: 10,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [Text("Role", style: AppFonts.regular(14, AppColors.textBlack)), Text("*", style: AppFonts.regular(14, AppColors.redText))]),
                                const SizedBox(height: 8),
                                Obx(() {
                                  return BaseDropdown<String>(
                                    valueAsString: (value) => value ?? "",
                                    items: controller.userRolesModel.value?.responseData ?? [],
                                    selectedValue: controller.selectedRoleValue.value,
                                    onChanged: (value) {
                                      controller.selectedRoleValue.value = value;
                                    },
                                    selectText: controller.selectedRoleValue.value,
                                  );
                                }),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [Text("Admin", style: AppFonts.regular(14, AppColors.textBlack)), Text("*", style: AppFonts.regular(14, AppColors.redText))]),
                                const SizedBox(height: 8),
                                Obx(() {
                                  return BaseDropdown<String>(
                                    valueAsString: (value) => value ?? "",
                                    items: controller.adminStatus,
                                    selectedValue: controller.selectedAdminValue.value,
                                    onChanged: (value) {
                                      controller.selectedAdminValue.value = value;
                                    },
                                    selectText: controller.selectedAdminValue.value,
                                  );
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
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
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 100,
                            child: CustomButton(
                              navigate: () {
                                if (controller.formKey.currentState!.validate()) {
                                  Map<String, dynamic> param = <String, dynamic>{};
                                  param["email"] = controller.emailAddressController.text;
                                  param["is_admin"] = controller.selectedAdminValue.value == "Yes" ? true : false;
                                  param["first_name"] = controller.firstNameController.text;
                                  param["last_name"] = controller.lastNameController.text;
                                  param["role"] = controller.selectedRoleValue.value;

                                  receiveParam(param);
                                  Navigator.pop(context);
                                }
                              },
                              label: "Invite",
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
}

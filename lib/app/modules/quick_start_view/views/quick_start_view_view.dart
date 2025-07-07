import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/no_space_lowercase.dart';
import '../../../../utils/validation_service.dart';
import '../../../../widgets/base_dropdown2.dart';
import '../../../../widgets/custom_tab_button.dart';
import '../../../../widgets/custom_textfiled.dart';
import '../../../../widgets/serachFiledTypeAhed.dart';
import '../../home/model/patient_list_model.dart';
import '../controllers/quick_start_view_controller.dart';

class QuickStartViewView extends GetView<QuickStartViewController> {
  // final void Function() completionResponse;

  const QuickStartViewView({super.key});

  // const QuickStartViewView({super.key, required this.completionResponse});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: AppColors.backgroundPurple,
          child: Row(
            children: [
              Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), child: Text("Quick Start", style: AppFonts.medium(14, Colors.white))),
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
                  child: Column(
                    spacing: 0,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      Obx(() {
                        return Serachfiledtypeahed<PatientListData>(
                          suggestionsCallback: (search) async {
                            if (search.isNotEmpty) {
                              return await controller.getPatientList(searchValue: search);
                            }
                            return [];
                          },
                          fillColor: AppColors.clear,
                          suggestionsController: controller.suggestionsController,
                          controller: controller.searchController,
                          valueAsString: (value) => value?.firstName ?? "",
                          items: controller.patientList,
                          selectedValue: controller.searchText.value,
                          isSearchable: true,
                          itemBuilder: (model) {
                            return Container(
                              color: AppColors.white,
                              child: Column(
                                children: [
                                  Padding(padding: const EdgeInsets.all(8.0), child: Row(children: [Text(model.firstName ?? ""), const SizedBox(width: 5), Text(model.lastName ?? "")])),
                                  Container(height: 1, color: AppColors.appbarBorder),
                                ],
                              ),
                            );
                          },
                          onChanged: (value) {
                            controller.searchController.text = "${value?.firstName ?? ""} ${value?.lastName ?? ""}";
                            controller.setUi(value);
                            controller.searchText.value = value;
                            controller.searchText.refresh();
                          },
                          selectText: "${controller.searchText.value?.firstName ?? ""} ${controller.searchText.value?.lastName ?? ""}",
                        );
                      }),
                      const SizedBox(height: 10),
                      IgnorePointer(
                        ignoring: true,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormFiledWidget(
                                label: "Patient Id ",
                                isValid: !controller.isValid.value,
                                // isImportant: true,
                                fillColor: AppColors.backgroundMobileAppbar,
                                isSuffixIconVisible: false,
                                readOnly: true,
                                isFirst: true,
                                format: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')), LengthLimitingTextInputFormatter(15)],
                                controller: controller.patientId,
                                hint: "123",
                                onTap: () {
                                  controller.patientId.clear();
                                },
                                suffixIcon: const Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormFiledWidget(
                              label: "First Name",
                              // isImportant: true,
                              fillColor: AppColors.backgroundMobileAppbar,
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
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Obx(() {
                              return TextFormFiledWidget(
                                isValid: !controller.isValid.value,
                                isSuffixIconVisible: false,
                                isFirst: true,
                                fillColor: AppColors.backgroundMobileAppbar,
                                format: [CustomTextInputFormatter()],
                                label: "Middle Name",
                                controller: controller.middleNameController,
                                hint: "Joseph",
                                onTap: () {
                                  controller.middleNameController.clear();
                                },
                                suffixIcon: const Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                              );
                            }),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Obx(() {
                              return TextFormFiledWidget(
                                format: [CustomTextInputFormatter()],
                                label: "Last Name",
                                isValid: controller.isValid.value,
                                // isImportant: true,
                                fillColor: AppColors.backgroundMobileAppbar,
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
                              );
                            }),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Obx(() {
                              return TextFormFiledWidget(
                                isValid: controller.editId.value.isEmpty ? false : !controller.isValid.value,
                                checkValidation: (value) {
                                  return Validation.birthDateValidation(value);
                                },
                                fillColor: AppColors.backgroundMobileAppbar,
                                suffixIcon: const Icon(Icons.calendar_month),
                                format: [
                                  DateInputFormatter(),
                                  // custom formatter
                                ],
                                label: "Date of birth",

                                controller: controller.dobController,
                                onTap: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now().subtract(const Duration(days: 400)),

                                    firstDate: DateTime.now().subtract(const Duration(days: 36700)),
                                    lastDate: DateTime.now().subtract(const Duration(days: 400)),
                                    builder: (context, child) {
                                      return Theme(data: ThemeData.light().copyWith(cardColor: AppColors.white, primaryColor: AppColors.backgroundPurple, hintColor: AppColors.backgroundPurple, colorScheme: const ColorScheme.light(primary: AppColors.backgroundPurple), buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary)), child: child!);
                                    },
                                  );
                                  if (picked != null) {
                                    String inputText;
                                    String padDayMonth(int value) => value.toString().padLeft(2, '0');
                                    inputText = '${padDayMonth(picked.month)}/${padDayMonth(picked.day)}/${picked.year}';
                                    controller.dobController.text = inputText;
                                  }
                                },
                                hint: "mm/dd/yyyy",
                              );
                            }),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [Text("Gender", style: AppFonts.regular(14, AppColors.textBlack))]),
                                const SizedBox(height: 8),
                                Obx(() {
                                  return BaseDropdown2<String>(
                                    direction: VerticalDirection.up,
                                    controller: TextEditingController(),
                                    valueAsString: (value) => value ?? "",
                                    items: controller.sex,
                                    fillColor: AppColors.backgroundMobileAppbar,
                                    selectedValue: controller.selectedSexValue.value,
                                    onChanged: (value) {
                                      controller.selectedSexValue.value = value;
                                    },
                                    selectText: "Male",
                                  );
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomTabButton(
            onPressed: () async {
              if (controller.formKey.currentState!.validate()) {
                if (controller.editId.value.isEmpty) {
                  // completionResponse();
                  await controller.addPatient();
                } else {
                  await controller.createVisit(int.parse(controller.editId.value));
                  // completionResponse();
                }
              }
            },
            text: "Start Recording",
            enabledColor: AppColors.backgroundPurple,
            borderRadius: 10,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );

    // return Scaffold(
    //   backgroundColor: AppColors.backgroundMobileAppbar,
    //   body: ,
    // );
  }
}

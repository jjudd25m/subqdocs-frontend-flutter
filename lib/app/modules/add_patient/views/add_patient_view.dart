import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:subqdocs/widget/appbar.dart';
import 'package:subqdocs/widgets/base_screen.dart';
import 'package:toastification/toastification.dart';

import '../../../../utils/FileOpener.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_diamentions.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../../../../utils/no_space_lowercase.dart';
import '../../../../utils/validation_service.dart';
import '../../../../widget/base_image_view.dart';
import '../../../../widget/bredcums.dart';
import '../../../../widget/fileImage.dart';
import '../../../../widget/timePickerTextFiled.dart';
import '../../../../widgets/ContainerButton.dart';
import '../../../../widgets/base_dropdown2.dart';
import '../../../../widgets/custom_textfiled.dart';
import '../../../../widgets/custom_toastification.dart';
import '../../../../widgets/serachFiledTypeAhed.dart';
import '../../../core/common/common_service.dart';
import '../../../core/common/logger.dart';
import '../../../models/SelectedDoctorMedicationModel.dart';
import '../../../routes/app_pages.dart';
import '../../home/model/patient_list_model.dart';
import '../../visit_main/views/delete_image_dialog.dart';
import '../../visit_main/views/view_attchment_image.dart';
import '../controllers/add_patient_controller.dart';

class AddPatientView extends GetView<AddPatientController> {
  AddPatientView({super.key});

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: removeFocus,
        child: SafeArea(
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                CustomAppBar(drawerkey: _key),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Container(
                      color: AppColors.ScreenBackGround,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(() {
                              return BreadcrumbWidget(
                                breadcrumbHistory: controller.globalController.breadcrumbHistory.value,
                                onBack: (breadcrumb) {
                                  controller.globalController.popUntilRoute(breadcrumb);
                                  while (Get.currentRoute != controller.globalController.getKeyByValue(breadcrumb)) {
                                    Get.back(); // Pop the current screen
                                  }
                                },
                              );
                            }),
                            const SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              // padding: EdgeInsets.all(Dimen.margin16),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: AppColors.white),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () {},
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Get.back();
                                          },
                                          child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20), color: AppColors.clear, child: SvgPicture.asset(ImagePath.arrowLeft, fit: BoxFit.cover, width: Dimen.margin30, height: Dimen.margin30)),
                                        ),
                                        Text(Get.currentRoute == Routes.ADD_PATIENT ? "Add Patient Details" : "Schedule Visit", style: AppFonts.regular(18, AppColors.textBlack)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Obx(() {
                                      return Serachfiledtypeahed<PatientListData>(
                                        suggestionsCallback: (search) async {
                                          if (search.isNotEmpty) {
                                            return await controller.getPatientList(searchValue: search);
                                          }

                                          return [];
                                        },
                                        suggestionsController: controller.suggestionsController,

                                        controller: controller.searchController,

                                        valueAsString: (value) => value?.firstName ?? "",
                                        items: controller.patientList,
                                        selectedValue: controller.searchText.value,

                                        isSearchable: true,

                                        itemBuilder: (model) {
                                          return Container(
                                            padding: const EdgeInsets.symmetric(vertical: 5),
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
                                  ),
                                  const SizedBox(height: 16),
                                  Obx(() {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: PopupMenuButton<String>(
                                        offset: const Offset(0, 8),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                        color: AppColors.white,
                                        position: PopupMenuPosition.under,
                                        padding: EdgeInsetsDirectional.zero,
                                        menuPadding: EdgeInsetsDirectional.zero,
                                        onSelected: (value) {},
                                        style: const ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsetsDirectional.zero), tapTargetSize: MaterialTapTargetSize.shrinkWrap, maximumSize: WidgetStatePropertyAll(Size.zero), visualDensity: VisualDensity(horizontal: 0, vertical: 0)),
                                        itemBuilder:
                                            (context) => [
                                              PopupMenuItem(
                                                padding: EdgeInsets.zero,
                                                onTap: () {
                                                  controller.pickProfileImage();
                                                },
                                                child: Padding(padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10), child: Row(children: [const Icon(Icons.file_copy_sharp, color: AppColors.textDarkGrey), const SizedBox(width: 10), Text("Pick From Files", style: AppFonts.regular(16, AppColors.textBlack))])),
                                              ),
                                              PopupMenuItem(
                                                // value: "",
                                                padding: EdgeInsets.zero,
                                                onTap: () async {
                                                  controller.captureProfileImage();
                                                },
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(width: double.infinity, height: 1, color: AppColors.appbarBorder),
                                                    Padding(padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10), child: Row(children: [const Icon(CupertinoIcons.camera), const SizedBox(width: 10), Text("Take A Photo", style: AppFonts.regular(16, AppColors.textBlack))])),
                                                  ],
                                                ),
                                              ),
                                            ],
                                        child: Row(children: [controller.profileImage.value?.path != null ? RoundedImageFileWidget(imagePath: controller.profileImage.value) : const BaseImageView(imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ4YreOWfDX3kK-QLAbAL4ufCPc84ol2MA8Xg&s", width: 50, height: 50)]),
                                      ),
                                    );
                                  }),
                                  const SizedBox(height: Dimen.margin16),
                                  Padding(padding: const EdgeInsets.symmetric(horizontal: Dimen.margin16), child: Row(children: [Text("Basic Detail", style: AppFonts.medium(14, AppColors.textPurple))])),
                                  const SizedBox(height: Dimen.margin16),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: Dimen.margin16),
                                    child: Obx(() {
                                      return Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        spacing: 10,
                                        children: [
                                          Expanded(
                                            child: Obx(() {
                                              return TextFormFiledWidget(
                                                label: "Patient Id ",
                                                isValid: !controller.isValid.value,
                                                isSuffixIconVisible: false,
                                                readOnly: true,
                                                isFirst: true,
                                                controller: controller.patientId,
                                                hint: "123",
                                                onTap: () {
                                                  controller.patientId.clear();
                                                },
                                                suffixIcon: const Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                                              );
                                            }),
                                          ),
                                          // SizedBox(width: Dimen.margin10),
                                          if (!controller.isOldPatient.value)
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(children: [Text("Patient Type", style: AppFonts.regular(14, AppColors.textBlack))]),
                                                  const SizedBox(height: 8),
                                                  Obx(() {
                                                    return BaseDropdown2<String>(
                                                      controller: TextEditingController(),
                                                      valueAsString: (value) => value ?? "",
                                                      items: controller.patientType,
                                                      selectedValue: controller.selectedPatientTypeValue.value,
                                                      onChanged: (value) {
                                                        if (value == "New Patient") {
                                                          controller.isExistingPatient.value = false;
                                                        } else {
                                                          controller.isExistingPatient.value = true;
                                                        }
                                                        controller.selectedPatientTypeValue.value = value;
                                                      },
                                                      selectText: "New Pat",
                                                    );
                                                  }),
                                                ],
                                              ),
                                            ),
                                          if (controller.isOldPatient.value) const Spacer(),
                                          // SizedBox(width: Dimen.margin10),
                                          const Spacer(),
                                        ],
                                      );
                                    }),
                                  ),
                                  const SizedBox(height: Dimen.margin16),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: Dimen.margin16),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      spacing: 10,
                                      children: [
                                        Obx(() {
                                          return Expanded(
                                            child: TextFormFiledWidget(
                                              label: "First Name",
                                              // isImportant: true,
                                              isValid: controller.isValid.value,
                                              format: [CustomTextInputFormatter()],
                                              controller: controller.firstNameController,
                                              hint: "",
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
                                          );
                                        }),
                                        Expanded(
                                          child: Obx(() {
                                            return TextFormFiledWidget(
                                              isValid: !controller.isValid.value,
                                              isSuffixIconVisible: false,
                                              isFirst: true,
                                              format: [CustomTextInputFormatter()],
                                              label: "Middle Name",
                                              controller: controller.middleNameController,
                                              hint: "",
                                              onTap: () {
                                                controller.middleNameController.clear();
                                              },
                                              suffixIcon: const Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                                            );
                                          }),
                                        ),
                                        Expanded(
                                          child: Obx(() {
                                            return TextFormFiledWidget(
                                              format: [CustomTextInputFormatter()],
                                              label: "Last Name",
                                              isValid: controller.isValid.value,
                                              // isImportant: true,
                                              controller: controller.lastNameController,
                                              isSuffixIconVisible: false,
                                              isFirst: true,
                                              hint: "",
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
                                  ),
                                  const SizedBox(height: Dimen.margin16),
                                  const Padding(padding: EdgeInsets.symmetric(horizontal: Dimen.margin16), child: Divider(color: AppColors.backgroundLightGrey, thickness: 1.0)),
                                  Padding(padding: const EdgeInsets.symmetric(horizontal: Dimen.margin16), child: Row(children: [Text("Personal Information", style: AppFonts.medium(14, AppColors.textPurple))])),
                                  const SizedBox(height: Dimen.margin16),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: Dimen.margin16),
                                    child: Row(
                                      spacing: 10,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // SizedBox(width: Dimen.margin10),
                                        Expanded(
                                          child: Obx(() {
                                            return TextFormFiledWidget(
                                              isValid: !controller.isValid.value,
                                              checkValidation: (value) {
                                                return Validation.birthDateValidation(value);
                                              },
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
                                        const Spacer(),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: Dimen.margin16),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: Dimen.margin16),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      spacing: 10,
                                      children: [
                                        Expanded(
                                          child: TextFormFiledWidget(
                                            isValid: !controller.isValid.value,
                                            format: [MaskTextInputFormatter(mask: "+1 (###) ###-####")],
                                            label: "Contact Number",
                                            controller: controller.contactNumberController,
                                            // isValid: true,
                                            isSuffixIconVisible: false,
                                            // prefixIcon: Icon(Icons.flag),
                                            isFirst: true,
                                            type: TextInputType.number,
                                            hint: "123456789",
                                            onTap: () {
                                              controller.contactNumberController.clear();
                                            },
                                            suffixIcon: const Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                                            checkValidation: (value) {
                                              return Validation.phoneValidate(value, isRequired: false);
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: Obx(() {
                                            return TextFormFiledWidget(
                                              format: [NoSpaceLowercaseTextFormatter()],
                                              label: "Email Address",
                                              controller: controller.emailAddressController,
                                              isValid: !controller.isValid.value,
                                              isSuffixIconVisible: false,
                                              isFirst: true,
                                              hint: "donjones@example.com",
                                              onTap: () {
                                                controller.emailAddressController.clear();
                                              },
                                              suffixIcon: const Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                                              checkValidation: (value) {
                                                return Validation.emailValidate(value);
                                              },
                                            );
                                          }),
                                        ),

                                        const Spacer(),
                                      ],
                                    ),
                                  ),
                                  if (controller.globalController.getEMAOrganizationDetailModel.value?.responseData?.isEmaIntegration == false) ...[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: Dimen.margin16),
                                      child: Obx(() {
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: Dimen.margin16),
                                            const SizedBox(height: Dimen.margin16),
                                            if (!controller.isAddPatient.value) const Divider(color: AppColors.backgroundLightGrey, thickness: 1.0),
                                            if (!controller.isAddPatient.value) Row(children: [Text("Appointment Details", style: AppFonts.medium(14, AppColors.textPurple))]),
                                            const SizedBox(height: Dimen.margin16),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              spacing: 10,
                                              children: [
                                                if (!controller.isAddPatient.value) ...[
                                                  Expanded(
                                                    child: TextFormFiledWidget(
                                                      checkValidation: (value) {
                                                        return Validation.visitDateValidation(value);
                                                      },
                                                      format: [DateInputFormatter()],
                                                      suffixIcon: const Icon(Icons.calendar_month),
                                                      label: "Visit Date",

                                                      // isImportant: true,
                                                      controller: controller.visitDateController,
                                                      onTap: () async {
                                                        final picked = await showDatePicker(
                                                          context: context,
                                                          initialDate: DateTime.now(),
                                                          firstDate: DateTime.now(),
                                                          lastDate: DateTime.now().add(const Duration(days: 1000)),
                                                          builder: (context, child) {
                                                            return Theme(data: ThemeData.light().copyWith(cardColor: AppColors.white, primaryColor: AppColors.backgroundPurple, hintColor: AppColors.backgroundPurple, colorScheme: const ColorScheme.light(primary: AppColors.backgroundPurple), buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary)), child: child!);
                                                          },
                                                        );
                                                        if (picked != null) {
                                                          String inputText;
                                                          String padDayMonth(int value) => value.toString().padLeft(2, '0');
                                                          inputText = '${padDayMonth(picked.month)}/${padDayMonth(picked.day)}/${picked.year}';
                                                          controller.visitDateController.text = inputText;
                                                        }
                                                      },
                                                      hint: "mm/dd/yyyy",
                                                    ),
                                                  ),
                                                ],
                                                if (!controller.isAddPatient.value) ...[
                                                  // Expanded(
                                                  //   child: TextFormFiledWidget(
                                                  //     // checkValidation: (value) {
                                                  //     //   return Validation.visitDateValidation(value);
                                                  //     // },
                                                  //     format: [TimeInputFormatter()],
                                                  //     suffixIcon: Icon(Icons.watch_later_outlined),
                                                  //     label: "Visit Time",
                                                  //
                                                  //     // isImportant: true,
                                                  //     controller: controller.selectedVisitTimeValueController,
                                                  //     onTap: () async {
                                                  //
                                                  //
                                                  //
                                                  //       TimeOfDay initial = TimeOfDay.now();
                                                  //       TimeOfDay? picked = await IosTimePickerHelper.showTimePicker(
                                                  //         context: context,
                                                  //         initialTime: initial,
                                                  //       );
                                                  //       if (picked != null) {
                                                  //         print('User picked time: ${picked.format(context)}');
                                                  //
                                                  //         controller.selectedVisitTimeValueController.text = picked.format(context);
                                                  //
                                                  //         // Do something with picked time
                                                  //       }
                                                  //     },
                                                  //     hint: "Select Visit Time",
                                                  //   ),
                                                  // ),
                                                  Expanded(child: TimePickerFormField(controller: controller.selectedVisitTimeValueController, onTimePicked: (pickedTime) {})),
                                                ],
                                                if (!controller.isAddPatient.value)
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        Row(children: [Text("Doctor Name", style: AppFonts.regular(14, AppColors.textBlack))]),
                                                        const SizedBox(height: 8),
                                                        Obx(() {
                                                          return BaseDropdown2<SelectedDoctorModel>(
                                                            isRequired: true,
                                                            direction: VerticalDirection.up,
                                                            controller: TextEditingController(),
                                                            scrollController: scrollController,
                                                            valueAsString: (p) => p?.name ?? "",
                                                            items: controller.globalController.selectedDoctorModel.toList(),

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

                                                if (controller.isAddPatient.value) ...[const Spacer()],
                                                if (controller.isAddPatient.value) ...[const Spacer()],
                                              ],
                                            ),
                                          ],
                                        );
                                      }),
                                    ),
                                    const SizedBox(height: Dimen.margin16),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: Dimen.margin16),
                                      child: Obx(() {
                                        return Row(
                                          spacing: 10,
                                          children: [
                                            if (!controller.isAddPatient.value)
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Row(children: [Text("Medical Assistant", style: AppFonts.regular(14, AppColors.textBlack))]),
                                                    const SizedBox(height: 8),
                                                    Obx(() {
                                                      return BaseDropdown2<SelectedDoctorModel>(
                                                        controller: TextEditingController(),
                                                        direction: VerticalDirection.up,
                                                        valueAsString: (p) => p?.name ?? "",
                                                        items: controller.globalController.selectedMedicalModel.toList(),
                                                        scrollController: scrollController,
                                                        selectedValue: controller.selectedMedicalValueModel.value,

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
                                                          controller.selectedMedicalValueModel.value = model;

                                                          controller.selectedMedicalValue.value = model?.name ?? "";

                                                          controller.selectedMedicalValueModel.refresh();
                                                          controller.selectedMedicalValue.refresh();
                                                        },

                                                        selectText: controller.selectedMedicalValue.value,
                                                        isSearchable: true,
                                                      );
                                                    }),
                                                  ],
                                                ),
                                              ),
                                            const Spacer(),
                                            const Spacer(),
                                          ],
                                        );
                                      }),
                                    ),
                                    const SizedBox(height: Dimen.margin16),
                                  ],
                                  Obx(() {
                                    return Column(
                                      children: [
                                        if (!controller.isOldPatient.value) ...[
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: Dimen.margin16),
                                            child: Container(
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(width: 0.5, color: AppColors.appbarBorder)),
                                              child: Padding(
                                                padding: const EdgeInsets.only(bottom: 0),
                                                child: Theme(
                                                  data: ThemeData(
                                                    splashColor: Colors.transparent,
                                                    // Remove splash color
                                                    highlightColor: Colors.transparent, // Remove highlight color
                                                  ),
                                                  child: ExpansionTile(
                                                    initiallyExpanded: true,
                                                    shape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                                                    backgroundColor: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                                    collapsedShape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                                                    collapsedBackgroundColor: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                                    title: Row(children: [const SizedBox(width: 10), Text(textAlign: TextAlign.center, "Attachments", style: AppFonts.medium(16, AppColors.textBlack))]),
                                                    children: <Widget>[
                                                      Obx(() {
                                                        return Container(
                                                          color: Colors.white,
                                                          child:
                                                              controller.selectedList.isNotEmpty
                                                                  ? Padding(
                                                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                                    child: SizedBox(
                                                                      height: 200,
                                                                      width: double.infinity,
                                                                      child: Obx(() {
                                                                        return ListView.separated(
                                                                          scrollDirection: Axis.horizontal,
                                                                          padding: const EdgeInsets.only(top: 20),
                                                                          itemBuilder: (context, index) {
                                                                            return SizedBox(
                                                                              height: 200,
                                                                              width: 140,
                                                                              child: Column(
                                                                                children: [
                                                                                  const SizedBox(height: 10),
                                                                                  Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    children: [
                                                                                      Stack(
                                                                                        clipBehavior: Clip.none,
                                                                                        alignment: Alignment.topRight,
                                                                                        children: [
                                                                                          Container(
                                                                                            decoration: BoxDecoration(color: AppColors.appbarBorder, borderRadius: BorderRadius.circular(10)),
                                                                                            width: 120,
                                                                                            height: 120,
                                                                                            child: GestureDetector(
                                                                                              onTap: () {},
                                                                                              child: GestureDetector(
                                                                                                onTap: () {
                                                                                                  FileOpener.openDocument(controller.selectedList[index].file?.path ?? "");
                                                                                                },
                                                                                                child: ClipRRect(
                                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                                  // Set the radius here
                                                                                                  child: controller.getFileExtension(controller.selectedList[index].file?.path ?? "") == "image" ? Image.file(controller.selectedList[index].file!, fit: BoxFit.cover) : Image.asset(ImagePath.file_placeHolder), // Display a placeholder if the file is not an image
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Positioned(
                                                                                            top: -10,
                                                                                            // Align at the top of the first container
                                                                                            right: -10,
                                                                                            child: Container(
                                                                                              width: 40,
                                                                                              height: 40,
                                                                                              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 2.2, offset: const Offset(0.2, 0))]),
                                                                                              child: GestureDetector(
                                                                                                onTap: () {
                                                                                                  showDialog(
                                                                                                    context: context,
                                                                                                    barrierDismissible: true,
                                                                                                    builder: (BuildContext context) {
                                                                                                      return DeleteImageDialog(
                                                                                                        onDelete: () {
                                                                                                          controller.deleteAttachments(index);
                                                                                                        },
                                                                                                        extension: controller.getFileExtension(controller.selectedList[index].file?.path ?? ""),
                                                                                                      );
                                                                                                    },
                                                                                                  );
                                                                                                },
                                                                                                child: SvgPicture.asset(ImagePath.delete_black),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      const SizedBox(height: 6),
                                                                                      Text(controller.selectedList[index].fileName ?? "", style: AppFonts.regular(12, AppColors.textDarkGrey)),
                                                                                      const SizedBox(height: 6),
                                                                                      Text(controller.selectedList[index].date ?? "", style: AppFonts.regular(12, AppColors.textDarkGrey)),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            );
                                                                          },
                                                                          separatorBuilder: (context, index) => const SizedBox(width: Dimen.margin15),
                                                                          itemCount: controller.selectedList.length,
                                                                        );
                                                                      }),
                                                                    ),
                                                                  )
                                                                  : const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: SizedBox(width: double.infinity, height: 200, child: Center(child: Text("Attachments Not available")))),
                                                        );
                                                      }),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ] else ...[
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: Dimen.margin16),
                                            child: Container(
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(width: 0.5, color: AppColors.appbarBorder)),

                                              child: Theme(
                                                data: ThemeData(
                                                  splashColor: Colors.transparent,
                                                  // Remove splash color
                                                  highlightColor: Colors.transparent, // Remove highlight color
                                                ),
                                                child: ExpansionTile(
                                                  initiallyExpanded: true,
                                                  shape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                                                  backgroundColor: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                                  collapsedShape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                                                  collapsedBackgroundColor: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                                  title: Row(children: [const SizedBox(width: 10), Text(textAlign: TextAlign.center, "Attachments", style: AppFonts.medium(16, AppColors.textBlack))]),
                                                  children: <Widget>[
                                                    Obx(() {
                                                      return Container(
                                                        color: Colors.white,
                                                        child:
                                                            controller.patientAttachmentList.isNotEmpty
                                                                ? Padding(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                                  child: SizedBox(
                                                                    height: 200,
                                                                    width: double.infinity,
                                                                    child: Obx(() {
                                                                      customPrint("Obx called-----------------");
                                                                      return ListView.separated(
                                                                        scrollDirection: Axis.horizontal,
                                                                        padding: const EdgeInsets.only(top: 20),
                                                                        itemBuilder: (context, index) {
                                                                          return SizedBox(
                                                                            height: 200,
                                                                            width: 140,
                                                                            child: Column(
                                                                              children: [
                                                                                const SizedBox(height: 10),
                                                                                Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  children: [
                                                                                    Stack(
                                                                                      clipBehavior: Clip.none,
                                                                                      alignment: Alignment.topRight,
                                                                                      children: [
                                                                                        Container(
                                                                                          decoration: BoxDecoration(color: AppColors.appbarBorder, borderRadius: BorderRadius.circular(10)),
                                                                                          width: 120,
                                                                                          height: 120,
                                                                                          child: GestureDetector(
                                                                                            onTap: () {
                                                                                              customPrint(controller.patientAttachmentList[index].fileType?.contains("image"));

                                                                                              final dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 10), receiveTimeout: const Duration(seconds: 10)));

                                                                                              if (controller.patientAttachmentList[index].fileType?.contains("image") ?? false) {
                                                                                                showDialog(
                                                                                                  context: context,
                                                                                                  barrierDismissible: true,
                                                                                                  // Allows dismissing the dialog by tapping outside
                                                                                                  builder: (BuildContext context) {
                                                                                                    return ViewAttachmentImage(imageUrl: controller.patientAttachmentList[index].filePath ?? "", attachmentUrl: '');

                                                                                                    // return ViewAttchmentImage(imageUrl: controller.patientAttachmentList[index].filePath ?? "", attchmentUrl: '');
                                                                                                  },
                                                                                                );
                                                                                              } else {
                                                                                                Uri attchmentUri = Uri.parse(controller.patientAttachmentList[index].filePath ?? "");
                                                                                                customPrint("attchmentUri is :- $attchmentUri");
                                                                                                controller.launchInAppWithBrowserOptions(attchmentUri);
                                                                                              }
                                                                                            },
                                                                                            child: ClipRRect(
                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                              // Set the radius here
                                                                                              child: CachedNetworkImage(
                                                                                                imageUrl: controller.patientAttachmentList[index].filePath ?? "",
                                                                                                width: 120,
                                                                                                height: 120,
                                                                                                errorWidget: (context, url, error) {
                                                                                                  return Image.asset(ImagePath.file_placeHolder);
                                                                                                },
                                                                                                fit: BoxFit.cover,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        Positioned(
                                                                                          top: -10,
                                                                                          // Align at the top of the first container
                                                                                          right: -10,
                                                                                          child: Container(
                                                                                            width: 40,
                                                                                            height: 40,
                                                                                            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 2.2, offset: const Offset(0.2, 0))]),
                                                                                            child: GestureDetector(
                                                                                              onTap: () {
                                                                                                showDialog(
                                                                                                  context: context,
                                                                                                  barrierDismissible: true,
                                                                                                  builder: (BuildContext context) {
                                                                                                    // return SizedBox();
                                                                                                    return DeleteImageDialog(
                                                                                                      onDelete: () {
                                                                                                        controller.deleteAttachmentsOldPatient(controller.patientAttachmentList[index].id ?? 0);
                                                                                                      },
                                                                                                      extension: controller.patientAttachmentList[index].fileType,
                                                                                                    );
                                                                                                  },
                                                                                                );
                                                                                              },
                                                                                              child: SvgPicture.asset(ImagePath.delete_black),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    const SizedBox(height: 6),
                                                                                    Text(maxLines: 1, controller.patientAttachmentList[index].fileName ?? "", style: AppFonts.regular(12, AppColors.textDarkGrey)),
                                                                                    const SizedBox(height: 6),
                                                                                    Text(DateFormat('MM/dd/yyyy').format(DateTime.parse(controller.patientAttachmentList[index].createdAt ?? "").toLocal()), style: AppFonts.regular(12, AppColors.textDarkGrey)),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          );
                                                                        },
                                                                        separatorBuilder: (context, index) => const SizedBox(width: Dimen.margin15),
                                                                        itemCount: controller.patientAttachmentList.length,
                                                                      );
                                                                    }),
                                                                  ),
                                                                )
                                                                : const SizedBox(width: double.infinity, height: 200, child: Center(child: Text("Attachments Not available"))),
                                                      );
                                                    }),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    );
                                  }),
                                  const SizedBox(height: Dimen.margin20),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: Dimen.margin16),
                                    child: Obx(() {
                                      return Row(
                                        children: [
                                          if (!controller.isOldPatient.value)
                                            ContainerButton(
                                              onPressed: () {
                                                controller.list.clear();
                                                controller.list.addAll(controller.selectedList);

                                                controller.showCustomDialog(context);
                                              },
                                              text: 'Add Attachments',

                                              borderColor: AppColors.backgroundPurple,
                                              // Custom border color
                                              backgroundColor: Colors.white,
                                              // Custom background color
                                              needBorder: true,
                                              // Show border
                                              textColor: AppColors.backgroundPurple,
                                              // Custom text color
                                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                              // Custom padding
                                              radius: 6, // Custom border radius
                                            ),
                                          if (controller.isOldPatient.value)
                                            ContainerButton(
                                              onPressed: () {
                                                controller.listOldPatient.clear();

                                                controller.showCustomDialogOldPatient(context);
                                              },
                                              text: 'Add Attachments',

                                              borderColor: AppColors.backgroundPurple,
                                              // Custom border color
                                              backgroundColor: Colors.white,
                                              // Custom background color
                                              needBorder: true,
                                              // Show border
                                              textColor: AppColors.backgroundPurple,
                                              // Custom text color
                                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                              // Custom padding
                                              radius: 6, // Custom border radius
                                            ),

                                          const Spacer(),
                                          GestureDetector(
                                            onTap: () {
                                              controller.clearForm();
                                            },
                                            child: Text("Clear Form", style: AppFonts.medium(14, AppColors.textDarkGrey)),
                                          ),
                                          const SizedBox(width: Dimen.margin8),
                                          ContainerButton(
                                            onPressed: () {
                                              // Your onPressed function

                                              Get.back();
                                            },
                                            text: ' Cancel ',

                                            borderColor: AppColors.backgroundPurple,
                                            // Custom border color
                                            backgroundColor: Colors.white,
                                            // Custom background color
                                            needBorder: true,
                                            // Show border
                                            textColor: AppColors.backgroundPurple,
                                            // Custom text color
                                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                            // Custom padding
                                            radius: 6, // Custom border radius
                                          ),
                                          const SizedBox(width: Dimen.margin8),
                                          ContainerButton(
                                            onPressed: () {
                                              // Your onPressed function

                                              controller.isSaveAddAnother.value = true;

                                              if (controller.formKey.currentState!.validate()) {
                                                String date = controller.visitDateController.text;
                                                String? time = controller.selectedVisitTimeValueController.text;

                                                if ((date.isEmpty && time.isNotEmpty)) {
                                                  CustomToastification().showToast("Please select date", type: ToastificationType.error);
                                                } else if ((date.isNotEmpty && time.isEmpty)) {
                                                  CustomToastification().showToast("Please select time", type: ToastificationType.error);
                                                } else {
                                                  try {
                                                    if (time.isNotEmpty) {
                                                      DateTime firstTime = DateFormat('hh:mm a').parse(time).toUtc(); // 10:30 AM to DateTime
                                                    }
                                                    if (!controller.isOldPatient.value) {
                                                      controller.addPatient();
                                                    } else {
                                                      controller.editPatient();
                                                    }
                                                  } catch (e) {
                                                    CustomToastification().showToast("Please enter valid time format", type: ToastificationType.error);
                                                  }
                                                }
                                              }
                                            },
                                            text: ' Save and Add Another ',

                                            borderColor: AppColors.backgroundPurple,
                                            // Custom border color
                                            backgroundColor: AppColors.backgroundPurple,
                                            // Custom background color
                                            needBorder: false,
                                            // Show border
                                            textColor: AppColors.white,
                                            // Custom text color
                                            padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 12),
                                            // Custom padding
                                            radius: 6, // Custom border radius
                                          ),
                                          const SizedBox(width: Dimen.margin8),
                                          GestureDetector(
                                            onTap: () {
                                              controller.isSaveAddAnother.value = false;

                                              String date = controller.visitDateController.text;
                                              String? time = controller.selectedVisitTimeValueController.text;

                                              if (controller.formKey.currentState!.validate()) {
                                                if ((date.isEmpty && time.isNotEmpty)) {
                                                  CustomToastification().showToast("Please select date", type: ToastificationType.error);
                                                } else if ((date.isNotEmpty && time.isEmpty)) {
                                                  CustomToastification().showToast("Please select time", type: ToastificationType.error);
                                                } else {
                                                  try {
                                                    if (time.isNotEmpty) {
                                                      DateTime firstTime = DateFormat('hh:mm a').parse(time).toUtc(); // 10:30 AM to DateTime
                                                    }

                                                    if (!controller.isOldPatient.value) {
                                                      controller.addPatient();
                                                    } else {
                                                      controller.editPatient();
                                                    }
                                                  } catch (e) {
                                                    CustomToastification().showToast("Please enter valid time format", type: ToastificationType.error);
                                                  }
                                                }
                                              }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(color: AppColors.backgroundPurple, borderRadius: BorderRadius.circular(6)),
                                              // width: 70,
                                              height: 40,
                                              child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Row(children: [Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Text("Save", style: AppFonts.medium(14, Colors.white)))])),
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                  ),
                                  const SizedBox(height: 15),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      globalKey: _key,
    );
  }
}

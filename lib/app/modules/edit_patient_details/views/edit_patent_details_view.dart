import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:subqdocs/widget/appbar.dart';
import 'package:subqdocs/widgets/base_screen.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_diamentions.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../../../../utils/no_space_lowercase.dart';
import '../../../../utils/validation_service.dart';
import '../../../../widget/base_image_view.dart';
import '../../../../widget/bredcums.dart';
import '../../../../widget/fileImage.dart';
import '../../../../widgets/ContainerButton.dart';
import '../../../../widgets/base_dropdown.dart';
import '../../../../widgets/custom_textfiled.dart';
import '../../../core/common/common_service.dart';
import '../../../routes/app_pages.dart';
import '../controllers/edit_patent_details_controller.dart';

class EditPatentDetailsView extends GetView<EditPatentDetailsController> {
  EditPatentDetailsView({super.key});

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      onItemSelected: (index) async {
        if (index == 0) {
          final _ = await Get.toNamed(Routes.ADD_PATIENT);

          _key.currentState!.closeDrawer();
        } else if (index == 1) {
          Get.toNamed(Routes.HOME, arguments: {"tabIndex": 1});

          _key.currentState!.closeDrawer();
        } else if (index == 2) {
          Get.toNamed(Routes.HOME, arguments: {"tabIndex": 2});
          _key.currentState!.closeDrawer();
        } else if (index == 3) {
          Get.toNamed(Routes.HOME, arguments: {"tabIndex": 0});
          _key.currentState!.closeDrawer();
        } else if (index == 4) {
          _key.currentState!.closeDrawer();
          final _ = await Get.toNamed(Routes.PERSONAL_SETTING);
        }
      },
      body: GestureDetector(
        onTap: removeFocus,
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomAppBar(drawerkey: _key),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      color: AppColors.ScreenBackGround,
                      child: Padding(
                        padding: const EdgeInsets.only(top: Dimen.margin20, right: Dimen.margin16, left: Dimen.margin16),
                        child: ListView(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.zero,
                          children: [
                            // SizedBox(height: 10),
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
                              padding: const EdgeInsets.all(Dimen.margin16),
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
                                        child: SvgPicture.asset(ImagePath.arrowLeft, fit: BoxFit.cover, width: Dimen.margin24, height: Dimen.margin24),
                                      ),
                                      const SizedBox(width: Dimen.margin8),
                                      Text("Patient Details", style: AppFonts.regular(18, AppColors.textBlack)),
                                    ],
                                  ),
                                  const SizedBox(height: Dimen.margin24),
                                  Obx(() {
                                    return Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(100),
                                          child:
                                              controller.profileImageUrl.value != null
                                                  ? CachedNetworkImage(imageUrl: controller.profileImageUrl.value ?? "", width: 60, height: 60, fit: BoxFit.cover)
                                                  : controller.profileImage.value?.path != null
                                                  ? RoundedImageFileWidget(size: 60, imagePath: controller.profileImage.value)
                                                  : BaseImageView(imageUrl: "", width: 60, height: 60, fontSize: 14, nameLetters: "${controller.firstNameController.text} ${controller.lastNameController.text}"),
                                        ),
                                        PopupMenuButton<String>(
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
                                                if ((controller.profileImageUrl.value != null && controller.profileImageUrl.value != "") || controller.profileImage.value != null) ...[
                                                  PopupMenuItem(
                                                    // value: "",
                                                    padding: EdgeInsets.zero,
                                                    onTap: () async {
                                                      controller.profileImageUrl.value = null;
                                                      controller.profileImage.value = null;
                                                      // controller.captureProfileImage();
                                                    },
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Container(width: double.infinity, height: 1, color: AppColors.appbarBorder),
                                                        Padding(padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10), child: Row(children: [const Icon(CupertinoIcons.camera), const SizedBox(width: 10), Text("Remove photo", style: AppFonts.regular(16, AppColors.textBlack))])),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ],
                                          child: Row(children: [const SizedBox(width: 12.5), SvgPicture.asset(ImagePath.edit, width: 26, height: 26, fit: BoxFit.cover), const SizedBox(width: 8), Text("Edit Profile Image", style: AppFonts.regular(14, AppColors.textDarkGrey))]),
                                        ),
                                      ],
                                    );
                                  }),
                                  const SizedBox(height: Dimen.margin16),
                                  const SizedBox(height: Dimen.margin16),
                                  Row(children: [Text("Basic Detail", style: AppFonts.medium(14, AppColors.textPurple))]),
                                  const SizedBox(height: Dimen.margin16),
                                  // Row(
                                  //   children: [
                                  //     Expanded(
                                  //       child: TextFormFiledWidget(
                                  //         label: "Patient Id ",
                                  //         type: TextInputType.number,
                                  //         readOnly: true,
                                  //         isValid: true,
                                  //         isSuffixIconVisible: false,
                                  //         isFirst: true,
                                  //         format: [
                                  //           FilteringTextInputFormatter.allow(
                                  //             RegExp(r'[a-zA-Z0-9]'),
                                  //           ),
                                  //           LengthLimitingTextInputFormatter(
                                  //             15,
                                  //           ),
                                  //         ],
                                  //         controller:
                                  //             controller.patientIdController,
                                  //         hint: "123",
                                  //         onTap: () {
                                  //           controller.patientIdController
                                  //               .clear();
                                  //         },
                                  //         suffixIcon: const Icon(
                                  //           Icons.highlight_remove,
                                  //           color: AppColors.textDarkGrey,
                                  //           size: 25,
                                  //         ),
                                  //         checkValidation: (value) {
                                  //           return Validation.requiredFiled(
                                  //             value,
                                  //           );
                                  //         },
                                  //       ),
                                  //     ),
                                  //     const SizedBox(width: Dimen.margin10),
                                  //     const Spacer(),
                                  //     const SizedBox(width: Dimen.margin10),
                                  //     const Spacer(),
                                  //
                                  //     const SizedBox(width: Dimen.margin10),
                                  //   ],
                                  // ),
                                  const SizedBox(height: Dimen.margin16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormFiledWidget(
                                          label: "First Name",
                                          isSuffixIconVisible: false,
                                          isFirst: true,
                                          format: [CustomTextInputFormatter()],
                                          // isImportant: true,
                                          isValid: true,
                                          controller: controller.firstNameController,
                                          hint: "",
                                          onTap: () {
                                            controller.firstNameController.clear();
                                          },
                                          suffixIcon: const Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                                          checkValidation: (value) {
                                            return Validation.requiredFiled(value);
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: Dimen.margin10),
                                      Expanded(
                                        child: TextFormFiledWidget(
                                          isSuffixIconVisible: false,
                                          isFirst: true,
                                          label: "Middle Name",
                                          format: [CustomTextInputFormatter()],
                                          onTap: () {
                                            controller.middleNameController.clear();
                                          },
                                          suffixIcon: const Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                                          controller: controller.middleNameController,
                                          hint: "",
                                        ),
                                      ),
                                      const SizedBox(width: Dimen.margin10),
                                      Expanded(
                                        child: TextFormFiledWidget(
                                          label: "Last Name",
                                          format: [CustomTextInputFormatter()],
                                          isValid: true,
                                          isSuffixIconVisible: false,
                                          isFirst: true,
                                          // isImportant: true,
                                          controller: controller.lastNameController,
                                          onTap: () {
                                            controller.lastNameController.clear();
                                          },
                                          suffixIcon: const Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                                          hint: "",
                                          checkValidation: (value) {
                                            return Validation.requiredFiled(value);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: Dimen.margin16),
                                  const SizedBox(height: Dimen.margin16),
                                  const Divider(color: AppColors.backgroundLightGrey, thickness: 1.0),
                                  Row(children: [Text("Personal Information", style: AppFonts.medium(14, AppColors.textPurple))]),
                                  const SizedBox(height: Dimen.margin16),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: TextFormFiledWidget(
                                          // checkValidation: (value) {
                                          //   return Validation.birthDateValidation(value, isRequired: true);
                                          // },
                                          suffixIcon: const Icon(Icons.calendar_month),

                                          label: "Date of birth",
                                          format: [DateInputFormatter()],
                                          // isValid: true,

                                          // isImportant: true,
                                          controller: controller.dobController,
                                          onTap: () async {
                                            final picked = await showDatePicker(
                                              context: context,
                                              initialDate: controller.selectedDOBDate.value ?? DateTime.now().subtract(const Duration(days: 400)),
                                              firstDate: DateTime.now().subtract(const Duration(days: 36700)),
                                              lastDate: DateTime.now().subtract(const Duration(days: 400)),
                                              builder: (context, child) {
                                                return Theme(data: ThemeData.light().copyWith(cardColor: AppColors.white, primaryColor: AppColors.backgroundPurple, hintColor: AppColors.backgroundPurple, colorScheme: const ColorScheme.light(primary: AppColors.backgroundPurple), buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary)), child: child!);
                                              },
                                            );
                                            if (picked != null) {
                                              String inputText;

                                              controller.selectedDOBDate.value = picked;
                                              String padDayMonth(int value) => value.toString().padLeft(2, '0');
                                              inputText = '${padDayMonth(picked.month)}/${padDayMonth(picked.day)}/${picked.year}';
                                              controller.dobController.text = inputText;
                                            }
                                          },
                                          hint: "mm/dd/yyyy",
                                        ),
                                      ),
                                      const SizedBox(width: Dimen.margin10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Sex", style: AppFonts.regular(14, AppColors.textBlack)),
                                            const SizedBox(height: 8),
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
                                            }),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: Dimen.margin10),
                                      Expanded(
                                        child: TextFormFiledWidget(
                                          isSuffixIconVisible: false,
                                          // isValid: true,
                                          isFirst: true,
                                          format: [NoSpaceLowercaseTextFormatter()],
                                          label: "Email Address",
                                          controller: controller.emailAddressController,
                                          hint: "donjones@example.com",
                                          onTap: () {
                                            controller.emailAddressController.clear();
                                          },
                                          suffixIcon: const Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                                          // checkValidation: (value) {
                                          //   return Validation.emailValidateRequired(value);
                                          // },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: Dimen.margin16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormFiledWidget(
                                          format: [MaskTextInputFormatter(mask: "+1 (###) ###-####")],
                                          label: "Contact Number",
                                          controller: controller.contactNumberController,
                                          // isValid: true,
                                          isSuffixIconVisible: false,
                                          isFirst: true,
                                          type: TextInputType.number,
                                          hint: "123456789",
                                          onTap: () {
                                            controller.emailAddressController.clear();
                                          },
                                          suffixIcon: const Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                                          // checkValidation: (value) {
                                          //   return Validation.phoneValidate(value, isRequired: true);
                                          // },
                                        ),
                                      ),
                                      const SizedBox(width: Dimen.margin10),
                                      const Spacer(),
                                      const SizedBox(width: Dimen.margin10),
                                      const Spacer(),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      const Spacer(),
                                      ContainerButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        text: 'Cancel',
                                        borderColor: AppColors.backgroundPurple,
                                        // Custom border color
                                        backgroundColor: AppColors.white,
                                        // Custom background color
                                        needBorder: true,
                                        // Show border
                                        textColor: AppColors.backgroundPurple,
                                        // Custom text color
                                        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 12),
                                        // Custom padding
                                        radius: 6, // Custom border radius
                                      ),
                                      const SizedBox(width: 8),
                                      ContainerButton(
                                        onPressed: () {
                                          if (_formKey.currentState!.validate()) {
                                            controller.addPatient();
                                          }
                                        },
                                        text: 'Save',
                                        borderColor: AppColors.backgroundPurple,
                                        // Custom border colorqq
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
                                    ],
                                  ),
                                  const SizedBox(height: 10),
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

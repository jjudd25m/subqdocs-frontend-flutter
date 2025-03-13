import 'dart:io';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullscreen_image_viewer/fullscreen_image_viewer.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:subqdocs/widget/appbar.dart';
import 'package:subqdocs/widgets/rounded_image_widget.dart';

import '../../../../utils/Formetors.dart';
import 'package:path/path.dart' as p;
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_diamentions.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../../../../utils/no_space_lowercase.dart';
import '../../../../utils/validation_service.dart';
import '../../../../widget/base_image_view.dart';
import '../../../../widget/fileImage.dart';
import '../../../../widgets/ContainerButton.dart';
import '../../../../widgets/base_dropdown.dart';
import '../../../../widgets/base_image_view.dart';
import '../../../core/common/common_service.dart';
import '../../../core/common/logger.dart';
import '../../custom_drawer/views/custom_drawer_view.dart';
import '../../visit_main/views/delete_image_dialog.dart';
import '../widgets/custom_dailog.dart';
import '../../../../widgets/custom_textfiled.dart';
import '../controllers/add_patient_controller.dart';

class AddPatientView extends GetView<AddPatientController> {
  AddPatientView({super.key});

  DateTime fromDate = DateTime.now().subtract(Duration(days: 371));

  void _showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true, // Allows dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return CustomDialogAttachment(); // Our custom dialog
      },
    );
  }

  bool isImage(File file) {
    final imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp'];

    customPrint("file extension is :- ${getFileExtension(file.path)}");
    final fileExtension = file.uri.pathSegments.last.split('.').last.toLowerCase();
    return imageExtensions.contains(fileExtension);
  }

  String getFileExtension(String filePath) {
    // Define image extensions
    final imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp'];

    // Get the file extension
    String extension = p.extension(filePath);

    // Check if the extension is an image type
    if (imageExtensions.contains(extension.toLowerCase())) {
      return 'image'; // Return "image" if it's an image extension
    } else {
      return extension.replaceFirst('.', ''); // Return extension without dot
    }
  }

  TextEditingController _controller = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  void showImagePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pick an Image'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Pick from Camera'),
                onTap: () {
                  Navigator.pop(context);
                  // Add your camera picking logic here
                  customPrint('Camera selected');
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Pick from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  // Add your gallery picking logic here
                  customPrint('Gallery selected');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCupertinoDatePicker(BuildContext context, TextEditingController control) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text(
            "Pick a Date",
            style: AppFonts.medium(16, AppColors.black),
          ),
          actions: <Widget>[
            Container(
              height: 400,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                maximumDate: DateTime.now().subtract(Duration(days: 370)),
                initialDateTime: DateTime.now().subtract(Duration(days: 371)),
                onDateTimeChanged: (DateTime newDate) {
                  fromDate = newDate;

                  // Update the TextField with selected date
                },
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text('Done'),
            onPressed: () {
              String formattedDate = DateFormat('MM/dd/yyyy').format(fromDate);

              // String formattedDate = DateFormat('MM-dd-yyyy').format(DateTime.now());
              control.text = formattedDate;

              // customPrint('${_selectedDate.toLocal()}'.split(' ')[0]);

              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.white,
        drawer: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 5.0,
            sigmaY: 5.0,
          ),
          child: CustomDrawerView(
            onItemSelected: (index) async {
              if (index == 0) {
                _key.currentState!.closeDrawer();
              } else if (index == 1) {
                _key.currentState!.closeDrawer();
                Get.back(result: 1);
              } else if (index == 2) {
                _key.currentState!.closeDrawer();
                Get.back(result: 2);
              } else if (index == 3) {
                _key.currentState!.closeDrawer();
                Get.back(result: 0);
              }
            },
          ),
        ),
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
                    child: Container(
                        color: AppColors.ScreenBackGround,
                        child: Padding(
                          padding: const EdgeInsets.only(top: Dimen.margin20, right: Dimen.margin16, left: Dimen.margin16),
                          child: ListView(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            // physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.zero,
                            children: [
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(Dimen.margin16),
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
                                              Get.back(result: -1);
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
                                            "Add Patient Details",
                                            style: AppFonts.regular(18, AppColors.textBlack),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: Dimen.margin24,
                                    ),
                                    TextFormFiledWidget(
                                      isSuffixIconVisible: false,
                                      isFirst: true,
                                      prefixIcon: SvgPicture.asset(
                                        ImagePath.search,
                                        fit: BoxFit.cover,
                                        width: 10,
                                        height: 10,
                                      ),
                                      onTap: () {
                                        controller.searchController.clear();
                                      },
                                      suffixIcon: Icon(
                                        Icons.highlight_remove,
                                        color: AppColors.textDarkGrey,
                                        size: 25,
                                      ),
                                      controller: controller.searchController,
                                      hint: "Search Patient Name, ID, Date of Birth or Email",
                                      label: '',
                                    ),
                                    SizedBox(
                                      height: Dimen.margin16,
                                    ),
                                    Obx(
                                      () {
                                        return Row(
                                          children: [
                                            controller.profileImage.value?.path != null
                                                ? RoundedImageFileWidget(
                                                    imagePath: controller.profileImage.value,
                                                  )
                                                : BaseImageView(
                                                    imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ4YreOWfDX3kK-QLAbAL4ufCPc84ol2MA8Xg&s",
                                                    width: 50,
                                                    height: 50,
                                                  ),
                                            PopupMenuButton<String>(
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
                                                    onTap: () {
                                                      controller.pickProfileImage();

                                                      // customPrint(" patient id is ${controller.patientList[rowIndex - 1].patientId.toString()}");
                                                    },
                                                    // value: "",
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.file_copy_sharp,
                                                            color: AppColors.textDarkGrey,
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            "Pick From Files",
                                                            style: AppFonts.regular(16, AppColors.textBlack),
                                                          ),
                                                        ],
                                                      ),
                                                    )),
                                                PopupMenuItem(
                                                    // value: "",
                                                    padding: EdgeInsets.zero,
                                                    onTap: () async {
                                                      controller.captureProfileImage();
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
                                                          padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
                                                          child: Row(
                                                            children: [
                                                              Icon(CupertinoIcons.camera),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Text(
                                                                "Take A Photo",
                                                                style: AppFonts.regular(16, AppColors.textBlack),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                              ],
                                              child: Text(
                                                "   + Add Profile Image",
                                                style: AppFonts.regular(14, AppColors.textGrey),
                                              ),
                                            )
                                          ],
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      height: Dimen.margin16,
                                    ),
                                    SizedBox(
                                      height: Dimen.margin16,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextFormFiledWidget(
                                              label: "Patient Id ",

                                              // isImportant: true,

                                              isSuffixIconVisible: false,
                                              isFirst: true,
                                              format: [
                                                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                                              ],
                                              controller: controller.patientId,
                                              hint: "123",
                                              onTap: () {
                                                controller.patientId.clear();
                                              },
                                              suffixIcon: Icon(
                                                Icons.highlight_remove,
                                                color: AppColors.textDarkGrey,
                                                size: 25,
                                              ),
                                              checkValidation: (value) {
                                                return Validation.requiredFiled(value);
                                              }),
                                        ),
                                        SizedBox(
                                          width: Dimen.margin10,
                                        ),
                                        Expanded(
                                          child: TextFormFiledWidget(
                                              label: "First Name",
                                              // isImportant: true,
                                              isValid: controller.isValid.value,
                                              format: [
                                                CustomTextInputFormatter(),
                                              ],
                                              controller: controller.firstNameController,
                                              hint: "Don",
                                              isSuffixIconVisible: false,
                                              isFirst: true,
                                              onTap: () {
                                                controller.firstNameController.clear();
                                              },
                                              suffixIcon: Icon(
                                                Icons.highlight_remove,
                                                color: AppColors.textDarkGrey,
                                                size: 25,
                                              ),
                                              checkValidation: (value) {
                                                return Validation.requiredFiled(value);
                                              }),
                                        ),
                                        SizedBox(
                                          width: Dimen.margin10,
                                        ),
                                        Expanded(
                                          child: TextFormFiledWidget(
                                            isValid: !controller.isValid.value,
                                            isSuffixIconVisible: false,
                                            isFirst: true,
                                            format: [
                                              CustomTextInputFormatter(),
                                            ],
                                            label: "Middle Name",
                                            controller: controller.middleNameController,
                                            hint: "Joseph",
                                            onTap: () {
                                              controller.middleNameController.clear();
                                            },
                                            suffixIcon: Icon(
                                              Icons.highlight_remove,
                                              color: AppColors.textDarkGrey,
                                              size: 25,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: Dimen.margin16,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextFormFiledWidget(
                                              format: [
                                                CustomTextInputFormatter(),
                                              ],
                                              label: "Last Name",
                                              isValid: controller.isValid.value,
                                              // isImportant: true,
                                              controller: controller.lastNameController,
                                              isSuffixIconVisible: false,
                                              isFirst: true,
                                              hint: "Jones",
                                              onTap: () {
                                                controller.lastNameController.clear();
                                              },
                                              suffixIcon: Icon(
                                                Icons.highlight_remove,
                                                color: AppColors.textDarkGrey,
                                                size: 25,
                                              ),
                                              checkValidation: (value) {
                                                return Validation.requiredFiled(value);
                                              }),
                                        ),
                                        SizedBox(
                                          width: Dimen.margin10,
                                        ),
                                        Expanded(
                                          child: TextFormFiledWidget(
                                              suffixIcon: Icon(Icons.calendar_month),
                                              format: [NoSpaceTextFormatter()],
                                              label: "Date of birth",
                                              isValid: true,
                                              readOnly: true,
                                              // isImportant: true,
                                              controller: controller.dobController,
                                              onTap: () async {
                                                final picked = await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now().subtract(Duration(days: 400)),
                                                  firstDate: DateTime.now().subtract(Duration(days: 36700)),
                                                  lastDate: DateTime.now().subtract(Duration(days: 400)),
                                                  builder: (context, child) {
                                                    return Theme(
                                                      data: ThemeData.light().copyWith(
                                                        cardColor: AppColors.white,
                                                        primaryColor: AppColors.backgroundPurple,
                                                        hintColor: AppColors.backgroundPurple,
                                                        colorScheme: ColorScheme.light(primary: AppColors.backgroundPurple),
                                                        buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
                                                      ),
                                                      child: child!,
                                                    );
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
                                              checkValidation: (value) {
                                                return Validation.requiredFiled(value);
                                              }),
                                        ),
                                        SizedBox(
                                          width: Dimen.margin10,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "Sex",
                                                    style: AppFonts.regular(14, AppColors.textBlack),
                                                  ),
                                                  Text(
                                                    "*",
                                                    style: AppFonts.regular(14, AppColors.redText),
                                                  ),
                                                ],
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
                                      ],
                                    ),
                                    SizedBox(
                                      height: Dimen.margin16,
                                    ),
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
                                              suffixIcon: Icon(
                                                Icons.highlight_remove,
                                                color: AppColors.textDarkGrey,
                                                size: 25,
                                              ),
                                              checkValidation: (value) {
                                                return Validation.emailValidateRequired(value);
                                              }),
                                        ),
                                        SizedBox(
                                          width: Dimen.margin10,
                                        ),
                                        Expanded(
                                          child: TextFormFiledWidget(
                                              format: [PlusTextFormatter()],
                                              label: "Contact Number",
                                              controller: controller.contactNumberController,
                                              isValid: true,
                                              isSuffixIconVisible: false,
                                              isFirst: true,
                                              type: TextInputType.number,
                                              hint: "123456789",
                                              onTap: () {
                                                controller.emailAddressController.clear();
                                              },
                                              suffixIcon: Icon(
                                                Icons.highlight_remove,
                                                color: AppColors.textDarkGrey,
                                                size: 25,
                                              ),
                                              checkValidation: (value) {
                                                return Validation.phoneValidate(value);
                                              }),
                                        ),
                                        SizedBox(
                                          width: Dimen.margin10,
                                        ),
                                        Expanded(
                                          child: TextFormFiledWidget(
                                            //format: [NoSpaceTextFormatter()],
                                            suffixIcon: Icon(Icons.calendar_month),
                                            label: "Visit Date",
                                            readOnly: true,
                                            // isImportant: true,
                                            controller: controller.visitDateController,
                                            onTap: () async {
                                              final picked = await showDatePicker(
                                                context: context,

                                                // initialDate:  DateFormat('MM/dd/yy').parse(controller.visitDateController.text),
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime.now().add(Duration(days: 1000)),
                                                builder: (context, child) {
                                                  return Theme(
                                                    data: ThemeData.light().copyWith(
                                                      cardColor: AppColors.white,
                                                      primaryColor: AppColors.backgroundPurple,
                                                      hintColor: AppColors.backgroundPurple,
                                                      colorScheme: ColorScheme.light(primary: AppColors.backgroundPurple),
                                                      buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
                                                    ),
                                                    child: child!,
                                                  );
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
                                    ),
                                    SizedBox(
                                      height: Dimen.margin16,
                                    ),
                                    Row(
                                      children: [
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
                                                    controller.selectedVisitTimeValue.value = value;
                                                  },
                                                  selectText: "11 PM",
                                                );
                                              })
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: Dimen.margin10,
                                        ),
                                        Spacer(),
                                        SizedBox(
                                          width: Dimen.margin10,
                                        ),
                                        Spacer(),
                                      ],
                                    ),
                                    SizedBox(
                                      height: Dimen.margin16,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(1),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(width: 0.5, color: AppColors.appbarBorder),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(1),
                                          child: Theme(
                                            data: ThemeData(
                                              splashColor: Colors.transparent, // Remove splash color
                                              highlightColor: Colors.transparent, // Remove highlight color
                                            ),
                                            child: ExpansionTile(
                                              initiallyExpanded: true,
                                              shape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                                              backgroundColor: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                              collapsedShape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                                              collapsedBackgroundColor: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                              title: Container(
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      textAlign: TextAlign.center,
                                                      "Attachments",
                                                      style: AppFonts.medium(16, AppColors.textBlack),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              children: <Widget>[
                                                Obx(() {
                                                  return Container(
                                                      color: Colors.white,
                                                      child: controller.selectedList.length != 0
                                                          ? Padding(
                                                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                              child: SizedBox(
                                                                  height: 200,
                                                                  width: double.infinity,
                                                                  child: Obx(
                                                                    () {
                                                                      return ListView.separated(
                                                                        scrollDirection: Axis.horizontal,
                                                                        padding: EdgeInsets.only(top: 20),
                                                                        itemBuilder: (context, index) {
                                                                          return Container(
                                                                            height: 200,
                                                                            width: 140,
                                                                            child: Column(
                                                                              children: [
                                                                                SizedBox(height: 10),
                                                                                Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  children: [
                                                                                    Stack(
                                                                                      clipBehavior: Clip.none,
                                                                                      alignment: Alignment.topRight,
                                                                                      children: [
                                                                                        Container(
                                                                                          decoration: BoxDecoration(
                                                                                            color: AppColors.appbarBorder,
                                                                                            borderRadius: BorderRadius.circular(10),
                                                                                          ),
                                                                                          width: 120,
                                                                                          height: 120,
                                                                                          child: GestureDetector(
                                                                                            onTap: () {
                                                                                              // FullscreenImageViewer.open(
                                                                                              //   context: context,
                                                                                              //   child: CachedNetworkImage(imageUrl: controller.selectedList[index].file),
                                                                                              // );
                                                                                            },
                                                                                            child: GestureDetector(
                                                                                              onTap: () {
                                                                                                if (getFileExtension(controller.selectedList[index].file?.path ?? "") == "image") {
                                                                                                  customPrint("1");
                                                                                                  FullscreenImageViewer.open(
                                                                                                    context: context,
                                                                                                    child: Image.file(controller.selectedList[index].file ?? File("")),
                                                                                                  );
                                                                                                } else {
                                                                                                  customPrint("2");
                                                                                                  controller.launchInAppWithBrowserOptions(Uri.file(controller.selectedList[index].file?.path ?? ""));
                                                                                                }
                                                                                              },
                                                                                              child: ClipRRect(
                                                                                                borderRadius: BorderRadius.circular(10), // Set the radius here
                                                                                                child: getFileExtension(controller.selectedList[index].file?.path ?? "") == "image"
                                                                                                    ? Image.file(
                                                                                                        controller.selectedList[index].file!,
                                                                                                        fit: BoxFit.cover,
                                                                                                      )
                                                                                                    : Image.asset(
                                                                                                        ImagePath.file_placeHolder,
                                                                                                      ), // Display a placeholder if the file is not an image
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
                                                                                            decoration: BoxDecoration(
                                                                                              shape: BoxShape.circle,
                                                                                              color: Colors.white,
                                                                                              boxShadow: [
                                                                                                BoxShadow(
                                                                                                  color: Colors.black.withOpacity(0.2),
                                                                                                  blurRadius: 2.2,
                                                                                                  offset: Offset(0.2, 0),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                            child: GestureDetector(
                                                                                              onTap: () {
                                                                                                showDialog(
                                                                                                  context: context,
                                                                                                  barrierDismissible: true,
                                                                                                  builder: (BuildContext context) {
                                                                                                    // return SizedBox();
                                                                                                    return DeleteImageDialog(
                                                                                                      onDelete: () {
                                                                                                        controller.deleteAttachments(index);
                                                                                                      },
                                                                                                      extension: getFileExtension(controller.selectedList[index].file?.path ?? ""),
                                                                                                    );
                                                                                                  },
                                                                                                );
                                                                                              },
                                                                                              child: SvgPicture.asset(
                                                                                                ImagePath.delete_black,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 6,
                                                                                    ),
                                                                                    Text(
                                                                                      controller.selectedList[index].fileName ?? "",
                                                                                      style: AppFonts.regular(12, AppColors.textDarkGrey),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 6,
                                                                                    ),
                                                                                    Text(
                                                                                      controller.selectedList[index].date ?? "",
                                                                                      style: AppFonts.regular(12, AppColors.textDarkGrey),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          );
                                                                        },
                                                                        separatorBuilder: (context, index) => const SizedBox(width: Dimen.margin15),
                                                                        itemCount: controller.selectedList.length,
                                                                      );
                                                                    },
                                                                  )))
                                                          : Container(
                                                              width: double.infinity,
                                                              height: 200,
                                                              child: Center(child: Text("Attachments Not available")),
                                                            ));
                                                }),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: Dimen.margin20,
                                    ),
                                    Row(
                                      children: [
                                        ContainerButton(
                                          onPressed: () {
                                            _showCustomDialog(context);
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
                                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                          // Custom padding
                                          radius: 6, // Custom border radius
                                        ),
                                        Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            controller.clearForm();
                                          },
                                          child: Text(
                                            "Clear Form",
                                            style: AppFonts.medium(14, AppColors.textDarkGrey),
                                          ),
                                        ),
                                        SizedBox(
                                          width: Dimen.margin6,
                                        ),
                                        ContainerButton(
                                          onPressed: () {
                                            // Your onPressed function

                                            Get.back();
                                          },
                                          text: 'Cancel',

                                          borderColor: AppColors.backgroundPurple,
                                          // Custom border color
                                          backgroundColor: Colors.white,
                                          // Custom background color
                                          needBorder: true,
                                          // Show border
                                          textColor: AppColors.backgroundPurple,
                                          // Custom text color
                                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                          // Custom padding
                                          radius: 6, // Custom border radius
                                        ),
                                        SizedBox(
                                          width: Dimen.margin6,
                                        ),
                                        ContainerButton(
                                          onPressed: () {
                                            // Your onPressed function

                                            controller.isSaveAddAnother.value = true;

                                            if (controller.formKey.currentState!.validate()) {
                                              controller.addPatient();
                                            }
                                          },
                                          text: 'Save and Add Another',

                                          borderColor: AppColors.backgroundPurple,
                                          // Custom border color
                                          backgroundColor: AppColors.backgroundPurple,
                                          // Custom background color
                                          needBorder: false,
                                          // Show border
                                          textColor: AppColors.white,
                                          // Custom text color
                                          padding: EdgeInsets.symmetric(vertical: 11, horizontal: 12),
                                          // Custom padding
                                          radius: 6, // Custom border radius
                                        ),
                                        SizedBox(
                                          width: Dimen.margin6,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            controller.isSaveAddAnother.value = false;

                                            if (controller.formKey.currentState!.validate()) {
                                              controller.addPatient();
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(color: AppColors.backgroundPurple, borderRadius: BorderRadius.circular(6)),
                                            width: 70,
                                            height: 40,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 3, right: 11),
                                                    child: Text(
                                                      "Save",
                                                      style: AppFonts.medium(14, Colors.white),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
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
                        )),
                  )),
                ],
              ),
            ),
          ),
        ));
  }
}
//

import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:subqdocs/widget/appbar.dart';

import '../../../../utils/NoNumbersTextInputFormatter.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_diamentions.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/app_string.dart';
import '../../../../utils/imagepath.dart';
import '../../../../utils/validation_service.dart';
import '../../../../widget/custom_animated_button.dart';
import '../../../../widget/fileImage.dart';
import '../../../../widgets/ContainerButton.dart';
import '../../../../widgets/base_dropdown.dart';
import '../../../../widgets/base_image_view.dart';
import '../../../../widgets/custom_button.dart';
import '../../../routes/app_pages.dart';
import '../../custom_drawer/views/custom_drawer_view.dart';
import '../widgets/custom_dailog.dart';
import '../../../../widgets/custom_textfiled.dart';
import '../../../../widgets/rounded_image_widget.dart';
import '../controllers/add_patient_controller.dart';

class AddPatientView extends GetView<AddPatientController> {
  AddPatientView({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                  print('Camera selected');
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Pick from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  // Add your gallery picking logic here
                  print('Gallery selected');
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
              String formattedDate = DateFormat('dd/MM/yyyy').format(fromDate);

              // String formattedDate = DateFormat('MM-dd-yyyy').format(DateTime.now());
              control.text = formattedDate;

              // print('${_selectedDate.toLocal()}'.split(' ')[0]);

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
                // final result = await Get.toNamed(Routes.ADD_PATIENT);
                //
                // if (result == 1) {
                //   controller.getPastVisitList();
                //   controller.getScheduleVisitList();
                //   controller.getPatientList();
                // }
                _key.currentState!.closeDrawer();
              } else if (index == 1) {
                Get.toNamed(Routes.HOME, arguments: {
                  "tabIndex": 1,
                });

                _key.currentState!.closeDrawer();
              } else if (index == 2) {
                Get.toNamed(Routes.HOME, arguments: {
                  "tabIndex": 2,
                });
                _key.currentState!.closeDrawer();
              } else if (index == 3) {
                Get.toNamed(Routes.HOME, arguments: {
                  "tabIndex": 0,
                });
                _key.currentState!.closeDrawer();
              }
            },
          ),
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomAppBar(drawerkey: _key),
                Expanded(
                    child: Container(
                        color: AppColors.ScreenBackGround,
                        child: Padding(
                          padding: const EdgeInsets.only(top: Dimen.margin20, right: Dimen.margin16, left: Dimen.margin16),
                          child: ListView(
                            physics: BouncingScrollPhysics(),
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
                                      prefixIcon: SvgPicture.asset(
                                        ImagePath.search,
                                        fit: BoxFit.cover,
                                        width: Dimen.margin12,
                                        height: Dimen.margin12,
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
                                                    imageUrl: "",
                                                    width: 40,
                                                    height: 40,
                                                    fontSize: 14,
                                                    nameLetters: "mihit thakkar",
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

                                                      // print(" patient id is ${controller.patientList[rowIndex - 1].patientId.toString()}");
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
                                              type: TextInputType.number,
                                              isValid: true,
                                              format: [FilteringTextInputFormatter.digitsOnly],
                                              controller: controller.patientId,
                                              hint: "123",
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
                                              isValid: true,
                                              controller: controller.firstNameController,
                                              hint: "Don",
                                              checkValidation: (value) {
                                                return Validation.requiredFiled(value);
                                              }),
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
                                      ],
                                    ),
                                    SizedBox(
                                      height: Dimen.margin16,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextFormFiledWidget(
                                              label: "Last Name",
                                              isValid: true,
                                              // isImportant: true,
                                              controller: controller.lastNameController,
                                              hint: "Jones",
                                              checkValidation: (value) {
                                                return Validation.requiredFiled(value);
                                              }),
                                        ),
                                        SizedBox(
                                          width: Dimen.margin10,
                                        ),
                                        Expanded(
                                          child: TextFormFiledWidget(
                                              onTap: () {
                                                _showCupertinoDatePicker(context, controller.dobController);
                                              },
                                              label: "Date of birth",
                                              readOnly: true,
                                              isValid: true,
                                              controller: controller.dobController,
                                              hint: "12/1/1972",
                                              suffixIcon: SvgPicture.asset(ImagePath.calendar),
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
                                              label: "Email Address",
                                              controller: controller.emailAddressController,
                                              hint: "donjones@example.com",
                                              checkValidation: (value) {
                                                return Validation.emailValidate(value);
                                              }),
                                        ),
                                        SizedBox(
                                          width: Dimen.margin10,
                                        ),
                                        Expanded(
                                          child: TextFormFiledWidget(
                                            readOnly: true,
                                            label: "Visit Date",
                                            onTap: () {
                                              controller.showVisitDateCupertinoDatePicker(context, controller.visitDateController);
                                            },
                                            controller: controller.visitDateController,
                                            hint: "10/12/2024",
                                            checkValidation: (value) {
                                              return Validation.visitDateAndTimeValidation(value, controller.selectedVisitTimeValue.value);
                                            },
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
                                          child: ExpansionTile(
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
                                              Container(
                                                color: Colors.white,
                                                child: Padding(
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
                                                                          Container(
                                                                            decoration: BoxDecoration(
                                                                              color: AppColors.appbarBorder,
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            width: 120,
                                                                            height: 120,
                                                                            child: ClipRRect(
                                                                              borderRadius: BorderRadius.circular(10), // Set the radius here
                                                                              child: Image.file(
                                                                                controller.selectedList[index].file ?? File(""),
                                                                                fit: BoxFit.cover,
                                                                              ),
                                                                            ),
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
                                                        ))),
                                              ),
                                            ],
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

                                          borderColor: AppColors.backgroundPurple, // Custom border color
                                          backgroundColor: Colors.white, // Custom background color
                                          needBorder: true, // Show border
                                          textColor: AppColors.backgroundPurple, // Custom text color
                                          padding: EdgeInsets.symmetric(vertical: 11, horizontal: 12), // Custom padding
                                          radius: 6, // Custom border radius
                                        ),
                                        // CustomButton(
                                        //   navigate: () {
                                        //     _showCustomDialog(context);
                                        //   },
                                        //   label: "Add Attachments",
                                        //   backGround: AppColors.white,
                                        //   textColor: AppColors.textPurple,
                                        //   isTrue: false,
                                        // ),
                                        Spacer(),
                                        Text(
                                          "Clear Form",
                                          style: AppFonts.medium(14, AppColors.textDarkGrey),
                                        ),
                                        SizedBox(
                                          width: Dimen.margin6,
                                        ),
                                        ContainerButton(
                                          onPressed: () {
                                            // Your onPressed function
                                          },
                                          text: 'Cancel',

                                          borderColor: AppColors.backgroundPurple, // Custom border color
                                          backgroundColor: Colors.white, // Custom background color
                                          needBorder: true, // Show border
                                          textColor: AppColors.backgroundPurple, // Custom text color
                                          padding: EdgeInsets.symmetric(vertical: 11, horizontal: 12), // Custom padding
                                          radius: 6, // Custom border radius
                                        ),
                                        SizedBox(
                                          width: Dimen.margin6,
                                        ),

                                        ContainerButton(
                                          onPressed: () {
                                            // Your onPressed function

                                            if (_formKey.currentState!.validate()) {
                                              controller.addPatient();
                                            }
                                          },
                                          text: 'Save and Add Another',

                                          borderColor: AppColors.backgroundPurple, // Custom border color
                                          backgroundColor: AppColors.backgroundPurple, // Custom background color
                                          needBorder: false, // Show border
                                          textColor: AppColors.white, // Custom text color
                                          padding: EdgeInsets.symmetric(vertical: 11, horizontal: 12), // Custom padding
                                          radius: 6, // Custom border radius
                                        ),

                                        SizedBox(
                                          width: Dimen.margin6,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(color: AppColors.backgroundPurple, borderRadius: BorderRadius.circular(6)),
                                          width: 98,
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
                                                Container(
                                                  height: 40,
                                                  width: 1,
                                                  color: Colors.white,
                                                ),
                                                PopupMenuButton<String>(
                                                    offset: const Offset(14, -70),
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                                    color: AppColors.white,
                                                    position: PopupMenuPosition.over,
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
                                                              value: "",
                                                              child: Row(
                                                                mainAxisSize: MainAxisSize.min,
                                                                children: [
                                                                  SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Text(
                                                                    "Start Visit Now",
                                                                    textAlign: TextAlign.end,
                                                                    style: AppFonts.regular(14, AppColors.textBlack),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 5,
                                                                  )
                                                                ],
                                                              )),
                                                        ],
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 8.0),
                                                      child: SvgPicture.asset(
                                                        ImagePath.downArrow,
                                                        width: 18,
                                                        colorFilter: ColorFilter.mode(AppColors.backgroundWhite, BlendMode.srcIn),
                                                      ),
                                                    )),
                                              ],
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
                        ))),
              ],
            ),
          ),
        ));
  }

  // List<String> generateTimeList(DateTime currentTime, {bool isCurrentDay = true}) {
  //   List<String> timeList = [];
  //
  //   if (isCurrentDay) {
  //     // If it's the current day, generate times from the current time onwards
  //     int startHour = currentTime.hour;
  //     int startMinute = (currentTime.minute ~/ 15) * 15; // Round down to nearest 15-minute mark
  //
  //     // Start with current time and create time slots until the end of the day
  //     for (int hour = startHour; hour < 24; hour++) {
  //       int minute = hour == startHour ? startMinute : 0;
  //       for (int min = minute; min < 60; min += 15) {
  //         timeList.add(DateFormat('h:mm a').format(DateTime(currentTime.year, currentTime.month, currentTime.day, hour, min)));
  //       }
  //     }
  //   } else {
  //     // If it's not the current day, generate times from 12:00 AM to 12:00 PM
  //     for (int hour = 0; hour < 12; hour++) {
  //       for (int min = 0; min < 60; min += 15) {
  //         timeList.add(DateFormat('h:mm a').format(DateTime(currentTime.year, currentTime.month, currentTime.day, hour, min)));
  //       }
  //     }
  //   }
  //
  //   return timeList;
  // }
}

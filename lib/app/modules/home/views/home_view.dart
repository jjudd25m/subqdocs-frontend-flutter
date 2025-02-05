import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:subqdocs/app/modules/home/views/home_past_visits_list.dart';
import 'package:subqdocs/app/modules/home/views/home_schedule_list_view.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/utils/app_fonts.dart';
import 'package:subqdocs/widget/appbar.dart';
import 'package:subqdocs/widgets/custom_button.dart';
import 'package:subqdocs/widgets/rounded_image_widget.dart';

import '../../../../utils/imagepath.dart';
import '../../../../widgets/custom_animated_button.dart';
import '../../../../widgets/custom_drawer.dart';
import '../../../../widgets/custom_table.dart';
import '../../../../widgets/custom_textfiled.dart';
import '../../../routes/app_pages.dart';
import '../../custom_drawer/views/custom_drawer_view.dart';
import '../controllers/home_controller.dart';
import 'home_patient_list_view.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  bool isPast = true;

  bool temp = false;

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  DateTime _selectedDate = DateTime.now();
  GlobalKey<FormState> formKeyFrom = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyTo = GlobalKey<FormState>();

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
                initialDateTime: _selectedDate,
                onDateTimeChanged: (DateTime newDate) {
                  _selectedDate = newDate;
                  // Update the TextField with selected date
                  String formattedDate = DateFormat('MM/dd/yyyy').format(_selectedDate);
                  control.text = formattedDate;

                  print('${_selectedDate.toLocal()}'.split(' ')[0]);
                },
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text('Done'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  void _showPopupMenu(BuildContext context, TextEditingController element, GlobalKey<FormState> formKey) {
    BuildContext? currentContext = formKey.currentContext;

    final RenderBox? renderBox = currentContext?.findRenderObject() as RenderBox?;

    if (renderBox != null) {
      final offset = renderBox.localToGlobal(Offset.zero); // Convert to global coordinates

      showMenu<String>(
        constraints: BoxConstraints(minWidth: 180),
        color: Colors.white,
        context: context,
        position: RelativeRect.fromLTRB(
          offset.dx,
          offset.dy + renderBox.size.height, // Position the menu just below the widget
          offset.dx + renderBox.size.width,
          offset.dy + renderBox.size.height + 100, // Optional: adjust the bottom part if needed
        ),
        items: [
          PopupMenuItem<String>(
            padding: EdgeInsets.zero,
            value: "Today",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12, left: 12, right: 15, bottom: 12),
                  child: Text("Today"),
                ),
                Container(
                  height: 1,
                  width: double.infinity,
                  color: AppColors.appbarBorder,
                )
              ],
            ),
          ),
          PopupMenuItem<String>(
            padding: EdgeInsets.zero,
            value: "Last 7 Days",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12, left: 12, right: 15, bottom: 12),
                  child: Text("Last 7 Days"),
                ),
                Container(
                  height: 1,
                  width: double.infinity,
                  color: AppColors.appbarBorder,
                )
              ],
            ),
          ),
          PopupMenuItem<String>(
            padding: EdgeInsets.zero,
            value: "Last 30 Days",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12, left: 12, right: 15, bottom: 12),
                  child: Text("Last 30 Days"),
                ),
                Container(
                  height: 1,
                  width: double.infinity,
                  color: AppColors.appbarBorder,
                )
              ],
            ),
          ),
          PopupMenuItem<String>(
            padding: EdgeInsets.zero,
            value: "Custom Date",
            onTap: () async {
              _showCupertinoDatePicker(context, element); // Custom Date picker
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12, left: 12, right: 15, bottom: 12),
                  child: Text("Custom Date"),
                ),
              ],
            ),
          ),
        ],
      );
    }
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
        child: CustomDrawerView(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(drawerkey: _key),
            Expanded(
                child: Container(
              width: double.infinity,
              color: AppColors.ScreenBackGround,
              child: Column(
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Obx(() {
                    return Padding(
                      padding: const EdgeInsets.all(15),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Column(
                          children: [
                            Obx(() {
                              return Padding(
                                padding: const EdgeInsets.all(16),
                                child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.white),
                                    height: 70,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                            width: 150,
                                            height: 40,
                                            child: CustomAnimatedButton(
                                              onPressed: () {
                                                controller.tabIndex.value = 0;
                                              },
                                              text: "Patient Visits",
                                              isOutline: true,
                                              fontSize: 14,
                                              enabledTextColor: controller.tabIndex.value == 0 ? AppColors.backgroundPurple : AppColors.textGrey,
                                              enabledColor: controller.tabIndex.value == 0 ? AppColors.backgroundPurple.withValues(alpha: 0.2) : AppColors.clear,
                                              outLineEnabledColor: AppColors.backgroundPurple,
                                              outlineColor: controller.tabIndex.value == 0 ? AppColors.backgroundPurple : AppColors.clear,
                                            )),
                                        SizedBox(
                                            width: 170,
                                            height: 40,
                                            child: CustomAnimatedButton(
                                              onPressed: () {
                                                controller.tabIndex.value = 1;
                                              },
                                              text: "Scheduled Visits",
                                              isOutline: true,
                                              fontSize: 14,
                                              enabledTextColor: controller.tabIndex.value == 1 ? AppColors.backgroundPurple : AppColors.textGrey,
                                              enabledColor: controller.tabIndex.value == 1 ? AppColors.backgroundPurple.withValues(alpha: 0.2) : AppColors.clear,
                                              outLineEnabledColor: AppColors.backgroundPurple,
                                              outlineColor: controller.tabIndex.value == 1 ? AppColors.backgroundPurple : AppColors.clear,
                                            )),
                                        SizedBox(
                                            width: 150,
                                            height: 40,
                                            child: CustomAnimatedButton(
                                              onPressed: () {
                                                controller.tabIndex.value = 2;
                                              },
                                              text: "Past Visits",
                                              isOutline: true,
                                              fontSize: 14,
                                              enabledTextColor: controller.tabIndex.value == 2 ? AppColors.backgroundPurple : AppColors.textGrey,
                                              enabledColor: controller.tabIndex.value == 2 ? AppColors.backgroundPurple.withValues(alpha: 0.2) : AppColors.clear,
                                              outLineEnabledColor: AppColors.backgroundPurple,
                                              outlineColor: controller.tabIndex.value == 2 ? AppColors.backgroundPurple : AppColors.clear,
                                            )),
                                      ],
                                    )),
                              );
                            }),
                            SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.white),
                              child: Column(
                                children: [
                                  Obx(
                                    () {
                                      return Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                controller.tabIndex.value != 1 ? "Patient List" : "Scheduled List",
                                                style: AppFonts.medium(16, AppColors.black),
                                              ),
                                            ),
                                            PopupMenuButton<String>(
                                              offset: const Offset(0, 0),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                              color: AppColors.white,
                                              position: PopupMenuPosition.under,
                                              padding: EdgeInsetsDirectional.zero,
                                              menuPadding: EdgeInsetsDirectional.only(bottom: 0),
                                              onSelected: (value) {
                                                print("selected value is  ${value}");
                                              },
                                              style: const ButtonStyle(
                                                padding: WidgetStatePropertyAll(EdgeInsetsDirectional.zero),
                                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                maximumSize: WidgetStatePropertyAll(Size.zero),
                                                visualDensity: VisualDensity(horizontal: 0, vertical: 2),
                                              ),
                                              itemBuilder: (context) => [
                                                PopupMenuItem(
                                                    onTap: () {
                                                      print("its tapped");
                                                    },
                                                    padding: EdgeInsets.zero,
                                                    value: "",
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 20, right: 40),
                                                          child: Row(
                                                            children: [
                                                              SvgPicture.asset(ImagePath.nameFilter),
                                                              SizedBox(width: 6),
                                                              Text(
                                                                "Name",
                                                                style: AppFonts.regular(14, AppColors.textBlack),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Container(
                                                          height: 2,
                                                          color: AppColors.appbarBorder,
                                                        )
                                                      ],
                                                    )),
                                                PopupMenuItem(
                                                  padding: EdgeInsets.zero,
                                                  child: PopupMenuButton<String>(
                                                    offset: const Offset(240, 10),
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                                    color: AppColors.white,
                                                    position: PopupMenuPosition.under,
                                                    padding: EdgeInsetsDirectional.symmetric(horizontal: 0, vertical: 0),
                                                    menuPadding: EdgeInsetsDirectional.only(bottom: 0),
                                                    onSelected: (value) {},
                                                    style: const ButtonStyle(
                                                        padding: WidgetStatePropertyAll(EdgeInsetsDirectional.zero),
                                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                        maximumSize: WidgetStatePropertyAll(Size.zero),
                                                        visualDensity: VisualDensity(horizontal: 0, vertical: 4)),
                                                    itemBuilder: (context) => [
                                                      PopupMenuItem(
                                                        // enabled: false,
                                                        value: "",
                                                        child: PopupMenuButton<String>(
                                                            constraints: BoxConstraints(minWidth: 200),
                                                            offset: const Offset(0, 8),
                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                                            color: AppColors.white,
                                                            position: PopupMenuPosition.under,
                                                            padding: EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 10),
                                                            menuPadding: EdgeInsetsDirectional.only(bottom: 10),
                                                            onSelected: (value) {},
                                                            style: const ButtonStyle(
                                                                padding: WidgetStatePropertyAll(EdgeInsetsDirectional.zero),
                                                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                maximumSize: WidgetStatePropertyAll(Size.zero),
                                                                visualDensity: VisualDensity(horizontal: 0, vertical: 4)),
                                                            itemBuilder: (context) => [
                                                                  PopupMenuItem(
                                                                      value: "",
                                                                      child: Text(
                                                                        "Today",
                                                                        style: AppFonts.regular(14, AppColors.textBlack),
                                                                      )),
                                                                  PopupMenuDivider(),
                                                                  PopupMenuItem(
                                                                      value: "",
                                                                      onTap: () {},
                                                                      child: Text(
                                                                        "Last 7 Days",
                                                                        style: AppFonts.regular(14, AppColors.textBlack),
                                                                      )),
                                                                  PopupMenuDivider(),
                                                                  PopupMenuItem(
                                                                      value: "",
                                                                      onTap: () {},
                                                                      child: Text(
                                                                        "Last 30 Days",
                                                                        style: AppFonts.regular(14, AppColors.textBlack),
                                                                      )),
                                                                  PopupMenuDivider(),
                                                                  PopupMenuItem(
                                                                      value: "",
                                                                      onTap: () async {
                                                                        _showCupertinoDatePicker(context, controller.fromController);
                                                                        // Last allowed date
                                                                      },
                                                                      child: Text(
                                                                        "Custom date",
                                                                        style: AppFonts.regular(14, AppColors.textBlack),
                                                                      ))
                                                                ],
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(bottom: 10.0),
                                                              child: Form(
                                                                key: formKeyFrom,
                                                                child: TextFormFiledWidget(
                                                                  readOnly: true,
                                                                  onTap: () async {
                                                                    _showPopupMenu(context, controller.fromController, formKeyFrom);
                                                                  },
                                                                  label: "From",
                                                                  controller: controller.fromController,
                                                                  hint: "12/1/1972",
                                                                  suffixIcon: SvgPicture.asset(ImagePath.calendar),
                                                                ),
                                                              ),
                                                            )),
                                                      ),
                                                      PopupMenuItem(
                                                        // enabled: false,
                                                        value: "",
                                                        child: PopupMenuButton<String>(
                                                            constraints: BoxConstraints(minWidth: 200),
                                                            offset: const Offset(0, 8),
                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                                            color: AppColors.white,
                                                            position: PopupMenuPosition.under,
                                                            padding: EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 10),
                                                            menuPadding: EdgeInsetsDirectional.only(bottom: 10),
                                                            onSelected: (value) {},
                                                            style: const ButtonStyle(
                                                                padding: WidgetStatePropertyAll(EdgeInsetsDirectional.zero),
                                                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                maximumSize: WidgetStatePropertyAll(Size.zero),
                                                                visualDensity: VisualDensity(horizontal: 0, vertical: 4)),
                                                            itemBuilder: (context) => [
                                                                  PopupMenuItem(
                                                                      value: "",
                                                                      child: Text(
                                                                        "Today",
                                                                        style: AppFonts.regular(14, AppColors.textBlack),
                                                                      )),
                                                                  PopupMenuDivider(),
                                                                  PopupMenuItem(
                                                                      value: "",
                                                                      onTap: () {},
                                                                      child: Text(
                                                                        "Last 7 Days",
                                                                        style: AppFonts.regular(14, AppColors.textBlack),
                                                                      )),
                                                                  PopupMenuDivider(),
                                                                  PopupMenuItem(
                                                                      value: "",
                                                                      onTap: () {},
                                                                      child: Text(
                                                                        "Last 30 Days",
                                                                        style: AppFonts.regular(14, AppColors.textBlack),
                                                                      )),
                                                                  PopupMenuDivider(),
                                                                  PopupMenuItem(
                                                                      value: "",
                                                                      onTap: () async {
                                                                        _showCupertinoDatePicker(context, controller.toController);
                                                                      },
                                                                      child: Text(
                                                                        "Custom date",
                                                                        style: AppFonts.regular(14, AppColors.textBlack),
                                                                      ))
                                                                ],
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(bottom: 10.0),
                                                              child: Form(
                                                                key: formKeyTo,
                                                                child: TextFormFiledWidget(
                                                                  readOnly: true,
                                                                  onTap: () async {
                                                                    _showPopupMenu(context, controller.toController, formKeyTo);
                                                                  },
                                                                  label: "To",
                                                                  controller: controller.toController,
                                                                  hint: "MM/DD/YYYY",
                                                                  suffixIcon: SvgPicture.asset(ImagePath.calendar),
                                                                ),
                                                              ),
                                                            )),
                                                      ),
                                                    ],
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 20, right: 40),
                                                          child: Row(
                                                            children: [
                                                              SvgPicture.asset(ImagePath.calenderDrawer,
                                                                  colorFilter: ColorFilter.mode(
                                                                    Colors.black, // The color you want to apply
                                                                    BlendMode.srcIn, // This blend mode is commonly used for coloring SVGs
                                                                  )),
                                                              SizedBox(width: 6),
                                                              Text(
                                                                "Visit Date",
                                                                style: AppFonts.regular(14, AppColors.textBlack),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Container(
                                                          height: 2,
                                                          color: AppColors.appbarBorder,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                    padding: EdgeInsets.zero,
                                                    value: "",
                                                    onTap: () {},
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 20, right: 40),
                                                      child: Row(
                                                        children: [
                                                          SvgPicture.asset(ImagePath.status),
                                                          SizedBox(width: 6),
                                                          Text(
                                                            "Status",
                                                            style: AppFonts.regular(14, AppColors.textBlack),
                                                          ),
                                                        ],
                                                      ),
                                                    ))
                                              ],
                                              child: Container(
                                                height: 40,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                    color: AppColors.textDarkGrey, // Border color
                                                    width: 0.5,
                                                    // Border width
                                                  ),

                                                  borderRadius: BorderRadius.circular(10), // Optional: to make the corners rounded
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(10),
                                                  child: SvgPicture.asset(
                                                    "assets/images/filter_logo.svg",
                                                    width: 40,
                                                    height: 40,
                                                  ),
                                                ),
                                              ),
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
                                                    width: 120,
                                                    child: TextField(
                                                      maxLines: 1, //or null
                                                      decoration: InputDecoration.collapsed(hintText: "Search", hintStyle: AppFonts.regular(14, AppColors.textGrey)),
                                                    ),
                                                  ),
                                                  // Text(
                                                  //   "Attachments",
                                                  //   style: AppFonts.medium(16, AppColors.textBlack),
                                                  // ),
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
                                                navigate: () {
                                                  Get.toNamed(Routes.ADD_PATIENT);
                                                },
                                                label: "Schedule Visit",
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  controller.tabIndex.value == 0
                                      ? HomePatientListView()
                                      : controller.tabIndex.value == 1
                                          ? HomeScheduleListView()
                                          : HomePastVisitsList(),
                                  SizedBox(
                                    height: 16,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}

// ? Padding(
//     padding: const EdgeInsets.all(3.0),
//     child: CustomTable(
//       rows: [
//         ['Patient Name', 'Age', "Gender", 'Last Visit Date', "Previous Visits", "Action"],
//         ["Jones, Don", '52', 'Male', '10/12/2024', '2', "Action"],
//         ["Jones, Don", '52', 'Male', '10/12/2024', '2', "Action"],
//         ["Jones, Don", '52', 'Male', '10/12/2024', '2', "Action"],
//         ["Jones, Don", '52', 'Male', '10/12/2024', '2', "Action"],
//         ["Jones, Don", '52', 'Male', '10/12/2024', '2', "Action"],
//       ],
//       cellBuilder: (context, rowIndex, colIndex, cellData) {
//         return colIndex == 0 && rowIndex != 0
//             ? Row(
//                 children: [
//                   RoundedImageWidget(
//                     size: 28,
//                     imagePath: "assets/images/user.png",
//                   ),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   Text(
//                     cellData,
//                     textAlign: TextAlign.center,
//                     style: AppFonts.regular(14, AppColors.textDarkGrey),
//                     softWrap: true, // Allows text to wrap
//                     overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
//                   ),
//                 ],
//               )
//             : colIndex == 5 && rowIndex != 0
//                 ? PopupMenuButton<String>(
//                     offset: const Offset(0, 8),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
//                     color: AppColors.white,
//                     position: PopupMenuPosition.under,
//                     padding: EdgeInsetsDirectional.zero,
//                     menuPadding: EdgeInsetsDirectional.zero,
//                     onSelected: (value) {},
//                     style: const ButtonStyle(
//                         padding: WidgetStatePropertyAll(EdgeInsetsDirectional.zero),
//                         tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                         maximumSize: WidgetStatePropertyAll(Size.zero),
//                         visualDensity: VisualDensity(horizontal: 0, vertical: 0)),
//                     itemBuilder: (context) => [
//                           PopupMenuItem(
//                               onTap: () {
//                                 Get.toNamed(Routes.PATIENT_PROFILE);
//                               },
//                               value: "",
//                               child: Text(
//                                 "View",
//                                 style: AppFonts.regular(14, AppColors.textBlack),
//                               )),
//                           PopupMenuDivider(),
//                           PopupMenuItem(
//                               value: "",
//                               onTap: () {
//                                 Get.toNamed(Routes.EDIT_PATENT_DETAILS);
//                               },
//                               child: Text(
//                                 "Edit",
//                                 style: AppFonts.regular(14, AppColors.textBlack),
//                               )),
//                           PopupMenuDivider(),
//                           PopupMenuItem(
//                               value: "",
//                               onTap: () {},
//                               child: Text(
//                                 "Delete",
//                                 style: AppFonts.regular(14, AppColors.textBlack),
//                               ))
//                         ],
//                     child: SvgPicture.asset(
//                       "assets/images/logo_threedots.svg",
//                       width: 20,
//                       height: 20,
//                     ))
//                 : rowIndex == 0
//                     ? Text(
//                         cellData,
//                         textAlign: colIndex == 0 ? TextAlign.start : TextAlign.center,
//                         style: AppFonts.regular(12, AppColors.black),
//                         softWrap: true, // Allows text to wrap
//                         overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
//                       )
//                     : Text(
//                         cellData,
//                         textAlign: colIndex == 0 ? TextAlign.start : TextAlign.center,
//                         style: AppFonts.regular(14, AppColors.textDarkGrey),
//                         softWrap: true, // Allows text to wrap
//                         overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
//                       );
//       },
//       columnCount: 6,
//       context: context,
//       columnWidths: [0.37, 0.1, 0.08, 0.15, 0.20, 0.1],
//     ),
//   )

// Padding(
// padding: const EdgeInsets.all(3.0),
// child: CustomTable(
// rows: [
// ['Patient Name', 'Visit Date & Time', 'Age', "Gender", "Previous Visits", "Action"],
// ["Jones, Don", '10/12  10:30 am', '52', 'Male', '2', "Action"],
// ["Jones, Don", '10/12  10:30 am', '52', 'Male', '2', "Action"],
// ["Jones, Don", '10/12  10:30 am', '52', 'Male', '2', "Action"],
// // Adding longer text to test overflow handling
// ["Jones, Don", '10/12  10:30 am', '52', 'Male', '2', "Action"],
// ["Jones, Don", '10/12  10:30 am', '52', 'Male', '2', "Action"],
// ["Jones, Don", '10/12  10:30 am', '52', 'Male', '2', "Action"],
// ],
// cellBuilder: (context, rowIndex, colIndex, cellData) {
// return colIndex == 0 && rowIndex != 0
// ? Row(
// children: [
// RoundedImageWidget(
// size: 28,
// imagePath: "assets/images/user.png",
// ),
// SizedBox(
// width: 10,
// ),
// Text(
// cellData,
// textAlign: TextAlign.center,
// style: AppFonts.regular(14, AppColors.textDarkGrey),
// softWrap: true, // Allows text to wrap
// overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
// ),
// ],
// )
//     : colIndex == 5 && rowIndex != 0
// ? PopupMenuButton<String>(
// offset: const Offset(0, 8),
// shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
// color: AppColors.white,
// position: PopupMenuPosition.under,
// padding: EdgeInsetsDirectional.zero,
// menuPadding: EdgeInsetsDirectional.zero,
// onSelected: (value) {},
// style: const ButtonStyle(
// padding: WidgetStatePropertyAll(EdgeInsetsDirectional.zero),
// tapTargetSize: MaterialTapTargetSize.shrinkWrap,
// maximumSize: WidgetStatePropertyAll(Size.zero),
// visualDensity: VisualDensity(horizontal: 0, vertical: 0)),
// itemBuilder: (context) => [
// PopupMenuItem(
// onTap: () {
// Get.toNamed(Routes.PATIENT_PROFILE);
// },
// value: "",
// child: Text(
// "View",
// style: AppFonts.regular(14, AppColors.textBlack),
// )),
// PopupMenuDivider(),
// PopupMenuItem(
// value: "",
// onTap: () {
// Get.toNamed(Routes.EDIT_PATENT_DETAILS);
// },
// child: Text(
// "Edit",
// style: AppFonts.regular(14, AppColors.textBlack),
// )),
// PopupMenuDivider(),
// PopupMenuItem(
// value: "",
// onTap: () {},
// child: Text(
// "Delete",
// style: AppFonts.regular(14, AppColors.textBlack),
// ))
// ],
// child: SvgPicture.asset(
// "assets/images/logo_threedots.svg",
// width: 20,
// height: 20,
// ))
//     : rowIndex == 0
// ? Text(
// cellData,
// textAlign: colIndex == 0 ? TextAlign.start : TextAlign.center,
// style: AppFonts.regular(12, AppColors.black),
// softWrap: true, // Allows text to wrap
// overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
// )
//     : Text(
// cellData,
// textAlign: colIndex == 0 ? TextAlign.start : TextAlign.center,
// style: AppFonts.regular(14, AppColors.textDarkGrey),
// softWrap: true, // Allows text to wrap
// overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
// );
// },
// columnCount: 6,
// context: context,
// columnWidths: [0.32, 0.20, 0.08, 0.1, 0.20, 0.1],
// ),
// )

// Padding(
// padding: const EdgeInsets.all(10.0),
// child: CustomTable(
// rows: [
// ['Patient Name', 'Visit Date', 'Age', "Gender", "Previous Visits", "Status", "Action"],
// ["Jones, Don", '10/12  10:30 am', '52', 'Male', '2', "Pending", "Action"],
// ["Jones, Don", '10/12  10:30 am', '52', 'Male', '2', "Pending", "Action"],
// ["Jones, Don", '10/12  10:30 am', '52', 'Male', '2', "Pending", "Action"],
// ["Jones, Don", '10/12  10:30 am', '52', 'Male', '2', "Pending", "Action"],
// ["Jones, Don", '10/12  10:30 am', '52', 'Male', '2', "Pending", "Action"],
// ],
// cellBuilder: (context, rowIndex, colIndex, cellData) {
// return colIndex == 0 && rowIndex != 0
// ? Row(
// children: [
// RoundedImageWidget(
// size: 28,
// imagePath: "assets/images/user.png",
// ),
// SizedBox(
// width: 10,
// ),
// Text(
// cellData,
// textAlign: TextAlign.center,
// style: AppFonts.regular(14, AppColors.textDarkGrey),
// softWrap: true, // Allows text to wrap
// overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
// ),
// ],
// )
//     : colIndex == 5 && rowIndex != 0
// ? Padding(
// padding: const EdgeInsets.only(left: 5),
// child: Container(
// decoration: BoxDecoration(
// color: AppColors.orange,
// borderRadius: BorderRadius.circular(16),
// ),
// child: Padding(
// padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 6),
// child: Text(
// cellData,
// textAlign: TextAlign.center,
// style: AppFonts.medium(14, AppColors.orangeText),
// ),
// ),
// ),
// )
//     : colIndex == 6 && rowIndex != 0
// ? PopupMenuButton<String>(
// offset: const Offset(0, 8),
// shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
// color: AppColors.white,
// position: PopupMenuPosition.under,
// padding: EdgeInsetsDirectional.zero,
// menuPadding: EdgeInsetsDirectional.zero,
// onSelected: (value) {},
// style: const ButtonStyle(
// padding: WidgetStatePropertyAll(EdgeInsetsDirectional.zero),
// tapTargetSize: MaterialTapTargetSize.shrinkWrap,
// maximumSize: WidgetStatePropertyAll(Size.zero),
// visualDensity: VisualDensity(horizontal: 0, vertical: 0)),
// itemBuilder: (context) => [
// PopupMenuItem(
// onTap: () {
// Get.toNamed(Routes.PATIENT_PROFILE);
// },
// value: "",
// child: Text(
// "View",
// style: AppFonts.regular(14, AppColors.textBlack),
// )),
// PopupMenuDivider(),
// PopupMenuItem(
// value: "",
// onTap: () {
// Get.toNamed(Routes.EDIT_PATENT_DETAILS);
// },
// child: Text(
// "Edit",
// style: AppFonts.regular(14, AppColors.textBlack),
// )),
// PopupMenuDivider(),
// PopupMenuItem(
// value: "",
// onTap: () {},
// child: Text(
// "Delete",
// style: AppFonts.regular(14, AppColors.textBlack),
// ))
// ],
// child: SvgPicture.asset(
// "assets/images/logo_threedots.svg",
// width: 20,
// height: 20,
// ))
//     : rowIndex == 0
// ? Text(
// cellData,
// textAlign: colIndex == 0 ? TextAlign.start : TextAlign.center,
// style: AppFonts.regular(12, AppColors.black),
// softWrap: true, // Allows text to wrap
// overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
// )
//     : Text(
// cellData,
// textAlign: colIndex == 0 ? TextAlign.start : TextAlign.center,
// style: AppFonts.regular(14, AppColors.textDarkGrey),
// softWrap: true, // Allows text to wrap
// overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
// );
// },
// columnCount: 7,
// context: context,
// columnWidths: [0.19, 0.20, 0.1, 0.09, 0.16, 0.19, 0.09],
// ),
// )

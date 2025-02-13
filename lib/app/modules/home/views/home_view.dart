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

import '../../../../utils/imagepath.dart';
import '../../../../widgets/custom_animated_button.dart';
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
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  GlobalKey<FormState> formKeyFrom = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyTo = GlobalKey<FormState>();

  void _showCupertinoDatePicker(BuildContext context, TextEditingController control, bool toController) {
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
                initialDateTime: toController ? fromDate : _selectedDate,
                minimumDate: toController ? fromDate : null,
                onDateTimeChanged: (DateTime newDate) {
                  if (toController) {
                    toDate = newDate;
                  } else {
                    fromDate = newDate;
                  }

                  // Update the TextField with selected date
                },
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text('Done'),
            onPressed: () {
              String formattedDate = DateFormat('MM-dd-yyyy').format(toController ? toDate : fromDate);

              // String formattedDate = DateFormat('MM-dd-yyyy').format(DateTime.now());
              control.text = formattedDate;

              // print('${_selectedDate.toLocal()}'.split(' ')[0]);
              controller.getPatientList();
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  void _showPopupMenu(BuildContext context, TextEditingController element, GlobalKey<FormState> formKey, bool isToController) {
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
            onTap: () {
              String today = DateFormat('MM-dd-yyyy').format(DateTime.now());

              print(today);

              controller.fromController.text = today;
              controller.toController.text = today;
              controller.getPatientList();
            },
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
            onTap: () {
              String today = DateFormat('MM-dd-yyyy').format(DateTime.now());
              String sevenDaysAgo = DateFormat('MM-dd-yyyy').format(DateTime.now().subtract(Duration(days: 7)));

              print(today);
              print(sevenDaysAgo);
              print(" seven days age is the $sevenDaysAgo");
              controller.fromController.text = sevenDaysAgo;
              controller.toController.text = today;
              controller.getPatientList();
            },
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
            onTap: () {
              String today = DateFormat('MM-dd-yyyy').format(DateTime.now());
              String thirtyDaysAgo = DateFormat('MM-dd-yyyy').format(DateTime.now().subtract(Duration(days: 30)));

              print(today);
              print(thirtyDaysAgo);

              controller.fromController.text = thirtyDaysAgo;
              controller.toController.text = today;
              controller.getPatientList();
            },
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
              _showCupertinoDatePicker(context, element, isToController); // Custom Date picker
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
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.backgroundWhite),
                                child: Obx(
                                  () {
                                    return Container(
                                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.white),
                                        height: 65,
                                        child: SingleChildScrollView(
                                          physics: BouncingScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              IntrinsicWidth(
                                                child: CustomAnimatedButton(
                                                  onPressed: () {
                                                    controller.tabIndex.value = 0;
                                                    controller.getPatientList();
                                                  },
                                                  text: "Patient List",
                                                  isOutline: true,
                                                  paddingText: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                                  fontSize: 14,
                                                  enabledTextColor: controller.tabIndex.value == 0 ? AppColors.backgroundPurple : AppColors.textGrey,
                                                  enabledColor: controller.tabIndex.value == 0 ? AppColors.buttonPurpleLight : AppColors.clear,
                                                  outLineEnabledColor: AppColors.textGrey,
                                                  outlineColor: controller.tabIndex.value == 0 ? AppColors.backgroundPurple : AppColors.clear,
                                                ),
                                              ),
                                              IntrinsicWidth(
                                                  child: CustomAnimatedButton(
                                                onPressed: () {
                                                  controller.tabIndex.value = 1;
                                                  controller.getScheduleVisitList();
                                                },
                                                text: "Scheduled Visits",
                                                isOutline: true,
                                                paddingText: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                                fontSize: 14,
                                                enabledTextColor: controller.tabIndex.value == 1 ? AppColors.backgroundPurple : AppColors.textGrey,
                                                enabledColor: controller.tabIndex.value == 1 ? AppColors.buttonPurpleLight : AppColors.clear,
                                                outLineEnabledColor: AppColors.textGrey,
                                                outlineColor: controller.tabIndex.value == 1 ? AppColors.backgroundPurple : AppColors.clear,
                                              )),
                                              IntrinsicWidth(
                                                  child: CustomAnimatedButton(
                                                onPressed: () {
                                                  controller.tabIndex.value = 2;
                                                  controller.getPastVisitList();
                                                },
                                                text: "Past Visits",
                                                isOutline: true,
                                                paddingText: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                                fontSize: 14,
                                                enabledTextColor: controller.tabIndex.value == 2 ? AppColors.backgroundPurple : AppColors.textGrey,
                                                enabledColor: controller.tabIndex.value == 2 ? AppColors.buttonPurpleLight : AppColors.clear,
                                                outLineEnabledColor: AppColors.textGrey,
                                                outlineColor: controller.tabIndex.value == 2 ? AppColors.backgroundPurple : AppColors.clear,
                                              )),
                                            ],
                                          ),
                                        ));
                                  },
                                ),
                              ),
                              SizedBox(height: 20),
                              Expanded(
                                child: Container(
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
                                                          controller.sortName = controller.sortName ? false : true;
                                                          controller.tabIndex.value == 0
                                                              ? controller.getPatientList()
                                                              : controller.tabIndex.value == 1
                                                                  ? controller.getScheduleVisitList()
                                                                  : controller.getPastVisitList();
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
                                                                          onTap: () {
                                                                            String today = DateFormat('MM-dd-yyyy').format(DateTime.now());

                                                                            print(today);

                                                                            controller.fromController.text = today;
                                                                            controller.toController.text = today;
                                                                            controller.getPatientList();
                                                                          },
                                                                          child: Text(
                                                                            "Today",
                                                                            style: AppFonts.regular(14, AppColors.textBlack),
                                                                          )),
                                                                      PopupMenuDivider(),
                                                                      PopupMenuItem(
                                                                          value: "",
                                                                          onTap: () {
                                                                            String today = DateFormat('MM-dd-yyyy').format(DateTime.now());
                                                                            String sevenDaysAgo = DateFormat('MM-dd-yyyy').format(DateTime.now().subtract(Duration(days: 7)));

                                                                            print(today);
                                                                            print(" seven days age is the $sevenDaysAgo");

                                                                            controller.fromController.text = sevenDaysAgo;
                                                                            controller.toController.text = today;
                                                                            controller.getPatientList();
                                                                          },
                                                                          child: Text(
                                                                            "Last 7 Days",
                                                                            style: AppFonts.regular(14, AppColors.textBlack),
                                                                          )),
                                                                      PopupMenuDivider(),
                                                                      PopupMenuItem(
                                                                          value: "last30",
                                                                          onTap: () {
                                                                            String today = DateFormat('MM-dd-yyyy').format(DateTime.now());
                                                                            String thirtyDaysAgo = DateFormat('MM-dd-yyyy').format(DateTime.now().subtract(Duration(days: 30)));

                                                                            print(today);
                                                                            print(thirtyDaysAgo);
                                                                            controller.fromController.text = thirtyDaysAgo;
                                                                            controller.toController.text = today;
                                                                            controller.getPatientList();
                                                                          },
                                                                          child: Text(
                                                                            "Last 30 Days",
                                                                            style: AppFonts.regular(14, AppColors.textBlack),
                                                                          )),
                                                                      PopupMenuDivider(),
                                                                      PopupMenuItem(
                                                                          value: "",
                                                                          onTap: () async {
                                                                            _showCupertinoDatePicker(context, controller.fromController, false);
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
                                                                        _showPopupMenu(context, controller.fromController, formKeyFrom, false);
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
                                                                          onTap: () {
                                                                            String today = DateFormat('MM-dd-yyyy').format(DateTime.now());

                                                                            print(today);

                                                                            controller.fromController.text = today;
                                                                            controller.toController.text = today;
                                                                            controller.getPatientList();
                                                                          },
                                                                          value: "",
                                                                          child: Text(
                                                                            "Today",
                                                                            style: AppFonts.regular(14, AppColors.textBlack),
                                                                          )),
                                                                      PopupMenuDivider(),
                                                                      PopupMenuItem(
                                                                          value: "",
                                                                          onTap: () {
                                                                            String today = DateFormat('MM-dd-yyyy').format(DateTime.now());
                                                                            String sevenDaysAgo = DateFormat('MM-dd-yyyy').format(DateTime.now().subtract(Duration(days: 7)));

                                                                            print(today);
                                                                            print(sevenDaysAgo);
                                                                            print(" seven days age is the $sevenDaysAgo");

                                                                            controller.fromController.text = sevenDaysAgo;
                                                                            controller.toController.text = today;
                                                                            controller.getPatientList();
                                                                          },
                                                                          child: Text(
                                                                            "Last 7 Days",
                                                                            style: AppFonts.regular(14, AppColors.textBlack),
                                                                          )),
                                                                      PopupMenuDivider(),
                                                                      PopupMenuItem(
                                                                          value: "last30",
                                                                          onTap: () {
                                                                            String today = DateFormat('MM-dd-yyyy').format(DateTime.now());
                                                                            String thirtyDaysAgo = DateFormat('MM-dd-yyyy').format(DateTime.now().subtract(Duration(days: 30)));

                                                                            print(today);
                                                                            print(thirtyDaysAgo);

                                                                            controller.fromController.text = thirtyDaysAgo;
                                                                            controller.toController.text = today;
                                                                            controller.getPatientList();
                                                                          },
                                                                          child: Text(
                                                                            "Last 30 Days",
                                                                            style: AppFonts.regular(14, AppColors.textBlack),
                                                                          )),
                                                                      PopupMenuDivider(),
                                                                      PopupMenuItem(
                                                                          value: "",
                                                                          onTap: () async {
                                                                            _showCupertinoDatePicker(context, controller.toController, true);
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
                                                                        _showPopupMenu(context, controller.toController, formKeyTo, true);
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
                                                          controller: controller.searchController,
                                                          onChanged: (value) {
                                                            controller.tabIndex.value == 0
                                                                ? controller.getPatientList()
                                                                : controller.tabIndex.value == 1
                                                                    ? controller.getScheduleVisitList()
                                                                    : controller.getPastVisitList();
                                                          },
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
                                                    navigate: () async {
                                                      final result = await Get.toNamed(Routes.ADD_PATIENT);

                                                      if (result == 1) {
                                                        controller.getPastVisitList();
                                                        controller.getScheduleVisitList();
                                                        controller.getPatientList();
                                                      }
                                                    },
                                                    label: "Schedule Visit",
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                      Expanded(
                                        child: controller.tabIndex.value == 0
                                            ? HomePatientListView()
                                            : controller.tabIndex.value == 1
                                                ? HomeScheduleListView()
                                                : HomePastVisitsList(),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
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

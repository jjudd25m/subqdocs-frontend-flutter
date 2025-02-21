import 'dart:ui';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
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
import 'package:subqdocs/widgets/ContainerButton.dart';
import 'package:subqdocs/widgets/custom_button.dart';

import '../../../../utils/imagepath.dart';
import '../../../../utils/validation_service.dart';
import '../../../../widgets/custom_animated_button.dart';
import '../../../../widgets/custom_textfiled.dart';
import '../../../routes/app_pages.dart';
import '../../custom_drawer/views/custom_drawer_view.dart';
import '../controllers/home_controller.dart';
import 'customCalender.dart';
import 'home_patient_list_view.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  bool isPast = true;
  bool temp = false;

  List<String> data = ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5']; // Example data list

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  DateTime _selectedDate = DateTime.now();
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  GlobalKey<FormState> formKeyFrom = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyTo = GlobalKey<FormState>();

  DateTimeRange? selectedDateRange;

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDateRange: selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue,
            colorScheme: ColorScheme.light(primary: Colors.blue),
          ),
          child: child!,
        );
      },
    );
  }

  Future<void> _showDialog(BuildContext context) async {
    final DateTimeRange? picked = await showDialog<DateTimeRange>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
            width: double.maxFinite,
            height: 290,
            child: CalendarDatePicker2(
              config: CalendarDatePicker2Config(
                selectableDayPredicate: (DateTime date) {
                  if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
                    return false;
                  }
                  return true;
                },
                calendarType: CalendarDatePicker2Type.range,
              ),
              onValueChanged: (value) {
                // controller.onChangeEventDate(value);
              },
              // initialValue: const [],
              value: [],
            ));
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
              final result = await Get.toNamed(Routes.ADD_PATIENT);

              if (result == 1) {
                controller.getPastVisitList();
                controller.getScheduleVisitList();
                controller.getPatientList();
              }
              _key.currentState!.closeDrawer();
            } else if (index == 1) {
              controller.tabIndex.value = 1;
              _key.currentState!.closeDrawer();
            } else if (index == 2) {
              controller.tabIndex.value = 2;
              _key.currentState!.closeDrawer();
            } else if (index == 3) {
              controller.tabIndex.value = 0;
              _key.currentState!.closeDrawer();
            }
          },
        ),
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
                                                    controller.clearFilter();
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
                                                  controller.clearFilter();
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
                                                  controller.clearFilter();
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
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                PopupMenuButton<String>(
                                                  offset: const Offset(0, 0),
                                                  onSelected: (value) {
                                                    if (value == "1") {
                                                      // Do custom logic for Item 1
                                                      // Example: close the popup programmatically
                                                      print('Closing popup manually for Item 1');
                                                    }
                                                  },
                                                  onCanceled: () {
                                                    // controller.selectedValue.clear();

                                                    controller.tabIndex.value == 0
                                                        ? controller.getPatientList()
                                                        : controller.tabIndex.value == 1
                                                            ? controller.getScheduleVisitList()
                                                            : controller.getPastVisitList();

                                                    print("dailog is cancelled");
                                                  },
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                                  color: AppColors.white,
                                                  position: PopupMenuPosition.under,
                                                  padding: EdgeInsetsDirectional.zero,
                                                  menuPadding: EdgeInsetsDirectional.only(bottom: 0),
                                                  style: const ButtonStyle(
                                                    padding: WidgetStatePropertyAll(EdgeInsetsDirectional.zero),
                                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                    visualDensity: VisualDensity(horizontal: 0, vertical: 2),
                                                  ),
                                                  itemBuilder: (context) => [
                                                    PopupMenuItem(
                                                        enabled: false,
                                                        onTap: () {},
                                                        padding: EdgeInsets.zero,
                                                        value: "1",
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.all(16),
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    "Filters",
                                                                    style: AppFonts.medium(16, AppColors.textBlack),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 145,
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      print("clicked");

                                                                      controller.clearFilter();
                                                                    },
                                                                    child: Text(
                                                                      "Clear",
                                                                      style: AppFonts.medium(14, AppColors.backgroundPurple),
                                                                    ),
                                                                  ),
                                                                  // SizedBox(
                                                                  //   width: 20,
                                                                  // ),
                                                                  // GestureDetector(
                                                                  //   onTap: () {
                                                                  //     print("clicked");
                                                                  //
                                                                  //     controller.clearFilter();
                                                                  //   },
                                                                  //   child: Text(
                                                                  //     "Apply",
                                                                  //     style: AppFonts.medium(
                                                                  //         14, AppColors.backgroundPurple),
                                                                  //   ),
                                                                  // ),
                                                                ],
                                                              ),
                                                            ),
                                                            controller.tabIndex.value == 2
                                                                ? Padding(
                                                                    padding: const EdgeInsets.only(left: 16, bottom: 0),
                                                                    child: Text(
                                                                      "Status",
                                                                      style: AppFonts.medium(14, AppColors.textBlack),
                                                                    ),
                                                                  )
                                                                : SizedBox()
                                                          ],
                                                        )),
                                                    controller.tabIndex.value == 2
                                                        ? PopupMenuItem(
                                                            enabled: false,
                                                            padding: EdgeInsets.zero,
                                                            value: "",
                                                            child: Obx(() {
                                                              return Column(
                                                                  children: List.generate(controller.statusModel.length, (index) {
                                                                return Padding(
                                                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                                                    child: Row(
                                                                      children: [
                                                                        controller.selectedIndex.value == index
                                                                            ? GestureDetector(
                                                                                onTap: () {
                                                                                  print("true false");
                                                                                  controller.selectedIndex.value = index;
                                                                                },
                                                                                child: SvgPicture.asset(ImagePath.checkedBox),
                                                                              )
                                                                            : GestureDetector(
                                                                                onTap: () {
                                                                                  print("");
                                                                                  controller.selectedIndex.value = index;
                                                                                },
                                                                                child: SvgPicture.asset(ImagePath.unCheckedBox),
                                                                              ),
                                                                        SizedBox(
                                                                          width: 9,
                                                                        ),
                                                                        Text(
                                                                          "${controller.statusModel[index].status ?? ""}",
                                                                          style: AppFonts.regular(14, AppColors.textBlack),
                                                                        ),
                                                                      ],
                                                                    ));
                                                              }) /*controller.statusModel.map((element) {
                                                            return Padding(
                                                                padding: const EdgeInsets.symmetric(
                                                                    horizontal: 16, vertical: 6),
                                                                child: Row(
                                                                  children: [
                                                                    element.selectedIndex ==
                                                                        ? GestureDetector(
                                                                            onTap: () {
                                                                              print("true false");
                                                                              element.selectedIndex = false;
                                                                              controller.temp.value = false;
                                                                              controller.statusModel.refresh();
                                                                            },
                                                                            child:
                                                                                SvgPicture.asset(ImagePath.checkedBox),
                                                                          )
                                                                        : GestureDetector(
                                                                            onTap: () {
                                                                              print("");
                                                                              element.isSelected = true;
                                                                              controller.temp.value = false;
                                                                              controller.statusModel.refresh();
                                                                            },
                                                                            child: SvgPicture.asset(
                                                                                ImagePath.unCheckedBox),
                                                                          ),
                                                                    SizedBox(
                                                                      width: 9,
                                                                    ),
                                                                    Text(
                                                                      "${element.status}",
                                                                      style: AppFonts.regular(14, AppColors.textBlack),
                                                                    ),
                                                                  ],
                                                                )); // You can customize this to display your data
                                                          }).toList(), */ //
                                                                  );
                                                            }),
                                                          )
                                                        : PopupMenuItem(
                                                            enabled: false,
                                                            onTap: () {},
                                                            padding: EdgeInsets.zero,
                                                            value: "",
                                                            child: Obx(() {
                                                              return Padding(
                                                                padding: const EdgeInsets.only(right: 16, left: 16, bottom: 16, top: 10),
                                                                child: TextFormFiledWidget(
                                                                    readOnly: true,
                                                                    label: "Visit Date",
                                                                    controller: controller.fromController,
                                                                    onTap: () async {
                                                                      print("print");
                                                                      showDialog(
                                                                        context: context,
                                                                        useSafeArea: true,
                                                                        builder: (context) {
                                                                          return AlertDialog(
                                                                            backgroundColor: AppColors.backgroundWhite,
                                                                            titlePadding: EdgeInsets.zero,
                                                                            shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            title: Column(
                                                                              children: [
                                                                                SizedBox(height: 10),
                                                                                // Padding(
                                                                                //   padding: EdgeInsets.symmetric(horizontal: DimensionConstant.d15),
                                                                                //   child: WidgetConstant().textLight14(changeEventDateStr),
                                                                                // ),
                                                                                SizedBox(
                                                                                  width: 305,
                                                                                  height: 290,
                                                                                  child: GetBuilder<HomeController>(
                                                                                    builder: (controller) {
                                                                                      return CalendarDatePicker2(
                                                                                        config: CalendarDatePicker2Config(
                                                                                          // weekdayLabelBuilder: ({isScrollViewTopHeader, required weekday}) => Text(weekday.toString()),
                                                                                          weekdayLabelTextStyle: AppFonts.regular(14, AppColors.textGrey),
                                                                                          weekdayLabels: ["Mo", "Tu", "We", "Th", "Fr", "Sa", "su"],
                                                                                          daySplashColor: AppColors.clear,
                                                                                          calendarViewMode: CalendarDatePicker2Mode.day,
                                                                                          selectedDayHighlightColor: AppColors.backgroundPurple,
                                                                                          dayMaxWidth: 60,
                                                                                          allowSameValueSelection: true,
                                                                                          firstDayOfWeek: 6,
                                                                                          disableMonthPicker: true,

                                                                                          scrollViewTopHeaderTextStyle: const TextStyle(
                                                                                            color: Colors.black87,
                                                                                            fontWeight: FontWeight.bold,
                                                                                          ),

                                                                                          controlsTextStyle: const TextStyle(
                                                                                            color: Colors.black,
                                                                                            fontSize: 15,
                                                                                            fontWeight: FontWeight.bold,
                                                                                          ),
                                                                                          centerAlignModePicker: true,
                                                                                          customModePickerIcon: const SizedBox(),
                                                                                          calendarViewScrollPhysics: const NeverScrollableScrollPhysics(),

                                                                                          calendarType: CalendarDatePicker2Type.range,
                                                                                        ),
                                                                                        onValueChanged: (value) {
                                                                                          controller.selectedValue = value;

                                                                                          print("onchanged  ${value}");
                                                                                        },
                                                                                        value: [DateTime.now()],
                                                                                      );
                                                                                    },
                                                                                  ),
                                                                                ),

                                                                                Row(
                                                                                  children: [
                                                                                    SizedBox(
                                                                                      width: 5,
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: ContainerButton(
                                                                                        padding: EdgeInsets.only(top: 10, bottom: 10),
                                                                                        onPressed: () {
                                                                                          Navigator.pop(context);
                                                                                        },
                                                                                        backgroundColor: Colors.white,
                                                                                        needBorder: true,
                                                                                        borderColor: AppColors.backgroundPurple,
                                                                                        textColor: AppColors.backgroundPurple,
                                                                                        text: "Cancel",
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 5,
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: ContainerButton(
                                                                                        padding: EdgeInsets.only(top: 10, bottom: 10),
                                                                                        onPressed: () {
                                                                                          controller.setDateRange();
                                                                                        },
                                                                                        text: "Choose Date",
                                                                                        backgroundColor: AppColors.backgroundPurple,
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 5,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(height: 10),
                                                                              ],
                                                                            ),
                                                                          );
                                                                        },
                                                                      );

                                                                      // final date = await showDatePickerDialog(
                                                                      //   context: context,
                                                                      //   initialDate: DateTime(2022, 10, 10),
                                                                      //   minDate: DateTime(2020, 10, 10),
                                                                      //   maxDate: DateTime(2024, 10, 30),
                                                                      //   width: 300,
                                                                      //   height: 300,
                                                                      //   currentDate: DateTime(2022, 10, 15),
                                                                      //   selectedDate: DateTime(2022, 10, 16),
                                                                      //   currentDateDecoration: const BoxDecoration(),
                                                                      //   currentDateTextStyle: const TextStyle(),
                                                                      //   daysOfTheWeekTextStyle: const TextStyle(),
                                                                      //   disabledCellsDecoration: const BoxDecoration(),
                                                                      //   disabledCellsTextStyle: const TextStyle(),
                                                                      //   enabledCellsDecoration: const BoxDecoration(),
                                                                      //   enabledCellsTextStyle: const TextStyle(),
                                                                      //   initialPickerType: PickerType.days,
                                                                      //   selectedCellDecoration: const BoxDecoration(),
                                                                      //   selectedCellTextStyle: const TextStyle(),
                                                                      //   leadingDateTextStyle: const TextStyle(),
                                                                      //   slidersColor: Colors.lightBlue,
                                                                      //   highlightColor: Colors.redAccent,
                                                                      //   slidersSize: 20,
                                                                      //   splashColor: Colors.lightBlueAccent,
                                                                      //   splashRadius: 40,
                                                                      //   centerLeadingDate: true,
                                                                      // );
                                                                    },
                                                                    suffixIcon: SvgPicture.asset(ImagePath.down_arrow),
                                                                    hint: "${controller.startDate}-${controller.endDate}",
                                                                    checkValidation: (value) {
                                                                      return Validation.emailValidate(value);
                                                                    }),
                                                              );
                                                            }),
                                                          ),
                                                    controller.tabIndex.value == 2
                                                        ? PopupMenuItem(
                                                            enabled: false,
                                                            onTap: () {},
                                                            padding: EdgeInsets.zero,
                                                            value: "",
                                                            child: Obx(() {
                                                              return Padding(
                                                                padding: const EdgeInsets.only(right: 16, left: 16, bottom: 16, top: 10),
                                                                child: TextFormFiledWidget(
                                                                    readOnly: true,
                                                                    label: "Visit Date",
                                                                    controller: controller.fromController,
                                                                    onTap: () async {
                                                                      print("print");
                                                                      showDialog(
                                                                        context: context,
                                                                        useSafeArea: true,
                                                                        builder: (context) {
                                                                          return AlertDialog(
                                                                            backgroundColor: AppColors.backgroundWhite,
                                                                            titlePadding: EdgeInsets.zero,
                                                                            shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            title: Column(
                                                                              children: [
                                                                                SizedBox(height: 10),
                                                                                // Padding(
                                                                                //   padding: EdgeInsets.symmetric(horizontal: DimensionConstant.d15),
                                                                                //   child: WidgetConstant().textLight14(changeEventDateStr),
                                                                                // ),
                                                                                SizedBox(
                                                                                  width: 305,
                                                                                  height: 290,
                                                                                  child: GetBuilder<HomeController>(
                                                                                    builder: (controller) {
                                                                                      return CalendarDatePicker2(
                                                                                        config: CalendarDatePicker2Config(
                                                                                          // weekdayLabelBuilder: ({isScrollViewTopHeader, required weekday}) => Text(weekday.toString()),
                                                                                          weekdayLabelTextStyle: AppFonts.regular(14, AppColors.textGrey),
                                                                                          weekdayLabels: ["Mo", "Tu", "We", "Th", "Fr", "Sa", "su"],
                                                                                          daySplashColor: AppColors.clear,
                                                                                          calendarViewMode: CalendarDatePicker2Mode.day,
                                                                                          selectedDayHighlightColor: AppColors.backgroundPurple,
                                                                                          dayMaxWidth: 60,
                                                                                          allowSameValueSelection: true,
                                                                                          firstDayOfWeek: 6,
                                                                                          disableMonthPicker: true,

                                                                                          scrollViewTopHeaderTextStyle: const TextStyle(
                                                                                            color: Colors.black87,
                                                                                            fontWeight: FontWeight.bold,
                                                                                          ),

                                                                                          controlsTextStyle: const TextStyle(
                                                                                            color: Colors.black,
                                                                                            fontSize: 15,
                                                                                            fontWeight: FontWeight.bold,
                                                                                          ),
                                                                                          centerAlignModePicker: true,
                                                                                          customModePickerIcon: const SizedBox(),
                                                                                          calendarViewScrollPhysics: const NeverScrollableScrollPhysics(),

                                                                                          calendarType: CalendarDatePicker2Type.range,
                                                                                        ),
                                                                                        onValueChanged: (value) {
                                                                                          controller.selectedValue = value;

                                                                                          print("onchanged  ${value}");
                                                                                        },
                                                                                        value: [DateTime.now()],
                                                                                      );
                                                                                    },
                                                                                  ),
                                                                                ),

                                                                                Row(
                                                                                  children: [
                                                                                    SizedBox(
                                                                                      width: 5,
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: ContainerButton(
                                                                                        padding: EdgeInsets.only(top: 10, bottom: 10),
                                                                                        onPressed: () {
                                                                                          Navigator.pop(context);
                                                                                        },
                                                                                        backgroundColor: Colors.white,
                                                                                        needBorder: true,
                                                                                        borderColor: AppColors.backgroundPurple,
                                                                                        textColor: AppColors.backgroundPurple,
                                                                                        text: "Cancel",
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 5,
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: ContainerButton(
                                                                                        padding: EdgeInsets.only(top: 10, bottom: 10),
                                                                                        onPressed: () {
                                                                                          controller.setDateRange();
                                                                                        },
                                                                                        text: "Choose Date",
                                                                                        backgroundColor: AppColors.backgroundPurple,
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 5,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(height: 10),
                                                                              ],
                                                                            ),
                                                                          );
                                                                        },
                                                                      );

                                                                      // final date = await showDatePickerDialog(
                                                                      //   context: context,
                                                                      //   initialDate: DateTime(2022, 10, 10),
                                                                      //   minDate: DateTime(2020, 10, 10),
                                                                      //   maxDate: DateTime(2024, 10, 30),
                                                                      //   width: 300,
                                                                      //   height: 300,
                                                                      //   currentDate: DateTime(2022, 10, 15),
                                                                      //   selectedDate: DateTime(2022, 10, 16),
                                                                      //   currentDateDecoration: const BoxDecoration(),
                                                                      //   currentDateTextStyle: const TextStyle(),
                                                                      //   daysOfTheWeekTextStyle: const TextStyle(),
                                                                      //   disabledCellsDecoration: const BoxDecoration(),
                                                                      //   disabledCellsTextStyle: const TextStyle(),
                                                                      //   enabledCellsDecoration: const BoxDecoration(),
                                                                      //   enabledCellsTextStyle: const TextStyle(),
                                                                      //   initialPickerType: PickerType.days,
                                                                      //   selectedCellDecoration: const BoxDecoration(),
                                                                      //   selectedCellTextStyle: const TextStyle(),
                                                                      //   leadingDateTextStyle: const TextStyle(),
                                                                      //   slidersColor: Colors.lightBlue,
                                                                      //   highlightColor: Colors.redAccent,
                                                                      //   slidersSize: 20,
                                                                      //   splashColor: Colors.lightBlueAccent,
                                                                      //   splashRadius: 40,
                                                                      //   centerLeadingDate: true,
                                                                      // );
                                                                    },
                                                                    suffixIcon: SvgPicture.asset(ImagePath.down_arrow),
                                                                    hint: "${controller.startDate}-${controller.endDate}",
                                                                    checkValidation: (value) {
                                                                      return Validation.emailValidate(value);
                                                                    }),
                                                              );
                                                            }),
                                                          )
                                                        : PopupMenuDivider(
                                                            height: 0,
                                                          ),
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
                                                    label: controller.tabIndex.value == 0 ? "Add Patient" : "Schedule Visit",
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

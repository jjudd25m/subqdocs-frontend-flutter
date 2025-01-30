import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/utils/app_fonts.dart';
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

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  bool isPast = true;
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.ScreenBackGround,
      drawer: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5.0,
          sigmaY: 5.0,
        ),
        child: CustomDrawerView(),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 25,
            ),
            child: Container(
              height: 68,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _key.currentState!.openDrawer();
                      },
                      child: SvgPicture.asset("assets/images/logo_drawer.svg"),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Image.asset("assets/images/log_subQdocs.png"),
                    Spacer(),
                    RoundedImageWidget(
                      size: 50,
                      imagePath: "assets/images/user.png",
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Adrian Tinajero",
                          style: AppFonts.medium(14, AppColors.backgroundBlack),
                        ),
                        Text(
                          "DO, FAAD",
                          style: AppFonts.medium(12, AppColors.textDarkGrey),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    SvgPicture.asset("assets/images/logo_signout.svg")
                  ],
                ),
              ),
            ),
          ),
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
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Obx(() {
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.backgroundPurple.withValues(alpha: 0.2)),
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
                                      fontSize: 17,
                                      enabledTextColor:
                                          controller.tabIndex.value == 0 ? AppColors.textWhite : AppColors.textGrey,
                                      enabledColor:
                                          controller.tabIndex.value == 0 ? AppColors.backgroundPurple : AppColors.clear,
                                      outLineEnabledColor: AppColors.textGrey,
                                      outlineColor:
                                          controller.tabIndex.value == 0 ? AppColors.backgroundPurple : AppColors.clear,
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
                                      fontSize: 17,
                                      enabledTextColor:
                                          controller.tabIndex.value == 1 ? AppColors.textWhite : AppColors.textGrey,
                                      enabledColor:
                                          controller.tabIndex.value == 1 ? AppColors.backgroundPurple : AppColors.clear,
                                      outLineEnabledColor: AppColors.textGrey,
                                      outlineColor:
                                          controller.tabIndex.value == 1 ? AppColors.backgroundPurple : AppColors.clear,
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
                                      fontSize: 17,
                                      enabledTextColor:
                                          controller.tabIndex.value == 2 ? AppColors.textWhite : AppColors.textGrey,
                                      enabledColor:
                                          controller.tabIndex.value == 2 ? AppColors.backgroundPurple : AppColors.clear,
                                      outLineEnabledColor: AppColors.textGrey,
                                      outlineColor:
                                          controller.tabIndex.value == 2 ? AppColors.backgroundPurple : AppColors.clear,
                                    )),
                              ],
                            )),
                      );
                    }),
                    Obx(
                      () {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Text(
                                controller.tabIndex.value != 1 ? "Patient List" : "Scheduled List",
                                style: AppFonts.regular(18, AppColors.black),
                              ),
                              Spacer(),
                              // PopupMenuButton<String>(
                              //   offset: const Offset(0, 8),
                              //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                              //   color: AppColors.white,
                              //   position: PopupMenuPosition.under,
                              //   padding: EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 10),
                              //   menuPadding: EdgeInsetsDirectional.only(bottom: 10),
                              //   onSelected: (value) {},
                              //   style: const ButtonStyle(
                              //       padding: WidgetStatePropertyAll(EdgeInsetsDirectional.zero),
                              //       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              //       maximumSize: WidgetStatePropertyAll(Size.zero),
                              //       visualDensity: VisualDensity(horizontal: 0, vertical: 4)),
                              //   itemBuilder: (context) => [
                              //     PopupMenuItem(
                              //       enabled: false, // Disable interaction with the header
                              //       child: Text(
                              //         "Date & Time",
                              //         style: AppFonts.medium(14, AppColors.textBlack),
                              //       ),
                              //     ),
                              //     PopupMenuItem(
                              //         enabled: false,
                              //         value: "",
                              //         child: Padding(
                              //           padding: const EdgeInsets.only(bottom: 10.0),
                              //           child: TextFormFiledWidget(
                              //             readOnly: true,
                              //             onTap: () async {
                              //               DateTime? selectedDate = await showDatePicker(
                              //                 context: context,
                              //                 initialDate: DateTime.now(),
                              //                 firstDate: DateTime(2000), // First allowed date
                              //                 lastDate: DateTime(2101), // Last allowed date
                              //               );
                              //
                              //               if (selectedDate != null) {}
                              //             },
                              //             label: "From",
                              //             controller: TextEditingController(),
                              //             hint: "12/1/1972",
                              //             suffixIcon: SvgPicture.asset(ImagePath.calendar),
                              //           ),
                              //         )),
                              //     PopupMenuItem(
                              //         enabled: false,
                              //         value: "",
                              //         child: TextFormFiledWidget(
                              //           readOnly: true,
                              //           onTap: () async {
                              //             DateTime? selectedDate = await showDatePicker(
                              //               context: context,
                              //               initialDate: DateTime.now(),
                              //               firstDate: DateTime(2000), // First allowed date
                              //               lastDate: DateTime(2101), // Last allowed date
                              //             );
                              //
                              //             if (selectedDate != null) {}
                              //           },
                              //           label: "To",
                              //           controller: TextEditingController(),
                              //           hint: "MM/DD/YYYY",
                              //           suffixIcon: SvgPicture.asset(ImagePath.calendar),
                              //         )),
                              //   ],
                              //   child: Container(
                              //     height: 47,
                              //     width: 47,
                              //     decoration: BoxDecoration(
                              //       color: Colors.white,
                              //       border: Border.all(
                              //         color: AppColors.textDarkGrey, // Border color
                              //         width: 0.5,
                              //         // Border width
                              //       ),
                              //
                              //       borderRadius: BorderRadius.circular(10), // Optional: to make the corners rounded
                              //     ),
                              //     child: SvgPicture.asset("assets/images/logo_filter.svg"),
                              //   ),
                              // ),

                              PopupMenuButton<String>(
                                offset: const Offset(0, 0),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                color: AppColors.white,
                                position: PopupMenuPosition.under,
                                padding: EdgeInsetsDirectional.zero,
                                menuPadding: EdgeInsetsDirectional.only(bottom: 0),
                                onSelected: (value) {},
                                style: const ButtonStyle(
                                  padding: WidgetStatePropertyAll(EdgeInsetsDirectional.zero),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  maximumSize: WidgetStatePropertyAll(Size.zero),
                                  visualDensity: VisualDensity(horizontal: 0, vertical: 2),
                                ),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
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
                                                          DateTime? selectedDate = await showDatePicker(
                                                            context: context,
                                                            initialDate: DateTime.now(),
                                                            firstDate: DateTime(2000), // First allowed date
                                                            lastDate: DateTime(2101), // Last allowed date
                                                          );
                                                        },
                                                        child: Text(
                                                          "Custom date",
                                                          style: AppFonts.regular(14, AppColors.textBlack),
                                                        ))
                                                  ],
                                              child: Padding(
                                                padding: const EdgeInsets.only(bottom: 10.0),
                                                child: TextFormFiledWidget(
                                                  readOnly: true,
                                                  onTap: () async {
                                                    // DateTime? selectedDate = await showDatePicker(
                                                    //   context: context,
                                                    //   initialDate: DateTime.now(),
                                                    //   firstDate: DateTime(2000), // First allowed date
                                                    //   lastDate: DateTime(2101), // Last allowed date
                                                    // );

                                                    // if (selectedDate != null) {}
                                                  },
                                                  label: "From",
                                                  controller: TextEditingController(),
                                                  hint: "12/1/1972",
                                                  suffixIcon: SvgPicture.asset(ImagePath.calendar),
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
                                                          DateTime? selectedDate = await showDatePicker(
                                                            context: context,
                                                            initialDate: DateTime.now(),
                                                            firstDate: DateTime(2000), // First allowed date
                                                            lastDate: DateTime(2101), // Last allowed date
                                                          );
                                                        },
                                                        child: Text(
                                                          "Custom date",
                                                          style: AppFonts.regular(14, AppColors.textBlack),
                                                        ))
                                                  ],
                                              child: Padding(
                                                padding: const EdgeInsets.only(bottom: 10.0),
                                                child: TextFormFiledWidget(
                                                  readOnly: true,
                                                  onTap: () async {
                                                    // DateTime? selectedDate = await showDatePicker(
                                                    //   context: context,
                                                    //   initialDate: DateTime.now(),
                                                    //   firstDate: DateTime(2000), // First allowed date
                                                    //   lastDate: DateTime(2101), // Last allowed date
                                                    // );

                                                    // if (selectedDate != null) {}
                                                  },
                                                  label: "To",
                                                  controller: TextEditingController(),
                                                  hint: "MM/DD/YYYY",
                                                  suffixIcon: SvgPicture.asset(ImagePath.calendar),
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
                                                      BlendMode
                                                          .srcIn, // This blend mode is commonly used for coloring SVGs
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
                                  height: 47,
                                  width: 47,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: AppColors.textDarkGrey, // Border color
                                      width: 0.5,
                                      // Border width
                                    ),

                                    borderRadius: BorderRadius.circular(10), // Optional: to make the corners rounded
                                  ),
                                  child: SvgPicture.asset("assets/images/logo_filter.svg"),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: Container(
                                height: 50,
                                child: TextFormFiledWidget(
                                  label: "",
                                  hint: "search",
                                  prefixIcon: Icon(Icons.search),
                                ),
                              )),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 120,
                                child: Expanded(
                                  child: CustomButton(
                                    hight: 50,
                                    navigate: () {
                                      Get.offAllNamed(Routes.ADD_PATIENT);
                                    },
                                    label: "Schedule Visit",
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                    controller.tabIndex.value == 0
                        ? Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: CustomTable(
                              rows: [
                                ['Patient Name', 'Age', "Gender", 'Last Visit Date', "Previous Visits", "Action"],
                                ["Jones, Don", '52', 'Male', '10/12/2024', '2', "Action"],
                                ["Jones, Don", '52', 'Male', '10/12/2024', '2', "Action"],
                                ["Jones, Don", '52', 'Male', '10/12/2024', '2', "Action"],
                                ["Jones, Don", '52', 'Male', '10/12/2024', '2', "Action"],
                                ["Jones, Don", '52', 'Male', '10/12/2024', '2', "Action"],
                              ],
                              cellBuilder: (context, rowIndex, colIndex, cellData) {
                                return colIndex == 0 && rowIndex != 0
                                    ? Row(
                                        children: [
                                          RoundedImageWidget(
                                            size: 28,
                                            imagePath: "assets/images/user.png",
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            cellData,
                                            textAlign: TextAlign.center,
                                            style: AppFonts.regular(14, AppColors.textDarkGrey),
                                            softWrap: true, // Allows text to wrap
                                            overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
                                          ),
                                        ],
                                      )
                                    : colIndex == 5 && rowIndex != 0
                                        ? SvgPicture.asset("assets/images/logo_threedots.svg")
                                        : rowIndex == 0
                                            ? Text(
                                                cellData,
                                                textAlign: colIndex == 0 ? TextAlign.start : TextAlign.center,
                                                style: AppFonts.regular(12, AppColors.black),
                                                softWrap: true, // Allows text to wrap
                                                overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
                                              )
                                            : Text(
                                                cellData,
                                                textAlign: colIndex == 0 ? TextAlign.start : TextAlign.center,
                                                style: AppFonts.regular(14, AppColors.textDarkGrey),
                                                softWrap: true, // Allows text to wrap
                                                overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
                                              );
                              },
                              columnCount: 6,
                              context: context,
                              columnWidths: [0.37, 0.1, 0.08, 0.15, 0.20, 0.1],
                            ),
                          )
                        : controller.tabIndex.value == 1
                            ? Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: CustomTable(
                                  rows: [
                                    ['Patient Name', 'Visit Date & Time', 'Age', "Gender", "Previous Visits", "Action"],
                                    ["Jones, Don", '10/12  10:30 am', '52', 'Male', '2', "Action"],
                                    ["Jones, Don", '10/12  10:30 am', '52', 'Male', '2', "Action"],
                                    ["Jones, Don", '10/12  10:30 am', '52', 'Male', '2', "Action"],
                                    // Adding longer text to test overflow handling
                                    ["Jones, Don", '10/12  10:30 am', '52', 'Male', '2', "Action"],
                                    ["Jones, Don", '10/12  10:30 am', '52', 'Male', '2', "Action"],
                                    ["Jones, Don", '10/12  10:30 am', '52', 'Male', '2', "Action"],
                                  ],
                                  cellBuilder: (context, rowIndex, colIndex, cellData) {
                                    return colIndex == 0 && rowIndex != 0
                                        ? Row(
                                            children: [
                                              RoundedImageWidget(
                                                size: 28,
                                                imagePath: "assets/images/user.png",
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                cellData,
                                                textAlign: TextAlign.center,
                                                style: AppFonts.regular(14, AppColors.textDarkGrey),
                                                softWrap: true, // Allows text to wrap
                                                overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
                                              ),
                                            ],
                                          )
                                        : colIndex == 5 && rowIndex != 0
                                            ? SvgPicture.asset("assets/images/logo_threedots.svg")
                                            : rowIndex == 0
                                                ? Text(
                                                    cellData,
                                                    textAlign: colIndex == 0 ? TextAlign.start : TextAlign.center,
                                                    style: AppFonts.regular(12, AppColors.black),
                                                    softWrap: true, // Allows text to wrap
                                                    overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
                                                  )
                                                : Text(
                                                    cellData,
                                                    textAlign: colIndex == 0 ? TextAlign.start : TextAlign.center,
                                                    style: AppFonts.regular(14, AppColors.textDarkGrey),
                                                    softWrap: true, // Allows text to wrap
                                                    overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
                                                  );
                                  },
                                  columnCount: 6,
                                  context: context,
                                  columnWidths: [0.32, 0.20, 0.08, 0.1, 0.20, 0.1],
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: CustomTable(
                                  rows: [
                                    [
                                      'Patient Name',
                                      'Visit Date',
                                      'Age',
                                      "Gender",
                                      "Previous Visits",
                                      "Status",
                                      "Action"
                                    ],
                                    ["Jones, Don", '10/12  10:30 am', '52', 'Male', '2', "panding", "Action"],
                                    ["Jones, Don", '10/12  10:30 am', '52', 'Male', '2', "panding", "Action"],
                                    ["Jones, Don", '10/12  10:30 am', '52', 'Male', '2', "panding", "Action"],
                                    ["Jones, Don", '10/12  10:30 am', '52', 'Male', '2', "panding", "Action"],
                                    ["Jones, Don", '10/12  10:30 am', '52', 'Male', '2', "panding", "Action"],
                                  ],
                                  cellBuilder: (context, rowIndex, colIndex, cellData) {
                                    return colIndex == 0 && rowIndex != 0
                                        ? Row(
                                            children: [
                                              RoundedImageWidget(
                                                size: 28,
                                                imagePath: "assets/images/user.png",
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                cellData,
                                                textAlign: TextAlign.center,
                                                style: AppFonts.regular(14, AppColors.textDarkGrey),
                                                softWrap: true, // Allows text to wrap
                                                overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
                                              ),
                                            ],
                                          )
                                        : colIndex == 5 && rowIndex != 0
                                            ? Padding(
                                                padding: const EdgeInsets.only(left: 5),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: AppColors.orange,
                                                    borderRadius: BorderRadius.circular(16),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 4),
                                                    child: Text(
                                                      cellData,
                                                      textAlign: TextAlign.center,
                                                      style: AppFonts.medium(14, AppColors.orangeText),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : colIndex == 6 && rowIndex != 0
                                                ? PopupMenuButton<String>(
                                                    offset: const Offset(0, 8),
                                                    shape:
                                                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
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
                                                              value: "",
                                                              child: Text(
                                                                "View",
                                                                style: AppFonts.regular(14, AppColors.textBlack),
                                                              )),
                                                          PopupMenuDivider(),
                                                          PopupMenuItem(
                                                              value: "",
                                                              onTap: () {},
                                                              child: Text(
                                                                "Edit",
                                                                style: AppFonts.regular(14, AppColors.textBlack),
                                                              )),
                                                          PopupMenuDivider(),
                                                          PopupMenuItem(
                                                              value: "",
                                                              onTap: () {},
                                                              child: Text(
                                                                "Delete",
                                                                style: AppFonts.regular(14, AppColors.textBlack),
                                                              ))
                                                        ],
                                                    child: SvgPicture.asset("assets/images/logo_threedots.svg"))
                                                : rowIndex == 0
                                                    ? Text(
                                                        cellData,
                                                        textAlign: colIndex == 0 ? TextAlign.start : TextAlign.center,
                                                        style: AppFonts.regular(12, AppColors.black),
                                                        softWrap: true, // Allows text to wrap
                                                        overflow:
                                                            TextOverflow.ellipsis, // Adds ellipsis if text overflows
                                                      )
                                                    : Text(
                                                        cellData,
                                                        textAlign: colIndex == 0 ? TextAlign.start : TextAlign.center,
                                                        style: AppFonts.regular(14, AppColors.textDarkGrey),
                                                        softWrap: true, // Allows text to wrap
                                                        overflow:
                                                            TextOverflow.ellipsis, // Adds ellipsis if text overflows
                                                      );
                                  },
                                  columnCount: 7,
                                  context: context,
                                  columnWidths: [0.19, 0.20, 0.1, 0.09, 0.16, 0.19, 0.09],
                                ),
                              ),
                    SizedBox(
                      height: 16,
                    )
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

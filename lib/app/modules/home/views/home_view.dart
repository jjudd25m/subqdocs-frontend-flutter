import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/utils/app_fonts.dart';
import 'package:subqdocs/widgets/custom_button.dart';
import 'package:subqdocs/widgets/rounded_image_widget.dart';

import '../../../../widgets/custom_table.dart';
import '../../../../widgets/custom_textfiled.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  bool isPast = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.ScreenBackGround,
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
                    SvgPicture.asset("assets/images/logo_drawer.svg"),
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
          Obx(() {
            return Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                height: 65,
                decoration: BoxDecoration(color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 200,
                        child: Expanded(
                            child: !controller.isPast.value
                                ? CustomButton(
                                    navigate: () {
                                      controller.changeScreen(false);
                                    },
                                    label: "Scheduled Visits",
                                    backGround: AppColors.buttonWithOpacity,
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      controller.changeScreen(false);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        "Scheduled Visits",
                                        style: AppFonts.medium(16, AppColors.backgroundBlack),
                                      ),
                                    ),
                                  )),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        width: 200,
                        child: Expanded(
                            child: controller.isPast.value
                                ? CustomButton(
                                    navigate: () {
                                      controller.changeScreen(true);
                                    },
                                    label: "Past Patient Visits",
                                    backGround: AppColors.buttonWithOpacity,
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      controller.changeScreen(true);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child: Text(
                                        "Past Patient Visits",
                                        style: AppFonts.medium(16, AppColors.backgroundBlack),
                                      ),
                                    ),
                                  )),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
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
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Text(
                            "Patient List",
                            style: AppFonts.regular(18, AppColors.black),
                          ),
                          Spacer(),
                          Container(
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
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: TextFormFiledWidget(
                            label: "",
                            hint: "search",
                            prefixIcon: Icon(Icons.search),
                          )),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: CustomButton(
                              navigate: () {},
                              label: "Schedule Visit",
                            ),
                          )
                        ],
                      ),
                    ),
                    !controller.isPast.value
                        ? Padding(
                            padding: const EdgeInsets.all(10.0),
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
                                            size: 25,
                                            imagePath: "assets/images/user.png",
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            cellData,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: rowIndex == 0 ? FontWeight.bold : FontWeight.normal,
                                            ),
                                            softWrap: true, // Allows text to wrap
                                            overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
                                          ),
                                        ],
                                      )
                                    : colIndex == 5 && rowIndex != 0
                                        ? SvgPicture.asset("assets/images/logo_threedots.svg")
                                        : Text(
                                            cellData,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: rowIndex == 0 ? FontWeight.bold : FontWeight.normal,
                                            ),
                                            softWrap: true, // Allows text to wrap
                                            overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
                                          );
                              },
                              columnCount: 6,
                              context: context,
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: CustomTable(
                              rows: [
                                ['Patient Name', 'Visit Date', 'Age', "Gender", "Previous Visits", "Status", "Action"],
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
                                            size: 25,
                                            imagePath: "assets/images/user.png",
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            cellData,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: rowIndex == 0 ? FontWeight.bold : FontWeight.normal,
                                            ),
                                            softWrap: true, // Allows text to wrap
                                            overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
                                          ),
                                        ],
                                      )
                                    : colIndex == 5 && rowIndex != 0
                                        ? Container(
                                            decoration: BoxDecoration(color: Colors.white),
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 20),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.yellow,
                                                  borderRadius: BorderRadius.circular(15),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(4.0),
                                                  child: Text(
                                                    cellData,
                                                    textAlign: TextAlign.center,
                                                    style: AppFonts.medium(14, AppColors.textDarkGrey),
                                                  ),
                                                ),
                                              ),
                                            ))
                                        : colIndex == 6 && rowIndex != 0
                                            ? SvgPicture.asset("assets/images/logo_threedots.svg")
                                            : Text(
                                                cellData,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontWeight: rowIndex == 0 ? FontWeight.bold : FontWeight.normal,
                                                ),
                                                softWrap: true, // Allows text to wrap
                                                overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
                                              );
                              },
                              columnCount: 7,
                              context: context,
                            ),
                          ),
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

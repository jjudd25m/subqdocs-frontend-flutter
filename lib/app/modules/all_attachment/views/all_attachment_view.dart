import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:subqdocs/app/modules/visit_main/views/delete_image_dialog.dart';
import 'package:subqdocs/app/modules/visit_main/views/view_attchment_image.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/widget/appbar.dart';
import 'package:subqdocs/widgets/base_screen.dart';

import '../../../../utils/app_diamentions.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../../../../widget/base_image_view.dart';
import '../../../../widget/bredcums.dart';
import '../../../../widgets/ContainerButton.dart';
import '../../../../widgets/custom_textfiled.dart';
import '../../../core/common/common_service.dart';
import '../../../core/common/logger.dart';
import '../../../routes/app_pages.dart';
import '../controllers/all_attachment_controller.dart';

class AllAttachmentView extends GetView<AllAttachmentController> {
  AllAttachmentView({super.key});

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  String getFormattedDate(String dateStr) {
    // Parse the date string (mm/dd/yyyy) into a DateTime object
    DateFormat format = DateFormat("dd-MM-yyyy");
    DateTime inputDate = format.parse(dateStr);

    // Get today's date and yesterday's date
    DateTime today = DateTime.now();
    DateTime yesterday = today.subtract(const Duration(days: 1));

    // Check if the input date is today
    if (inputDate.year == today.year && inputDate.month == today.month && inputDate.day == today.day) {
      return "Today";
    }

    // Check if the input date is yesterday
    if (inputDate.year == yesterday.year && inputDate.month == yesterday.month && inputDate.day == yesterday.day) {
      return "Yesterday";
    }

    // Return the original date string if it's neither today nor yesterday
    return dateStr;
  }

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
          child: Container(
            color: AppColors.backgroundLightBlue,
            child: Column(
              children: [
                CustomAppBar(drawerkey: _key),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    color: AppColors.backgroundLightBlue,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
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
                        const SizedBox(height: 20),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                              decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Get.back(result: 1);
                                          },
                                          child: SvgPicture.asset(ImagePath.logo_back, height: 20, width: 20),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(textAlign: TextAlign.center, "Back", style: AppFonts.medium(16, AppColors.textBlack)),
                                        const Spacer(),
                                        PopupMenuButton<String>(
                                          offset: const Offset(0, 0),
                                          onSelected: (value) {
                                            if (value == "1") {
                                              // Do custom logic for Item 1
                                              // Example: close the popup programmatically
                                              customPrint('Closing popup manually for Item 1');
                                            }
                                          },
                                          onCanceled: () {
                                            customPrint("dailog is cancelled");
                                          },
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                          color: AppColors.white,
                                          position: PopupMenuPosition.under,
                                          padding: EdgeInsetsDirectional.zero,
                                          menuPadding: const EdgeInsetsDirectional.only(bottom: 0),
                                          style: const ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsetsDirectional.zero), tapTargetSize: MaterialTapTargetSize.shrinkWrap, visualDensity: VisualDensity(horizontal: 0, vertical: 2)),
                                          itemBuilder:
                                              (context) => [
                                                PopupMenuItem(
                                                  enabled: false,
                                                  onTap: () {},
                                                  padding: EdgeInsets.zero,
                                                  value: "1",
                                                  child: SizedBox(
                                                    width: 300,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.all(16),
                                                          child: Row(
                                                            children: [
                                                              Text("Filters", style: AppFonts.medium(16, AppColors.textBlack)),
                                                              const SizedBox(width: 160),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  customPrint("clicked");

                                                                  controller.startDate.value = "";
                                                                  controller.endDate.value = "";
                                                                  controller.fromController.clear();
                                                                  controller.getAllPatientAttachment();
                                                                },
                                                                child: Text("Clear", style: AppFonts.medium(14, AppColors.backgroundPurple)),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  enabled: false,
                                                  onTap: () {},
                                                  padding: EdgeInsets.zero,
                                                  value: "",
                                                  child: SizedBox(
                                                    width: 500,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(right: 16, left: 16, bottom: 16, top: 10),
                                                      child: TextFormFiledWidget(
                                                        readOnly: true,
                                                        label: "Visit Date",
                                                        controller: controller.fromController,
                                                        onTap: () async {
                                                          customPrint("customPrint");
                                                          showDialog(
                                                            context: context,
                                                            useSafeArea: true,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                backgroundColor: AppColors.backgroundWhite,
                                                                titlePadding: EdgeInsets.zero,
                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                title: Column(
                                                                  children: [
                                                                    const SizedBox(height: 10),
                                                                    SizedBox(
                                                                      width: 305,
                                                                      height: 290,
                                                                      child: GetBuilder<AllAttachmentController>(
                                                                        builder: (controller) {
                                                                          return CalendarDatePicker2(
                                                                            config: CalendarDatePicker2Config(
                                                                              weekdayLabelTextStyle: AppFonts.regular(14, AppColors.textGrey),
                                                                              weekdayLabels: ["sun", "Mon", "Tu", "We", "Th", "Fri", "Sat"],
                                                                              daySplashColor: AppColors.clear,
                                                                              calendarViewMode: CalendarDatePicker2Mode.day,
                                                                              selectedDayHighlightColor: AppColors.backgroundPurple,
                                                                              dayMaxWidth: 60,
                                                                              allowSameValueSelection: true,
                                                                              firstDayOfWeek: 6,
                                                                              disableMonthPicker: true,
                                                                              scrollViewTopHeaderTextStyle: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                                                                              controlsTextStyle: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                                                                              centerAlignModePicker: true,
                                                                              customModePickerIcon: const SizedBox(),
                                                                              calendarViewScrollPhysics: const NeverScrollableScrollPhysics(),
                                                                              calendarType: CalendarDatePicker2Type.range,
                                                                            ),
                                                                            onValueChanged: (value) {
                                                                              controller.selectedValue = value;
                                                                            },
                                                                            value: [DateTime.now()],
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        const SizedBox(width: 5),
                                                                        Expanded(
                                                                          child: ContainerButton(
                                                                            padding: const EdgeInsets.only(top: 10, bottom: 10),
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
                                                                        const SizedBox(width: 5),
                                                                        Expanded(
                                                                          child: ContainerButton(
                                                                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                                                                            onPressed: () {
                                                                              controller.setDateRange();
                                                                              controller.getAllPatientAttachment();
                                                                            },
                                                                            text: "Choose Date",
                                                                            backgroundColor: AppColors.backgroundPurple,
                                                                          ),
                                                                        ),
                                                                        const SizedBox(width: 5),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(height: 10),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                        suffixIcon: SvgPicture.asset(ImagePath.down_arrow),
                                                        hint: " MM/DD/YYYY - MM/DD/YYYY",
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                          child: Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(color: AppColors.textDarkGrey, width: 0.5),
                                              borderRadius: BorderRadius.circular(10), // Optional: to make the corners rounded
                                            ),
                                            child: Padding(padding: const EdgeInsets.all(10), child: SvgPicture.asset("assets/images/filter_logo.svg", width: 40, height: 40)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Obx(() {
                                    return ListView.builder(
                                      physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder:
                                          (context, index) => InkWell(
                                            onTap: () {},
                                            child: Theme(
                                              data: ThemeData(
                                                splashColor: Colors.transparent,
                                                // Remove splash color
                                                highlightColor: Colors.transparent, // Remove highlight color
                                              ),
                                              child: ExpansionTile(
                                                initiallyExpanded: true,
                                                collapsedShape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                                                shape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                                                backgroundColor: AppColors.backgroundWhite,
                                                collapsedBackgroundColor: AppColors.backgroundWhite,
                                                title: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                                  child: Row(
                                                    children: [Text(overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, getFormattedDate(controller.allAttachmentList.value!.responseData.data.keys.elementAt(index)), style: AppFonts.medium(16, AppColors.textPurple)), const SizedBox(width: 10), const Expanded(child: Divider(color: AppColors.buttonBackgroundGrey, height: 1, thickness: 1))],
                                                  ),
                                                ),
                                                children: <Widget>[
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                                    child: GridView.builder(
                                                      shrinkWrap: true,

                                                      physics: const NeverScrollableScrollPhysics(),
                                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: (MediaQuery.of(context).size.width.toInt() / 140).toInt(),
                                                        // Number of columns
                                                        crossAxisSpacing: Dimen.margin15,
                                                        // Horizontal space between items
                                                        mainAxisSpacing: Dimen.margin15,
                                                        // Vertical space between items
                                                        childAspectRatio: 0.9, // Adjust the height-to-width ratio of the grid items
                                                      ),
                                                      padding: const EdgeInsets.only(top: 20),
                                                      itemBuilder: (context, subindex) {
                                                        return SizedBox(
                                                          height: 200,
                                                          width: 140,
                                                          child: Column(
                                                            children: [
                                                              const SizedBox(height: 10),
                                                              Stack(
                                                                clipBehavior: Clip.none,
                                                                alignment: Alignment.topRight,
                                                                children: [
                                                                  Container(
                                                                    height: 120,
                                                                    width: 120,
                                                                    decoration: BoxDecoration(border: Border.all(color: AppColors.buttonBackgroundGrey.withValues(alpha: 0.8)), borderRadius: BorderRadius.circular(8)),
                                                                    padding: const EdgeInsets.only(bottom: Dimen.margin2),
                                                                    child: GestureDetector(
                                                                      onTap: () {
                                                                        final dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 10), receiveTimeout: const Duration(seconds: 10)));

                                                                        if (controller.allAttachmentList.value!.responseData.data.values.elementAt(index)[subindex].fileType?.contains("image") ?? false) {
                                                                          showDialog(
                                                                            context: context,
                                                                            barrierDismissible: true,
                                                                            // Allows dismissing the dialog by tapping outside
                                                                            builder: (BuildContext context) {
                                                                              return ViewAttachmentImage(imageUrl: controller.allAttachmentList.value!.responseData.data.values.elementAt(index)[subindex].filePath ?? "", attachmentUrl: '');

                                                                              // return ViewAttchmentImage(imageUrl: controller.allAttachmentList.value!.responseData.data.values.elementAt(index)[subindex].filePath ?? "", attchmentUrl: '');
                                                                            },
                                                                          );
                                                                        } else {
                                                                          Uri attchmentUri = Uri.parse(controller.allAttachmentList.value!.responseData.data.values.elementAt(index)[subindex].filePath ?? "");
                                                                          customPrint("attchmentUri is :- $attchmentUri");
                                                                        }
                                                                      },
                                                                      child: ClipRRect(
                                                                        borderRadius: BorderRadius.circular(8),
                                                                        child: Container(color: AppColors.backgroundPdfAttchment, width: 120, height: 120, child: Center(child: BaseImageView(imageUrl: controller.allAttachmentList.value!.responseData.data.values.elementAt(index)[subindex].filePath ?? "", width: 120, height: 120, errorWidget: Image.asset(ImagePath.file_placeHolder)))),
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
                                                                                  controller.deleteAttachments(index, subindex, controller.allAttachmentList.value!.responseData.data.values.elementAt(index)[subindex].id ?? -1);
                                                                                },
                                                                                extension: controller.allAttachmentList.value!.responseData.data.values.elementAt(index)[subindex].fileType,
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
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                      itemCount: controller.allAttachmentList.value!.responseData.data.values.elementAt(index).length,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 20),
                                                ],
                                              ),
                                            ),
                                          ),
                                      itemCount: controller.allAttachmentList.value?.responseData.data.keys.length ?? 0,
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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

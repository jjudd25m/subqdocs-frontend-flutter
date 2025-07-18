import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_diamentions.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../../../core/common/logger.dart';
import '../controllers/home_controller.dart';
import 'container_dropdown_view.dart';
import 'drop_down_with_search.dart';

class PastPatientListFilterBottomSheet extends GetView<HomeController> {
  final VoidCallback onTap;

  RxList<DateTime>? selectedDate = RxList([DateTime.now()]);
  RxList<String> selectedStatusIndex = RxList();
  RxList<int> selectedDoctorId = RxList();

  PageController pageController = PageController();

  RxBool isExpandedDoctor = RxBool(false);
  RxBool isExpandedMedicalAssistant = RxBool(false);
  RxBool isExpandedStatus = RxBool(false);

  PastPatientListFilterBottomSheet({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    customPrint(
      "arr count:- ${controller.globalController.homePastPatientListSortingModel.value?.selectedStatusIndex ?? []}",
    );
    selectedDate?.value =
        controller
            .globalController
            .homePastPatientListSortingModel
            .value
            ?.selectedDateValue ??
        RxList([DateTime.now()]);
    pageController = PageController(
      initialPage: DateUtils.monthDelta(
        DateTime(2000, 01, 01),
        selectedDate?.firstOrNull ?? DateTime.now(),
      ),
    );
    selectedStatusIndex.value =
        controller
            .globalController
            .homePastPatientListSortingModel
            .value
            ?.selectedStatusIndex ??
        [];
    selectedDoctorId.value =
        controller
            .globalController
            .homePastPatientListSortingModel
            .value
            ?.selectedDoctorId ??
        [];
    return SizedBox(
      width: double.infinity, // Ensures full width
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          color: AppColors.backgroundWhite,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimen.margin0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimen.margin20),
                child: Row(
                  children: [
                    Text(
                      "Filter",
                      style: AppFonts.medium(16, AppColors.textBlack),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        selectedStatusIndex.clear();
                        selectedDoctorId.clear();
                        controller
                            .globalController
                            .homePastPatientListSortingModel
                            .value
                            ?.selectedDateValue
                            ?.clear();
                        controller
                            .globalController
                            .homePastPatientListSortingModel
                            .value
                            ?.startDate = "";
                        controller
                            .globalController
                            .homePastPatientListSortingModel
                            .value
                            ?.endDate = "";
                        controller.globalController.saveHomePastPatientData();
                        controller.pastTriggeredIndexes.clear();

                        Get.back();
                        onTap();
                      },
                      child: Text(
                        "Clear",
                        style: AppFonts.medium(
                          14,
                          AppColors.backgroundPurple,
                        ).copyWith(decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimen.margin20,
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Visit Date",
                              style: AppFonts.regular(14, AppColors.textBlack),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimen.margin20,
                        ),
                        child: Obx(() {
                          return PopupMenuButton<String>(
                            offset: const Offset(0, 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            color: AppColors.white,
                            position: PopupMenuPosition.under,
                            padding: EdgeInsetsDirectional.zero,
                            menuPadding: EdgeInsetsDirectional.zero,
                            onSelected: (value) {},
                            style: const ButtonStyle(
                              padding: WidgetStatePropertyAll(
                                EdgeInsetsDirectional.zero,
                              ),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              maximumSize: WidgetStatePropertyAll(
                                Size.infinite,
                              ),
                              visualDensity: VisualDensity(
                                horizontal: 0,
                                vertical: 0,
                              ),
                            ),
                            itemBuilder:
                                (context) => [
                                  PopupMenuItem(
                                    padding: EdgeInsets.zero,
                                    onTap: () {
                                      selectedDate?.value = [
                                        DateTime.now(),
                                        DateTime.now(),
                                      ];
                                      updateSelectedDate();
                                      controller
                                          .globalController
                                          .homePastPatientListSortingModel
                                          .value
                                          ?.selectedDateValue = selectedDate;
                                      pageController.animateToPage(
                                        DateUtils.monthDelta(
                                          DateTime(2000, 01, 01),
                                          selectedDate?.first ?? DateTime.now(),
                                        ),
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        curve: Curves.easeIn,
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                          ),
                                          child: Text(
                                            "Today",
                                            style: AppFonts.regular(
                                              14,
                                              AppColors.textBlack,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    padding: EdgeInsets.zero,
                                    onTap: () {
                                      selectedDate?.value = [
                                        DateTime.now().subtract(
                                          const Duration(days: 1),
                                        ),
                                        DateTime.now().subtract(
                                          const Duration(days: 1),
                                        ),
                                      ];
                                      updateSelectedDate();
                                      controller
                                          .globalController
                                          .homePastPatientListSortingModel
                                          .value
                                          ?.selectedDateValue = selectedDate;
                                      pageController.animateToPage(
                                        DateUtils.monthDelta(
                                          DateTime(2000, 01, 01),
                                          selectedDate?.first ?? DateTime.now(),
                                        ),
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        curve: Curves.easeIn,
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: 1,
                                          color: AppColors.appbarBorder,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Yesterday",
                                            style: AppFonts.regular(
                                              14,
                                              AppColors.textBlack,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    padding: EdgeInsets.zero,
                                    onTap: () {
                                      selectedDate?.value = [
                                        DateTime.now().subtract(
                                          const Duration(days: 7),
                                        ),
                                        DateTime.now(),
                                      ];
                                      updateSelectedDate();
                                      controller
                                          .globalController
                                          .homePastPatientListSortingModel
                                          .value
                                          ?.selectedDateValue = selectedDate;
                                      pageController.animateToPage(
                                        DateUtils.monthDelta(
                                          DateTime(2000, 01, 01),
                                          selectedDate?.first ?? DateTime.now(),
                                        ),
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        curve: Curves.easeIn,
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: 1,
                                          color: AppColors.appbarBorder,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Past 7 Days",
                                            style: AppFonts.regular(
                                              14,
                                              AppColors.textBlack,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    padding: EdgeInsets.zero,
                                    onTap: () {
                                      DateTime now = DateTime.now();
                                      selectedDate?.value = [
                                        DateTime(now.year, now.month - 1, 1),
                                        DateTime(now.year, now.month, 0),
                                      ];
                                      updateSelectedDate();
                                      controller
                                          .globalController
                                          .homePastPatientListSortingModel
                                          .value
                                          ?.selectedDateValue = selectedDate;
                                      // pageController.previousPage(duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                      pageController.animateToPage(
                                        DateUtils.monthDelta(
                                          DateTime(2000, 01, 01),
                                          selectedDate?.first ?? DateTime.now(),
                                        ),
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        curve: Curves.easeIn,
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: 1,
                                          color: AppColors.appbarBorder,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Previous Month",
                                            style: AppFonts.regular(
                                              14,
                                              AppColors.textBlack,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                            child: Container(
                              height: 45,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    controller
                                                .getCustomDateRange(
                                                  selectedDate ?? [],
                                                )
                                                .length ==
                                            2
                                        ? "${controller.getCustomDateRange(selectedDate ?? [])[0]}-${controller.getCustomDateRange(selectedDate ?? [])[1]}"
                                        : "Select",
                                    style: AppFonts.regular(
                                      14,
                                      AppColors.textBlack,
                                    ),
                                  ),
                                  const Spacer(),
                                  SvgPicture.asset(
                                    ImagePath.down_arrow,
                                    width: 25,
                                    height: 25,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimen.margin20,
                        ),
                        child: Obx(() {
                          return SizedBox(
                            width: Get.width,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                              child: CalendarDatePicker2(
                                config: CalendarDatePicker2Config(
                                  dayViewController: pageController,
                                  weekdayLabelTextStyle: AppFonts.regular(
                                    14,
                                    AppColors.textGrey,
                                  ),
                                  weekdayLabels: [
                                    "sun",
                                    "Mon",
                                    "Tu",
                                    "We",
                                    "Th",
                                    "Fri",
                                    "Sat",
                                  ],
                                  daySplashColor: AppColors.clear,
                                  calendarViewMode: CalendarDatePicker2Mode.day,
                                  selectedDayHighlightColor:
                                      AppColors.backgroundPurple,
                                  dayMaxWidth: 31,
                                  allowSameValueSelection: true,
                                  firstDayOfWeek: 0,
                                  rangeBidirectional: true,
                                  animateToDisplayedMonthDate: true,
                                  dayTextStyle: AppFonts.regular(
                                    14,
                                    AppColors.textBlack,
                                  ),
                                  disableMonthPicker: true,
                                  dayBorderRadius: const BorderRadius.all(
                                    Radius.circular(6),
                                  ),
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
                                  calendarViewScrollPhysics:
                                      const RangeMaintainingScrollPhysics(),
                                  calendarType: CalendarDatePicker2Type.range,
                                  firstDate: DateTime(2000, 01, 01),
                                  lastDate: DateTime.now().add(
                                    const Duration(days: 365),
                                  ),
                                ),
                                onValueChanged: (value) {
                                  selectedDate?.value = value;

                                  if (selectedStatusIndex.isNotEmpty) {
                                    controller
                                            .globalController
                                            .homePastPatientListSortingModel
                                            .value
                                            ?.selectedStatusIndex =
                                        selectedStatusIndex;
                                  }

                                  controller
                                      .globalController
                                      .homePastPatientListSortingModel
                                      .value
                                      ?.selectedDateValue = selectedDate;
                                  List<String> dates = controller
                                      .getCustomDateRange(selectedDate ?? []);
                                  if (dates.length == 2) {
                                    controller
                                        .globalController
                                        .homePastPatientListSortingModel
                                        .value
                                        ?.startDate = dates[0];
                                    controller
                                        .globalController
                                        .homePastPatientListSortingModel
                                        .value
                                        ?.endDate = dates[1];
                                    controller.globalController
                                        .saveHomePastPatientData();
                                    controller.pastTriggeredIndexes.clear();
                                  }
                                },
                                value: selectedDate ?? [DateTime.now()],
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 17.5),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimen.margin20,
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Status",
                              style: AppFonts.regular(14, AppColors.textBlack),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 17.5),
                      Obx(() {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Dimen.margin20,
                          ),
                          child: ContainerDropdownView(
                            key: UniqueKey(),
                            onRemove: (name, index) {
                              controller.globalController
                                  .removeStatusFilterByIndex(index: index);
                              controller.getPastVisitList();

                              // controller.globalController.setDoctorModel();
                            },
                            selectedItem:
                                controller
                                    .globalController
                                    .homePastPatientListSortingModel
                                    .value
                                    ?.selectedStatusIndex ??
                                [],
                            receiveParam: (isExpand) {
                              isExpandedStatus.value = isExpand;
                            },
                            name: "select status",
                          ),
                        );
                      }),
                      const SizedBox(height: 10),
                      Obx(() {
                        return isExpandedStatus.value
                            ? Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Dimen.margin20,
                              ),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  border: Border.all(
                                    width: 1,
                                    color: AppColors.textfieldBorder,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Column(
                                  children: List.generate(
                                    controller
                                        .filterPastVisitStatusCategoryData
                                        .length,
                                    (index) {
                                      return Column(
                                        children: [
                                          if (index != 0) ...[const Divider()],
                                          const SizedBox(height: 5),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: Dimen.margin20,
                                            ),
                                            child: Row(
                                              children: [
                                                Text(
                                                  controller
                                                      .filterPastVisitStatusCategoryData[index]
                                                      .category,
                                                  style: AppFonts.medium(
                                                    14,
                                                    AppColors.textDarkGrey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: Dimen.margin20,
                                            ),
                                            child: Column(
                                              children: List.generate(
                                                controller
                                                    .filterPastVisitStatusCategoryData[index]
                                                    .subcategories
                                                    .length,
                                                (subIndex) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 0,
                                                          vertical: 6,
                                                        ),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        if (selectedStatusIndex
                                                            .contains(
                                                              controller
                                                                  .filterPastVisitStatusCategoryData[index]
                                                                  .subcategories[subIndex],
                                                            )) {
                                                          customPrint(
                                                            "contain val",
                                                          );
                                                          selectedStatusIndex.remove(
                                                            controller
                                                                .filterPastVisitStatusCategoryData[index]
                                                                .subcategories[subIndex],
                                                          );
                                                        } else {
                                                          customPrint(
                                                            "add val",
                                                          );
                                                          selectedStatusIndex.add(
                                                            controller
                                                                .filterPastVisitStatusCategoryData[index]
                                                                .subcategories[subIndex],
                                                          );
                                                        }

                                                        if (selectedStatusIndex
                                                            .isNotEmpty) {
                                                          // List<String>? statusList = selectedStatusIndex!.map((e) => controller.statusModel[e].status.toString()).toList();
                                                          controller
                                                                  .globalController
                                                                  .homePastPatientListSortingModel
                                                                  .value
                                                                  ?.selectedStatusIndex =
                                                              selectedStatusIndex;
                                                        }

                                                        controller
                                                            .globalController
                                                            .saveHomePastPatientData();
                                                        controller
                                                            .globalController
                                                            .homePastPatientListSortingModel
                                                            .refresh();

                                                        controller
                                                            .getPastVisitList(
                                                              isFist: true,
                                                            );

                                                        customPrint(
                                                          "selectedStatusIndex :- $selectedStatusIndex",
                                                        );
                                                      },
                                                      child: Row(
                                                        children: [
                                                          selectedStatusIndex.contains(
                                                                controller
                                                                    .filterPastVisitStatusCategoryData[index]
                                                                    .subcategories[subIndex],
                                                              )
                                                              ? SvgPicture.asset(
                                                                ImagePath
                                                                    .checkedBox,
                                                                width: 20,
                                                                height: 20,
                                                              )
                                                              : SvgPicture.asset(
                                                                ImagePath
                                                                    .unCheckedBox,
                                                                width: 20,
                                                                height: 20,
                                                              ),
                                                          const SizedBox(
                                                            width: 9,
                                                          ),
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  10,
                                                                ),
                                                            child: Container(
                                                              width: 20,
                                                              height: 20,
                                                              color: controller
                                                                  .getStatusColor(
                                                                    controller
                                                                        .filterPastVisitStatusCategoryData[index]
                                                                        .subcategories[subIndex]
                                                                        .replaceAll(
                                                                          " ",
                                                                          "-",
                                                                        ),
                                                                  ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              controller
                                                                  .filterPastVisitStatusCategoryData[index]
                                                                  .subcategories[subIndex],
                                                              style: AppFonts.regular(
                                                                14,
                                                                AppColors
                                                                    .textDarkGrey,
                                                              ),
                                                            ),
                                                          ),
                                                          // Spacer(),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            )
                            : const SizedBox();
                      }),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimen.margin20,
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Doctor",
                              style: AppFonts.regular(14, AppColors.textBlack),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 17.5),
                      Obx(() {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Dimen.margin20,
                          ),
                          child: ContainerDropdownView(
                            key: UniqueKey(),
                            onRemove: (name, index) {
                              controller.globalController
                                  .removeDoctorFilterByIndex(index: index);
                              controller.globalController.setDoctorModel();
                            },
                            selectedItem:
                                controller
                                    .globalController
                                    .homePastPatientListSortingModel
                                    .value
                                    ?.selectedDoctorNames ??
                                [],
                            receiveParam: (isExpand) {
                              isExpandedDoctor.value = isExpand;
                            },
                            name: "Select Doctor",
                          ),
                        );
                      }),
                      const SizedBox(height: 10),
                      Obx(() {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Dimen.margin20,
                          ),
                          child:
                              isExpandedDoctor.value
                                  ? DropDownWithSearch(
                                    key: UniqueKey(),
                                    onChanged: (
                                      value,
                                      index,
                                      selectedId,
                                      name,
                                    ) {
                                      controller
                                          .globalController
                                          .selectedDoctorModel[index]
                                          .isSelected = !value;
                                      controller
                                          .globalController
                                          .selectedDoctorModel
                                          .refresh();

                                      if (!value) {
                                        controller.globalController
                                            .saveDoctorFilter(
                                              selectedId: selectedId,
                                              name: name,
                                            );
                                      } else {
                                        controller.globalController
                                            .removeDoctorFilter(
                                              selectedId: selectedId,
                                              name: name,
                                            );
                                      }
                                      controller
                                          .globalController
                                          .homePastPatientListSortingModel
                                          .refresh();

                                      controller.getPastVisitList();
                                    },
                                    receiveParam: (id) {},
                                    list:
                                        controller
                                            .globalController
                                            .selectedDoctorModel
                                            .value,
                                    selectedId: 1,
                                  )
                                  : const SizedBox(),
                        );
                      }),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimen.margin20,
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Medical Assistant",
                              style: AppFonts.regular(14, AppColors.textBlack),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 17.5),
                      Obx(() {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Dimen.margin20,
                          ),
                          child: ContainerDropdownView(
                            onRemove: (name, index) {
                              controller.globalController
                                  .removeMedicalFilterByIndex(index: index);

                              controller.globalController.setMedicalModel();
                            },
                            selectedItem:
                                controller
                                    .globalController
                                    .homePastPatientListSortingModel
                                    .value
                                    ?.selectedMedicationNames ??
                                [],
                            receiveParam: (isExpand) {
                              isExpandedMedicalAssistant.value = isExpand;
                            },
                            name: "Select Medical Assistant",
                          ),
                        );
                      }),
                      const SizedBox(height: 10),
                      Obx(() {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Dimen.margin20,
                          ),
                          child:
                              isExpandedMedicalAssistant.value
                                  ? DropDownWithSearch(
                                    key: UniqueKey(),
                                    onChanged: (
                                      value,
                                      index,
                                      selectedId,
                                      name,
                                    ) {
                                      controller
                                          .globalController
                                          .selectedMedicalModel[index]
                                          .isSelected = !value;
                                      controller
                                          .globalController
                                          .selectedMedicalModel
                                          .refresh();

                                      if (!value) {
                                        controller.globalController
                                            .saveMedicalFilter(
                                              selectedId: selectedId,
                                              name: name,
                                            );
                                      } else {
                                        controller.globalController
                                            .removeMedicalFilter(
                                              selectedId: selectedId,
                                              name: name,
                                            );
                                      }
                                      controller
                                          .globalController
                                          .homePastPatientListSortingModel
                                          .refresh();

                                      controller.getPastVisitList();
                                    },
                                    list:
                                        controller
                                            .globalController
                                            .selectedMedicalModel
                                            .value,
                                    receiveParam: (int id) {},
                                    selectedId: 1,
                                  )
                                  : const SizedBox(),
                        );
                      }),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateSelectedDate() async {
    if (selectedStatusIndex.isNotEmpty) {
      controller
          .globalController
          .homePastPatientListSortingModel
          .value
          ?.selectedStatusIndex = selectedStatusIndex;
    }
    controller
        .globalController
        .homePastPatientListSortingModel
        .value
        ?.selectedDateValue = selectedDate;
    List<String> dates = controller.getCustomDateRange(selectedDate ?? []);
    if (dates.length == 2) {
      controller
          .globalController
          .homePastPatientListSortingModel
          .value
          ?.startDate = dates[0];
      controller
          .globalController
          .homePastPatientListSortingModel
          .value
          ?.endDate = dates[1];
      controller.globalController.saveHomePastPatientData();
      controller.pastTriggeredIndexes.clear();
    }
  }
}

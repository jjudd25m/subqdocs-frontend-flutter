import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:subqdocs/utils/app_fonts.dart';
import 'package:subqdocs/widgets/base_screen_mobile.dart';
import 'package:subqdocs/widgets/custom_tab_button.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/imagepath.dart';
import '../../../../utils/no_space_lowercase.dart';
import '../../../../utils/validation_service.dart';
import '../../../../widget/appbar.dart';
import '../../../../widgets/base_dropdown2.dart';
import '../../../../widgets/custom_textfiled.dart';
import '../../../../widgets/serachFiledTypeAhed.dart';
import '../../../modules/home/model/patient_list_model.dart';
import '../controllers/add_patient_mobile_view_controller.dart';

class AddPatientMobileViewView extends GetView<AddPatientMobileViewController> {
  AddPatientMobileViewView({super.key});

  bool isPast = true;
  bool temp = false;

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  GlobalKey<FormState> formKeyFrom = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyTo = GlobalKey<FormState>();

  DateTimeRange? selectedDateRange;

  Timer? timer;

  @override
  Widget build(BuildContext context) {
    return BaseScreenMobile(
      onItemSelected: (index) async {},
      body: Column(
        children: [
          CustomMobileAppBar(
            drawerKey: _key,
            titleWidget: Text("Add Patient Details", style: AppFonts.medium(15.0, AppColors.textBlackDark)),
            actions: const [SizedBox()],
            leadingWidget: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: IconButton(
                highlightColor: Colors.transparent,
                icon: SvgPicture.asset(ImagePath.back_arrow_mobile, height: 20, width: 20),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: controller.formKey,
                child: Container(
                  width: double.infinity,
                  color: AppColors.backgroundMobileAppbar,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      spacing: 15,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        Obx(() {
                          return Serachfiledtypeahed<PatientListData>(
                            suggestionsCallback: (search) async {
                              if (search.isNotEmpty) {
                                return await controller.getPatientList(searchValue: search);
                              }
                              return [];
                            },
                            fillColor: AppColors.clear,
                            suggestionsController: controller.suggestionsController,
                            controller: controller.searchController,
                            valueAsString: (value) => value?.firstName ?? "",
                            items: controller.patientList,
                            selectedValue: controller.searchText.value,
                            isSearchable: true,
                            itemBuilder: (model) {
                              return Container(
                                color: AppColors.white,
                                child: Column(
                                  children: [
                                    Padding(padding: const EdgeInsets.all(8.0), child: Row(children: [Text(model.firstName ?? ""), const SizedBox(width: 5), Text(model.lastName ?? "")])),
                                    Container(height: 1, color: AppColors.appbarBorder),
                                  ],
                                ),
                              );
                            },

                            onChanged: (value) {
                              print("seach val:- ${value?.toJson()}");

                              controller.searchController.text = "${value?.firstName ?? ""} ${value?.lastName ?? ""}";
                              controller.setUi(value);
                              controller.searchText.value = value;
                              controller.searchText.refresh();
                            },
                            selectText: "${controller.searchText.value?.firstName ?? ""} ${controller.searchText.value?.lastName ?? ""}",
                          );
                        }),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormFiledWidget(
                                label: "Patient Id ",
                                isValid: !controller.isValid.value,
                                // isImportant: true,
                                fillColor: AppColors.backgroundMobileAppbar,
                                isSuffixIconVisible: false,
                                readOnly: true,
                                isFirst: true,
                                format: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')), LengthLimitingTextInputFormatter(15)],
                                controller: controller.patientId,
                                hint: "123",
                                onTap: () {
                                  controller.patientId.clear();
                                },
                                suffixIcon: const Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormFiledWidget(
                                label: "First Name",
                                // isImportant: true,
                                fillColor: AppColors.backgroundMobileAppbar,
                                isValid: controller.isValid.value,
                                format: [CustomTextInputFormatter()],
                                controller: controller.firstNameController,
                                hint: "Don",
                                isSuffixIconVisible: false,
                                isFirst: true,
                                onTap: () {
                                  controller.firstNameController.clear();
                                },
                                suffixIcon: const Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                                checkValidation: (value) {
                                  return Validation.requiredFiled(value);
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Obx(() {
                                return TextFormFiledWidget(
                                  isValid: !controller.isValid.value,
                                  isSuffixIconVisible: false,
                                  isFirst: true,
                                  fillColor: AppColors.backgroundMobileAppbar,
                                  format: [CustomTextInputFormatter()],
                                  label: "Middle Name",
                                  controller: controller.middleNameController,
                                  hint: "Joseph",
                                  onTap: () {
                                    controller.middleNameController.clear();
                                  },
                                  suffixIcon: const Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                                );
                              }),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Obx(() {
                                return TextFormFiledWidget(
                                  format: [CustomTextInputFormatter()],
                                  label: "Last Name",
                                  isValid: controller.isValid.value,
                                  // isImportant: true,
                                  fillColor: AppColors.backgroundMobileAppbar,
                                  controller: controller.lastNameController,
                                  isSuffixIconVisible: false,
                                  isFirst: true,
                                  hint: "Jones",
                                  onTap: () {
                                    controller.lastNameController.clear();
                                  },
                                  suffixIcon: const Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                                  checkValidation: (value) {
                                    return Validation.requiredFiled(value);
                                  },
                                );
                              }),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Obx(() {
                                return TextFormFiledWidget(
                                  isValid: controller.editId.value.isEmpty ? false : !controller.isValid.value,
                                  checkValidation: (value) {
                                    return Validation.birthDateValidation(value);
                                  },
                                  fillColor: AppColors.backgroundMobileAppbar,
                                  suffixIcon: const Icon(Icons.calendar_month),
                                  format: [
                                    DateInputFormatter(),
                                    // custom formatter
                                  ],
                                  label: "Date of birth",

                                  controller: controller.dobController,
                                  onTap: () async {
                                    final picked = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now().subtract(const Duration(days: 400)),

                                      firstDate: DateTime.now().subtract(const Duration(days: 36700)),
                                      lastDate: DateTime.now().subtract(const Duration(days: 400)),
                                      builder: (context, child) {
                                        return Theme(data: ThemeData.light().copyWith(cardColor: AppColors.white, primaryColor: AppColors.backgroundPurple, hintColor: AppColors.backgroundPurple, colorScheme: const ColorScheme.light(primary: AppColors.backgroundPurple), buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary)), child: child!);
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
                                );
                              }),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [Text("Gender", style: AppFonts.regular(14, AppColors.textBlack))]),
                                  const SizedBox(height: 8),
                                  Obx(() {
                                    return BaseDropdown2<String>(
                                      direction: VerticalDirection.up,
                                      controller: TextEditingController(),
                                      valueAsString: (value) => value ?? "",
                                      items: controller.sex,
                                      fillColor: AppColors.backgroundMobileAppbar,
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
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTabButton(
              onPressed: () {
                if (controller.formKey.currentState!.validate()) {
                  if (controller.editId.value.isEmpty) {
                    print("---------------------------");
                    print("add patient");
                    print("---------------------------");
                    controller.addPatient();
                  } else {
                    print("---------------------------");
                    print("create visit");
                    print("---------------------------");
                    controller.createVisit(int.parse(controller.editId.value));
                  }
                }
              },
              text: "Start Recording",
              enabledColor: AppColors.backgroundPurple,
              borderRadius: 10,
            ),
          ),
          if (Platform.isAndroid) ...[const SizedBox(height: 20)],
        ],
      ),
      globalKey: _key,
    );
  }
}

// class DatePickerWidget extends StatefulWidget {
//   final ValueChanged<DateTime> onDateSelected;
//   final DateTime? initialDate;
//   final DateTime? firstDate;
//   final DateTime? lastDate;
//   final String? labelText;
//   final TextStyle? style;
//   final InputDecoration? decoration;
//
//   const DatePickerWidget({Key? key, required this.onDateSelected, this.initialDate, this.firstDate, this.lastDate, this.labelText, this.style, this.decoration}) : super(key: key);
//
//   @override
//   _DatePickerWidgetState createState() => _DatePickerWidgetState();
// }
//
// class _DatePickerWidgetState extends State<DatePickerWidget> {
//   late TextEditingController _controller;
//   DateTime? _selectedDate;
//   String _errorText = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _selectedDate = widget.initialDate ?? DateTime.now();
//     _controller = TextEditingController(text: _selectedDate != null ? _formatDate(_selectedDate!) : '');
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   String _formatDate(DateTime date) {
//     return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
//   }
//
//   Future<void> _showDatePicker() async {
//     final DateTime? picked = await showCupertinoModalPopup<DateTime>(
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           height: 250,
//           color: CupertinoColors.systemBackground.resolveFrom(context),
//           child: Column(
//             children: [
//               Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [CupertinoButton(child: const Text('Cancel'), onPressed: () => Navigator.pop(context)), CupertinoButton(child: const Text('Done'), onPressed: () => Navigator.pop(context, _selectedDate ?? DateTime.now()))]),
//               Expanded(
//                 child: CupertinoDatePicker(
//                   mode: CupertinoDatePickerMode.date,
//                   initialDateTime: _selectedDate ?? DateTime.now(),
//                   minimumDate: widget.firstDate,
//                   maximumDate: widget.lastDate,
//                   onDateTimeChanged: (DateTime newDate) {
//                     _selectedDate = newDate;
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//
//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//         _controller.text = _formatDate(picked);
//         _errorText = '';
//       });
//       widget.onDateSelected(picked);
//     }
//   }
//
//   bool _validateDate(String input) {
//     // Simple regex for mm/dd/yyyy format
//     final RegExp dateRegex = RegExp(r'^(0[1-9]|1[0-2])\/(0[1-9]|[12][0-9]|3[01])\/(19|20)\d{2}$');
//
//     if (!dateRegex.hasMatch(input)) {
//       return false;
//     }
//
//     try {
//       final parts = input.split('/');
//       final month = int.parse(parts[0]);
//       final day = int.parse(parts[1]);
//       final year = int.parse(parts[2]);
//
//       // Check if the date is valid (e.g., not Feb 30)
//       final date = DateTime(year, month, day);
//       if (date.month != month || date.day != day || date.year != year) {
//         return false;
//       }
//
//       // Check if date is within optional bounds
//       if (widget.firstDate != null && date.isBefore(widget.firstDate!)) {
//         return false;
//       }
//       if (widget.lastDate != null && date.isAfter(widget.lastDate!)) {
//         return false;
//       }
//
//       return true;
//     } catch (e) {
//       return false;
//     }
//   }
//
//   void _handleManualDateEntry(String input) {
//     if (input.isEmpty) {
//       setState(() {
//         _errorText = '';
//         _selectedDate = null;
//       });
//       return;
//     }
//
//     if (_validateDate(input)) {
//       final parts = input.split('/');
//       final month = int.parse(parts[0]);
//       final day = int.parse(parts[1]);
//       final year = int.parse(parts[2]);
//
//       final newDate = DateTime(year, month, day);
//       setState(() {
//         _selectedDate = newDate;
//         _errorText = '';
//       });
//       widget.onDateSelected(newDate);
//     } else {
//       setState(() {
//         _errorText = 'Please enter a valid date (MM/DD/YYYY)';
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         TextFormField(
//           controller: _controller,
//           decoration: (widget.decoration ?? InputDecoration(labelText: widget.labelText ?? 'Date', suffixIcon: IconButton(icon: const Icon(Icons.calendar_today), onPressed: _showDatePicker), border: const OutlineInputBorder())).copyWith(errorText: _errorText.isNotEmpty ? _errorText : null),
//           style: widget.style,
//           keyboardType: TextInputType.datetime,
//           onChanged: (value) {
//             // Format as user types
//             if (value.length == 2 && !value.contains('/')) {
//               _controller.text = '$value/';
//               _controller.selection = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));
//             } else if (value.length == 5 && value.lastIndexOf('/') == 2) {
//               _controller.text = '$value/';
//               _controller.selection = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));
//             }
//           },
//           onFieldSubmitted: _handleManualDateEntry,
//           onEditingComplete: () {
//             _handleManualDateEntry(_controller.text);
//             FocusScope.of(context).unfocus();
//           },
//         ),
//       ],
//     );
//   }
// }

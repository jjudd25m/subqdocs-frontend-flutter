import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../../../../widget/base_image_view.dart';
import '../controllers/patient_info_controller.dart';

class DoctorView extends GetView<PatientInfoController> {
  const DoctorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                  color: AppColors.white,
                  border: Border.all(color: AppColors.backgroundLightGrey, width: 1)),
              child: Column(
                children: [
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                        color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                        border: Border.all(color: AppColors.borderTable, width: 1)),
                    // color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              textAlign: TextAlign.center,
                              "Diagnosis codes / Procedures",
                              style: AppFonts.medium(16, AppColors.textPurple),
                            ),
                            Spacer(),
                            SvgPicture.asset(
                              ImagePath.edit_outline,
                              height: 28,
                              width: 28,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          Table(
                            border: TableBorder.all(
                              color: AppColors.buttonBackgroundGrey, // Table border color
                              width: 1, // Border width
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5)), // Optional rounded corners
                            ),
                            columnWidths: {
                              0: FractionColumnWidth(0.35), // Fixed width for "Procedure" column
                              1: FractionColumnWidth(0.35), // Fixed width for "Diagnosis" column
                              2: FractionColumnWidth(0.15), // Flexible width for "Unit" column (20% of screen)
                              3: FractionColumnWidth(0.15), // Flexible width for "Unit charges" column (40% of screen)
                            },
                            children: [
                              TableRow(
                                decoration: BoxDecoration(
                                  color: AppColors.white, // Header row background color
                                ),
                                children: [
                                  _headerBuildTableCell('Procedure'),
                                  _headerBuildTableCell('Diagnosis'),
                                  _headerBuildTableCell('Unit'),
                                  _headerBuildTableCell('Unit charges'),
                                ],
                              ),
                              TableRow(
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                ),
                                children: [
                                  _buildTableCell('99213 25 OFFICE O/P EST LOW 20 MIN', false),
                                  _buildTableCell(
                                      'Z08 (Encounter for follow-up examination after completed treatment for malignant neoplasm)',
                                      false),
                                  _buildTableCell('1', false),
                                  _buildTableCell('\$1344.5', false),
                                ],
                              ),
                              // Add more rows if needed
                            ],
                          ),
                          Table(
                            border: TableBorder.all(
                              color: AppColors.buttonBackgroundGrey, // Table border color
                              width: 1, // Border width
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5),
                                  bottomRight: Radius.circular(5)), // Optional rounded corners
                            ),
                            columnWidths: {
                              0: FractionColumnWidth(0.85), // Fixed width for "Procedure" column
                              1: FractionColumnWidth(0.15), // Fixed width for "Diagnosis" column
                            },
                            children: [
                              TableRow(
                                decoration: BoxDecoration(
                                  color: AppColors.white, // Header row background color
                                ),
                                children: [
                                  _headerBuildTableCell('Total'),
                                  _headerBuildTableCell("\$279.46"),
                                ],
                              ),
                              // Add more rows if needed
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              )),
        ),

        //after table
        SizedBox(
          height: 10,
        ),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                  color: AppColors.white,
                  border: Border.all(color: AppColors.backgroundLightGrey, width: 1)),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                        color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                        border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 1)),
                    // color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              textAlign: TextAlign.center,
                              "Impressions and Plan",
                              style: AppFonts.medium(16, AppColors.textPurple),
                            ),
                            Spacer(),
                            SvgPicture.asset(
                              ImagePath.edit_outline,
                              height: 28,
                              width: 28,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ReorderableListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      onReorder: (oldIndex, newIndex) {
                        // setState(() {
                        if (newIndex > oldIndex) {
                          newIndex = newIndex - 1;
                        }
                        // });
                        final task = controller.tasks.removeAt(oldIndex);
                        controller.tasks.insert(newIndex, task);
                      },
                      children: [
                        for (final task in controller.tasks)
                          Container(
                            key: ValueKey(task),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      ImagePath.reorder,
                                      height: 15,
                                      width: 10,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      textAlign: TextAlign.center,
                                      "1. History of Malignant melanoma on the right side of the nose (Z85.820)",
                                      style: AppFonts.medium(14, AppColors.textPurple),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 13,
                                ),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      ImagePath.reorder,
                                      height: 15,
                                      width: 10,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      textAlign: TextAlign.center,
                                      "2.Scar on right side of the nose (L90.5)",
                                      style: AppFonts.medium(14, AppColors.textPurple),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          )
                        // Card(
                        //   color: AppColors.white,
                        //   key: ValueKey(task),
                        //   elevation: 5.0,
                        //   child: ListTile(
                        //     title: Text(task),
                        //     leading: const Icon(Icons.work, color: Colors.black),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              )),
        ),
      ],
    );
  }

  Widget _headerBuildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Text(
        text,
        style: AppFonts.regular(14, AppColors.black),
      ),
    );
  }

  Widget _buildTableCell(String text, bool isTotal) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:
          Text(text, style: isTotal ? AppFonts.medium(14, AppColors.black) : AppFonts.regular(14, AppColors.textGrey)),
    );
  }
}

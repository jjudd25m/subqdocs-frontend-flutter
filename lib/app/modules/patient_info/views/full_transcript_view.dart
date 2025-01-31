import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../../../../widget/base_image_view.dart';
import '../controllers/patient_info_controller.dart';

class FullTranscriptView extends GetView<PatientInfoController> {
  const FullTranscriptView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
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
                    // height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.2),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              textAlign: TextAlign.center,
                              "Transcribing Summary",
                              style: AppFonts.medium(20, AppColors.textBlack),
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8), color: AppColors.backgroundPurple, border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 1)),
                              child: Row(children: [
                                SizedBox(width: 15),
                                Text(
                                  textAlign: TextAlign.center,
                                  "Select Template",
                                  style: AppFonts.medium(20, AppColors.textWhite),
                                ),
                                SizedBox(width: 10),
                                SvgPicture.asset(
                                  ImagePath.down_arrow,
                                  height: 30,
                                  width: 30,
                                  colorFilter: ColorFilter.mode(AppColors.backgroundWhite, BlendMode.srcIn),
                                ),
                                SizedBox(width: 10),
                              ]),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              textAlign: TextAlign.left,
                              "(Transcription Time- 03:55)",
                              style: AppFonts.medium(14, AppColors.textGrey),
                            ),
                            // Spacer()
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  decoration:
                                      BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.white, border: Border.all(color: AppColors.textGrey.withValues(alpha: 0.3), width: 1)),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 10),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          BaseImageView(
                                            imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ4YreOWfDX3kK-QLAbAL4ufCPc84ol2MA8Xg&s",
                                            width: 40,
                                            height: 40,
                                          ),
                                          SizedBox(width: 15),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  textAlign: TextAlign.left,
                                                  "Doctor",
                                                  style: AppFonts.regular(15, AppColors.textGrey),
                                                ),
                                                Text(
                                                  "Yes, doctor. I’ve not been feeling well for the past few days. I’ve been having a stomach ache for a few days and feeling a bit dizzy since yesterday.",
                                                  style: AppFonts.regular(15, AppColors.textGrey),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          Text(
                                            "(00:00)",
                                            style: AppFonts.regular(15, AppColors.textGrey),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                )
                              ],
                            ),
                        itemCount: 8),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 20),
                  //   child: SingleChildScrollView(
                  //     padding: EdgeInsets.zero,
                  //     child: Column(
                  //       children: [
                  //         Table(
                  //           border: TableBorder.all(
                  //             color: AppColors.buttonBackgroundGrey, // Table border color
                  //             width: 1, // Border width
                  //             borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)), // Optional rounded corners
                  //           ),
                  //           columnWidths: {
                  //             0: FractionColumnWidth(0.35), // Fixed width for "Procedure" column
                  //             1: FractionColumnWidth(0.35), // Fixed width for "Diagnosis" column
                  //             2: FractionColumnWidth(0.15), // Flexible width for "Unit" column (20% of screen)
                  //             3: FractionColumnWidth(0.15), // Flexible width for "Unit charges" column (40% of screen)
                  //           },
                  //           children: [
                  //             TableRow(
                  //               decoration: BoxDecoration(
                  //                 color: AppColors.white, // Header row background color
                  //               ),
                  //               children: [
                  //                 _headerBuildTableCell('Procedure'),
                  //                 _headerBuildTableCell('Diagnosis'),
                  //                 _headerBuildTableCell('Unit'),
                  //                 _headerBuildTableCell('Unit charges'),
                  //               ],
                  //             ),
                  //             TableRow(
                  //               decoration: BoxDecoration(
                  //                 color: AppColors.white,
                  //               ),
                  //               children: [
                  //                 _buildTableCell('99213 25 OFFICE O/P EST LOW 20 MIN', false),
                  //                 _buildTableCell('Z08 (Encounter for follow-up examination after completed treatment for malignant neoplasm)', false),
                  //                 _buildTableCell('1', false),
                  //                 _buildTableCell('\$1344.5', false),
                  //               ],
                  //             ),
                  //             // Add more rows if needed
                  //           ],
                  //         ),
                  //         Table(
                  //           border: TableBorder.all(
                  //             color: AppColors.buttonBackgroundGrey, // Table border color
                  //             width: 1, // Border width
                  //             borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)), // Optional rounded corners
                  //           ),
                  //           columnWidths: {
                  //             0: FractionColumnWidth(0.85), // Fixed width for "Procedure" column
                  //             1: FractionColumnWidth(0.15), // Fixed width for "Diagnosis" column
                  //           },
                  //           children: [
                  //             TableRow(
                  //               decoration: BoxDecoration(
                  //                 color: AppColors.white, // Header row background color
                  //               ),
                  //               children: [
                  //                 _headerBuildTableCell('Total'),
                  //                 _headerBuildTableCell("\$279.46"),
                  //               ],
                  //             ),
                  //             // Add more rows if needed
                  //           ],
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              )),
        ),
        SizedBox(
          height: 20,
        ),
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 20),
        //   child: Container(
        //       width: double.infinity,
        //       padding: EdgeInsets.symmetric(horizontal: 0),
        //       decoration: BoxDecoration(
        //           borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
        //           color: AppColors.white,
        //           border: Border.all(color: AppColors.backgroundLightGrey, width: 1)),
        //       child: Column(
        //         children: [
        //           Container(
        //             height: 70,
        //             decoration: BoxDecoration(
        //                 borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
        //                 color: AppColors.backgroundPurple.withValues(alpha: 0.2),
        //                 border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 1)),
        //             // color: AppColors.backgroundPurple.withValues(alpha: 0.2),
        //             padding: EdgeInsets.symmetric(horizontal: 20),
        //             child: Column(
        //               children: [
        //                 SizedBox(
        //                   height: 20,
        //                 ),
        //                 Row(
        //                   children: [
        //                     Text(
        //                       textAlign: TextAlign.center,
        //                       "Impressions and Plan",
        //                       style: AppFonts.medium(20, AppColors.textPurple),
        //                     ),
        //                     Spacer(),
        //                     SvgPicture.asset(
        //                       ImagePath.edit_outline,
        //                       height: 40,
        //                       width: 40,
        //                     ),
        //                   ],
        //                 ),
        //               ],
        //             ),
        //           ),
        //           SizedBox(
        //             height: 20,
        //           ),
        //           Padding(
        //             padding: const EdgeInsets.symmetric(horizontal: 20),
        //             child: ReorderableListView(
        //               shrinkWrap: true,
        //               physics: NeverScrollableScrollPhysics(),
        //               onReorder: (oldIndex, newIndex) {
        //                 // setState(() {
        //                 if (newIndex > oldIndex) {
        //                   newIndex = newIndex - 1;
        //                 }
        //                 // });
        //                 final task = controller.tasks.removeAt(oldIndex);
        //                 controller.tasks.insert(newIndex, task);
        //               },
        //               children: [
        //                 for (final task in controller.tasks)
        //                   Container(
        //                     key: ValueKey(task),
        //                     child: Column(
        //                       crossAxisAlignment: CrossAxisAlignment.start,
        //                       children: [
        //                         Row(
        //                           children: [
        //                             SvgPicture.asset(
        //                               ImagePath.reorder,
        //                               height: 25,
        //                               width: 25,
        //                             ),
        //                             SizedBox(
        //                               width: 20,
        //                             ),
        //                             Text(
        //                               textAlign: TextAlign.center,
        //                               "1. History of Malignant melanoma on the right side of the nose (Z85.820)",
        //                               style: AppFonts.medium(17, AppColors.textPurple),
        //                             ),
        //                             Spacer()
        //                           ],
        //                         ),
        //                         Padding(
        //                           padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
        //                           child: Text(
        //                             textAlign: TextAlign.left,
        //                             "a. Pear Fractional laser ",
        //                             style: AppFonts.medium(16, AppColors.textBlack),
        //                           ),
        //                         ),
        //                         Padding(
        //                           padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
        //                           child: Text(
        //                             textAlign: TextAlign.left,
        //                             "Location: noe \n Hand piece: Ptearl Fraction \nWavelength: 2970 nm \nSpot size: 5 mm",
        //                             style: AppFonts.medium(16, AppColors.textGrey),
        //                           ),
        //                         ),
        //                         SizedBox(height: 20),
        //                         Padding(
        //                           padding: const EdgeInsets.symmetric(horizontal: 20),
        //                           child: Container(
        //                             width: double.infinity,
        //                             decoration: BoxDecoration(
        //                                 borderRadius: BorderRadius.circular(12), color: AppColors.imageBannerGrayBackground, border: Border.all(color: AppColors.imageBannerGrayBorder, width: 1)),
        //                             padding: EdgeInsets.symmetric(horizontal: 20),
        //                             child: Column(
        //                               children: [
        //                                 SizedBox(height: 15),
        //                                 Row(
        //                                   children: [
        //                                     Text(
        //                                       textAlign: TextAlign.center,
        //                                       "Right side of the nose before the laser session",
        //                                       style: AppFonts.medium(14, AppColors.textBlack),
        //                                     ),
        //                                     SizedBox(width: 10),
        //                                     SvgPicture.asset(
        //                                       ImagePath.edit,
        //                                       height: 25,
        //                                       width: 25,
        //                                     ),
        //                                     Spacer(),
        //                                     SvgPicture.asset(
        //                                       ImagePath.chat_outline,
        //                                       height: 40,
        //                                       width: 40,
        //                                     ),
        //                                     SizedBox(width: 10),
        //                                     SvgPicture.asset(
        //                                       ImagePath.delete_outline,
        //                                       height: 40,
        //                                       width: 40,
        //                                     ),
        //                                   ],
        //                                 ),
        //                                 SizedBox(height: 10),
        //                                 BaseImageView(width: double.infinity, height: 300, imageUrl: "https://www.cdfa.ca.gov/v6.5/sample/images/gallery/orangecounty-big.jpg"),
        //                                 SizedBox(height: 10),
        //                                 Row(
        //                                   children: [
        //                                     Text(
        //                                       textAlign: TextAlign.center,
        //                                       "12/24/2024 - 10:13AM",
        //                                       style: AppFonts.medium(14, AppColors.textGrey),
        //                                     ),
        //                                     SizedBox(width: 10),
        //                                     Spacer(),
        //                                   ],
        //                                 ),
        //                                 SizedBox(height: 10),
        //                                 Container(
        //                                     decoration:
        //                                         BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.white, border: Border.all(color: AppColors.imageBannerGrayBorder, width: 1)),
        //                                     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        //                                     child: Column(
        //                                       children: [
        //                                         Row(
        //                                           children: [
        //                                             ClipRRect(
        //                                                 borderRadius: BorderRadius.circular(22.5),
        //                                                 child: BaseImageView(width: 45, height: 45, imageUrl: "https://www.cdfa.ca.gov/v6.5/sample/images/gallery/orangecounty-big.jpg")),
        //                                             SizedBox(width: 10),
        //                                             Text(
        //                                               textAlign: TextAlign.center,
        //                                               "Dr. Tinajero",
        //                                               style: AppFonts.medium(14, AppColors.textBlack),
        //                                             ),
        //                                             SizedBox(width: 10),
        //                                             Spacer(),
        //                                             SvgPicture.asset(
        //                                               ImagePath.edit_outline,
        //                                               height: 40,
        //                                               width: 40,
        //                                             ),
        //                                             SizedBox(width: 10),
        //                                             SvgPicture.asset(
        //                                               ImagePath.delete_outline,
        //                                               height: 40,
        //                                               width: 40,
        //                                             ),
        //                                           ],
        //                                         ),
        //                                         SizedBox(
        //                                           height: 10,
        //                                         ),
        //                                         Text(
        //                                           textAlign: TextAlign.left,
        //                                           "Pre-treatment photo of the nasal scar prior to the first erbium Pearl Fractional laser session. Documenting baseline appearance for progress tracking.",
        //                                           style: AppFonts.medium(14, AppColors.textGrey),
        //                                         ),
        //                                       ],
        //                                     )),
        //                                 SizedBox(height: 20),
        //                               ],
        //                             ),
        //                           ),
        //                         ),
        //                         SizedBox(height: 20),
        //                       ],
        //                     ),
        //                   )
        //                 // Card(
        //                 //   color: AppColors.white,
        //                 //   key: ValueKey(task),
        //                 //   elevation: 5.0,
        //                 //   child: ListTile(
        //                 //     title: Text(task),
        //                 //     leading: const Icon(Icons.work, color: Colors.black),
        //                 //   ),
        //                 // ),
        //               ],
        //             ),
        //           ),
        //           SizedBox(
        //             height: 20,
        //           ),
        //         ],
        //       )),
        // ),
      ],
    );
  }

  Widget _headerBuildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTableCell(String text, bool isTotal) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          color: isTotal ? Colors.black : Colors.grey[700],
        ),
      ),
    );
  }
}

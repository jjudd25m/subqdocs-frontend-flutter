import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../controllers/patient_info_controller.dart';

class PatientView extends GetView<PatientInfoController> {
  const PatientView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
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
                          height: 40,
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
                                    "Note",
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
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: SingleChildScrollView(
                            padding: EdgeInsets.zero,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) => InkWell(
                                            onTap: () {},
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 0),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        textAlign: TextAlign.left,
                                                        controller.patientViewListModel.value?.responseData?.visitNoteDetails.dynamicData.keys.elementAt(index).replaceAll("_", " ").capitalizeFirst ??
                                                            '',
                                                        style: AppFonts.medium(14, AppColors.textBlack),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(height: 10),
                                                  ListView.builder(
                                                    shrinkWrap: true,
                                                    physics: NeverScrollableScrollPhysics(),
                                                    itemCount: 4, // Number of items
                                                    itemBuilder: (context, subIndex) {
                                                      return Row(
                                                        children: [
                                                          Expanded(
                                                              child: Text(
                                                            textAlign: TextAlign.left,
                                                            controller.patientViewListModel.value?.responseData!.visitNoteDetails
                                                                    .dynamicData[controller.patientViewListModel.value?.responseData?.visitNoteDetails.dynamicData.keys.elementAt(index)]?[subIndex] ??
                                                                "",
                                                            style: AppFonts.regular(14, AppColors.textGrey),
                                                          )),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                  // Row(
                                                  //   crossAxisAlignment: CrossAxisAlignment.start,
                                                  //   children: [
                                                  //     Text(
                                                  //       textAlign: TextAlign.start,
                                                  //       '\u2022',
                                                  //       style: AppFonts.regular(14, AppColors.textGrey),
                                                  //     ),
                                                  //     SizedBox(width: 15),
                                                  //     Expanded(
                                                  //         child: Text(
                                                  //       textAlign: TextAlign.left,
                                                  //       "No issues were reported with your overall health (no night sweats, skin rashes, chest pain, shortness of breath, fever, or chills).",
                                                  //       style: AppFonts.regular(14, AppColors.textGrey),
                                                  //     )),
                                                  //   ],
                                                  // ),
                                                  SizedBox(height: 0),
                                                ],
                                              ),
                                            ),
                                          ),
                                      itemCount: controller.patientViewListModel.value?.responseData?.visitNoteDetails.dynamicData.values.length ?? 0),
                                  //
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                // Row(
                                //   children: [
                                //     Text(
                                //       textAlign: TextAlign.left,
                                //       "Today's Findings:",
                                //       style: AppFonts.medium(14, AppColors.textBlack),
                                //     )
                                //   ],
                                // ),
                                // Padding(
                                //   padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                //   child: ListView.builder(
                                //       shrinkWrap: true,
                                //       itemBuilder: (context, index) => InkWell(
                                //             onTap: () {},
                                //             child: Padding(
                                //               padding: const EdgeInsets.symmetric(horizontal: 0),
                                //               child: Column(
                                //                 children: [
                                //                   SizedBox(height: 5),
                                //                   Row(
                                //                     children: [
                                //                       Text(
                                //                         textAlign: TextAlign.center,
                                //                         '\u2022',
                                //                         style: AppFonts.regular(14, AppColors.textGrey),
                                //                       ),
                                //                       SizedBox(width: 15),
                                //                       Expanded(
                                //                           child: Text(
                                //                         textAlign: TextAlign.left,
                                //                         "Brown, scaly spots on your trunk (common and not harmful)",
                                //                         style: AppFonts.regular(14, AppColors.textGrey),
                                //                       )),
                                //                     ],
                                //                   ),
                                //                   SizedBox(height: 0),
                                //                 ],
                                //               ),
                                //             ),
                                //           ),
                                //       itemCount: 2),
                                // ),
                                // SizedBox(
                                //   height: 10,
                                // ),
                                // Row(
                                //   children: [
                                //     Text(
                                //       textAlign: TextAlign.left,
                                //       "Your Care Plan:",
                                //       style: AppFonts.medium(14, AppColors.textBlack),
                                //     )
                                //   ],
                                // ),
                                // Padding(
                                //   padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                //   child: ListView.builder(
                                //       padding: EdgeInsets.zero,
                                //       shrinkWrap: true,
                                //       itemBuilder: (context, index) => InkWell(
                                //             onTap: () {},
                                //             child: Padding(
                                //               padding: const EdgeInsets.symmetric(horizontal: 0),
                                //               child: Column(
                                //                 children: [
                                //                   SizedBox(height: 5),
                                //                   Row(
                                //                     children: [
                                //                       Text(
                                //                         textAlign: TextAlign.center,
                                //                         "${index + 1}.",
                                //                         style: AppFonts.regular(14, AppColors.textGrey),
                                //                       ),
                                //                       SizedBox(width: 15),
                                //                       Expanded(
                                //                           child: Text(
                                //                         textAlign: TextAlign.left,
                                //                         "Skin Health Monitoring:Continue regular skin checks every 6 months.",
                                //                         style: AppFonts.regular(14, AppColors.textGrey),
                                //                       )),
                                //                     ],
                                //                   ),
                                //                   SizedBox(height: 0),
                                //                 ],
                                //               ),
                                //             ),
                                //           ),
                                //       itemCount: 2),
                                // ),
                                // SizedBox(
                                //   height: 10,
                                // ),
                                // Row(
                                //   children: [
                                //     Text(
                                //       textAlign: TextAlign.left,
                                //       "Next Steps:",
                                //       style: AppFonts.medium(14, AppColors.textBlack),
                                //     )
                                //   ],
                                // ),
                                // Padding(
                                //   padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                //   child: ListView.builder(
                                //       shrinkWrap: true,
                                //       itemBuilder: (context, index) => InkWell(
                                //             onTap: () {},
                                //             child: Padding(
                                //               padding: const EdgeInsets.symmetric(horizontal: 0),
                                //               child: Column(
                                //                 children: [
                                //                   SizedBox(height: 2),
                                //                   Row(
                                //                     children: [
                                //                       Text(
                                //                         textAlign: TextAlign.center,
                                //                         '\u2022',
                                //                         style: AppFonts.regular(14, AppColors.textGrey),
                                //                       ),
                                //                       SizedBox(width: 15),
                                //                       Expanded(
                                //                           child: Text(
                                //                         textAlign: TextAlign.left,
                                //                         "Schedule your next skin check in 6 months.",
                                //                         style: AppFonts.regular(14, AppColors.textGrey),
                                //                       )),
                                //                     ],
                                //                   ),
                                //                   SizedBox(height: 0),
                                //                 ],
                                //               ),
                                //             ),
                                //           ),
                                //       itemCount: 2),
                                // ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 0,
                        ),
                      ],
                    )),
              ),
              SizedBox(
                height: 5,
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
          ),
          if (controller.isPatientViewLoading.value) ...[
            if (controller.isPatientViewLoadText.value.toLowerCase() == "failure") ...[
              Center(
                  child: Column(
                children: [
                  SizedBox(
                    height: 90,
                  ),
                  Text("An error occurred while processing the patient view")
                ],
              ))
            ] else ...[
              Center(
                  child: Column(
                children: [CircularProgressIndicator(), Text(controller.isPatientViewLoadText.value)],
              ))
            ]
          ]
        ],
      );
    });
  }
}

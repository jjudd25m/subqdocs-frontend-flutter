import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:subqdocs/app/modules/visit_main/views/delete_image_dialog.dart';
import 'package:subqdocs/app/modules/visit_main/views/view_attchment_image.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/widget/appbar.dart';
import 'package:subqdocs/widget/custom_animated_button.dart';

import '../../../../utils/app_diamentions.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../../../../widget/base_image_view.dart';
import '../../../routes/app_pages.dart';
import '../controllers/all_attachment_controller.dart';

class AllAttachmentView extends GetView<AllAttachmentController> {
  AllAttachmentView({super.key});

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Obx(() {
          return Column(
            children: [
              CustomAppBar(drawerkey: _key),
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: AppColors.backgroundLightBlue,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: SvgPicture.asset(
                                    ImagePath.logo_back,
                                    height: 20,
                                    width: 20,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  textAlign: TextAlign.center,
                                  "Back",
                                  style: AppFonts.medium(16, AppColors.textBlack),
                                ),
                                Spacer(),
                                SvgPicture.asset(
                                  ImagePath.logo_filter,
                                  height: 40,
                                  width: 40,
                                ),
                              ],
                            ),
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (context, index) => InkWell(
                                    onTap: () {},
                                    child: ExpansionTile(
                                      collapsedShape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                                      shape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                                      backgroundColor: AppColors.backgroundWhite,
                                      collapsedBackgroundColor: AppColors.backgroundWhite,
                                      title: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 5),
                                        child: Row(
                                          children: [
                                            Text(
                                              textAlign: TextAlign.center,
                                              controller.attachmentDic.keys.elementAt(index),
                                              style: AppFonts.medium(16, AppColors.textPurple),
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: Divider(
                                                color: AppColors.buttonBackgroundGrey,
                                                height: 1,
                                                thickness: 1,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 20),
                                          // height: 300,
                                          child: GridView.builder(
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: (MediaQuery.of(context).size.width.toInt() / 140).toInt(), // Number of columns
                                              crossAxisSpacing: Dimen.margin15, // Horizontal space between items
                                              mainAxisSpacing: Dimen.margin15, // Vertical space between items
                                              childAspectRatio: 0.9, // Adjust the height-to-width ratio of the grid items
                                            ),
                                            padding: EdgeInsets.only(top: 20),
                                            itemBuilder: (context, subindex) {
                                              return Container(
                                                height: 200,
                                                width: 140,
                                                child: Column(
                                                  children: [
                                                    SizedBox(height: 10),
                                                    Stack(
                                                      children: [
                                                        Container(
                                                          height: 120,
                                                          width: 120,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(color: AppColors.buttonBackgroundGrey.withValues(alpha: 0.8)),
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          padding: const EdgeInsets.only(bottom: Dimen.margin2),
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(8),
                                                            child: Container(
                                                              color: AppColors.backgroundPdfAttchment,
                                                              width: 120,
                                                              height: 120,
                                                              child: Center(
                                                                child:
                                                                    // (index % 2 == 0)
                                                                    //     ? Image.asset(
                                                                    //         ImagePath.pdf,
                                                                    //         width: 60,
                                                                    //         height: 60,
                                                                    //         fit: BoxFit.contain,
                                                                    //       )
                                                                    //     :
                                                                    BaseImageView(
                                                                  imageUrl: controller.attachmentDic.values.elementAt(index)[subindex].filePath ?? "",
                                                                  width: 120,
                                                                  height: 120,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          top: -20,
                                                          right: -20,
                                                          child: Container(
                                                            width: 50,
                                                            height: 50,
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              color: Colors.white,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors.black.withOpacity(0.25),
                                                                  blurRadius: 8,
                                                                  offset: Offset(2, 2),
                                                                ),
                                                              ],
                                                            ),
                                                            child: GestureDetector(
                                                              onTap: () {
                                                                showDialog(
                                                                  context: context,
                                                                  barrierDismissible: true,
                                                                  builder: (BuildContext context) {
                                                                    return DeleteImageDialog();
                                                                  },
                                                                );
                                                              },
                                                              child: SvgPicture.asset(
                                                                ImagePath.delete_round,
                                                                height: 50,
                                                                width: 50,
                                                                fit: BoxFit.cover,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            itemCount: controller.attachmentDic.values.elementAt(index).length,
                                          ),
                                        ),
                                        // Row(
                                        //   children: [
                                        //     SizedBox(width: 20),
                                        //     Stack(
                                        //       children: [
                                        //         Padding(
                                        //           padding: const EdgeInsets.only(right: 10),
                                        //           child: BaseImageView(
                                        //             imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ4YreOWfDX3kK-QLAbAL4ufCPc84ol2MA8Xg&s",
                                        //             width: 70,
                                        //             height: 70,
                                        //           ),
                                        //         ),
                                        //         Positioned(
                                        //           bottom: -10,
                                        //           right: -3,
                                        //           child: SvgPicture.asset(
                                        //             ImagePath.camera,
                                        //             height: 44,
                                        //             width: 44,
                                        //           ),
                                        //         )
                                        //       ],
                                        //     ),
                                        //     SizedBox(
                                        //       width: 20,
                                        //     ),
                                        //     Expanded(
                                        //         child: Row(
                                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //       children: [
                                        //         Column(
                                        //           crossAxisAlignment: CrossAxisAlignment.start,
                                        //           children: [
                                        //             Text(
                                        //               textAlign: TextAlign.center,
                                        //               "Don Jones",
                                        //               style: AppFonts.medium(15, AppColors.textBlack),
                                        //             ),
                                        //             SizedBox(
                                        //               width: 15,
                                        //             ),
                                        //             Text(
                                        //               textAlign: TextAlign.center,
                                        //               "12345678",
                                        //               style: AppFonts.regular(13, AppColors.textGrey),
                                        //             ),
                                        //           ],
                                        //         ),
                                        //         Column(
                                        //           children: [
                                        //             Text(
                                        //               textAlign: TextAlign.center,
                                        //               "Age",
                                        //               style: AppFonts.medium(15, AppColors.textBlack),
                                        //             ),
                                        //             SizedBox(
                                        //               width: 15,
                                        //             ),
                                        //             Text(
                                        //               textAlign: TextAlign.center,
                                        //               "52",
                                        //               style: AppFonts.regular(13, AppColors.textGrey),
                                        //             ),
                                        //           ],
                                        //         ),
                                        //         Column(
                                        //           children: [
                                        //             Text(
                                        //               textAlign: TextAlign.center,
                                        //               "Gender",
                                        //               style: AppFonts.medium(15, AppColors.textBlack),
                                        //             ),
                                        //             SizedBox(
                                        //               width: 15,
                                        //             ),
                                        //             Text(
                                        //               textAlign: TextAlign.center,
                                        //               "Male",
                                        //               style: AppFonts.regular(13, AppColors.textGrey),
                                        //             ),
                                        //           ],
                                        //         ),
                                        //         Column(
                                        //           children: [
                                        //             Text(
                                        //               textAlign: TextAlign.center,
                                        //               "Visit Date & Time",
                                        //               style: AppFonts.medium(15, AppColors.textBlack),
                                        //             ),
                                        //             SizedBox(
                                        //               width: 15,
                                        //             ),
                                        //             Text(
                                        //               textAlign: TextAlign.center,
                                        //               "10/12/2024  10:30 am",
                                        //               style: AppFonts.regular(13, AppColors.textGrey),
                                        //             ),
                                        //           ],
                                        //         )
                                        //       ],
                                        //     )),
                                        //     SizedBox(
                                        //       width: 30,
                                        //     )
                                        //   ],
                                        // ),
                                        SizedBox(
                                          height: 20,
                                        )
                                        // ExpansionTile(
                                        //   title: Text(
                                        //     'Sub title',
                                        //   ),
                                        //   children: <Widget>[
                                        //     // ListTile(
                                        //     //   title: Text('data'),
                                        //     // )
                                        //   ],
                                        // ),
                                        // ListTile(
                                        //   title: Text('data'),
                                        // )
                                      ],
                                    ),
                                  ),
                              itemCount: controller.attachmentDic.keys.length)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Obx(() {
                return Container(
                  color: AppColors.backgroundLightBlue,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Container(
                    // color: AppColors.backgroundWhite,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.backgroundWhite),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Row(
                      spacing: 15,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                barrierDismissible: true, // Allows dismissing the dialog by tapping outside
                                builder: (BuildContext context) {
                                  return ViewAttchmentImage(); // Our custom dialog
                                },
                              );
                            },
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.textGrey.withValues(alpha: 0.5)),
                                color: AppColors.backgroundLightGrey,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        ImagePath.add_photo,
                                        height: 30,
                                        width: 30,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        textAlign: TextAlign.center,
                                        "Add a Photo",
                                        style: AppFonts.medium(16, AppColors.textBlack),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (controller.isStartRecording.value == false) ...[
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                controller.isStartRecording.value = true;
                              },
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.backgroundPurple),
                                  color: AppColors.backgroundPurple,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          ImagePath.ai_white,
                                          height: 30,
                                          width: 30,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          textAlign: TextAlign.center,
                                          "Start Transcribing",
                                          style: AppFonts.medium(16, AppColors.textWhite),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                        if (controller.isStartRecording.value) ...[
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.PATIENT_INFO);
                              },
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.buttonBackgroundGreen),
                                  color: AppColors.buttonBackgroundGreen,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          ImagePath.pause,
                                          height: 30,
                                          width: 30,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          textAlign: TextAlign.center,
                                          "Pause",
                                          style: AppFonts.medium(16, AppColors.textWhite),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                controller.isStartRecording.value = false;
                              },
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.buttonBackgroundred),
                                  color: AppColors.buttonBackgroundred,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          ImagePath.stop_transcript,
                                          height: 30,
                                          width: 30,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          textAlign: TextAlign.center,
                                          "Stop Transcribing",
                                          style: AppFonts.medium(16, AppColors.textWhite),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                );
              })
            ],
          );
        }),
      ),
    );
  }
}

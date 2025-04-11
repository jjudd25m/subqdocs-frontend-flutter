import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:subqdocs/app/modules/add_patient/controllers/add_patient_controller.dart';
import 'package:subqdocs/app/modules/visit_main/controllers/visit_main_controller.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/utils/app_fonts.dart';
import 'package:subqdocs/widgets/custom_button.dart';

import '../../../../services/media_picker_services.dart';

class attachmentDailog extends StatelessWidget {
  VisitMainController controller;
  attachmentDailog(this.controller);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 16,
      child: Container(
        constraints: BoxConstraints(maxHeight: Get.height * .80, maxWidth: Get.width * .50),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListView(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          children: [
            Container(
              width: 360,
              color: AppColors.backgroundPurple,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Add Attachments",
                      style: AppFonts.medium(14, Colors.white),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        controller.list.clear();
                        Get.back();
                      },
                      child: SvgPicture.asset(
                        "assets/images/cross_white.svg",
                        width: 15,
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 360,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    DottedBorder(
                      color: AppColors.textDarkGrey,
                      strokeWidth: 0.5,
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            SvgPicture.asset("assets/images/upload_image.svg"),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                              child: Text(
                                "Upload and manage Photos",
                                style: AppFonts.medium(14, AppColors.black),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 80, right: 80),
                              child: CustomButton(
                                  navigate: () async {
                                    await controller.pickFiles(context, clear: false);
                                  },
                                  label: "Choose Files"),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Supported Formats: JPG, PNG, WEBP, MP3, WAV,MP4, DOC, PDF",
                      textAlign: TextAlign.start,
                      style: AppFonts.medium(
                        10,
                        AppColors.textDarkGrey,
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    CustomButton(
                      navigate: () async {
                        await controller.captureImage(context, fromCamera: true, clear: false);
                      },
                      label: "Take a photo",
                      backGround: Colors.white,
                      isTrue: false,
                      textColor: AppColors.backgroundPurple,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 360,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Obx(() {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Files",
                        style: AppFonts.medium(16, AppColors.black),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Container(
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
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset("assets/images/placeholde_image.svg"),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(controller.list.value[index].fileName ?? ""),
                                            //
                                            Text(controller.visitId.value),
                                            Text("${controller.list.value[index].date ?? " "} |  ${controller.list.value[index].Size ?? ""}"),

                                            if (controller.list.value[index].isGraterThan10 ?? false)
                                              Text(
                                                "File Size must not exceed 10 MB",
                                                style: AppFonts.medium(15, Colors.red),
                                              )
                                          ],
                                        ),
                                        Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            controller.list.removeAt(index);
                                            controller.list.refresh();
                                          },
                                          child: SvgPicture.asset(
                                            "assets/images/logo_cross.svg",
                                            width: 18,
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                            );
                          },
                          itemCount: controller.list.length),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              navigate: () {
                                Get.back();
                              },
                              label: "Cancel",
                              backGround: Colors.white,
                              isTrue: false,
                              textColor: AppColors.backgroundPurple,
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: CustomButton(
                              navigate: () {
                                Get.back();
                                controller.uploadAttachments();
                              },
                              label: "Add",
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}

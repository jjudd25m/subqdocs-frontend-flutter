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

class attachmentDailog extends GetView<VisitMainController> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 16,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                        Navigator.pop(context);

                        // controller.list.clear();
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
            Container(
              width: 360,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
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
                                  child: Obx(
                                    () {
                                      return Row(
                                        children: [
                                          SvgPicture.asset("assets/images/placeholde_image.svg"),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(controller.list.value[index].fileName ?? ""),
                                              Text(controller.visitId.value),
                                              Text(
                                                  "${controller.list.value[index].date ?? " "} |  ${controller.list.value[index].Size ?? ""}"),
                                            ],
                                          ),
                                          Spacer(),
                                          GestureDetector(
                                            onTap: () {
                                              // controller.removeItem(index);
                                            },
                                            child: SvgPicture.asset(
                                              "assets/images/logo_cross.svg",
                                              width: 18,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
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
                              Navigator.pop(context);
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
                              // controller.addImage(
                              // )
                              Navigator.pop(context);
                              controller.uploadAttachments();

                              //

                              // Navigator.pop(context);
                            },
                            label: "Add",
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

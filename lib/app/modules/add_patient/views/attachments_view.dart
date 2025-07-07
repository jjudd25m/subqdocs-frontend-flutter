import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:subqdocs/app/modules/add_patient/controllers/add_patient_controller.dart';

import '../../../../utils/FileOpener.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_diamentions.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../../visit_main/views/delete_image_dialog.dart';

class AttachmentsView extends StatelessWidget {
  final AddPatientController controller;

  const AttachmentsView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimen.margin16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 0.5, color: AppColors.appbarBorder),
        ),
        child: Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: ExpansionTile(
            initiallyExpanded: true,
            shape: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: AppColors.backgroundPurple.withValues(alpha: 0.2),
            collapsedShape: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8),
            ),
            collapsedBackgroundColor: AppColors.backgroundPurple.withValues(
              alpha: 0.2,
            ),
            title: Row(
              children: [
                const SizedBox(width: 10),
                Text(
                  "Attachments",
                  textAlign: TextAlign.center,
                  style: AppFonts.medium(16, AppColors.textBlack),
                ),
              ],
            ),
            children: <Widget>[
              Obx(() {
                return Container(
                  color: Colors.white,
                  child:
                      controller.selectedList.isNotEmpty
                          ? Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: SizedBox(
                              height: 200,
                              width: double.infinity,
                              child: Obx(() {
                                return ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.only(top: 20),
                                  itemCount: controller.selectedList.length,
                                  separatorBuilder:
                                      (context, index) =>
                                          const SizedBox(width: Dimen.margin15),
                                  itemBuilder: (context, index) {
                                    final fileItem =
                                        controller.selectedList[index];
                                    final filePath = fileItem.file?.path ?? "";
                                    final isImage =
                                        controller.getFileExtension(filePath) ==
                                        "image";

                                    return SizedBox(
                                      height: 200,
                                      width: 140,
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 10),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Stack(
                                                clipBehavior: Clip.none,
                                                alignment: Alignment.topRight,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color:
                                                          AppColors
                                                              .appbarBorder,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                    ),
                                                    width: 120,
                                                    height: 120,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        FileOpener.openDocument(
                                                          filePath,
                                                        );
                                                      },
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                        child:
                                                            isImage
                                                                ? Image.file(
                                                                  fileItem
                                                                      .file!,
                                                                  fit:
                                                                      BoxFit
                                                                          .cover,
                                                                )
                                                                : Image.asset(
                                                                  ImagePath
                                                                      .file_placeHolder,
                                                                ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: -10,
                                                    right: -10,
                                                    child: Container(
                                                      width: 40,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black
                                                                .withValues(
                                                                  alpha: 0.2,
                                                                ),
                                                            blurRadius: 2.2,
                                                            offset:
                                                                const Offset(
                                                                  0.2,
                                                                  0,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          showDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                true,
                                                            builder: (context) {
                                                              return DeleteImageDialog(
                                                                onDelete: () {
                                                                  controller
                                                                      .deleteAttachments(
                                                                        index,
                                                                      );
                                                                },
                                                                extension: controller
                                                                    .getFileExtension(
                                                                      filePath,
                                                                    ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                        child: SvgPicture.asset(
                                                          ImagePath
                                                              .delete_black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                fileItem.fileName ?? "",
                                                style: AppFonts.regular(
                                                  12,
                                                  AppColors.textDarkGrey,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                fileItem.date ?? "",
                                                style: AppFonts.regular(
                                                  12,
                                                  AppColors.textDarkGrey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }),
                            ),
                          )
                          : const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: SizedBox(
                              width: double.infinity,
                              height: 200,
                              child: Center(
                                child: Text("Attachments Not available"),
                              ),
                            ),
                          ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

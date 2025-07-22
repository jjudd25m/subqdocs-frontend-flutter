import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Added for SvgPicture
import 'package:get/get.dart';
import 'package:subqdocs/utils/imagepath.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_diamentions.dart';
import '../../../../utils/app_fonts.dart';
import '../controllers/patient_info_controller.dart';
import 'home_custom_search_bar.dart';

class TemplateBottomsheet extends StatelessWidget {
  final VoidCallback onTap;
  PatientInfoController controller;
  RxBool isExpandedDoctor = RxBool(false);
  RxBool isExpandedMedicalAssistant = RxBool(false);

  final List<Map<String, dynamic>> templatesList = [
    {
      'name': 'General Note',
      'features': ['SOAP', 'Quick Fill', 'AI Suggest', 'Favorites'],
    },
    {
      'name': 'Dermatology',
      'features': ['Skin', 'Lesion', 'Photo'],
    },
    {
      'name': 'Follow Up',
      'features': ['SOAP', 'Summary'],
    },
  ];

  TemplateBottomsheet({super.key, required this.controller, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Ensures full width
      child: Container(
        decoration: const BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(12)), color: AppColors.backgroundWhite),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              color: AppColors.lightpurpule,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimen.margin20, vertical: Dimen.margin10),
                child: Column(
                  children: [
                    // const SizedBox(height: 20),
                    Row(
                      children: [
                        Text("Select a Template", style: AppFonts.medium(16, AppColors.textPurple)),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                            onTap();
                          },
                          child: Padding(padding: const EdgeInsets.all(8.0), child: SvgPicture.asset(ImagePath.cross_white, width: 15, height: 15, colorFilter: const ColorFilter.mode(AppColors.textPurple, BlendMode.srcIn))),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimen.margin20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      SizedBox(
                        height: 42,
                        width: double.infinity,
                        child: Obx(() {
                          return HomeCustomSearchBar(border: Border.all(color: AppColors.textGrey.withValues(alpha: 0.5), width: 0.5), showClearButton: controller.showTemplateSearchClearButton.value, controller: controller.templateSearchController, hintText: 'Search Template ', onChanged: (text) {}, onSubmit: (text) {});
                        }),
                      ),
                      const SizedBox(height: 20),
                      // Template List Container
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white, // or AppColors.backgroundWhite if you want
                          borderRadius: BorderRadius.circular(12), // Adjust the radius as needed
                          border: Border.all(
                            color: AppColors.filterBorder, // Choose your border color
                            width: 1, // Adjust the border width as needed
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(padding: const EdgeInsets.all(10.0), child: Row(children: [Text("Possible templates to add", style: AppFonts.medium(16, AppColors.textPurple))])),

                            SizedBox(
                              // height: 300,
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: templatesList.length, // Use templatesList
                                itemBuilder: (context, index) {
                                  final template = templatesList[index];
                                  final features = template['features'] as List<String>;
                                  final visibleFeatures = features.take(2).join(', ');
                                  final extraCount = features.length - 2;
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        // 1. SVG Icon and Template Name
                                        SvgPicture.asset(
                                          ImagePath.template, // <-- Replace with actual template icon path
                                          width: 20,
                                          height: 20,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(template['name'], style: AppFonts.medium(14, AppColors.textDarkGrey))])),
                                        const Spacer(),
                                        Row(children: [Text(visibleFeatures + (extraCount > 0 ? ', +$extraCount' : ''), style: AppFonts.regular(13, AppColors.textGrey), overflow: TextOverflow.ellipsis)]),
                                        const Spacer(),
                                        TextButton(
                                          onPressed: onTap,
                                          style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0), minimumSize: const Size(0, 32), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                                          child: Text('View', style: AppFonts.medium(14, AppColors.textPurple).copyWith(decoration: TextDecoration.underline, decorationColor: AppColors.textPurple, decorationThickness: 2)),
                                        ),
                                        const SizedBox(width: 10),
                                        // 3. Use Template Button
                                        TextButton(
                                          onPressed: onTap,
                                          style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0), minimumSize: const Size(0, 32), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                                          child: Text('Use Template', style: AppFonts.medium(14, AppColors.textPurple).copyWith(decoration: TextDecoration.underline, decorationColor: AppColors.textPurple, decorationThickness: 2)),
                                        ),
                                        // 4. 3-dot menu
                                        PopupMenuButton<String>(
                                          icon: const Icon(Icons.more_vert, color: AppColors.textPurple),
                                          onSelected: (value) {
                                            if (value == 'edit') {
                                              // TODO: Implement edit logic
                                            } else if (value == 'delete') {
                                              // TODO: Implement delete logic
                                            }
                                          },
                                          itemBuilder: (context) => [const PopupMenuItem(value: 'edit', child: Text('Edit')), const PopupMenuItem(value: 'delete', child: Text('Delete'))],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white, // or AppColors.backgroundWhite if you want
                          borderRadius: BorderRadius.circular(12), // Adjust the radius as needed
                          border: Border.all(
                            color: AppColors.filterBorder, // Choose your border color
                            width: 1, // Adjust the border width as needed
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(padding: const EdgeInsets.all(10.0), child: Row(children: [Text("Templates ", style: AppFonts.medium(16, AppColors.textPurple))])),

                            SizedBox(
                              // height: 300,
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: templatesList.length, // Use templatesList
                                itemBuilder: (context, index) {
                                  final template = templatesList[index];
                                  final features = template['features'] as List<String>;
                                  final visibleFeatures = features.take(2).join(', ');
                                  final extraCount = features.length - 2;
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        // 1. SVG Icon and Template Name
                                        SvgPicture.asset(
                                          ImagePath.template, // <-- Replace with actual template icon path
                                          width: 20,
                                          height: 20,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(template['name'], style: AppFonts.medium(14, AppColors.textDarkGrey))])),
                                        const Spacer(),
                                        Row(children: [Text(visibleFeatures + (extraCount > 0 ? ', +$extraCount' : ''), style: AppFonts.regular(13, AppColors.textGrey), overflow: TextOverflow.ellipsis)]),
                                        const Spacer(),
                                        TextButton(
                                          onPressed: onTap,
                                          style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0), minimumSize: const Size(0, 32), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                                          child: Text('View', style: AppFonts.medium(14, AppColors.textPurple).copyWith(decoration: TextDecoration.underline, decorationColor: AppColors.textPurple, decorationThickness: 2)),
                                        ),
                                        const SizedBox(width: 10),
                                        // 3. Use Template Button
                                        TextButton(
                                          onPressed: onTap,
                                          style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0), minimumSize: const Size(0, 32), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                                          child: Text('Use Template', style: AppFonts.medium(14, AppColors.textPurple).copyWith(decoration: TextDecoration.underline, decorationColor: AppColors.textPurple, decorationThickness: 2)),
                                        ),
                                        // 4. 3-dot menu
                                        PopupMenuButton<String>(
                                          icon: const Icon(Icons.more_vert, color: AppColors.textPurple),
                                          onSelected: (value) {
                                            if (value == 'edit') {
                                              // TODO: Implement edit logic
                                            } else if (value == 'delete') {
                                              // TODO: Implement delete logic
                                            }
                                          },
                                          itemBuilder: (context) => [const PopupMenuItem(value: 'edit', child: Text('Edit')), const PopupMenuItem(value: 'delete', child: Text('Delete'))],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

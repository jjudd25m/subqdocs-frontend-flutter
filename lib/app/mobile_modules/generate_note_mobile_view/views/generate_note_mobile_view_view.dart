import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:subqdocs/widgets/custom_animated_button.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../../../../widgets/base_screen_mobile.dart';
import '../../../../widgets/custom_tab_button.dart';
import '../../../routes/app_pages.dart';
import '../controllers/generate_note_mobile_view_controller.dart';

class GenerateNoteMobileViewView extends GetView<GenerateNoteMobileViewController> {
  GenerateNoteMobileViewView({super.key});

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BaseScreenMobile(
      onItemSelected: (index) async {},
      body: Column(
        children: [
          Expanded(
            child: Expanded(
              child: Container(
                width: double.infinity,
                color: AppColors.backgroundMobileAppbar,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 15,
                    children: [
                      SvgPicture.asset(ImagePath.medical_notes_generated, width: MediaQuery.of(context).size.width * 0.8),
                      const SizedBox(height: 10),
                      SvgPicture.asset(ImagePath.divider_medical_note, width: MediaQuery.of(context).size.width * 0.6),
                      const SizedBox(height: 10),
                      Center(child: Text("Want to review this note on your computer?", textAlign: TextAlign.center, style: AppFonts.regular(16.0, AppColors.black))),
                      const SizedBox(height: 10),
                      const Center(child: SizedBox(width: 150, child: CustomAnimatedButton(text: "Email links", height: 45, isOutline: true, outlineColor: AppColors.backgroundPurple, enabledColor: AppColors.clear, enabledTextColor: AppColors.backgroundPurple, outLineWidth: 1))),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: CustomTabButton(onPressed: () async {
            Get.until((route) => Get.currentRoute == Routes.HOME_VIEW_MOBILE);
          }, text: "Return to the Home screen", enabledColor: AppColors.backgroundPurple, borderRadius: 10)),
        ],
      ),
      globalKey: _key,
    );
  }
}

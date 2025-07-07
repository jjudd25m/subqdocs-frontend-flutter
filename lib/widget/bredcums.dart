import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/utils/app_fonts.dart';
import 'package:subqdocs/utils/imagepath.dart';

import '../app/core/common/global_controller.dart';
import '../app/routes/app_pages.dart';

class BreadcrumbWidget extends StatelessWidget {
  List<String> breadcrumbHistory;

  // final VoidCallback? onBack(String bredcums);

  final void Function(String) onBack;

  BreadcrumbWidget({super.key, required this.breadcrumbHistory, required this.onBack});

  @override
  Widget build(BuildContext context) {
    // Get the current route from GetX
    var route = Routes.HOME;

    // final GlobalController controller = Get.find();

    final GlobalController globalController = Get.find();

    if (breadcrumbHistory.isEmpty) {
      // Build breadcrumb trail based on the route
      globalController.breadcrumbs.forEach((key, value) {
        if (route.contains(key)) {
          breadcrumbHistory.add(value);
        }
      });
    }

    // We will use a ListView to display the breadcrumb
    return Wrap(
      key: UniqueKey(),
      children:
          breadcrumbHistory.map((breadcrumb) {
            bool isLast = breadcrumb == breadcrumbHistory.last;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap:
                      isLast
                          ? null // Do nothing for the last item
                          : () {
                            globalController.closeFormState = 0;
                            globalController.breadcrumbHistory.refresh();
                            onBack(breadcrumb);
                          },
                  child: Text(breadcrumb, style: AppFonts.regular(14, isLast ? AppColors.textBlack : AppColors.textGrey)),
                ),
                const SizedBox(width: 10),
                if (!isLast) SvgPicture.asset(ImagePath.bredCums),
                const SizedBox(width: 11),
              ],
            );
          }).toList(),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/utils/app_fonts.dart';

import '../app/core/common/global_controller.dart';
import '../app/routes/app_pages.dart';

class BreadcrumbWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the current route from GetX
    var route = Get.currentRoute;

    // final GlobalController controller = Get.find();


    // final GlobalController globalController = Get.find();

    GlobalController globalController = Get.find<GlobalController>();
    if(globalController.breadcrumbHistory.isEmpty) {
      // Build breadcrumb trail based on the route
      globalController.breadcrumbs.forEach((key, value) {
        if (route.contains(key)) {
          globalController.breadcrumbHistory.add(value);
        }
      });
    }

    // We will use a ListView to display the breadcrumb
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        children: globalController.breadcrumbHistory.map((breadcrumb) {
          bool isLast = breadcrumb == globalController.breadcrumbHistory.last;
          return Row(
            mainAxisSize: MainAxisSize.min
            ,
            children: [
              InkWell(
                onTap: isLast
                    ? null // Do nothing for the last item
                    : () {
                  globalController.popUntilRoute(breadcrumb);
                  Get.offAllNamed(globalController.getKeyByValue(breadcrumb));

                },
                child: Text(
                    breadcrumb,
                    style:AppFonts.regular(14, isLast ? AppColors.textBlack : AppColors.textGrey)
                ),
              ),
              SizedBox(width: 10,),
              if(!isLast) Text(">",style:AppFonts.regular(14, isLast ? AppColors.textBlack : AppColors.textGrey)),

              SizedBox(width: 10,),
            ],
          );
        }).toList(),
      ),
    );
  }
}

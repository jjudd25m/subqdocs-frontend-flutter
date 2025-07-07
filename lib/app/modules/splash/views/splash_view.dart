import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/utils/imagepath.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final double logoWidth = _getLogoWidth(context);

    return Scaffold(backgroundColor: AppColors.backgroundPurple, body: Center(child: SvgPicture.asset(ImagePath.subqdocs_white, width: logoWidth)));
  }

  /// Returns the appropriate logo width based on device type.
  double _getLogoWidth(BuildContext context) {
    final bool isPhone = controller.deviceType == 'iPhone' || controller.deviceType == 'Android Phone';

    return isPhone ? MediaQuery.of(context).size.width * 0.70 : MediaQuery.of(context).size.width * 0.45;
  }
}

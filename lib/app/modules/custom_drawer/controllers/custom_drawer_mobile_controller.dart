import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:subqdocs/app/core/common/global_mobile_controller.dart';
import 'package:subqdocs/app/modules/custom_drawer/Models/drawer_model.dart';
import 'package:subqdocs/app/routes/app_pages.dart';
import 'package:subqdocs/utils/imagepath.dart';

import '../../../core/common/logger.dart';

class CustomDrawerMobileController extends GetxController {
  //TODO: Implement CustomDrawerController

  final count = 0.obs;

  RxList<DrawerItemModel> drawerItemModelList = RxList();

  final GlobalMobileController globalController = Get.find();
  RxString version = RxString("");
  RxString buildNumber = RxString("");

  @override
  Future<void> onInit() async {
    drawerItemModelList.add(DrawerItemModel(drawerItemTitle: "Patient List", drawerIconPath: ImagePath.patient_list_mobile, routePath: ""));
    drawerItemModelList.add(DrawerItemModel(drawerItemTitle: "Schedule Visits", drawerIconPath: ImagePath.schedule_visits_mobile, routePath: ""));
    drawerItemModelList.add(DrawerItemModel(drawerItemTitle: "Past Visits", drawerIconPath: ImagePath.schedule_visits_mobile, routePath: ""));
    drawerItemModelList.add(DrawerItemModel(drawerItemTitle: "Settings", drawerIconPath: ImagePath.setting_mobile, routePath: ""));

    final info = await PackageInfo.fromPlatform();
    version.value = info.version;
    buildNumber.value = info.buildNumber;
    super.onInit();
  }

  void increment() => count.value++;

  void setSelectedIndexByTheScreen() {
    drawerItemModelList.forEach((element) {
      element.isSelected = false;
    });

    if (Get.currentRoute == Routes.HOME_VIEW_MOBILE) {
      drawerItemModelList[globalController.tabIndex.value].isSelected = true;
    }

    if (Get.currentRoute == Routes.PERSONAL_SETTING_MOBILE_VIEW) {
      drawerItemModelList[globalController.tabIndex.value].isSelected = true;
    }

    drawerItemModelList.refresh();
  }

  void changeSelected(int index) {
    customPrint(" selected index is the  $index");

    drawerItemModelList.forEach((element) {
      element.isSelected = false;
    });

    drawerItemModelList[index].isSelected = true;
    drawerItemModelList.refresh();
  }
}

import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:subqdocs/app/modules/custom_drawer/Models/drawer_model.dart';
import 'package:subqdocs/app/routes/app_pages.dart';
import 'package:subqdocs/utils/imagepath.dart';

import '../../../core/common/global_controller.dart';
import '../../../core/common/logger.dart';

class CustomDrawerController extends GetxController {
  //TODO: Implement CustomDrawerController

  final count = 0.obs;

  RxList<DrawerItemModel> drawerItemModelList = RxList();

  final GlobalController globalController = Get.find();
  RxString version = RxString("");
  RxString buildNumber = RxString("");

  @override
  Future<void> onInit() async {
    // drawerItemModelList.add(DrawerItemModel(drawerItemTitle: "Add New Visit", drawerIconPath: ImagePath.calendar, routePath: ""));
    drawerItemModelList.add(DrawerItemModel(drawerItemTitle: "Schedule Visit", drawerIconPath: ImagePath.calendar, routePath: ""));
    drawerItemModelList.add(DrawerItemModel(drawerItemTitle: "Scheduled Visits", drawerIconPath: ImagePath.scheduleDrawer, routePath: ""));
    drawerItemModelList.add(DrawerItemModel(drawerItemTitle: "Past Visits", drawerIconPath: ImagePath.pastDrawer, routePath: ""));
    drawerItemModelList.add(DrawerItemModel(isSelected: true, drawerItemTitle: "Patients", drawerIconPath: ImagePath.patiton_visit_drawer, routePath: ""));

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

    if (Get.currentRoute == Routes.HOME) {
      drawerItemModelList[globalController.tabIndex.value == 0 ? 3 : globalController.tabIndex.value].isSelected = true;
    }

    if (Get.currentRoute == Routes.ADD_PATIENT || Get.currentRoute == Routes.SCHEDULE_PATIENT) {
      drawerItemModelList[0].isSelected = true;
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

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:subqdocs/app/modules/custom_drawer/Models/drawer_model.dart';
import 'package:subqdocs/utils/imagepath.dart';

class CustomDrawerController extends GetxController {
  //TODO: Implement CustomDrawerController

  final count = 0.obs;

  RxList<DrawerItemModel> drawerItemModelList = RxList();

  @override
  void onInit() {
    drawerItemModelList.add(
      DrawerItemModel(
        isSelected: true,
        drawerItemTitle: "Add New Visit",
        drawerIconPath: ImagePath.calendar,
        routePath: "",
      ),
    );
    drawerItemModelList.add(
      DrawerItemModel(
        drawerItemTitle: "Scheduled Visits",
        drawerIconPath: ImagePath.scheduleDrawer,
        routePath: "",
      ),
    );
    drawerItemModelList.add(
      DrawerItemModel(
        drawerItemTitle: "Past Visits",
        drawerIconPath: ImagePath.pastDrawer,
        routePath: "",
      ),
    );
    drawerItemModelList.add(
      DrawerItemModel(
        drawerItemTitle: "Patient Visits",
        drawerIconPath: ImagePath.patiton_visit_drawer,
        routePath: "",
      ),
    );
    drawerItemModelList.add(
      DrawerItemModel(
        drawerItemTitle: "Settings",
        drawerIconPath: ImagePath.settingsDrawer,
        routePath: "",
      ),
    );

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  void changeSelected(int index) {
    drawerItemModelList.forEach(
      (element) {
        element.isSelected = false;
      },
    );

    drawerItemModelList[index].isSelected = true;
    drawerItemModelList.refresh();
  }
}

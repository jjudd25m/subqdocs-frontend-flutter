import 'package:get/get.dart';

class GenerateNoteMobileViewController extends GetxController {
  //TODO: Implement GenerateNoteMobileViewController

  String patientId = "";
  String visitId = "";

  @override
  void onInit() {
    super.onInit();

    patientId = Get.arguments["patientId"];
    visitId = Get.arguments["visitId"];
  }
}

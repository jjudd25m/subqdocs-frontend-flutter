import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';
import '../../../../widgets/custom_toastification.dart';
import '../../../core/common/global_controller.dart';
import '../../../routes/app_pages.dart';
import '../../forgot_password/models/common_respons.dart';
import '../../visit_main/model/all_attachment_list_model.dart';
import '../../visit_main/repository/visit_main_repository.dart';

class AllAttachmentController extends GetxController {
  //TODO: Implement AllAttachmentController
  RxBool isStartRecording = false.obs;
  final count = 0.obs;
  final GlobalController globalController = Get.find();
  RxString referesh = RxString("");

  Rxn<AllAttachmentListModel> allAttachmentList = Rxn();

  TextEditingController fromController = TextEditingController();
  List<DateTime> selectedValue = [];

  final VisitMainRepository _visitMainRepository = VisitMainRepository();
  RxString startDate = RxString("");
  RxString endDate = RxString("");

  RxString visitId = RxString("");

  @override
  void onInit() {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      globalController.addRouteInit(Routes.ALL_ATTACHMENT);
    });
    visitId.value = Get.arguments["visit_id"];

    if (visitId.value.isNotEmpty) {
      getAllPatientAttachment();
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();

    if (globalController.getKeyByValue(globalController.breadcrumbHistory.last) == Routes.ALL_ATTACHMENT) {
      globalController.popRoute();
    }
  }

  Future<void> getAllPatientAttachment() async {
    Map<String, dynamic> param = {};

    try {
      if (startDate.isNotEmpty && endDate.isNotEmpty) {
        DateTime startDateTime = DateFormat('MM/dd/yyyy').parse(startDate.value);
        String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDateTime);
        DateTime endDateTime = DateFormat('MM/dd/yyyy').parse(endDate.value);
        String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDateTime);
        param['dateRange'] = '{"startDate":"$formattedStartDate", "endDate":"$formattedEndDate"}';
      }
      allAttachmentList.value = await _visitMainRepository.getAllPatientAttachment(id: visitId.value, param: param);
    } catch (error) {}
  }

  void setDateRange() {
    if (selectedValue.isNotEmpty) {
      for (int i = 0; i < selectedValue.length; i++) {
        var dateTime = selectedValue[i];

        if (selectedValue.length == 1) {
          startDate.value = '${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}/${dateTime.year}';
          endDate.value = '${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}/${dateTime.year}';
        } else {
          if (i == 0) {
            startDate.value = '${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}/${dateTime.year}';
          } else {
            endDate.value = '${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}/${dateTime.year}';
          }
        }
      }
    } else {
      DateTime dateTime = DateTime.now();
      startDate.value = '${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}/${dateTime.year}';
      endDate.value = '${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}/${dateTime.year}';
    }

    fromController.text = "${startDate} - ${endDate}";

    Get.back();
  }

  void deleteAttachments(int index, int subIndex, int id) async {
    if (id != 1) {
      Map<String, List<int>> params = {};
      params["attachments"] = [id];

      print("attch :- ${params}");
      CommonResponse commonResponse = await _visitMainRepository.deleteAttachments(params: params);

      if (commonResponse.responseType == "success") {
        CustomToastification().showToast(commonResponse.message ?? "", type: ToastificationType.success);
        getAllPatientAttachment();
      } else {
        CustomToastification().showToast(commonResponse.message ?? "", type: ToastificationType.error);
      }
      Get.back();
    } else {
      CustomToastification().showToast("something went wrong " ?? "", type: ToastificationType.error);
      Get.back();
    }
  }
}

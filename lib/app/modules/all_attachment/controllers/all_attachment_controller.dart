import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../widgets/custom_toastification.dart';
import '../../../core/common/global_controller.dart';
import '../../../routes/app_pages.dart';
import '../../forgot_password/models/common_respons.dart';
import '../../visit_main/model/all_attachment_list_model.dart';
import '../../visit_main/model/patient_attachment_list_model.dart';
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
  // RxMap<String, List<ResponseData>> attachmentDic = RxMap<String, List<ResponseData>>();

  RxString visitId = RxString("");

  @override
  void onInit() {
    super.onInit();
    globalController.addRouteInit(Routes.ALL_ATTACHMENT);
    visitId.value = Get.arguments["visit_id"];
    // patientAttachmentList = Get.arguments["attachmentList"];

    if(visitId.value.isNotEmpty)
      {
        getAllPatientAttachment();
      }

  }


  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();

    globalController.popRoute();
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

      // print("All attachment is :- ${patientAttachmentList.value?.responseData?.length}");
      //
      // Map<String, List<ResponseData>> groupedAttachments = groupAttachmentsByDate(patientAttachmentList.value?.responseData ?? []);
      //
      // attachmentDic.value = groupedAttachments;
      //
      // groupedAttachments.forEach((date, attachments) {
      //   print('Date: $date');
      //   attachments.forEach((attachment) {
      //     print('  - ${attachment.fileName}');
      //   });
      // });

      // Get.back();
    } catch (error) {
      // Get.back();
    }
  }




  void setDateRange() {
    // customPrint("function  is called ");

    if (selectedValue.isNotEmpty) {
      for (int i = 0; i < selectedValue.length; i++) {
        var dateTime = selectedValue[i];
        // Format the date to 'MM-dd-yyyy'
        // customPrint("goint to this ");
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

        // attachmentDic.values.elementAt(index).removeAt(subIndex);
        // attachmentDic.refresh();
      } else {
        CustomToastification().showToast(commonResponse.message ?? "", type: ToastificationType.error);
      }
      Get.back();
    } else {
      CustomToastification().showToast("something went wrong " ?? "", type: ToastificationType.error);
      Get.back();
    }
  }

  // Map<String, List<ResponseData>> groupAttachmentsByDate(List<ResponseData> responseData) {
  //   Map<String, List<ResponseData>> groupedAttachments = {};
  //
  //   // Define the date format you want
  //   var formatter = DateFormat('MM/dd/yyyy'); // Adjust format as necessary
  //
  //   for (var attachment in responseData) {
  //     // Parse the createdAt field (assuming it's in ISO 8601 format)
  //     DateTime createdAtDate = DateTime.parse(attachment.createdAt!);
  //
  //     // Format the date to MM/dd/yyyy (or whatever format you need)
  //     String formattedDate = formatter.format(createdAtDate);
  //
  //     // If the date key does not exist, create an empty list
  //     if (!groupedAttachments.containsKey(formattedDate)) {
  //       groupedAttachments[formattedDate] = [];
  //     }
  //
  //     // Add the attachment to the list for this date
  //     groupedAttachments[formattedDate]?.add(attachment);
  //   }
  //
  //   return groupedAttachments;
  // }
  //
  // Future<void> launchInAppWithBrowserOptions(Uri url) async {
  //   if (!await launchUrl(
  //     url,
  //     mode: LaunchMode.inAppBrowserView,
  //     browserConfiguration: const BrowserConfiguration(showTitle: true),
  //   )) {
  //     throw Exception('Could not launch $url');
  //   }
  // }
}

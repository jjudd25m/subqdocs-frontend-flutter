import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../widgets/custom_toastification.dart';
import '../../forgot_password/models/common_respons.dart';
import '../../visit_main/model/all_attachment_list_model.dart';
import '../../visit_main/model/patient_attachment_list_model.dart';
import '../../visit_main/repository/visit_main_repository.dart';

class AllAttachmentController extends GetxController {
  //TODO: Implement AllAttachmentController
  RxBool isStartRecording = false.obs;
  final count = 0.obs;

  RxString referesh = RxString("");

  Rxn<AllAttachmentListModel> allAttachmentList = Rxn();

  final VisitMainRepository _visitMainRepository = VisitMainRepository();

  // RxMap<String, List<ResponseData>> attachmentDic = RxMap<String, List<ResponseData>>();

  RxString visitId = RxString("");

  @override
  void onInit() {
    super.onInit();

    visitId.value = Get.arguments["visit_id"];
    // patientAttachmentList = Get.arguments["attachmentList"];

    if(visitId.value.isNotEmpty)
      {
        getAllPatientAttachment();
      }

  }

  Future<void> getAllPatientAttachment() async {
    Map<String, dynamic> param = {};

    try {

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

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../visit_main/model/patient_attachment_list_model.dart';

class AllAttachmentController extends GetxController {
  //TODO: Implement AllAttachmentController
  RxBool isStartRecording = false.obs;
  final count = 0.obs;

  Rxn<PatientAttachmentListModel> patientAttachmentList = Rxn();

  Map<String, List<ResponseData>> attachmentDic = Map<String, List<ResponseData>>();

  @override
  void onInit() {
    super.onInit();

    patientAttachmentList = Get.arguments["attachmentList"];

    Map<String, List<ResponseData>> groupedAttachments = groupAttachmentsByDate(patientAttachmentList.value?.responseData ?? []);

    attachmentDic = groupedAttachments;

    groupedAttachments.forEach((date, attachments) {
      print('Date: $date');
      attachments.forEach((attachment) {
        print('  - ${attachment.fileName}');
      });
    });
  }

  Map<String, List<ResponseData>> groupAttachmentsByDate(List<ResponseData> responseData) {
    Map<String, List<ResponseData>> groupedAttachments = {};

    // Define the date format you want
    var formatter = DateFormat('MM/dd/yyyy'); // Adjust format as necessary

    for (var attachment in responseData) {
      // Parse the createdAt field (assuming it's in ISO 8601 format)
      DateTime createdAtDate = DateTime.parse(attachment.createdAt!);

      // Format the date to MM/dd/yyyy (or whatever format you need)
      String formattedDate = formatter.format(createdAtDate);

      // If the date key does not exist, create an empty list
      if (!groupedAttachments.containsKey(formattedDate)) {
        groupedAttachments[formattedDate] = [];
      }

      // Add the attachment to the list for this date
      groupedAttachments[formattedDate]?.add(attachment);
    }

    return groupedAttachments;
  }
}

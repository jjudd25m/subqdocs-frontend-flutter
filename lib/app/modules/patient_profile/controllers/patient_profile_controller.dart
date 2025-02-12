import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../edit_patient_details/model/patient_detail_model.dart';
import '../../edit_patient_details/repository/edit_patient_details_repository.dart';

class PatientProfileController extends GetxController {
  //TODO: Implement PatientProfileController

  final EditPatientDetailsRepository _editPatientDetailsRepository = EditPatientDetailsRepository();
  PatientDetailModel patientDetailModel = PatientDetailModel();
  String patientId = "";
  String visitId = "";
  final count = 0.obs;

  RxString dob = RxString("");

  @override
  void onInit() {
    super.onInit();
    patientId = Get.arguments["patientData"];
    visitId = Get.arguments["visitId"];

    print("our patientdata is ${patientId}");
    getPatient(patientId, visitId);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getPatient(String id, String visitId) async {
    Map<String, dynamic> param = {};

    if (visitId != "") {
      param['visit_id'] = visitId;
    }

    patientDetailModel = await _editPatientDetailsRepository.getPatient(id: id, param: param);

    // firstNameController.text = patientDetailModel.responseData?.firstName ?? "";
    // middleNameController.text = patientDetailModel.responseData?.middleName ?? "";
    // lastNameController.text = patientDetailModel.responseData?.lastName ?? "";
    //
    // print("dob is :- ${patientDetailModel.responseData?.dateOfBirth}");
    //
    // Parse the date string to a DateTime object
    DateTime dateTime = DateTime.parse(patientDetailModel.responseData?.dateOfBirth ?? "").toLocal();

    // Create a DateFormat to format the date
    DateFormat dateFormat = DateFormat('MM/dd/yyyy');

    // Format the DateTime object to the desired format
    String formattedDate = dateFormat.format(dateTime);
    dob.value = formattedDate;
    // print("dob is :- $formattedDate");
    //
    // emailAddressController.text = patientDetailModel.responseData?.email ?? "";
    //
    // print("dob is :- ${patientDetailModel.responseData?.dateOfBirth}");
    //
    // // Parse the date string to a DateTime object
    // DateTime visitdateTime = DateTime.parse(patientDetailModel.responseData?.visitTime ?? "").toLocal();
    //
    // // Create a DateFormat to format the date
    // DateFormat visitdateFormat = DateFormat('MM/dd/yyyy');
    //
    // // Format the DateTime object to the desired format
    // String visitformattedDate = visitdateFormat.format(visitdateTime);
    //
    // visitDateController.text = visitformattedDate;
    //
    // // time
    //
    // // Parse the date string to a DateTime object
    // DateTime visitTimeS = DateTime.parse(patientDetailModel.responseData?.visitTime ?? "").toLocal();
    //
    // // Create a DateFormat to format the date
    // DateFormat visitTimeFormat = DateFormat('hh:mm a');
    //
    // // Format the DateTime object to the desired format
    // String visitformattedTime = visitTimeFormat.format(visitTimeS);
    //
    // print("visitformattedTime is:- $visitformattedTime");
    //
    // selectedVisitTimeValue.value = visitformattedTime;
    //
    // selectedSexValue.value = patientDetailModel.responseData?.gender ?? "";
    // // selectedVisitTimeValue.value = patientListData.visits?.last.visitTime ?? "";
    //
    // visitTime.value = generateTimeIntervals(visitdateTime);
    // selectedVisitTimeValue.value = visitTime.firstOrNull!;
  }
}

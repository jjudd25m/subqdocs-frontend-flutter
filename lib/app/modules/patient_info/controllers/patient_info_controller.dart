import 'dart:convert';

import 'package:get/get.dart';

import '../../../../utils/app_string.dart';
import '../../../core/common/app_preferences.dart';
import '../../../data/service/socket_service.dart';
import '../../login/model/login_model.dart';
import '../../visit_main/model/patient_transcript_upload_model.dart';
import '../model/patient_view_list_model.dart';
import '../model/transcript_list_model.dart';
import '../repository/patient_info_repository.dart';

class PatientInfoController extends GetxController {
  //TODO: Implement PatientInfoController

  final PatientInfoRepository _patientInfoRepository = PatientInfoRepository();
  SocketService socketService = SocketService();

  RxBool isSignatureDone = RxBool(false);
  List<String> tasks = ["A Task"];
  RxInt tabIndex = RxInt(1);
  final count = 0.obs;
  Rxn<TranscriptListModel> transcriptListModel = Rxn();
  Rxn<PatientViewListModel> patientViewListModel = Rxn();

  PatientTranscriptUploadModel patientTranscriptUploadModel = PatientTranscriptUploadModel();

  RxBool isFullTranscriptLoading = RxBool(false);
  RxBool isPatientViewLoading = RxBool(false);
  RxString isFullTranscriptLoadText = RxString("");
  RxString isPatientViewLoadText = RxString("");

  @override
  void onInit() {
    super.onInit();

    patientTranscriptUploadModel = Get.arguments["trascriptUploadData"];
    print("patientTranscriptUploadModel data is:- \n \n ${patientTranscriptUploadModel.toJson()}");
  }

  @override
  void onReady() {
    super.onReady();

    var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));
    print("socket status:- ${socketService.socket.connected}");
    if (socketService.socket.connected) {
      print("socket is connected");

      socketService.socket.emit("joinRoom", [loginData.responseData?.user?.id, patientTranscriptUploadModel.responseData?.visitId]);

      socketService.socket.on(
        "VisitDataStatus",
        (data) {
          print("visit data status is :- ${data}");
        },
      );

      socketService.socket.on(
        "patientViewStatus",
        (data) {
          var res = data as Map<String, dynamic>;
          print("---------------------------------------------");
          print("PatientViewStatus data:- $res");

          int visit_id = res["visit_id"];
          int transcription_id = res["transcription_id"];
          String status = res["status"];
          String message = res["message"];

          print("$visit_id == ${patientTranscriptUploadModel.responseData?.visitId} && $transcription_id == ${patientTranscriptUploadModel.responseData?.id}");

          if (visit_id == patientTranscriptUploadModel.responseData?.visitId) {
            print("inside condition");
            if (status.toLowerCase() == "pending") {
              isPatientViewLoading.value = true;
              isPatientViewLoadText.value = message;
              print("pending");
            } else if (status.toLowerCase() == "inprogress") {
              print("inprogress");
              isPatientViewLoading.value = true;
              isPatientViewLoadText.value = message;
            } else if (status.toLowerCase() == "success") {
              print("success");
              isPatientViewLoading.value = false;
              isPatientViewLoadText.value = message;
              getPatientView();
            } else if (status.toLowerCase() == "failure") {
              isPatientViewLoading.value = true;
              isPatientViewLoadText.value = "failure";
            }
          }
        },
      );

      socketService.socket.on(
        "transcriptStatus",
        (data) {
          print("---------------------------------------------");
          var res = data as Map<String, dynamic>;
          print("transcriptStatus data:- $res");

          int visit_id = res["visit_id"];
          int transcription_id = res["transcription_id"];
          String status = res["status"];
          String message = res["message"];

          print("$visit_id == ${patientTranscriptUploadModel.responseData?.visitId} && $transcription_id == ${patientTranscriptUploadModel.responseData?.id}");

          if (visit_id == patientTranscriptUploadModel.responseData?.visitId) {
            print("inside condition");
            if (status.toLowerCase() == "pending") {
              print("pending");
              isFullTranscriptLoading.value = true;
              isFullTranscriptLoadText.value = message;

              isPatientViewLoading.value = true;
              isPatientViewLoadText.value = "Patient View under process ";
            } else if (status.toLowerCase() == "inprogress") {
              print("inprogress");
              isFullTranscriptLoading.value = true;
              isFullTranscriptLoadText.value = message;
            } else if (status.toLowerCase() == "success") {
              print("success");
              isFullTranscriptLoading.value = false;
              isFullTranscriptLoadText.value = message;
              getTranscript();
            }
          }
        },
      );
    } else {
      print("socket is not connected");
    }
  }

  Future<void> getTranscript() async {
    transcriptListModel.value = await _patientInfoRepository.getTranscript(id: patientTranscriptUploadModel.responseData!.visitId.toString());
    print("transcriptListModel is :- ${transcriptListModel.value?.toJson()}");
  }

  Future<void> getPatientView() async {
    patientViewListModel.value = await _patientInfoRepository.getPatientView(id: patientTranscriptUploadModel.responseData!.visitId.toString());
    print("getPatientView is :- ${patientViewListModel.value?.toJson()}");
  }
}

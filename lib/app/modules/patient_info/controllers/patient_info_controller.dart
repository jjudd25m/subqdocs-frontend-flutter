import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../../utils/app_string.dart';
import '../../../core/common/app_preferences.dart';
import '../../../core/common/logger.dart';
import '../../../data/service/socket_service.dart';
import '../../login/model/login_model.dart';
import '../../visit_main/model/doctor_view_model.dart';
import '../../visit_main/model/patient_transcript_upload_model.dart';
import '../../visit_main/model/visitmainModel.dart';
import '../../visit_main/repository/visit_main_repository.dart';
import '../model/patient_doctor_visit_data_model.dart';
import '../model/patient_fullnote_model.dart';
import '../model/patient_view_list_model.dart';
import '../model/transcript_list_model.dart';
import '../repository/patient_info_repository.dart';
import '../views/confirm_finalize_dialog.dart';

class PatientInfoController extends GetxController {
  //TODO: Implement PatientInfoController

  final PatientInfoRepository _patientInfoRepository = PatientInfoRepository();
  SocketService socketService = SocketService();

  RxBool isPromptFailure = RxBool(false);
  RxBool isSignatureDone = RxBool(false);
  List<String> tasks = ["A Task"];
  RxInt tabIndex = RxInt(1);
  final count = 0.obs;
  Rxn<TranscriptListModel> transcriptListModel = Rxn();
  Rxn<PatientViewListModel> patientViewListModel = Rxn();
  Rxn<PatientDoctorVisitDataModel> patientDoctorVisitDataModel = Rxn();
  Rxn<PatientFullNoteModel> patientFullNoteModel = Rxn();
  Rxn<DoctorViewModel> doctorViewList = Rxn();

  PatientTranscriptUploadModel patientTranscriptUploadModel = PatientTranscriptUploadModel();

  RxBool isDoctorViewLoading = RxBool(false);
  RxString isDoctorViewLoadText = RxString("Waiting for response!");

  RxBool isFullNoteLoading = RxBool(false);
  RxString isFullNoteLoadText = RxString("Waiting for response!");

  RxBool isVisitDataLoading = RxBool(false);
  RxString isVisitDataLoadText = RxString("Waiting for response!");

  RxBool isPatientViewLoading = RxBool(false);
  RxString isPatientViewLoadText = RxString("Waiting for response!");

  RxBool isFullTranscriptLoading = RxBool(false);
  RxString isFullTranscriptLoadText = RxString("Waiting for response!");

  String visitId = "";

  Rxn<VisitMainPatientDetails> patientData = Rxn();
  final VisitMainRepository _visitMainRepository = VisitMainRepository();

  Rxn<LoginModel> loginData = Rxn();

  Future<void> getPatientDetails() async {
    patientData.value = await _visitMainRepository.getPatientDetails(id: visitId);
    print("patient data is :- ${patientData.value?.toJson()}");
    // Get.back();Get
    // back  customPrint("patientAttachmentList is:- ${patientAttachmentList.value?.toJson()}");
  }

  @override
  void onInit() async {
    super.onInit();

    loginData.value = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

    customPrint("argument is :- ${Get.arguments}");

    if (Get.arguments["visitId"] != null) {
      visitId = Get.arguments["visitId"];
      customPrint("visit id :- $visitId");
      getPatientDetails();

      var status = await InternetConnection().internetStatus;

      if (status == InternetStatus.disconnected) {
        print("you net is now Disconnected");

        offLine();
      } else {
        getAllPatientInfo();
      }

      handelInternetConnection();
    }

    if (Get.arguments["trascriptUploadData"] != null) {
      patientTranscriptUploadModel = Get.arguments["trascriptUploadData"];
      visitId = patientTranscriptUploadModel.responseData!.visitId.toString();
      customPrint("patientTranscriptUploadModel data is:- \n \n ${patientTranscriptUploadModel.toJson()}");
    }
  }

  @override
  void onReady() {
    super.onReady();

    var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

    if (patientTranscriptUploadModel.responseData != null) {
      customPrint("socket status:- ${socketService.socket.connected}");
      if (socketService.socket.connected) {
        customPrint("socket is connected");

        socketService.socket.emit("joinRoom", [loginData.responseData?.user?.id, patientTranscriptUploadModel.responseData?.visitId]);

        socketService.socket.on(
          "AllTabStatus",
          (data) {
            var res = data as Map<String, dynamic>;
            customPrint("---------------------------------------------");
            customPrint("AllTabStatus status is :- ${res}");

            int visit_id = res["visit_id"];
            int transcription_id = res["transcription_id"];
            String status = res["status"];
            String message = res["message"];

            if (status.toLowerCase() == "failure") {
              customPrint("PatientViewStatus failure");

              showPrompError(Get.context!, message);
            }
          },
        );

        socketService.socket.on(
          "DoctorsViewStatus",
          (data) {
            var res = data as Map<String, dynamic>;
            customPrint("---------------------------------------------");
            customPrint("DoctorsViewStatus status is :- $res");

            int visit_id = res["visit_id"];
            int transcription_id = res["transcription_id"];
            String status = res["status"];
            String message = res["message"];

            if (visit_id == patientTranscriptUploadModel.responseData?.visitId) {
              customPrint("DoctorsViewStatus inside condition");
              if (status.toLowerCase() == "pending") {
                customPrint("DoctorsViewStatus pending");
                isDoctorViewLoading.value = true;
                isDoctorViewLoadText.value = message;
              } else if (status.toLowerCase() == "inprogress") {
                customPrint("DoctorsViewStatus inprogress");
                isDoctorViewLoading.value = true;
                isDoctorViewLoadText.value = message;
              } else if (status.toLowerCase() == "success") {
                customPrint("DoctorsViewStatus success");
                isDoctorViewLoading.value = false;
                isDoctorViewLoadText.value = message;

                getDoctorNote();
              } else if (status.toLowerCase() == "failure") {
                isDoctorViewLoading.value = false;
                isDoctorViewLoadText.value = "failure";
              }
            }
          },
        );

        socketService.socket.on(
          "FullNoteStatus",
          (data) {
            var res = data as Map<String, dynamic>;
            customPrint("---------------------------------------------");
            customPrint("FullNoteStatus status is :- ${res}");

            int visit_id = res["visit_id"];
            int transcription_id = res["transcription_id"];
            String status = res["status"];
            String message = res["message"];

            if (visit_id == patientTranscriptUploadModel.responseData?.visitId) {
              customPrint("FullNoteStatus inside condition");
              if (status.toLowerCase() == "pending") {
                customPrint("FullNoteStatus pending");
                isFullNoteLoading.value = true;
                isFullNoteLoadText.value = message;
              } else if (status.toLowerCase() == "inprogress") {
                customPrint("FullNoteStatus inprogress");
                isFullNoteLoading.value = true;
                isFullNoteLoadText.value = message;
              } else if (status.toLowerCase() == "success") {
                customPrint("FullNoteStatus success");
                isFullNoteLoading.value = false;
                isFullNoteLoadText.value = message;

                getFullNote();
              } else if (status.toLowerCase() == "failure") {
                isFullNoteLoading.value = false;
                isFullNoteLoadText.value = "failure";
              }
            }
          },
        );

        socketService.socket.on(
          "VisitDataStatus",
          (data) {
            var res = data as Map<String, dynamic>;
            customPrint("---------------------------------------------");
            customPrint("visit data status is :- ${res}");

            int visit_id = res["visit_id"];
            int transcription_id = res["transcription_id"];
            String status = res["status"];
            String message = res["message"];

            if (visit_id == patientTranscriptUploadModel.responseData?.visitId) {
              customPrint("VisitDataStatus inside condition");
              if (status.toLowerCase() == "pending") {
                customPrint("VisitDataStatus pending");
                isVisitDataLoading.value = true;
                isVisitDataLoadText.value = message;
              } else if (status.toLowerCase() == "inprogress") {
                customPrint("VisitDataStatus inprogress");
                isVisitDataLoading.value = true;
                isVisitDataLoadText.value = message;
              } else if (status.toLowerCase() == "success") {
                customPrint("VisitDataStatus success");
                isVisitDataLoading.value = false;
                isVisitDataLoadText.value = message;

                getPatientDoctorVisitData();
              } else if (status.toLowerCase() == "failure") {
                isVisitDataLoading.value = false;
                isVisitDataLoadText.value = "failure";
              }
            }
          },
        );

        socketService.socket.on(
          "PatientViewStatus",
          (data) {
            var res = data as Map<String, dynamic>;
            customPrint("---------------------------------------------");
            customPrint("PatientViewStatus data:- $res");

            int visit_id = res["visit_id"];
            int transcription_id = res["transcription_id"];
            String status = res["status"];
            String message = res["message"];

            customPrint("$visit_id == ${patientTranscriptUploadModel.responseData?.visitId} && $transcription_id == ${patientTranscriptUploadModel.responseData?.id}");

            if (visit_id == patientTranscriptUploadModel.responseData?.visitId) {
              customPrint("PatientViewStatus inside condition");
              if (status.toLowerCase() == "pending") {
                isPatientViewLoading.value = true;
                isPatientViewLoadText.value = message;
                customPrint("PatientViewStatus pending");
              } else if (status.toLowerCase() == "inprogress") {
                customPrint("PatientViewStatus inprogress");
                isPatientViewLoading.value = true;
                isPatientViewLoadText.value = message;
              } else if (status.toLowerCase() == "success") {
                customPrint("PatientViewStatus success");
                isPatientViewLoading.value = false;
                isPatientViewLoadText.value = message;
                getPatientView();
              } else if (status.toLowerCase() == "failure") {
                customPrint("PatientViewStatus failure");
                isPatientViewLoading.value = true;
                isPatientViewLoadText.value = "failure";
              }
            }
          },
        );

        socketService.socket.on(
          "transcriptStatus",
          (data) {
            customPrint("---------------------------------------------");
            var res = data as Map<String, dynamic>;
            customPrint("transcriptStatus data:- $res");

            int visit_id = res["visit_id"];
            int transcription_id = res["transcription_id"];
            String status = res["status"];
            String message = res["message"];

            customPrint("$visit_id == ${patientTranscriptUploadModel.responseData?.visitId} && $transcription_id == ${patientTranscriptUploadModel.responseData?.id}");

            if (visit_id == patientTranscriptUploadModel.responseData?.visitId) {
              customPrint("transcriptStatus inside condition");
              if (status.toLowerCase() == "pending") {
                customPrint("transcriptStatus pending");
                isFullTranscriptLoading.value = true;
                isFullTranscriptLoadText.value = message;

                isPatientViewLoading.value = true;
                isPatientViewLoadText.value = "Patient View under process ";
              } else if (status.toLowerCase() == "inprogress") {
                customPrint("transcriptStatus inprogress");
                isFullTranscriptLoading.value = true;
                isFullTranscriptLoadText.value = message;
              } else if (status.toLowerCase() == "success") {
                customPrint("transcriptStatus success");
                isFullTranscriptLoading.value = false;
                isFullTranscriptLoadText.value = message;
                getTranscript();
              }
            }
          },
        );
      } else {
        customPrint("socket is not connected");
      }
    }
  }

  Future<void> showPrompError(BuildContext context, String message) async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return PrompErrorDialog(message);
      },
    );
  }

  Future<void> getAllPatientInfo() async {
    await getTranscript();
    getPatientView();
    getPatientDoctorVisitData();
    getFullNote();
    getDoctorNote();
  }

  Future<void> getTranscript() async {
    transcriptListModel.value = await _patientInfoRepository.getTranscript(id: visitId);
    customPrint("transcriptListModel is :- ${transcriptListModel.value?.toJson()}");
  }

  Future<void> getPatientView() async {
    patientViewListModel.value = await _patientInfoRepository.getPatientView(id: visitId);
    customPrint("getPatientView is :- ${patientViewListModel.value?.toJson()}");
  }

  Future<void> getPatientDoctorVisitData() async {
    patientDoctorVisitDataModel.value = await _patientInfoRepository.getDoctorVisitData(id: visitId);
    customPrint("getPatientView is :- ${patientDoctorVisitDataModel.value?.toJson()}");
  }

  Future<void> getFullNote() async {
    patientFullNoteModel.value = await _patientInfoRepository.getFullNote(id: visitId);
    customPrint("getFullNote is :- ${patientFullNoteModel.value}");
  }

  Future<void> getDoctorNote() async {
    doctorViewList.value = await _patientInfoRepository.getDoctorNote(id: visitId);
    customPrint("getDoctorNote is :- ${doctorViewList.value?.toJson()}");
    // customPrint("diagnos is :- ${doctorViewList.value?.responseData?.diagnosisCodesProcedures?.toJson()}");
  }

  void offLine() {
    var responseData = jsonDecode(AppPreference.instance.getString(AppString.offLineData));

    var doctorViewResponse = fetchVisitDetails(type: AppString.pastPatientVisitsList, modelType: AppString.doctorView, visitId: visitId, responseData: responseData);

    var fullNoteResponse = fetchVisitDetails(type: AppString.pastPatientVisitsList, modelType: AppString.fullNote, visitId: visitId, responseData: responseData);

    var visitDataResponse = fetchVisitDetails(type: AppString.pastPatientVisitsList, modelType: AppString.patientVisitDetails, visitId: visitId, responseData: responseData);

    var fullTransScriptResponse = fetchVisitDetails(type: AppString.pastPatientVisitsList, modelType: AppString.fullTranscript, visitId: visitId, responseData: responseData);

    var patientViewResponse = fetchVisitDetails(type: AppString.pastPatientVisitsList, modelType: AppString.patientView, visitId: visitId, responseData: responseData);
    doctorViewList.value = DoctorViewModel.fromJson(doctorViewResponse);
    patientFullNoteModel.value = PatientFullNoteModel.fromJson(fullNoteResponse);
    patientDoctorVisitDataModel.value = PatientDoctorVisitDataModel.fromJson(visitDataResponse);
    transcriptListModel.value = TranscriptListModel.fromJson(fullTransScriptResponse);
    patientViewListModel.value = PatientViewListModel.fromJson(patientViewResponse);
  }

  Map<String, dynamic> fetchVisitDetails({required Map<String, dynamic> responseData, required String type, required String visitId, required String modelType}) {
    // Extract the correct visit list based on the type (scheduleVisitsList or pastPatientVisitsList)
    List<dynamic> visitList = responseData['responseData'][type];

    // Initialize the result data
    var responseDataResult;

    // Search for the visit with the matching visit_id
    for (var visit in visitList) {
      // Check for the nested visit by visit-<visit_id> key
      var visitKey = 'visit-$visitId';
      if (visit.containsKey(visitKey)) {
        var visitDetails = visit[visitKey];

        // Check for the value of the key that we need (e.g., scheduledVisits)
        if (visitDetails['$modelType'] != null && visitDetails['$modelType'].isNotEmpty) {
          responseDataResult = visitDetails['$modelType']; // Set the value to return
        }
        break;
      }
    }

    // Return the formatted response
    return {"responseData": responseDataResult, "message": " Details Fetched Successfully", "toast": true, "response_type": "success"};
  }

  void handelInternetConnection() {
    final listener = InternetConnection().onStatusChange.listen((InternetStatus status) async {
      switch (status) {
        case InternetStatus.connected:
          getAllPatientInfo();

          break;
        case InternetStatus.disconnected:
          offLine();

          break;
      }
    });
  }
}

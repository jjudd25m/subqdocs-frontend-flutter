import 'dart:convert';

import 'package:get/get.dart';

import '../../../../utils/app_string.dart';
import '../../../core/common/app_preferences.dart';
import '../../../data/service/socket_service.dart';
import '../../login/model/login_model.dart';
import '../../visit_main/model/doctor_view_model.dart';
import '../../visit_main/model/patient_transcript_upload_model.dart';
import '../model/patient_doctor_visit_data_model.dart';
import '../model/patient_fullnote_model.dart';
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

  @override
  void onInit() {
    super.onInit();

    print("argument is :- ${Get.arguments}");

    if (Get.arguments["visitId"] != null) {
      visitId = Get.arguments["visitId"];
      print("visit id :- $visitId");

      getAllPatientInfo();
    }

    if (Get.arguments["trascriptUploadData"] != null) {
      patientTranscriptUploadModel = Get.arguments["trascriptUploadData"];
      visitId = patientTranscriptUploadModel.responseData!.visitId.toString();
      print("patientTranscriptUploadModel data is:- \n \n ${patientTranscriptUploadModel.toJson()}");
    }
  }

  @override
  void onReady() {
    super.onReady();

    var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

    if (patientTranscriptUploadModel.responseData != null) {
      print("socket status:- ${socketService.socket.connected}");
      if (socketService.socket.connected) {
        print("socket is connected");

        socketService.socket.emit("joinRoom", [loginData.responseData?.user?.id, patientTranscriptUploadModel.responseData?.visitId]);

        socketService.socket.on(
          "DoctorsViewStatus",
          (data) {
            var res = data as Map<String, dynamic>;
            print("---------------------------------------------");
            print("DoctorsViewStatus status is :- ${res}");

            int visit_id = res["visit_id"];
            int transcription_id = res["transcription_id"];
            String status = res["status"];
            String message = res["message"];

            if (visit_id == patientTranscriptUploadModel.responseData?.visitId) {
              print("DoctorsViewStatus inside condition");
              if (status.toLowerCase() == "pending") {
                print("DoctorsViewStatus pending");
                isDoctorViewLoading.value = true;
                isDoctorViewLoadText.value = message;
              } else if (status.toLowerCase() == "inprogress") {
                print("DoctorsViewStatus inprogress");
                isDoctorViewLoading.value = true;
                isDoctorViewLoadText.value = message;
              } else if (status.toLowerCase() == "success") {
                print("DoctorsViewStatus success");
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
            print("---------------------------------------------");
            print("FullNoteStatus status is :- ${res}");

            int visit_id = res["visit_id"];
            int transcription_id = res["transcription_id"];
            String status = res["status"];
            String message = res["message"];

            if (visit_id == patientTranscriptUploadModel.responseData?.visitId) {
              print("FullNoteStatus inside condition");
              if (status.toLowerCase() == "pending") {
                print("FullNoteStatus pending");
                isFullNoteLoading.value = true;
                isFullNoteLoadText.value = message;
              } else if (status.toLowerCase() == "inprogress") {
                print("FullNoteStatus inprogress");
                isFullNoteLoading.value = true;
                isFullNoteLoadText.value = message;
              } else if (status.toLowerCase() == "success") {
                print("FullNoteStatus success");
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
            print("---------------------------------------------");
            print("visit data status is :- ${res}");

            int visit_id = res["visit_id"];
            int transcription_id = res["transcription_id"];
            String status = res["status"];
            String message = res["message"];

            if (visit_id == patientTranscriptUploadModel.responseData?.visitId) {
              print("VisitDataStatus inside condition");
              if (status.toLowerCase() == "pending") {
                print("VisitDataStatus pending");
                isVisitDataLoading.value = true;
                isVisitDataLoadText.value = message;
              } else if (status.toLowerCase() == "inprogress") {
                print("VisitDataStatus inprogress");
                isVisitDataLoading.value = true;
                isVisitDataLoadText.value = message;
              } else if (status.toLowerCase() == "success") {
                print("VisitDataStatus success");
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
            print("---------------------------------------------");
            print("PatientViewStatus data:- $res");

            int visit_id = res["visit_id"];
            int transcription_id = res["transcription_id"];
            String status = res["status"];
            String message = res["message"];

            print("$visit_id == ${patientTranscriptUploadModel.responseData?.visitId} && $transcription_id == ${patientTranscriptUploadModel.responseData?.id}");

            if (visit_id == patientTranscriptUploadModel.responseData?.visitId) {
              print("PatientViewStatus inside condition");
              if (status.toLowerCase() == "pending") {
                isPatientViewLoading.value = true;
                isPatientViewLoadText.value = message;
                print("PatientViewStatus pending");
              } else if (status.toLowerCase() == "inprogress") {
                print("PatientViewStatus inprogress");
                isPatientViewLoading.value = true;
                isPatientViewLoadText.value = message;
              } else if (status.toLowerCase() == "success") {
                print("PatientViewStatus success");
                isPatientViewLoading.value = false;
                isPatientViewLoadText.value = message;
                getPatientView();
              } else if (status.toLowerCase() == "failure") {
                print("PatientViewStatus failure");
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
              print("transcriptStatus inside condition");
              if (status.toLowerCase() == "pending") {
                print("transcriptStatus pending");
                isFullTranscriptLoading.value = true;
                isFullTranscriptLoadText.value = message;

                isPatientViewLoading.value = true;
                isPatientViewLoadText.value = "Patient View under process ";
              } else if (status.toLowerCase() == "inprogress") {
                print("transcriptStatus inprogress");
                isFullTranscriptLoading.value = true;
                isFullTranscriptLoadText.value = message;
              } else if (status.toLowerCase() == "success") {
                print("transcriptStatus success");
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
    print("transcriptListModel is :- ${transcriptListModel.value?.toJson()}");
  }

  Future<void> getPatientView() async {
    patientViewListModel.value = await _patientInfoRepository.getPatientView(id: visitId);
    print("getPatientView is :- ${patientViewListModel.value?.toJson()}");
  }

  Future<void> getPatientDoctorVisitData() async {
    patientDoctorVisitDataModel.value = await _patientInfoRepository.getDoctorVisitData(id: visitId);
    print("getPatientView is :- ${patientDoctorVisitDataModel.value?.toJson()}");
  }

  Future<void> getFullNote() async {
    patientFullNoteModel.value = await _patientInfoRepository.getFullNote(id: visitId);
    print("getFullNote is :- ${patientFullNoteModel.value}");
  }

  Future<void> getDoctorNote() async {
    doctorViewList.value = await _patientInfoRepository.getDoctorNote(id: visitId);
    print("getDoctorNote is :- ${doctorViewList.value?.toJson()}");
    print("diagnos is :- ${doctorViewList.value?.responseData?.diagnosisCodesProcedures?.toJson()}");
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:subqdocs/utils/Loader.dart';
import 'package:toastification/toastification.dart';

import '../../../../utils/app_string.dart';
import '../../../../widgets/custom_toastification.dart';
import '../../../core/common/app_preferences.dart';
import '../../../core/common/global_controller.dart';
import '../../../core/common/logger.dart';
import '../../../data/service/socket_service.dart';
import '../../../models/ChangeModel.dart';
import '../../../routes/app_pages.dart';
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

class PatientInfoController extends GetxController with WidgetsBindingObserver {
  //TODO: Implement PatientInfoController
  final GlobalController globalController = Get.find();
  final PatientInfoRepository _patientInfoRepository = PatientInfoRepository();
  SocketService socketService = SocketService();

  RxDouble totalUnitCost = RxDouble(0.0);

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
  String patientId = "";

  Rxn<VisitMainPatientDetails> patientData = Rxn();
  final VisitMainRepository _visitMainRepository = VisitMainRepository();

  Rxn<LoginModel> loginData = Rxn();

  Future<void> getPatientDetails() async {
    patientData.value = await _visitMainRepository.getPatientDetails(id: visitId);

    if (patientData.value?.responseData?.visitStatus == "Finalized") {
      isSignatureDone.value = true;
    } else if (patientData.value?.responseData?.visitStatus == "Pending") {
      // isSignatureDone.value = true;
    }
    print("patient data is :- ${patientData.value?.toJson()}");
    // Get.back();Get
    // back  customPrint("patientAttachmentList is:- ${patientAttachmentList.value?.toJson()}");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      // Code to run when app comes to the foreground (onResume equivalent)

      // Run any code you need here
    } else if (state == AppLifecycleState.paused) {
      // Code to run when app goes to the background (onPause equivalent)
      print("App is in the background");
    }
  }

  @override
  void onInit() async {
    super.onInit();
    // WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addObserver(this);

    loginData.value = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

    customPrint("argument is :- ${Get.arguments}");

    if (Get.arguments["visitId"] != null) {
      visitId = Get.arguments["visitId"];
      customPrint("visit id :- $visitId");
      getPatientDetails();

      var status = await InternetConnection().internetStatus;

      getAllPatientInfo();

      // getAllPatientInfo();
      if (status == InternetStatus.disconnected) {
        print("you net is now Disconnected");

        offLine();
      } else {
        getAllPatientInfo();
      }

      handelInternetConnection();
    }

    if (Get.arguments["patientId"] != null) {
      tabIndex.value = 0;
      patientId = Get.arguments["patientId"];
    }

    if (Get.arguments["trascriptUploadData"] != null) {
      patientTranscriptUploadModel = Get.arguments["trascriptUploadData"];
      visitId = patientTranscriptUploadModel.responseData!.visitId.toString();
      getPatientDetails();
      customPrint("patientTranscriptUploadModel data is:- \n \n ${patientTranscriptUploadModel.toJson()}");
    }
  }

  @override
  void onReady() {
    super.onReady();
    // getAllPatientInfo();
    customPrint("its on claaed");
    var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

    if (patientTranscriptUploadModel.responseData != null) {
      print("if condition on onReady");
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

              getPatientDetails();
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

            getPatientDetails();
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
    } else {
      print("visit id:- ${patientTranscriptUploadModel.responseData?.visitId}");
      print("another visit id:- ${visitId}");
      print("else condition on onReady");

      if (visitId.isNotEmpty) {
        socketService.socket.emit("joinRoom", [loginData.responseData?.user?.id, int.parse(visitId)]);

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

            if (visit_id == int.parse(visitId)) {
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

            if (visit_id == int.parse(visitId)) {
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

            if (visit_id == int.parse(visitId)) {
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

            // customPrint("$visit_id == ${patientTranscriptUploadModel.responseData?.visitId} && $transcription_id == ${patientTranscriptUploadModel.responseData?.id}");

            if (visit_id == int.parse(visitId)) {
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

            // customPrint("$visit_id == ${patientTranscriptUploadModel.responseData?.visitId} && $transcription_id == ${patientTranscriptUploadModel.responseData?.id}");

            if (visit_id == int.parse(visitId)) {
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
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      globalController.addRouteInit(Routes.PATIENT_INFO);
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();

    if (globalController.getKeyByValue(globalController.breadcrumbHistory.last) == Routes.PATIENT_INFO) {
      globalController.popRoute();
    }
    // globalController.popRoute();
  }

  Future<void> onRefresh() async {
    print("_onRefresh called");

    var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

    if (patientTranscriptUploadModel.responseData != null) {
      print("if condition on onReady");
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
    } else {
      print("visit id:- ${patientTranscriptUploadModel.responseData?.visitId}");
      print("another visit id:- ${visitId}");
      print("else condition on onReady");

      if (visitId.isNotEmpty) {
        socketService.socket.emit("joinRoom", [loginData.responseData?.user?.id, int.parse(visitId)]);

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

            if (visit_id == int.parse(visitId)) {
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

            if (visit_id == int.parse(visitId)) {
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

            if (visit_id == int.parse(visitId)) {
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

            // customPrint("$visit_id == ${patientTranscriptUploadModel.responseData?.visitId} && $transcription_id == ${patientTranscriptUploadModel.responseData?.id}");

            if (visit_id == int.parse(visitId)) {
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

            // customPrint("$visit_id == ${patientTranscriptUploadModel.responseData?.visitId} && $transcription_id == ${patientTranscriptUploadModel.responseData?.id}");

            if (visit_id == int.parse(visitId)) {
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

  Future<void> getAllPatientInfo({bool isLoading = false}) async {
    await getTranscript();
    getPatientView();
    getPatientDoctorVisitData();
    getFullNote();
    getDoctorNote();
  }

  Future<void> changeStatus() async {
    // try {
    Loader().showLoadingDialogForSimpleLoader();

    Map<String, dynamic> param = {};

    param['status'] = "Finalized";

    ChangeStatusModel changeStatusModel = await _patientInfoRepository.changeStatus(id: visitId, params: param);
    if (changeStatusModel.responseType == "success") {
      Get.back();
      Get.back();
      CustomToastification().showToast("${changeStatusModel.message}", type: ToastificationType.success);
      if (patientTranscriptUploadModel.responseData?.id != null) {
        Get.back();
        // Get.back();
      } else {
        Get.back();
        // Get.back();
        dynamic response = await Get.toNamed(Routes.VISIT_MAIN, arguments: {
          "visitId": visitId,
          "patientId": patientId,
          "unique_tag": DateTime.now().toString(),
        });
      }
    } else {
      CustomToastification().showToast("${changeStatusModel.message}", type: ToastificationType.error);
      Get.back();
      // Get.back();
    }
    // } catch (e) {
    //   // customPrint("$e");
    //   Get.back();
    //   CustomToastification().showToast("$e", type: ToastificationType.error);
    // }
  }

  Future<void> getTranscript() async {
    transcriptListModel.value = await _patientInfoRepository.getTranscript(id: visitId);
    getPatientDetails();
    customPrint("transcriptListModel is :- ${transcriptListModel.value?.toJson()}");
  }

  Future<void> getPatientView() async {
    patientViewListModel.value = await _patientInfoRepository.getPatientView(id: visitId);
    getPatientDetails();
    customPrint("getPatientView is :- ${patientViewListModel.value?.toJson()}");
  }

  Future<void> getPatientDoctorVisitData() async {
    patientDoctorVisitDataModel.value = await _patientInfoRepository.getDoctorVisitData(id: visitId);
    getPatientDetails();
    customPrint("getPatientDoctorVisitData is :- ${patientDoctorVisitDataModel.value?.toJson()}");
  }

  Future<void> getFullNote() async {
    patientFullNoteModel.value = await _patientInfoRepository.getFullNote(id: visitId);
    getPatientDetails();
    customPrint("getFullNote is :- ${patientFullNoteModel.value}");
  }

  Future<void> getDoctorNote() async {
    doctorViewList.value = await _patientInfoRepository.getDoctorNote(id: visitId);
    getPatientDetails();
    customPrint("getDoctorNote is :- ${doctorViewList.value?.toJson()}");
    // customPrint("diagnos is :- ${doctorViewList.value?.responseData?.diagnosisCodesProcedures?.toJson()}");
  }

  void offLine() {
    var responseData = jsonDecode(AppPreference.instance.getString(AppString.offLineData));

    var doctorViewResponse = fetchVisitDetails(type: AppString.pastPatientVisitsList, modelType: AppString.doctorView, visitId: visitId, responseData: responseData);

    var fullNoteResponse = fetchVisitDetails(type: AppString.pastPatientVisitsList, modelType: AppString.fullNote, visitId: visitId, responseData: responseData);

    var visitDataResponse = fetchVisitDetails(type: AppString.pastPatientVisitsList, modelType: AppString.patientVisitDetails, visitId: visitId, responseData: responseData);

    var fullTransScriptResponse = fetchVisitDetails(type: AppString.pastPatientVisitsList, modelType: AppString.fullTranscript, visitId: visitId, responseData: responseData);

    var patientDetailsResponse = fetchVisitDetails(type: AppString.pastPatientVisitsList, modelType: AppString.visitMainData, visitId: visitId, responseData: responseData);
    var patientViewResponse = fetchVisitDetails(type: AppString.pastPatientVisitsList, modelType: AppString.patientView, visitId: visitId, responseData: responseData);
    doctorViewList.value = DoctorViewModel.fromJson(doctorViewResponse);

    patientFullNoteModel.value = PatientFullNoteModel.fromJson(fullNoteResponse);
    patientDoctorVisitDataModel.value = PatientDoctorVisitDataModel.fromJson(visitDataResponse);
    transcriptListModel.value = TranscriptListModel.fromJson(fullTransScriptResponse);
    patientViewListModel.value = PatientViewListModel.fromJson(patientViewResponse);
    patientData.value = VisitMainPatientDetails.fromJson(patientDetailsResponse);
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

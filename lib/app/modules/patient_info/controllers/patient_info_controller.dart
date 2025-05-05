import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:subqdocs/app/modules/patient_info/model/icd10_code_list_model.dart';
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
import '../../edit_patient_details/repository/edit_patient_details_repository.dart';
import '../../login/model/login_model.dart';
// import '../../visit_main/model/doctor_view_model.dart';
import '../../visit_main/model/doctor_view_model.dart';
import '../../visit_main/model/patient_transcript_upload_model.dart';
import '../../visit_main/model/visitmainModel.dart';
import '../../visit_main/repository/visit_main_repository.dart';
import '../model/diagnosis_model.dart';
import '../model/impresion_and_plan_view_model.dart';
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
  Rxn<TableModel> tableModel = Rxn();
  Rxn<TableModel> possibleDignosisProcedureTableModel = Rxn();

  List<ProcedurePossibleAlternatives> icd10CodeItems = [];

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

  RxString doctorValue = RxString("select Doctor");
  RxString medicationValue = RxString("select M.A");
  RxList<ImpresionAndPlanViewModel> impressionAndPlanList = RxList();
  RxList<ImpresionAndPlanViewModel> impressionAndPlanListFullNote = RxList();

  RxList<ImpresionAndPlanViewModel> editableDataForSkinHistory = RxList();
  RxList<ImpresionAndPlanViewModel> editableDataForCancerHistory = RxList();
  RxList<ImpresionAndPlanViewModel> editableDataForSocialHistory = RxList();
  RxList<ImpresionAndPlanViewModel> editableDataForMedication = RxList();
  RxList<ImpresionAndPlanViewModel> editableDataForAllergies = RxList();
  RxList<ImpresionAndPlanViewModel> editableDataForReviewOfSystems = RxList();
  RxList<ImpresionAndPlanViewModel> editableDataForExam = RxList();
  RxList<ImpresionAndPlanViewModel> editableDataForPatientView = RxList();
  RxList<ImpresionAndPlanViewModel> editableDataHpiView = RxList();
  RxList<ImpresionAndPlanViewModel> editableChiefView = RxList();

  Rxn<VisitMainPatientDetails> patientData = Rxn();
  final VisitMainRepository _visitMainRepository = VisitMainRepository();

  Rxn<LoginModel> loginData = Rxn();

  final EditPatientDetailsRepository _editPatientDetailsRepository = EditPatientDetailsRepository();

  Future<void> getPatientDetails() async {
    patientData.value = await _visitMainRepository.getPatientDetails(id: visitId);

    if (patientData.value?.responseData?.doctorId != null) {
      doctorValue.value = globalController.getDoctorNameById(patientData.value?.responseData?.doctorId ?? -1) ?? "";
    }

    if (patientData.value?.responseData?.medicalAssistantId != null) {
      medicationValue.value = globalController.getMedicalNameById(patientData.value?.responseData?.medicalAssistantId ?? -1) ?? "";
    }

    if (patientData.value?.responseData?.visitStatus == "Finalized") {
      isSignatureDone.value = true;
    } else if (patientData.value?.responseData?.visitStatus == "Pending") {
      // isSignatureDone.value = true;
    }
    print("patient data is :- ${patientData.value?.toJson()}");
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

        socketService.socket.on("AllTabStatus", (data) {
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
        });

        socketService.socket.on("DoctorsViewStatus", (data) {
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
        });

        socketService.socket.on("FullNoteStatus", (data) {
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
        });

        socketService.socket.on("VisitDataStatus", (data) {
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
        });

        socketService.socket.on("PatientViewStatus", (data) {
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
        });

        socketService.socket.on("transcriptStatus", (data) {
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
        });
      } else {
        customPrint("socket is not connected");
      }
    } else {
      print("visit id:- ${patientTranscriptUploadModel.responseData?.visitId}");
      print("another visit id:- ${visitId}");
      print("else condition on onReady");

      if (visitId.isNotEmpty) {
        socketService.socket.emit("joinRoom", [loginData.responseData?.user?.id, int.parse(visitId)]);

        socketService.socket.on("AllTabStatus", (data) {
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
        });

        socketService.socket.on("DoctorsViewStatus", (data) {
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
        });

        socketService.socket.on("FullNoteStatus", (data) {
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
        });

        socketService.socket.on("VisitDataStatus", (data) {
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
        });

        socketService.socket.on("PatientViewStatus", (data) {
          var res = data as Map<String, dynamic>;
          customPrint("---------------------------------------------");
          customPrint("PatientViewStatus data:- $res");

          int visit_id = res["visit_id"];
          int transcription_id = res["transcription_id"];
          String status = res["status"];
          String message = res["message"];

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
        });

        socketService.socket.on("transcriptStatus", (data) {
          customPrint("---------------------------------------------");
          var res = data as Map<String, dynamic>;
          customPrint("transcriptStatus data:- $res");

          int visit_id = res["visit_id"];
          int transcription_id = res["transcription_id"];
          String status = res["status"];
          String message = res["message"];

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
        });
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
  }

  void resetImpressionAndPlanList() {
    final editableLists = [
      editableChiefView,
      editableDataHpiView,
      editableDataForPatientView,
      editableDataForExam,
      editableDataForReviewOfSystems,
      editableDataForAllergies,
      editableDataForMedication,
      editableDataForSocialHistory,
      editableDataForCancerHistory,
      editableDataForSkinHistory,
      impressionAndPlanListFullNote,
      impressionAndPlanList,
    ];

    for (var list in editableLists) {
      for (var element in list) {
        element.isEditing = false;
      }
      list.refresh();
    }
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

        socketService.socket.on("AllTabStatus", (data) {
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
        });

        socketService.socket.on("DoctorsViewStatus", (data) {
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
        });

        socketService.socket.on("FullNoteStatus", (data) {
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
        });

        socketService.socket.on("VisitDataStatus", (data) {
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
        });

        socketService.socket.on("PatientViewStatus", (data) {
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
        });

        socketService.socket.on("transcriptStatus", (data) {
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
        });
      } else {
        customPrint("socket is not connected");
      }
    } else {
      print("visit id:- ${patientTranscriptUploadModel.responseData?.visitId}");
      print("another visit id:- ${visitId}");
      print("else condition on onReady");

      if (visitId.isNotEmpty) {
        socketService.socket.emit("joinRoom", [loginData.responseData?.user?.id, int.parse(visitId)]);

        socketService.socket.on("AllTabStatus", (data) {
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
        });

        socketService.socket.on("DoctorsViewStatus", (data) {
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
        });

        socketService.socket.on("FullNoteStatus", (data) {
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
        });

        socketService.socket.on("VisitDataStatus", (data) {
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
        });

        socketService.socket.on("PatientViewStatus", (data) {
          var res = data as Map<String, dynamic>;
          customPrint("---------------------------------------------");
          customPrint("PatientViewStatus data:- $res");

          int visit_id = res["visit_id"];
          int transcription_id = res["transcription_id"];
          String status = res["status"];
          String message = res["message"];

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
        });

        socketService.socket.on("transcriptStatus", (data) {
          customPrint("---------------------------------------------");
          var res = data as Map<String, dynamic>;
          customPrint("transcriptStatus data:- $res");

          int visit_id = res["visit_id"];
          int transcription_id = res["transcription_id"];
          String status = res["status"];
          String message = res["message"];

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
        });
      }
    }
  }

  Future<void> updateDoctorViewAPI(String id, Map<String, dynamic> param) async {
    dynamic response = await _patientInfoRepository.updateDoctorView(id: id, params: param);
    print(" update doctor view response is:- $response");
  }

  void updateDoctorView(int id) async {
    Map<String, dynamic> param = {};
    Map<String, List<File>> profileParams = {};
    if (id != -1) {
      param['doctor_id'] = id;
    }

    if (patientId != "") {
      param['patient_id'] = patientId;
    }
    var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));
    try {
      dynamic response = await _editPatientDetailsRepository.updatePatient(files: profileParams, id: patientId, param: param, token: loginData.responseData?.token ?? "");

      CustomToastification().showToast("Update Doctor Successfully", type: ToastificationType.success);
    } catch (e) {
      CustomToastification().showToast("$e", type: ToastificationType.error);
    }
  }

  void updateMedicalView(int id) async {
    Map<String, dynamic> param = {};
    Map<String, List<File>> profileParams = {};
    if (id != -1) {
      param['medical_assistant_id'] = id;
    }

    if (patientId != "") {
      param['patient_id'] = patientId;
    }
    var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));
    try {
      dynamic response = await _editPatientDetailsRepository.updatePatient(files: profileParams, id: patientId, param: param, token: loginData.responseData?.token ?? "");

      CustomToastification().showToast("Update Medical Assistant Successfully", type: ToastificationType.success);
    } catch (e) {
      CustomToastification().showToast("$e", type: ToastificationType.error);
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
        dynamic response = await Get.toNamed(Routes.VISIT_MAIN, arguments: {"visitId": visitId, "patientId": patientId, "unique_tag": DateTime.now().toString()});
      }
    } else {
      CustomToastification().showToast("${changeStatusModel.message}", type: ToastificationType.error);
      Get.back();
    }
  }

  Future<void> getTranscript() async {
    transcriptListModel.value = await _patientInfoRepository.getTranscript(id: visitId);
    getPatientDetails();
    customPrint("transcriptListModel is :- ${transcriptListModel.value?.toJson()}");
  }

  Future<void> getPatientView() async {
    patientViewListModel.value = await _patientInfoRepository.getPatientView(id: visitId);

    setPatientViewEditableData();

    getPatientDetails();
    customPrint("getPatientView is :- ${patientViewListModel.value?.toJson()}");
  }

  Future<Icd10CodeListModel> getIcd10CodeList(Map<String, dynamic> param) async {
    return await _patientInfoRepository.getIcd10CodeAll(param: param);
  }

  Future<void> getPatientDoctorVisitData() async {
    patientDoctorVisitDataModel.value = await _patientInfoRepository.getDoctorVisitData(id: visitId);
    getPatientDetails();
    customPrint("getPatientDoctorVisitData is :- ${patientDoctorVisitDataModel.value?.toJson()}");
  }

  Future<void> getFullNote() async {
    patientFullNoteModel.value = await _patientInfoRepository.getFullNote(id: visitId);

    setImpressionAndPlanListPatientView();
    getPatientDetails();
    customPrint("getFullNote is :- ${patientFullNoteModel.value}");
  }

  Future<void> updateImpressionAndPlan() async {
    Map<String, List<dynamic>> params = {};

    params["impressions_and_plan"] = impressionAndPlanList.map((item) => item.toJson()).toList();

    print(params);

    var response = await _patientInfoRepository.updateImpressionAndPlan(id: doctorViewList.value?.responseData?.id ?? 0, params: params);

    // setImpressionAndPlanList();
    // setDoctorModel();
    //
    // await getPatientDetails();
    //
    // // setDoctorModel();
    customPrint("getDoctorNote is :- ${doctorViewList.value?.toJson()}");
  }

  Future<void> updateImpressionAndPlanFullNote() async {
    Map<String, List<dynamic>> params = {};

    params["impressions_and_plan"] = impressionAndPlanListFullNote.map((item) => item.toJson()).toList();

    print(params);

    var response = await _patientInfoRepository.updateImpressionAndPlanFullNote(id: patientFullNoteModel.value?.responseData?.id ?? 0, params: params);
  }

  Future<void> updateFullNote(String keyName, List<ImpresionAndPlanViewModel> list) async {
    var response = await _patientInfoRepository.updateFullNote(id: patientFullNoteModel.value?.responseData?.id ?? 0, params: buildParams(keyName, list));
  }

  Future<void> updatePatientView(String keyName, List<ImpresionAndPlanViewModel> list) async {
    var response = await _patientInfoRepository.updatePatientView(id: patientViewListModel.value?.responseData?.id ?? 0, params: buildParams(keyName, list));
  }

  Future<void> getDoctorNote() async {
    final startTime = DateTime.now();
    doctorViewList.value = await _patientInfoRepository.getDoctorNote(id: visitId);
    setImpressionAndPlanList();
    setDoctorModel();

    await getPatientDetails();

    // setDoctorModel();
    customPrint("getDoctorNote is :- ${doctorViewList.value?.toJson()}");
  }

  void setDoctorModel() {
    print("setDoctorModel called");
    tableModel.value = TableModel(rows: []);
    possibleDignosisProcedureTableModel.value = TableModel(rows: []);

    icd10CodeItems.clear();

    // for (Icd10Codes icdItem in doctorViewList.value?.responseData?.icd10Codes ?? []) {
    //   icd10CodeItems.add(ProcedurePossibleAlternatives(code: icdItem.code, description: icdItem.description, modifier: null, isPin: false));
    // }

    for (MainDiagnosisCodesProceduresDiagnosisCodesProcedures diagnosis in (doctorViewList.value?.responseData?.mainDiagnosisCodesProcedures?.diagnosisCodesProcedures ?? [])) {
      List<DiagnosisModel>? diagnosisModelList = [];

      for (Diagnosis diagnosisModel in diagnosis.diagnosis ?? []) {
        print("diagnosis aleternative:- ${diagnosisModel.diagnosisPossibleAlternatives?.length ?? 0}");

        // for (ProcedurePossibleAlternatives icd10CodeItem in icd10CodeItems) {
        //   diagnosisModel.diagnosisPossibleAlternatives?.add(DiagnosisPossibleAlternatives(code: icd10CodeItem.code, description: icd10CodeItem.description, isPin: false));
        // }

        diagnosisModelList.add(
          DiagnosisModel(confidence: diagnosisModel.confidenceScore, code: diagnosisModel.code, description: diagnosisModel.description, diagnosisPossibleAlternatives: diagnosisModel.diagnosisPossibleAlternatives),
        );
      }

      // diagnosis.procedure?.procedurePossibleAlternatives?.addAll(icd10CodeItems);

      tableModel.value?.rows.add(
        TableRowModel(
          cells: [
            TableCellModel(
              items: [
                SingleCellModel(
                  code: diagnosis.procedure?.code,
                  unit: "0",
                  modifiers: diagnosis.procedure?.modifier,
                  description: diagnosis.procedure?.description ?? "",
                  unitPrice: "0",
                  procedurePossibleAlternatives: diagnosis.procedure?.procedurePossibleAlternatives,
                ),
              ],
            ),

            TableCellModel(items: [SingleCellModel(diagnosisModelList: diagnosisModelList)]),

            TableCellModel(items: [SingleCellModel(unit: diagnosis.units)]),
            TableCellModel(items: [SingleCellModel(unitPrice: diagnosis.unitCharge)]),
          ],
        ),
      );
      tableModel.refresh();
    }

    for (PossibleDiagnosisCodesProcedures possibleDiagnosisCodesProcedures in (doctorViewList.value?.responseData?.mainDiagnosisCodesProcedures?.possibleDiagnosisCodesProcedures ?? [])) {
      List<DiagnosisModel>? diagnosisModelList = [];

      for (Diagnosis diagnosisModel in possibleDiagnosisCodesProcedures.diagnosis ?? []) {
        print("diagnosis aleternative:- ${diagnosisModel.diagnosisPossibleAlternatives?.length ?? 0}");

        diagnosisModelList.add(
          DiagnosisModel(confidence: diagnosisModel.confidenceScore, code: diagnosisModel.code, description: diagnosisModel.description, diagnosisPossibleAlternatives: diagnosisModel.diagnosisPossibleAlternatives),
        );
      }

      possibleDignosisProcedureTableModel.value?.rows.add(
        TableRowModel(
          cells: [
            TableCellModel(
              items: [
                SingleCellModel(
                  code: possibleDiagnosisCodesProcedures.procedure?.code,
                  unit: "0",
                  modifiers: possibleDiagnosisCodesProcedures.procedure?.modifier,
                  description: possibleDiagnosisCodesProcedures.procedure?.description ?? "",
                  unitPrice: "0",
                  procedurePossibleAlternatives: possibleDiagnosisCodesProcedures.procedure?.procedurePossibleAlternatives,
                ),
              ],
            ),
            TableCellModel(items: [SingleCellModel(diagnosisModelList: diagnosisModelList)]),
            TableCellModel(items: [SingleCellModel(unit: possibleDiagnosisCodesProcedures.units)]),
            TableCellModel(items: [SingleCellModel(unitPrice: possibleDiagnosisCodesProcedures.unitCharge)]),
          ],
        ),
      );
      possibleDignosisProcedureTableModel.refresh();
    }
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

  void setImpressionAndPlanList() {
    if (doctorViewList.value?.responseData?.impressionsAndPlan != null) {
      impressionAndPlanList.clear();

      for (var ImpressionsAndPlan in doctorViewList.value!.responseData!.impressionsAndPlan!) {
        HtmlEditorController htmlEditorController = HtmlEditorController();
        htmlEditorController.setText(ImpressionsAndPlan.content ?? "");

        impressionAndPlanList.add(ImpresionAndPlanViewModel(htmlContent: ImpressionsAndPlan.content ?? "", htmlEditorController: htmlEditorController, title: ImpressionsAndPlan.title));
      }

      impressionAndPlanList.refresh();
    }
  }

  void setImpressionAndPlanListPatientView() {
    if (patientFullNoteModel.value?.responseData?.fullNoteDetails?.impressionsAndPlan != null) {
      impressionAndPlanListFullNote.clear();

      for (var ImpressionsAndPlan in patientFullNoteModel.value?.responseData?.fullNoteDetails?.impressionsAndPlan ?? []) {
        HtmlEditorController htmlEditorController = HtmlEditorController();
        htmlEditorController.setText(ImpressionsAndPlan.content ?? "");

        impressionAndPlanListFullNote.add(ImpresionAndPlanViewModel(htmlContent: ImpressionsAndPlan.content ?? "", htmlEditorController: htmlEditorController, title: ImpressionsAndPlan.title));
      }

      impressionAndPlanListFullNote.refresh();
    }

    if (patientFullNoteModel.value?.responseData?.fullNoteDetails?.skinHistoryWithLocation != null) {
      editableDataForSkinHistory.clear();

      HtmlEditorController htmlEditorController = HtmlEditorController();
      htmlEditorController.setText(patientFullNoteModel.value?.responseData?.fullNoteDetails?.skinHistoryWithLocation ?? "");
      editableDataForSkinHistory.add(ImpresionAndPlanViewModel(htmlContent: patientFullNoteModel.value?.responseData?.fullNoteDetails?.skinHistoryWithLocation ?? "", htmlEditorController: htmlEditorController, title: ""));
      editableDataForSkinHistory.refresh();
    }

    if (patientFullNoteModel.value?.responseData?.fullNoteDetails?.cancerHistoryHtml != null) {
      editableDataForCancerHistory.clear();

      HtmlEditorController htmlEditorController = HtmlEditorController();
      htmlEditorController.setText(patientFullNoteModel.value?.responseData?.fullNoteDetails?.cancerHistoryHtml ?? "");
      editableDataForCancerHistory.add(ImpresionAndPlanViewModel(htmlContent: patientFullNoteModel.value?.responseData?.fullNoteDetails?.cancerHistoryHtml ?? "", htmlEditorController: htmlEditorController, title: ""));
      editableDataForCancerHistory.refresh();
    }

    if (patientFullNoteModel.value?.responseData?.fullNoteDetails?.socialHistoryHtml != null) {
      editableDataForSocialHistory.clear();

      HtmlEditorController htmlEditorController = HtmlEditorController();
      htmlEditorController.setText(patientFullNoteModel.value?.responseData?.fullNoteDetails?.socialHistoryHtml ?? "");
      editableDataForSocialHistory.add(ImpresionAndPlanViewModel(htmlContent: patientFullNoteModel.value?.responseData?.fullNoteDetails?.socialHistoryHtml ?? "", htmlEditorController: htmlEditorController, title: ""));
      editableDataForSocialHistory.refresh();
    }

    if (patientFullNoteModel.value?.responseData?.fullNoteDetails?.medicationsHtml != null) {
      editableDataForMedication.clear();

      HtmlEditorController htmlEditorController = HtmlEditorController();
      htmlEditorController.setText(patientFullNoteModel.value?.responseData?.fullNoteDetails?.medicationsHtml ?? "");
      editableDataForMedication.add(ImpresionAndPlanViewModel(htmlContent: patientFullNoteModel.value?.responseData?.fullNoteDetails?.medicationsHtml ?? "", htmlEditorController: htmlEditorController, title: ""));
      editableDataForMedication.refresh();
    }

    if (patientFullNoteModel.value?.responseData?.fullNoteDetails?.allergies != null) {
      editableDataForAllergies.clear();

      HtmlEditorController htmlEditorController = HtmlEditorController();
      htmlEditorController.setText(patientFullNoteModel.value?.responseData?.fullNoteDetails?.allergies ?? "");
      editableDataForAllergies.add(ImpresionAndPlanViewModel(htmlContent: patientFullNoteModel.value?.responseData?.fullNoteDetails?.allergies ?? "", htmlEditorController: htmlEditorController, title: ""));
      editableDataForAllergies.refresh();
    }

    if (patientFullNoteModel.value?.responseData?.fullNoteDetails?.reviewOfSystem != null) {
      editableDataForReviewOfSystems.clear();

      HtmlEditorController htmlEditorController = HtmlEditorController();
      htmlEditorController.setText("""   """ ?? "");
      editableDataForReviewOfSystems.add(ImpresionAndPlanViewModel(htmlContent: patientFullNoteModel.value?.responseData?.fullNoteDetails?.reviewOfSystem ?? "", htmlEditorController: htmlEditorController, title: ""));
      editableDataForReviewOfSystems.refresh();
    }

    if (patientFullNoteModel.value?.responseData?.fullNoteDetails?.exam != null) {
      editableDataForExam.clear();

      HtmlEditorController htmlEditorController = HtmlEditorController();
      htmlEditorController.setText(patientFullNoteModel.value?.responseData?.fullNoteDetails?.exam ?? "");
      editableDataForExam.add(ImpresionAndPlanViewModel(htmlContent: patientFullNoteModel.value?.responseData?.fullNoteDetails?.exam ?? "", htmlEditorController: htmlEditorController, title: ""));
      editableDataForExam.refresh();
    }

    if (patientFullNoteModel.value?.responseData?.fullNoteDetails?.hpi != null) {
      editableDataHpiView.clear();

      HtmlEditorController htmlEditorController = HtmlEditorController();
      htmlEditorController.setText(patientFullNoteModel.value?.responseData?.fullNoteDetails?.hpi ?? "");
      editableDataHpiView.add(ImpresionAndPlanViewModel(htmlContent: patientFullNoteModel.value?.responseData?.fullNoteDetails?.hpi ?? "", htmlEditorController: htmlEditorController, title: ""));
      editableDataHpiView.refresh();
    }

    if (patientFullNoteModel.value?.responseData?.fullNoteDetails?.chiefComplain != null) {
      editableChiefView.clear();

      HtmlEditorController htmlEditorController = HtmlEditorController();
      htmlEditorController.setText(patientFullNoteModel.value?.responseData?.fullNoteDetails?.chiefComplain ?? "");
      editableChiefView.add(ImpresionAndPlanViewModel(htmlContent: patientFullNoteModel.value?.responseData?.fullNoteDetails?.chiefComplain ?? "", htmlEditorController: htmlEditorController, title: ""));
      editableChiefView.refresh();
    }
  }

  Map<String, String> buildParams(String keyName, List<ImpresionAndPlanViewModel> list) {
    return {keyName: list.firstOrNull?.htmlContent ?? ""};
  }

  void setPatientViewEditableData() {
    if (patientViewListModel.value?.responseData?.visitNoteDetails?.patientViewNoteHtml != null) {
      editableDataForPatientView.clear();

      HtmlEditorController htmlEditorController = HtmlEditorController();
      htmlEditorController.setText(patientViewListModel.value?.responseData?.visitNoteDetails?.patientViewNoteHtml ?? "");
      editableDataForPatientView.add(ImpresionAndPlanViewModel(htmlContent: patientViewListModel.value?.responseData?.visitNoteDetails?.patientViewNoteHtml ?? "", htmlEditorController: htmlEditorController, title: ""));
      editableDataForPatientView.refresh();
    }
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:easy_popover/easy_popover.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html;
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
import '../../../models/copyModel.dart';
import '../../../routes/app_pages.dart';
import '../../edit_patient_details/repository/edit_patient_details_repository.dart';
import '../../home/repository/home_repository.dart';
import '../../login/model/login_model.dart';
// import '../../visit_main/model/doctor_view_model.dart';
import '../../visit_main/model/doctor_view_model.dart';
import '../../visit_main/model/patient_transcript_upload_model.dart';
import '../../visit_main/model/visit_main_model.dart';
import '../../visit_main/repository/visit_main_repository.dart';
import '../model/diagnosis_model.dart';
import '../model/get_CPT_code_model.dart';
import '../model/get_modifier_code_model.dart';
import '../model/impresion_and_plan_view_model.dart';
import '../model/patient_doctor_visit_data_model.dart';
import '../model/patient_fullnote_model.dart';
import '../model/patient_view_list_model.dart';
import '../model/transcript_list_model.dart';
import '../repository/patient_info_repository.dart';
import '../views/confirm_finalize_dialog.dart';

class PatientInfoController extends GetxController with WidgetsBindingObserver, GetTickerProviderStateMixin {
  //TODO: Implement PatientInfoController

  final isDragging = false.obs;

  // final KeyboardController keyboardController = Get.put(KeyboardController());

  RxBool isKeyboardVisible = RxBool(false);

  final ScrollController doctorScrollController = ScrollController();

  final ScrollController scrollController = ScrollController();
  final KeyboardController keyboardController = Get.put(KeyboardController());

  final GlobalController globalController = Get.find();
  final PatientInfoRepository _patientInfoRepository = PatientInfoRepository();
  final HomeRepository _homeRepository = HomeRepository();
  SocketService socketService = SocketService();

  RxDouble totalUnitCost = RxDouble(0.0);

  RxBool isPromptFailure = RxBool(false);
  RxBool isSignatureDone = RxBool(false);
  List<String> tasks = ["A Task"];
  RxInt tabIndex = RxInt(1);
  final count = 0.obs;
  RxList<CleanedTranscriptResponseData> transcriptList = RxList();
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

  final GlobalKey doctorSearchBarKey = GlobalKey();
  PopoverController doctorPopoverController = PopoverController();
  RxString doctorValue = RxString("N/A");
  RxString medicationValue = RxString("N/A");

  Rxn<PatientFullNoteResponseData> patientFullNoteResponseData = Rxn();

  RxBool isFullNoteAttachment = RxBool(false);
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
  RxList<Attachments>? generalAttachments = <Attachments>[].obs;
  Rxn<VisitMainPatientDetails> patientData = Rxn();
  final VisitMainRepository _visitMainRepository = VisitMainRepository();

  Rxn<LoginModel> loginData = Rxn();

  final EditPatientDetailsRepository _editPatientDetailsRepository = EditPatientDetailsRepository();

  Future<void> getPatientDetails() async {
    Map<String, dynamic> param = {};

    param['visit_id'] = visitId;

    try {
      patientData.value = await _visitMainRepository.getPatientDetails(param: param);

      print("visit type:- ${patientData.value?.responseData?.visitStatus}");

      customPrint("patient data is :- ${patientData.toJson()}");

      if (patientData.value?.responseData?.doctorId != null) {
        doctorValue.value = globalController.getDoctorNameById(patientData.value?.responseData?.doctorId ?? -1) ?? "";
      }

      if (patientData.value?.responseData?.medicalAssistantId != null) {
        medicationValue.value = globalController.getMedicalNameById(patientData.value?.responseData?.medicalAssistantId ?? -1) ?? "N/A";
      }

      if (patientData.value?.responseData?.visitStatus == "Finalized") {
        isSignatureDone.value = true;
      } else if (patientData.value?.responseData?.visitStatus == "Pending") {
        // isSignatureDone.value = true;
      }
      customPrint("patient data is :- ${patientData.value?.toJson()}");
    } catch (e) {
      customPrint("catch patient data is :- $e");
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      // Code to run when app comes to the foreground (onResume equivalent)

      // Run any code you need here
    } else if (state == AppLifecycleState.paused) {
      // Code to run when app goes to the background (onPause equivalent)
      customPrint("App is in the background");
    }
  }

  @override
  void onInit() async {
    super.onInit();

    WidgetsBinding.instance.addObserver(this);

    loginData.value = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

    globalController.getDoctorsFilter();
    globalController.getMedicalAssistance();

    customPrint("argument is :- ${Get.arguments}");

    patientFullNoteModel.value = PatientFullNoteModel();

    transcriptList.value = [
      CleanedTranscriptResponseData(chunkId: 0, fileName: "", transcript: [Transcript(end: 9.5199995, start: 0, speaker: "Tester", sentence: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s")]),
      CleanedTranscriptResponseData(chunkId: 0, fileName: "", transcript: [Transcript(end: 9.5199995, start: 0, speaker: "Tester", sentence: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s")]),
      CleanedTranscriptResponseData(chunkId: 0, fileName: "", transcript: [Transcript(end: 9.5199995, start: 0, speaker: "Tester", sentence: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s")]),
      CleanedTranscriptResponseData(chunkId: 0, fileName: "", transcript: [Transcript(end: 9.5199995, start: 0, speaker: "Tester", sentence: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s")]),
      CleanedTranscriptResponseData(chunkId: 0, fileName: "", transcript: [Transcript(end: 9.5199995, start: 0, speaker: "Tester", sentence: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s")]),
      CleanedTranscriptResponseData(chunkId: 0, fileName: "", transcript: [Transcript(end: 9.5199995, start: 0, speaker: "Tester", sentence: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s")]),
    ];

    if (Get.arguments["visitId"] != null) {
      visitId = Get.arguments["visitId"];
      customPrint("visit id :- $visitId");
      getPatientDetails();

      var status = await InternetConnection().internetStatus;

      getAllPatientInfo();

      // getAllPatientInfo();
      if (status == InternetStatus.disconnected) {
        customPrint("you net is now Disconnected");

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

    // socketService.openAISocket.onConnect((data) {
    if (socketService.openAISocket.connected) {
      socketService.openAISocket.on("openaiStatusUpdate", (data) {
        customPrint('Open Ai server status');
        var res = data as Map<String, dynamic>;
        customPrint('Open Ai server status $res');

        WidgetsBinding.instance.addPostFrameCallback((_) {
          CustomToastification().showChatGPTDownBanner();
        });
      });
    }
    // });
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    final isVisibleNow = bottomInset > 0.0;

    if (isKeyboardVisible != isVisibleNow) {
      isKeyboardVisible.value = isVisibleNow;
    }
  }

  @override
  void onReady() {
    super.onReady();
    // getAllPatientInfo();
    customPrint("its on claaed");
    var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

    // if (socketService.socket.connected) {
    //   socketService.socket.on("openaiStatusUpdate", (data) {
    //     customPrint('Open Ai server status');
    //     var res = data as Map<String, dynamic>;
    //     customPrint('Open Ai server status $res');
    //
    //     WidgetsBinding.instance.addPostFrameCallback((_) {
    //       CustomToastification().showChatGPTDownBanner();
    //     });
    //   });
    // }

    if (patientTranscriptUploadModel.responseData != null) {
      customPrint("if condition on onReady");
      customPrint("socket status:- ${socketService.socket.connected}");
      if (socketService.socket.connected) {
        customPrint("socket is connected");

        isFullTranscriptLoading.value = true;
        isFullTranscriptLoadText.value = "Waiting for response";

        socketService.socket.emit("joinRoom", [loginData.responseData?.user?.id, patientTranscriptUploadModel.responseData?.visitId]);

        setUpFullNoteSocket();

        socketService.socket.on("AllTabStatus", (data) {
          var res = data as Map<String, dynamic>;
          customPrint("---------------------------------------------");
          customPrint("AllTabStatus status is :- $res");

          // int visit_id = res["visit_id"];
          // int transcription_id = res["transcription_id"];
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

          // int visit_id = res["visit_id"];
          // int transcription_id = res["transcription_id"];
          String status = res["status"];
          String message = res["message"];
          customPrint("DoctorsViewStatus status is :- $res");
          // if (visit_id == patientTranscriptUploadModel.responseData?.visitId) {
          //   customPrint("DoctorsViewStatus inside condition");
          //   if (status.toLowerCase() == "pending") {
          //     customPrint("DoctorsViewStatus pending");
          //     isDoctorViewLoading.value = true;
          //     isDoctorViewLoadText.value = message;
          //   } else if (status.toLowerCase() == "inprogress") {
          //     customPrint("DoctorsViewStatus inprogress");
          //     isDoctorViewLoading.value = true;
          //     isDoctorViewLoadText.value = message;
          //   } else if (status.toLowerCase() == "success") {
          //     customPrint("DoctorsViewStatus success");
          //     isDoctorViewLoading.value = false;
          //     isDoctorViewLoadText.value = message;
          //
          //     getDoctorNote();
          //   } else if (status.toLowerCase() == "failure") {
          //     isDoctorViewLoading.value = false;
          //     isDoctorViewLoadText.value = "failure";
          //   }
          // }
        });

        socketService.socket.on("FullNoteStatus", (data) {
          var res = data as Map<String, dynamic>;
          customPrint("---------------------------------------------");
          customPrint("FullNoteStatus status is :- $res");

          int visit_id = res["visit_id"];
          // int transcription_id = res["transcription_id"];
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
          customPrint("visit data status is :- $res");

          int visit_id = res["visit_id"];
          // int transcription_id = res["transcription_id"];
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
      customPrint("visit id:- ${patientTranscriptUploadModel.responseData?.visitId}");
      customPrint("another visit id:- $visitId");
      customPrint("else condition on onReady");

      if (visitId.isNotEmpty) {
        socketService.socket.emit("joinRoom", [loginData.responseData?.user?.id, int.parse(visitId)]);

        setUpFullNoteSocket();

        // socketService.socket.on("openaiStatusUpdate", (data) {
        //   customPrint('Open Ai server status');
        //   var res = data as Map<String, dynamic>;
        //   customPrint('Open Ai server status $res');
        //
        //   WidgetsBinding.instance.addPostFrameCallback((_) {
        //     CustomToastification().showChatGPTDownBanner();
        //   });
        // });

        socketService.socket.on("AllTabStatus", (data) {
          var res = data as Map<String, dynamic>;
          customPrint("---------------------------------------------");
          customPrint("AllTabStatus status is :- $res");

          // int visit_id = res["visit_id"];
          // int transcription_id = res["transcription_id"];
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

          // int visit_id = res["visit_id"];
          // int transcription_id = res["transcription_id"];
          String status = res["status"];
          String message = res["message"];
          customPrint("DoctorsViewStatus status is :- $res");
          // if (visit_id == int.parse(visitId)) {
          //   customPrint("DoctorsViewStatus inside condition");
          //   if (status.toLowerCase() == "pending") {
          //     customPrint("DoctorsViewStatus pending");
          //     isDoctorViewLoading.value = true;
          //     isDoctorViewLoadText.value = message;
          //   } else if (status.toLowerCase() == "inprogress") {
          //     customPrint("DoctorsViewStatus inprogress");
          //     isDoctorViewLoading.value = true;
          //     isDoctorViewLoadText.value = message;
          //   } else if (status.toLowerCase() == "success") {
          //     customPrint("DoctorsViewStatus success");
          //     isDoctorViewLoading.value = false;
          //     isDoctorViewLoadText.value = message;
          //
          //     getDoctorNote();
          //   } else if (status.toLowerCase() == "failure") {
          //     isDoctorViewLoading.value = false;
          //     isDoctorViewLoadText.value = "failure";
          //   }
          // }
        });

        socketService.socket.on("FullNoteStatus", (data) {
          var res = data as Map<String, dynamic>;
          customPrint("---------------------------------------------");
          customPrint("FullNoteStatus status is :- $res");

          int visit_id = res["visit_id"];
          // int transcription_id = res["transcription_id"];
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
          customPrint("visit data status is :- $res");

          int visit_id = res["visit_id"];
          // int transcription_id = res["transcription_id"];
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
          // int transcription_id = res["transcription_id"];
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
          // int transcription_id = res["transcription_id"];
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
  }

  Future<void> setUpFullNoteSocket() async {
    socketService.socket.on("DoctorsViewStatus", (data) {
      var res = data as Map<String, dynamic>;
      customPrint("---------------------------------------------");

      // int visit_id = res["visit_id"];
      // int transcription_id = res["transcription_id"];
      String status = res["status"];
      String message = res["message"];
      customPrint("DoctorsViewStatus status is :- $res");

      if (status.toLowerCase() == "success") {
        Map<String, dynamic> responseData = res["responseData"];
        Map<String, dynamic> doctorDiagnosisiResponseData = responseData["diagnosis_codes_procedures"];

        doctorViewList.value = DoctorViewModel(toast: true, message: "", responseType: "Success", responseData: DoctorViewResponseData.fromJson(responseData));
        setDoctorModel();
        // setImpressionAndPlanList();
        // getPatientDetails();
        update();
      }
    });

    socketService.socket.on("isMedicalTranscriptStatus", (data) {
      var res = data as Map<String, dynamic>;

      String status = res["status"];
      String message = res["message"];

      if (status.toLowerCase() == "failure") {
        getAllPatientInfo();
      }
    });

    socketService.socket.on("HpiCheifAllergiesStatus", (data) {
      var res = data as Map<String, dynamic>;

      String status = res["status"];
      String message = res["message"];

      if (status.toLowerCase() == "success") {
        Map<String, dynamic> responseData = res["responseData"];
        Map<String, dynamic> fullNoteResponseData = responseData["full_note_details"];
        patientFullNoteModel.value = PatientFullNoteModel(message: "", toast: true, responseType: "success", responseData: PatientFullNoteResponseData(id: 0, message: "", status: "Success", fullNoteDetails: FullNoteDetails.fromJson(fullNoteResponseData)));

        HtmlEditorController htmlEditorController = HtmlEditorController();
        editableDataHpiView.add(ImpresionAndPlanViewModel(htmlContent: patientFullNoteModel.value?.responseData?.fullNoteDetails?.hpi ?? "", htmlEditorController: htmlEditorController, title: ""));

        editableChiefView.add(ImpresionAndPlanViewModel(htmlContent: patientFullNoteModel.value?.responseData?.fullNoteDetails?.chiefComplain ?? "", htmlEditorController: htmlEditorController, title: ""));
        editableDataForAllergies.add(ImpresionAndPlanViewModel(htmlContent: patientFullNoteModel.value?.responseData?.fullNoteDetails?.allergies ?? "", htmlEditorController: htmlEditorController, title: ""));

        editableDataHpiView.refresh();
      }
    });

    socketService.socket.on("SkinHistoryStatus", (data) {
      var res = data as Map<String, dynamic>;

      String status = res["status"];
      String message = res["message"];

      if (status.toLowerCase() == "success") {
        Map<String, dynamic> responseData = res["responseData"];
        Map<String, dynamic> fullNoteResponseData = responseData["full_note_details"];
        patientFullNoteModel.value = PatientFullNoteModel(message: "", toast: true, responseType: "success", responseData: PatientFullNoteResponseData(id: 0, message: "", status: "Success", fullNoteDetails: FullNoteDetails.fromJson(fullNoteResponseData)));
        HtmlEditorController htmlEditorController = HtmlEditorController();
        editableDataForSkinHistory.add(ImpresionAndPlanViewModel(htmlContent: patientFullNoteModel.value?.responseData?.fullNoteDetails?.skinHistoryWithLocation ?? "", htmlEditorController: htmlEditorController, title: ""));
        editableDataForSkinHistory.refresh();
      }
    });

    socketService.socket.on("SocialHistoryStatus", (data) {
      var res = data as Map<String, dynamic>;

      String status = res["status"];
      String message = res["message"];

      if (status.toLowerCase() == "success") {
        Map<String, dynamic> responseData = res["responseData"];
        Map<String, dynamic> fullNoteResponseData = responseData["full_note_details"];
        patientFullNoteModel.value = PatientFullNoteModel(message: "", toast: true, responseType: "success", responseData: PatientFullNoteResponseData(id: 0, message: "", status: "Success", fullNoteDetails: FullNoteDetails.fromJson(fullNoteResponseData)));
        HtmlEditorController htmlEditorController = HtmlEditorController();
        editableDataForSocialHistory.add(ImpresionAndPlanViewModel(htmlContent: patientFullNoteModel.value?.responseData?.fullNoteDetails?.socialHistoryHtml ?? "", htmlEditorController: htmlEditorController, title: ""));
        editableDataForSocialHistory.refresh();
      }
    });

    socketService.socket.on("CancerHistoryStatus", (data) {
      var res = data as Map<String, dynamic>;

      String status = res["status"];
      String message = res["message"];

      if (status.toLowerCase() == "success") {
        Map<String, dynamic> responseData = res["responseData"];
        Map<String, dynamic> fullNoteResponseData = responseData["full_note_details"];
        patientFullNoteModel.value = PatientFullNoteModel(message: "", toast: true, responseType: "success", responseData: PatientFullNoteResponseData(id: 0, message: "", status: "Success", fullNoteDetails: FullNoteDetails.fromJson(fullNoteResponseData)));
        HtmlEditorController htmlEditorController = HtmlEditorController();
        editableDataForCancerHistory.add(ImpresionAndPlanViewModel(htmlContent: patientFullNoteModel.value?.responseData?.fullNoteDetails?.cancerHistoryHtml ?? "", htmlEditorController: htmlEditorController, title: ""));
        editableDataForCancerHistory.refresh();
        update();
      }
    });

    socketService.socket.on("MedicationHistoryStatus", (data) {
      var res = data as Map<String, dynamic>;

      String status = res["status"];
      String message = res["message"];

      if (status.toLowerCase() == "success") {
        Map<String, dynamic> responseData = res["responseData"];
        Map<String, dynamic> fullNoteResponseData = responseData["full_note_details"];
        patientFullNoteModel.value = PatientFullNoteModel(message: "", toast: true, responseType: "success", responseData: PatientFullNoteResponseData(id: 0, message: "", status: "Success", fullNoteDetails: FullNoteDetails.fromJson(fullNoteResponseData)));
        HtmlEditorController htmlEditorController = HtmlEditorController();
        editableDataForMedication.add(ImpresionAndPlanViewModel(htmlContent: patientFullNoteModel.value?.responseData?.fullNoteDetails?.medicationsHtml ?? "", htmlEditorController: htmlEditorController, title: ""));
        editableDataForMedication.refresh();
        update();
      }
    });

    socketService.socket.on("ExamStatus", (data) {
      var res = data as Map<String, dynamic>;

      String status = res["status"];
      String message = res["message"];

      if (status.toLowerCase() == "success") {
        Map<String, dynamic> responseData = res["responseData"];
        Map<String, dynamic> fullNoteResponseData = responseData["full_note_details"];
        patientFullNoteModel.value = PatientFullNoteModel(message: "", toast: true, responseType: "success", responseData: PatientFullNoteResponseData(id: 0, message: "", status: "Success", fullNoteDetails: FullNoteDetails.fromJson(fullNoteResponseData)));
        HtmlEditorController htmlEditorController = HtmlEditorController();
        editableDataForExam.add(ImpresionAndPlanViewModel(htmlContent: patientFullNoteModel.value?.responseData?.fullNoteDetails?.exam ?? "", htmlEditorController: htmlEditorController, title: ""));
        editableDataForExam.refresh();
        update();
      }
    });

    socketService.socket.on("ReviewOfSystemStatus", (data) {
      var res = data as Map<String, dynamic>;

      String status = res["status"];
      String message = res["message"];

      if (status.toLowerCase() == "success") {
        Map<String, dynamic> responseData = res["responseData"];
        Map<String, dynamic> fullNoteResponseData = responseData["full_note_details"];
        patientFullNoteModel.value = PatientFullNoteModel(message: "", toast: true, responseType: "success", responseData: PatientFullNoteResponseData(id: 0, message: "", status: "Success", fullNoteDetails: FullNoteDetails.fromJson(fullNoteResponseData)));
        HtmlEditorController htmlEditorController = HtmlEditorController();
        editableDataForReviewOfSystems.add(ImpresionAndPlanViewModel(htmlContent: patientFullNoteModel.value?.responseData?.fullNoteDetails?.reviewOfSystem ?? "", htmlEditorController: htmlEditorController, title: ""));
        editableDataForReviewOfSystems.refresh();
      }
    });

    socketService.socket.on("DoctorsViewImpressionAndPlanStatus", (data) {
      var res = data as Map<String, dynamic>;

      String status = res["status"];
      String message = res["message"];

      if (status.toLowerCase() == "success") {
        Map<String, dynamic> responseData = res["responseData"];
        Map<String, dynamic> doctorDiagnosisiResponseData = responseData["diagnosis_codes_procedures"];

        doctorViewList.value = DoctorViewModel(toast: true, message: "", responseType: "Success", responseData: DoctorViewResponseData.fromJson(responseData));
        setDoctorModel();
        setImpressionAndPlanList();
        getPatientDetails();
        update();
      }
    });

    socketService.socket.on("ImpressionAndPlanStatus", (data) {
      var res = data as Map<String, dynamic>;

      String status = res["status"];
      String message = res["message"];

      if (status.toLowerCase() == "success") {
        Map<String, dynamic> responseData = res["responseData"];
        Map<String, dynamic> fullNoteResponseData = responseData["full_note_details"];
        patientFullNoteModel.value = PatientFullNoteModel(message: "", toast: true, responseType: "success", responseData: PatientFullNoteResponseData(id: responseData["id"], message: "", status: "Success", fullNoteDetails: FullNoteDetails.fromJson(fullNoteResponseData)));

        impressionAndPlanListFullNote.clear();
        if (patientFullNoteModel.value?.responseData?.fullNoteDetails?.isImageGenerated ?? false) {
          socketService.socket.on("PhotoMetaDataStatus", (data) {
            var res = data as Map<String, dynamic>;
            String status = res["status"];
            String message = res["message"];

            if (status.toLowerCase() == "success") {
              Map<String, dynamic> responseData = res["responseData"];
              patientFullNoteResponseData.value = PatientFullNoteResponseData.fromJson(responseData);
              Map<String, dynamic> fullNoteResponseData = responseData["full_note_details"];
              // log("messages: ${patientFullNoteResponseData.value?.toJson()}");

              patientFullNoteModel.value = PatientFullNoteModel(message: "", toast: true, responseType: "success", responseData: PatientFullNoteResponseData(id: responseData["id"], message: "", status: "Success", fullNoteDetails: FullNoteDetails.fromJson(fullNoteResponseData)));
            }
            for (var impressionsAndPlan in patientFullNoteModel.value?.responseData?.fullNoteDetails?.impressionsAndPlan ?? []) {
              HtmlEditorController htmlEditorController = HtmlEditorController();
              customPrint("message:attach ${impressionsAndPlan.attachments}");
              customPrint("message:attach ${impressionsAndPlan.title}");
              customPrint("message:attach ${impressionsAndPlan.content}");
              impressionAndPlanListFullNote.add(
                ImpresionAndPlanViewModel(
                  htmlContent: impressionsAndPlan.content ?? "",
                  htmlEditorController: htmlEditorController,
                  title: impressionsAndPlan.title,
                  siblingIcd10FullNote: impressionsAndPlan.siblingIcd10,
                  slidableController: SlidableController(this),
                  attachments: impressionsAndPlan.attachments ?? [],
                  // generalAttachments: patientFullNoteModel.value?.responseData?.fullNoteDetails?.impressionsAndPlanAttachments ?? []
                ),
              );
            }
            generalAttachments?.value = patientFullNoteModel.value?.responseData?.fullNoteDetails?.impressionsAndPlanAttachments ?? [];
          });
        } else {
          for (var impressionsAndPlan in patientFullNoteModel.value?.responseData?.fullNoteDetails?.impressionsAndPlan ?? []) {
            HtmlEditorController htmlEditorController = HtmlEditorController();

            impressionAndPlanListFullNote.add(ImpresionAndPlanViewModel(htmlContent: impressionsAndPlan.content ?? "", htmlEditorController: htmlEditorController, title: impressionsAndPlan.title, siblingIcd10FullNote: impressionsAndPlan.siblingIcd10, slidableController: SlidableController(this), attachments: impressionsAndPlan.attachments ?? []));
          }

          generalAttachments?.value = patientFullNoteModel.value?.responseData?.fullNoteDetails?.impressionsAndPlanAttachments ?? [];
        }

        impressionAndPlanListFullNote.refresh();
        generalAttachments?.refresh();
      }

      // if (status.toLowerCase() == "success") {
      //   Map<String, dynamic> responseData = res["responseData"];
      //   Map<String, dynamic> fullNoteResponseData = responseData["full_note_details"];
      //   patientFullNoteModel.value = PatientFullNoteModel(message: "", toast: true, responseType: "success", responseData: PatientFullNoteResponseData(id: 0, message: "", status: "Success", fullNoteDetails: FullNoteDetails.fromJson(fullNoteResponseData)));
      //
      //   impressionAndPlanListFullNote.clear();
      //
      //   for (var impressionsAndPlan in patientFullNoteModel.value?.responseData?.fullNoteDetails?.impressionsAndPlan ?? []) {
      //     HtmlEditorController htmlEditorController = HtmlEditorController();
      //
      //     impressionAndPlanListFullNote.add(ImpresionAndPlanViewModel(htmlContent: impressionsAndPlan.content ?? "", htmlEditorController: htmlEditorController, title: impressionsAndPlan.title, siblingIcd10FullNote: impressionsAndPlan.siblingIcd10));
      //   }
      //
      //   impressionAndPlanListFullNote.refresh();
      // }
    });
  }

  void resetImpressionAndPlanList() {
    final editableLists = [editableChiefView, editableDataHpiView, editableDataForPatientView, editableDataForExam, editableDataForReviewOfSystems, editableDataForAllergies, editableDataForMedication, editableDataForSocialHistory, editableDataForCancerHistory, editableDataForSkinHistory, impressionAndPlanListFullNote, impressionAndPlanList];

    for (var list in editableLists) {
      for (var element in list) {
        element.toggleHtmlContent = element.htmlContent;
        element.initialHtmlContent = element.htmlContent;

        element.isEditing = false;
      }
      list.refresh();
    }
  }

  Future<void> onRefresh() async {
    customPrint("_onRefresh called");

    var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

    if (patientTranscriptUploadModel.responseData != null) {
      customPrint("if condition on onReady");
      customPrint("socket status:- ${socketService.socket.connected}");
      if (socketService.socket.connected) {
        customPrint("socket is connected");

        socketService.socket.emit("joinRoom", [loginData.responseData?.user?.id, patientTranscriptUploadModel.responseData?.visitId]);

        setUpFullNoteSocket();

        // socketService.socket.on("openaiStatusUpdate", (data) {
        //   var res = data as Map<String, dynamic>;
        //   customPrint('Open Ai server status $res');
        //
        //   CustomToastification().showChatGPTDownBanner();
        // });

        socketService.socket.on("AllTabStatus", (data) {
          var res = data as Map<String, dynamic>;
          customPrint("---------------------------------------------");
          customPrint("AllTabStatus status is :- $res");

          // int visit_id = res["visit_id"];
          // int transcription_id = res["transcription_id"];
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

          // int visit_id = res["visit_id"];
          // int transcription_id = res["transcription_id"];
          String status = res["status"];
          String message = res["message"];

          customPrint("DoctorsViewStatus status is :- $res");

          // if (visit_id == patientTranscriptUploadModel.responseData?.visitId) {
          //   customPrint("DoctorsViewStatus inside condition");
          //   if (status.toLowerCase() == "pending") {
          //     customPrint("DoctorsViewStatus pending");
          //     isDoctorViewLoading.value = true;
          //     isDoctorViewLoadText.value = message;
          //   } else if (status.toLowerCase() == "inprogress") {
          //     customPrint("DoctorsViewStatus inprogress");
          //     isDoctorViewLoading.value = true;
          //     isDoctorViewLoadText.value = message;
          //   } else if (status.toLowerCase() == "success") {
          //     customPrint("DoctorsViewStatus success");
          //     isDoctorViewLoading.value = false;
          //     isDoctorViewLoadText.value = message;
          //
          //     getDoctorNote();
          //   } else if (status.toLowerCase() == "failure") {
          //     isDoctorViewLoading.value = false;
          //     isDoctorViewLoadText.value = "failure";
          //   }
          // }
        });

        socketService.socket.on("FullNoteStatus", (data) {
          var res = data as Map<String, dynamic>;
          customPrint("---------------------------------------------");
          customPrint("FullNoteStatus status is :- $res");

          int visit_id = res["visit_id"];
          // int transcription_id = res["transcription_id"];
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
          customPrint("visit data status is :- $res");

          int visit_id = res["visit_id"];
          // int transcription_id = res["transcription_id"];
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
      customPrint("visit id:- ${patientTranscriptUploadModel.responseData?.visitId}");
      customPrint("another visit id:- $visitId");
      customPrint("else condition on onReady");

      if (visitId.isNotEmpty) {
        socketService.socket.emit("joinRoom", [loginData.responseData?.user?.id, int.parse(visitId)]);

        setUpFullNoteSocket();

        // socketService.socket.on("openaiStatusUpdate", (data) {
        //   var res = data as Map<String, dynamic>;
        //   customPrint('Open Ai server status $res');
        //
        //   CustomToastification().showChatGPTDownBanner();
        // });

        socketService.socket.on("AllTabStatus", (data) {
          var res = data as Map<String, dynamic>;
          customPrint("---------------------------------------------");
          customPrint("AllTabStatus status is :- $res");

          // int visit_id = res["visit_id"];
          // int transcription_id = res["transcription_id"];
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

          // int visit_id = res["visit_id"];
          // int transcription_id = res["transcription_id"];
          String status = res["status"];
          String message = res["message"];
          customPrint("DoctorsViewStatus status is :- $res");
          // if (visit_id == int.parse(visitId)) {
          //   customPrint("DoctorsViewStatus inside condition");
          //   if (status.toLowerCase() == "pending") {
          //     customPrint("DoctorsViewStatus pending");
          //     isDoctorViewLoading.value = true;
          //     isDoctorViewLoadText.value = message;
          //   } else if (status.toLowerCase() == "inprogress") {
          //     customPrint("DoctorsViewStatus inprogress");
          //     isDoctorViewLoading.value = true;
          //     isDoctorViewLoadText.value = message;
          //   } else if (status.toLowerCase() == "success") {
          //     customPrint("DoctorsViewStatus success");
          //     isDoctorViewLoading.value = false;
          //     isDoctorViewLoadText.value = message;
          //
          //     getDoctorNote();
          //   } else if (status.toLowerCase() == "failure") {
          //     isDoctorViewLoading.value = false;
          //     isDoctorViewLoadText.value = "failure";
          //   }
          // }
        });

        socketService.socket.on("FullNoteStatus", (data) {
          var res = data as Map<String, dynamic>;
          customPrint("---------------------------------------------");
          customPrint("FullNoteStatus status is :- $res");

          int visit_id = res["visit_id"];
          // int transcription_id = res["transcription_id"];
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
          customPrint("visit data status is :- $res");

          int visit_id = res["visit_id"];
          // int transcription_id = res["transcription_id"];
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
          // int transcription_id = res["transcription_id"];
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
          // int transcription_id = res["transcription_id"];
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
    customPrint(" update doctor view response is:- $response");
  }

  void updateDoctorView(int id) async {
    Map<String, dynamic> param = {};
    Map<String, List<File>> profileParams = {};
    if (id != -1) {
      param['doctor_id'] = id;
    }

    try {
      dynamic response = await _homeRepository.patientReScheduleVisit(param: param, visitId: visitId);
      getPatientDetails();

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

    dynamic response = await _homeRepository.patientReScheduleVisit(param: param, visitId: visitId);

    try {
      dynamic response = await _homeRepository.patientReScheduleVisit(param: param, visitId: visitId);

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

  Future<void> changeStatus(Map<String, dynamic> param) async {
    // try {
    Get.back();
    Loader().showLoadingDialogForSimpleLoader();

    ChangeStatusModel changeStatusModel = await _patientInfoRepository.changeStatus(id: visitId, params: param);
    if (changeStatusModel.responseType == "success") {
      // Get.back();
      // Get.back();
      Loader().stopLoader();
      CustomToastification().showToast("${changeStatusModel.message}", type: ToastificationType.success);
      if (patientTranscriptUploadModel.responseData?.id != null) {
        // Get.back();
        // Get.back();
      } else {
        // Get.back();
        // Get.back();
        // dynamic response = await Get.toNamed(Routes.VISIT_MAIN, arguments: {"visitId": visitId, "patientId": patientId, "unique_tag": DateTime.now().toString()});
      }

      getPatientDetails();
    } else {
      Loader().stopLoader();
      CustomToastification().showToast("${changeStatusModel.message}", type: ToastificationType.error);
      // Get.back();
    }
  }

  Future<dynamic> hasEncounter({required String id}) async {
    dynamic response = _patientInfoRepository.hasEncounter(id: id);
    return response;
  }

  Future<void> getTranscript() async {
    transcriptListModel.value = await _patientInfoRepository.getTranscript(id: visitId);
    // if (/**/transcriptListModel.value?.responseData != null) {
    transcriptList.value = transcriptListModel.value?.responseData?.cleanedTranscript?.responseData ?? [];
    print("transctipt data :- ${transcriptListModel.value?.message}");
    getPatientDetails();
    // }

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

  Future<GetCPTCodeModel> getCPTCodeAll(Map<String, dynamic> param) async {
    return await _patientInfoRepository.getCPTCodeAll(param: param);
  }

  Future<GetModifierCodeModel> getModifierCodeAll(Map<String, dynamic> param) async {
    return await _patientInfoRepository.getModifierCodeAll(param: param);
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

    params["impressions_and_plan"] = impressionAndPlanListFullNote.map((item) => item.toJsonFullNote()).where((map) => map.isNotEmpty).toList();
    customPrint(params);
    try {
      var response = await _patientInfoRepository.updateImpressionAndPlan(id: doctorViewList.value?.responseData?.id ?? 0, params: params);
    } catch (e) {
      customPrint(e);
    }

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

    params["impressions_and_plan"] = impressionAndPlanListFullNote.map((item) => item.toJsonFullNote()).where((map) => map.isNotEmpty).toList();
    if (isFullNoteAttachment.value) {
      params["impressions_and_plan_attachments"] = generalAttachments?.value.map((attachment) => attachment.toJson()).toList() ?? [];
    }
    customPrint("params: $params");

    try {
      var response = await _patientInfoRepository.updateImpressionAndPlanFullNote(id: patientFullNoteModel.value?.responseData?.id ?? 0, params: params);
    } catch (e) {
      customPrint(e);
    }
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
    customPrint("setDoctorModel called");

    if (doctorViewList.value?.responseData != null) {
      tableModel.value = TableModel(rows: []);
      possibleDignosisProcedureTableModel.value = TableModel(rows: []);

      icd10CodeItems.clear();

      // for (Icd10Codes icdItem in doctorViewList.value?.responseData?.icd10Codes ?? []) {
      //   icd10CodeItems.add(ProcedurePossibleAlternatives(code: icdItem.code, description: icdItem.description, modifier: null, isPin: false));
      // }

      for (MainDiagnosisCodesProceduresDiagnosisCodesProcedures diagnosis in (doctorViewList.value?.responseData?.mainDiagnosisCodesProcedures?.diagnosisCodesProcedures ?? [])) {
        List<DiagnosisModel>? diagnosisModelList = [];

        for (Diagnosis diagnosisModel in diagnosis.diagnosis ?? []) {
          customPrint("diagnosis aleternative:- ${diagnosisModel.diagnosisPossibleAlternatives?.length ?? 0}");

          // for (ProcedurePossibleAlternatives icd10CodeItem in icd10CodeItems) {
          //   diagnosisModel.diagnosisPossibleAlternatives?.add(DiagnosisPossibleAlternatives(code: icd10CodeItem.code, description: icd10CodeItem.description, isPin: false));
          // }

          diagnosisModelList.add(DiagnosisModel(confidence: diagnosisModel.confidenceScore, code: diagnosisModel.code, description: diagnosisModel.description, diagnosisPossibleAlternatives: diagnosisModel.diagnosisPossibleAlternatives));
        }

        // diagnosis.procedure?.procedurePossibleAlternatives?.addAll(icd10CodeItems);

        tableModel.value?.rows.add(
          TableRowModel(
            cells: [
              TableCellModel(items: [SingleCellModel(code: diagnosis.procedure?.code, unit: "0", modifiers: diagnosis.procedure?.modifier, description: diagnosis.procedure?.description ?? "", shortDescription: diagnosis.procedure?.shortDescription ?? "", unitPrice: "0", procedurePossibleAlternatives: diagnosis.procedure?.procedurePossibleAlternatives)]),
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
          customPrint("diagnosis aleternative:- ${diagnosisModel.diagnosisPossibleAlternatives?.length ?? 0}");

          diagnosisModelList.add(DiagnosisModel(confidence: diagnosisModel.confidenceScore, code: diagnosisModel.code, description: diagnosisModel.description, diagnosisPossibleAlternatives: diagnosisModel.diagnosisPossibleAlternatives));
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
                    shortDescription: possibleDiagnosisCodesProcedures.procedure?.shortDescription ?? "",
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
        if (visitDetails[modelType] != null && visitDetails[modelType].isNotEmpty) {
          responseDataResult = visitDetails[modelType]; // Set the value to return
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

  void setImpressionAndPlanListPatientView() {
    if (patientFullNoteModel.value?.responseData?.fullNoteDetails?.impressionsAndPlan != null) {
      impressionAndPlanListFullNote.clear();

      for (var impressionsAndPlan in patientFullNoteModel.value?.responseData?.fullNoteDetails?.impressionsAndPlan ?? []) {
        HtmlEditorController htmlEditorController = HtmlEditorController();
        // htmlEditorController.setText(ImpressionsAndPlan.content ?? "");

        impressionAndPlanListFullNote.add(ImpresionAndPlanViewModel(htmlContent: impressionsAndPlan.content ?? "", htmlEditorController: htmlEditorController, title: impressionsAndPlan.title, siblingIcd10FullNote: impressionsAndPlan.siblingIcd10, attachments: impressionsAndPlan.attachments ?? [], slidableController: SlidableController(this)));
      }

      impressionAndPlanListFullNote.refresh();
    }
    if (patientFullNoteModel.value?.responseData?.fullNoteDetails?.impressionsAndPlanAttachments != null) {
      generalAttachments?.clear();

      generalAttachments?.value = patientFullNoteModel.value?.responseData?.fullNoteDetails?.impressionsAndPlanAttachments ?? [];
      generalAttachments?.refresh();
    }

    if (patientFullNoteModel.value?.responseData?.fullNoteDetails?.skinHistoryWithLocation != null) {
      editableDataForSkinHistory.clear();

      HtmlEditorController htmlEditorController = HtmlEditorController();
      // htmlEditorController.setText(patientFullNoteModel.value?.responseData?.fullNoteDetails?.skinHistoryWithLocation ?? "");
      editableDataForSkinHistory.add(ImpresionAndPlanViewModel(htmlContent: patientFullNoteModel.value?.responseData?.fullNoteDetails?.skinHistoryWithLocation ?? "", htmlEditorController: htmlEditorController, title: ""));
      editableDataForSkinHistory.refresh();
    }

    if (patientFullNoteModel.value?.responseData?.fullNoteDetails?.cancerHistoryHtml != null) {
      editableDataForCancerHistory.clear();

      HtmlEditorController htmlEditorController = HtmlEditorController();
      // htmlEditorController.setText(patientFullNoteModel.value?.responseData?.fullNoteDetails?.cancerHistoryHtml ?? "");
      editableDataForCancerHistory.add(ImpresionAndPlanViewModel(htmlContent: patientFullNoteModel.value?.responseData?.fullNoteDetails?.cancerHistoryHtml ?? "", htmlEditorController: htmlEditorController, title: ""));
      editableDataForCancerHistory.refresh();
    }

    if (patientFullNoteModel.value?.responseData?.fullNoteDetails?.socialHistoryHtml != null) {
      editableDataForSocialHistory.clear();

      HtmlEditorController htmlEditorController = HtmlEditorController();
      // htmlEditorController.setText(patientFullNoteModel.value?.responseData?.fullNoteDetails?.socialHistoryHtml ?? "");
      editableDataForSocialHistory.add(ImpresionAndPlanViewModel(htmlContent: patientFullNoteModel.value?.responseData?.fullNoteDetails?.socialHistoryHtml ?? "", htmlEditorController: htmlEditorController, title: ""));
      editableDataForSocialHistory.refresh();
    }

    if (patientFullNoteModel.value?.responseData?.fullNoteDetails?.medicationsHtml != null) {
      editableDataForMedication.clear();

      HtmlEditorController htmlEditorController = HtmlEditorController();
      // htmlEditorController.setText(patientFullNoteModel.value?.responseData?.fullNoteDetails?.medicationsHtml ?? "");
      editableDataForMedication.add(ImpresionAndPlanViewModel(htmlContent: patientFullNoteModel.value?.responseData?.fullNoteDetails?.medicationsHtml ?? "", htmlEditorController: htmlEditorController, title: ""));
      editableDataForMedication.refresh();
    }

    if (patientFullNoteModel.value?.responseData?.fullNoteDetails?.allergies != null) {
      editableDataForAllergies.clear();

      HtmlEditorController htmlEditorController = HtmlEditorController();
      // htmlEditorController.setText(patientFullNoteModel.value?.responseData?.fullNoteDetails?.allergies ?? "");
      editableDataForAllergies.add(ImpresionAndPlanViewModel(htmlContent: patientFullNoteModel.value?.responseData?.fullNoteDetails?.allergies ?? "", htmlEditorController: htmlEditorController, title: ""));
      editableDataForAllergies.refresh();
    }

    if (patientFullNoteModel.value?.responseData?.fullNoteDetails?.reviewOfSystem != null) {
      editableDataForReviewOfSystems.clear();

      HtmlEditorController htmlEditorController = HtmlEditorController();
      // htmlEditorController.setText("""   """ ?? "");
      editableDataForReviewOfSystems.add(ImpresionAndPlanViewModel(htmlContent: patientFullNoteModel.value?.responseData?.fullNoteDetails?.reviewOfSystem ?? "", htmlEditorController: htmlEditorController, title: ""));
      editableDataForReviewOfSystems.refresh();
    }

    if (patientFullNoteModel.value?.responseData?.fullNoteDetails?.exam != null) {
      editableDataForExam.clear();

      HtmlEditorController htmlEditorController = HtmlEditorController();
      // htmlEditorController.setText(patientFullNoteModel.value?.responseData?.fullNoteDetails?.exam ?? "");
      editableDataForExam.add(ImpresionAndPlanViewModel(htmlContent: patientFullNoteModel.value?.responseData?.fullNoteDetails?.exam ?? "", htmlEditorController: htmlEditorController, title: ""));
      editableDataForExam.refresh();
    }

    if (patientFullNoteModel.value?.responseData?.fullNoteDetails?.hpi != null) {
      editableDataHpiView.clear();

      HtmlEditorController htmlEditorController = HtmlEditorController();
      // htmlEditorController.setText(patientFullNoteModel.value?.responseData?.fullNoteDetails?.hpi ?? "");
      editableDataHpiView.add(ImpresionAndPlanViewModel(htmlContent: patientFullNoteModel.value?.responseData?.fullNoteDetails?.hpi ?? "", htmlEditorController: htmlEditorController, title: ""));
      editableDataHpiView.refresh();
    }

    if (patientFullNoteModel.value?.responseData?.fullNoteDetails?.chiefComplain != null) {
      editableChiefView.clear();

      HtmlEditorController htmlEditorController = HtmlEditorController();
      // htmlEditorController.setText(patientFullNoteModel.value?.responseData?.fullNoteDetails?.chiefComplain ?? "");
      editableChiefView.add(ImpresionAndPlanViewModel(htmlContent: patientFullNoteModel.value?.responseData?.fullNoteDetails?.chiefComplain ?? "", htmlEditorController: htmlEditorController, title: ""));
      editableChiefView.refresh();
    }
  }

  void setImpressionAndPlanList() {
    if (doctorViewList.value?.responseData?.impressionsAndPlan != null) {
      impressionAndPlanList.clear();

      for (var impressionsAndPlan in doctorViewList.value!.responseData!.impressionsAndPlan!) {
        HtmlEditorController htmlEditorController = HtmlEditorController();
        // htmlEditorController.setText(ImpressionsAndPlan.content ?? "");

        impressionAndPlanList.add(ImpresionAndPlanViewModel(htmlContent: impressionsAndPlan.content ?? "", htmlEditorController: htmlEditorController, title: impressionsAndPlan.title, siblingIcd10: impressionsAndPlan.siblingIcd10, slidableController: SlidableController(this)));
      }

      impressionAndPlanList.refresh();
    }
  }

  // void setImpressionAndPlanListPatientView() {
  //   if (patientFullNoteModel.value?.responseData?.fullNoteDetails?.impressionsAndPlan != null) {
  //     impressionAndPlanListFullNote.clear();
  //
  //     for (var impressionsAndPlan in patientFullNoteModel.value?.responseData?.fullNoteDetails?.impressionsAndPlan ?? []) {
  //       HtmlEditorController htmlEditorController = HtmlEditorController();
  //       // htmlEditorController.setText(ImpressionsAndPlan.content ?? "");
  //
  //       impressionAndPlanListFullNote.add(ImpresionAndPlanViewModel(htmlContent: impressionsAndPlan.content ?? "", htmlEditorController: htmlEditorController, title: impressionsAndPlan.title, siblingIcd10FullNote: impressionsAndPlan.siblingIcd10, attachments: impressionsAndPlan.attachments ?? []));
  //     }
  //
  //     impressionAndPlanListFullNote.refresh();
  //   }
  //
  //   if (patientFullNoteModel.value?.responseData?.fullNoteDetails?.skinHistoryWithLocation != null) {
  //     editableDataForSkinHistory.clear();
  //
  //     HtmlEditorController htmlEditorController = HtmlEditorController();
  //     // htmlEditorController.setText(patientFullNoteModel.value?.responseData?.fullNoteDetails?.skinHistoryWithLocation ?? "");
  //     editableDataForSkinHistory.add(ImpresionAndPlanViewModel(htmlContent: patientFullNoteModel.value?.responseData?.fullNoteDetails?.skinHistoryWithLocation ?? "", htmlEditorController: htmlEditorController, title: ""));
  //     editableDataForSkinHistory.refresh();
  //   }
  //
  //   if (patientFullNoteModel.value?.responseData?.fullNoteDetails?.cancerHistoryHtml != null) {
  //     editableDataForCancerHistory.clear();
  //
  //     HtmlEditorController htmlEditorController = HtmlEditorController();
  //     // htmlEditorController.setText(patientFullNoteModel.value?.responseData?.fullNoteDetails?.cancerHistoryHtml ?? "");
  //     editableDataForCancerHistory.add(ImpresionAndPlanViewModel(htmlContent: patientFullNoteModel.value?.responseData?.fullNoteDetails?.cancerHistoryHtml ?? "", htmlEditorController: htmlEditorController, title: ""));
  //     editableDataForCancerHistory.refresh();
  //   }
  //
  //   if (patientFullNoteModel.value?.responseData?.fullNoteDetails?.socialHistoryHtml != null) {
  //     editableDataForSocialHistory.clear();
  //
  //     HtmlEditorController htmlEditorController = HtmlEditorController();
  //     // htmlEditorController.setText(patientFullNoteModel.value?.responseData?.fullNoteDetails?.socialHistoryHtml ?? "");
  //     editableDataForSocialHistory.add(ImpresionAndPlanViewModel(htmlContent: patientFullNoteModel.value?.responseData?.fullNoteDetails?.socialHistoryHtml ?? "", htmlEditorController: htmlEditorController, title: ""));
  //     editableDataForSocialHistory.refresh();
  //   }
  //
  //   if (patientFullNoteModel.value?.responseData?.fullNoteDetails?.medicationsHtml != null) {
  //     editableDataForMedication.clear();
  //
  //     HtmlEditorController htmlEditorController = HtmlEditorController();
  //     // htmlEditorController.setText(patientFullNoteModel.value?.responseData?.fullNoteDetails?.medicationsHtml ?? "");
  //     editableDataForMedication.add(ImpresionAndPlanViewModel(htmlContent: patientFullNoteModel.value?.responseData?.fullNoteDetails?.medicationsHtml ?? "", htmlEditorController: htmlEditorController, title: ""));
  //     editableDataForMedication.refresh();
  //   }
  //
  //   if (patientFullNoteModel.value?.responseData?.fullNoteDetails?.allergies != null) {
  //     editableDataForAllergies.clear();
  //
  //     HtmlEditorController htmlEditorController = HtmlEditorController();
  //     // htmlEditorController.setText(patientFullNoteModel.value?.responseData?.fullNoteDetails?.allergies ?? "");
  //     editableDataForAllergies.add(ImpresionAndPlanViewModel(htmlContent: patientFullNoteModel.value?.responseData?.fullNoteDetails?.allergies ?? "", htmlEditorController: htmlEditorController, title: ""));
  //     editableDataForAllergies.refresh();
  //   }
  //
  //   if (patientFullNoteModel.value?.responseData?.fullNoteDetails?.reviewOfSystem != null) {
  //     editableDataForReviewOfSystems.clear();
  //
  //     HtmlEditorController htmlEditorController = HtmlEditorController();
  //     // htmlEditorController.setText("""   """ ?? "");
  //     editableDataForReviewOfSystems.add(ImpresionAndPlanViewModel(htmlContent: patientFullNoteModel.value?.responseData?.fullNoteDetails?.reviewOfSystem ?? "", htmlEditorController: htmlEditorController, title: ""));
  //     editableDataForReviewOfSystems.refresh();
  //   }
  //
  //   if (patientFullNoteModel.value?.responseData?.fullNoteDetails?.exam != null) {
  //     editableDataForExam.clear();
  //
  //     HtmlEditorController htmlEditorController = HtmlEditorController();
  //     // htmlEditorController.setText(patientFullNoteModel.value?.responseData?.fullNoteDetails?.exam ?? "");
  //     editableDataForExam.add(ImpresionAndPlanViewModel(htmlContent: patientFullNoteModel.value?.responseData?.fullNoteDetails?.exam ?? "", htmlEditorController: htmlEditorController, title: ""));
  //     editableDataForExam.refresh();
  //   }
  //
  //   if (patientFullNoteModel.value?.responseData?.fullNoteDetails?.hpi != null) {
  //     editableDataHpiView.clear();
  //
  //     HtmlEditorController htmlEditorController = HtmlEditorController();
  //     // htmlEditorController.setText(patientFullNoteModel.value?.responseData?.fullNoteDetails?.hpi ?? "");
  //     editableDataHpiView.add(ImpresionAndPlanViewModel(htmlContent: patientFullNoteModel.value?.responseData?.fullNoteDetails?.hpi ?? "", htmlEditorController: htmlEditorController, title: ""));
  //     editableDataHpiView.refresh();
  //   }
  //
  //   if (patientFullNoteModel.value?.responseData?.fullNoteDetails?.chiefComplain != null) {
  //     editableChiefView.clear();
  //
  //     HtmlEditorController htmlEditorController = HtmlEditorController();
  //     // htmlEditorController.setText(patientFullNoteModel.value?.responseData?.fullNoteDetails?.chiefComplain ?? "");
  //     editableChiefView.add(ImpresionAndPlanViewModel(htmlContent: patientFullNoteModel.value?.responseData?.fullNoteDetails?.chiefComplain ?? "", htmlEditorController: htmlEditorController, title: ""));
  //     editableChiefView.refresh();
  //   }
  // }

  Map<String, String> buildParams(String keyName, List<ImpresionAndPlanViewModel> list) {
    return {keyName: list.firstOrNull?.htmlContent ?? ""};
  }

  void copyPatientViewSection() async {
    customPrint("HTML is :- ${patientViewListModel.value?.responseData?.visitNoteDetails?.patientViewNoteHtml}");

    // List<CopyModel> copyModel = [
    //   CopyModel(contentModel: [ContentModel(htmlContent: patientViewListModel.value?.responseData?.visitNoteDetails?.patientViewNoteHtml ?? "")], sectionName: "Patient Note"),
    // ];

    final StringBuffer formattedText = StringBuffer();

    // Add static heading
    formattedText.writeln('PATIENT NOTE \n');

    String plainText = _parsePatientViewHtmlToFormattedText(patientViewListModel.value?.responseData?.visitNoteDetails?.patientViewNoteHtml ?? "");
    //
    // final indentedText = plainText
    //     .split('\n')
    //     .expand((line) {
    //   final trimmedLine = line.trim();
    //   final keywords = ['Follow-Up:', 'Counseling and Discussion', 'Procedure'];
    //   final needsSpacing = keywords.any((keyword) => trimmedLine.toLowerCase().startsWith(keyword.toLowerCase()));
    //
    //   if (needsSpacing) {
    //     return ['', '\t$trimmedLine'];
    //   } else {
    //     return ['\t$trimmedLine'];
    //   }
    // })
    //     .join('\n');
    //
    // formattedText.writeln(indentedText);
    //
    await Clipboard.setData(ClipboardData(text: plainText));
    CustomToastification().showToast("Content copied to clipboard", type: ToastificationType.info);

    // copyMedicalRecordToClipboard(copyModel);
  }

  String _parsePatientViewHtmlToFormattedText(String htmlString) {
    dom.Document document = html.parse(htmlString);

    // Comprehensive list of block-level elements
    final Set<String> blockElements = {
      'address', 'article', 'aside', 'blockquote', 'canvas', 'dd', 'div',
      'dl', 'dt', 'fieldset', 'figcaption', 'figure', 'footer', 'form', 'h1',
      'h2', 'h3', 'h4', 'h5', 'h6', 'header', 'hr', 'li', 'main', 'nav',
      'noscript', 'ol', 'p', 'pre', 'section', 'table', 'tfoot', 'ul', 'video',
      'br', 'tr', 'td', 'th', 'thead', 'tbody', 'caption', 'colgroup', 'col',
      'article', 'aside', 'details', 'dialog', 'summary', 'menu', 'menuitem',
      'output', 'progress', 'meter', 'legend', 'map', 'object', 'iframe',
      // Deprecated but still seen in legacy HTML
      'center', 'dir', 'isindex', 'listing', 'plaintext', 'xmp',
    };

    void extractText(dom.Node node, StringBuffer buffer, {bool isListItem = false}) {
      if (node is dom.Text) {
        // Clean up and write text
        final text = node.text.replaceAll(RegExp(r'\s+'), ' ').trim();
        if (text.isNotEmpty) {
          if (isListItem && buffer.isNotEmpty && !buffer.toString().endsWith('\n• ')) {
            buffer.write('• ');
          }
          buffer.write(text);
        }
      } else if (node is dom.Element) {
        // Check if this is a title element (has color #6b4fe4)
        final isTitle = node.attributes['style']?.contains('#6b4fe4') ?? false;

        // Add newline before title if it's not the first element
        if (isTitle && buffer.isNotEmpty) {
          buffer.write('\n');
        }

        // Check if this is a list item
        final isLi = node.localName?.toLowerCase() == 'li';

        for (var child in node.nodes) {
          extractText(child, buffer, isListItem: isLi);
          if (child is dom.Element && blockElements.contains(child.localName)) {
            if (isLi) {
              buffer.write('\n');
            } else {
              buffer.write('\n');
            }
          }
        }
      }
    }

    final buffer = StringBuffer();
    extractText(document.body ?? document.documentElement!, buffer);

    // Normalize multiple newlines and trim output
    String result =
        buffer
            .toString()
            .replaceAll(RegExp(r'•\s+•'), '•') // Fix duplicate bullets
            .replaceAll(RegExp(r'\n\s*\n+'), '\n\n') // Normalize newlines
            .replaceAll(RegExp(r'(\n• )+'), '\n• ') // Fix bullet formatting
            .trim();

    // Ensure bullets are properly formatted
    result = result
        .split('\n')
        .map((line) {
          if (line.startsWith('• ')) return line;
          if (line.startsWith('•')) return '• ${line.substring(1)}';
          return line;
        })
        .join('\n');

    return result;
  }

  void setPatientViewEditableData() {
    if (patientViewListModel.value?.responseData?.visitNoteDetails?.patientViewNoteHtml != null) {
      editableDataForPatientView.clear();

      HtmlEditorController htmlEditorController = HtmlEditorController();
      // htmlEditorController.setText(patientViewListModel.value?.responseData?.visitNoteDetails?.patientViewNoteHtml ?? "");
      editableDataForPatientView.add(
        ImpresionAndPlanViewModel(htmlContent: patientViewListModel.value?.responseData?.visitNoteDetails?.patientViewNoteHtml ?? "", htmlEditorController: htmlEditorController, title: "", initialHtmlContent: patientViewListModel.value?.responseData?.visitNoteDetails?.patientViewNoteHtml, toggleHtmlContent: patientViewListModel.value?.responseData?.visitNoteDetails?.patientViewNoteHtml),
      );
      editableDataForPatientView.refresh();
    }
  }

  void loadDoctorviewPDF(String visitID) async {
    var response = await _patientInfoRepository.loadDoctorviewPDF(visitId, "${patientData.value?.responseData?.patientFirstName}_${patientData.value?.responseData?.patientLastName}_doctorview_${patientData.value?.responseData?.visitTime}");
  }

  void loadFullNotePDF(String visitID) async {
    var response = await _patientInfoRepository.loadFullNotePDF(visitId, "${patientData.value?.responseData?.patientFirstName}_${patientData.value?.responseData?.patientLastName}_full_note_${patientData.value?.responseData?.visitTime}");
  }

  Future<void> copyMedicalRecordToClipboard(List<CopyModel> copyModels) async {
    // Add commentMore actions
    final StringBuffer formattedText = StringBuffer();

    // Add static heading
    formattedText.writeln('PATIENT MEDICAL RECORD \n');

    // Iterate over each CopyModel
    for (int i = 0; i < copyModels.length; i++) {
      final copyModel = copyModels[i];

      // Add section number if sectionName is null

      // Add section name with tab indentation

      // formattedText.writeln('----------------------------------------------------------------------------------------------');

      formattedText.writeln('${copyModel.sectionName}:');

      // Iterate over each ContentModel in the section
      for (int index = 0; index < (copyModel.contentModel?.length ?? 0); index++) {
        final content = copyModel.contentModel![index];

        if (content.label != null) {
          formattedText.writeln('${index + 1}. ${content.label}:');

          if (content.htmlContent != null) {
            String plainText = _parseHtmlToFormattedText(content.htmlContent!);

            final indentedText = plainText
                .split('\n')
                .expand((line) {
                  final trimmedLine = line.trim();
                  final keywords = ['Follow-Up:', 'Counseling and Discussion', 'Procedure'];
                  final needsSpacing = keywords.any((keyword) => trimmedLine.toLowerCase().startsWith(keyword.toLowerCase()));

                  if (needsSpacing) {
                    return ['', '\t$trimmedLine'];
                  } else {
                    return ['\t$trimmedLine'];
                  }
                })
                .join('\n');

            formattedText.writeln(indentedText);
          }
        } else {
          if (content.htmlContent != null) {
            String plainText = _parseHtmlToFormattedText(content.htmlContent!);
            List<String> lines = plainText.split('\n').map((l) => l.trim()).toList();

            // Check if multiline (more than 1 non-empty line)
            int nonEmptyLineCount = lines.where((line) => line.isNotEmpty).length;
            bool isMultiLine = nonEmptyLineCount > 1;

            final bulletText = lines
                .expand((line) {
                  final keywords = ['Follow-Up:', 'Counseling and Discussion', 'Procedure'];
                  final needsSpacing = keywords.any((keyword) => line.toLowerCase().startsWith(keyword.toLowerCase()));

                  if (needsSpacing) {
                    return ['', line]; // blank line before keywords, no dash
                  }

                  if (line.isEmpty) {
                    // Empty line, just print blank (no dash)
                    return [''];
                  }

                  // For multiline, non-empty lines => add dash prefix
                  if (isMultiLine) {
                    return ['- $line'];
                  } else {
                    // Single line content, no dash prefix
                    return [line];
                  }
                })
                .join('\n');

            formattedText.writeln(bulletText);
          }
        }

        // formattedText.writeln();
      }

      // Add a newline for separation between sections
      formattedText.writeln();
    }

    // Copy the formatted text to the clipboard
    await Clipboard.setData(ClipboardData(text: formattedText.toString()));
    CustomToastification().showToast("Content copied to clipboard", type: ToastificationType.info);

    // Optionally, show a confirmation message
  }

  String _parseHtmlToFormattedText(String htmlString) {
    dom.Document document = html.parse(htmlString);

    // Comprehensive list of block-level elements
    final Set<String> blockElements = {
      'address', 'article', 'aside', 'blockquote', 'canvas', 'dd', 'div',
      'dl', 'dt', 'fieldset', 'figcaption', 'figure', 'footer', 'form', 'h1',
      'h2', 'h3', 'h4', 'h5', 'h6', 'header', 'hr', 'li', 'main', 'nav',
      'noscript', 'ol', 'p', 'pre', 'section', 'table', 'tfoot', 'ul', 'video',
      'br', 'tr', 'td', 'th', 'thead', 'tbody', 'caption', 'colgroup', 'col',
      'article', 'aside', 'details', 'dialog', 'summary', 'menu', 'menuitem',
      'output', 'progress', 'meter', 'legend', 'map', 'object', 'iframe',
      // Deprecated but still seen in legacy HTML
      'center', 'dir', 'isindex', 'listing', 'plaintext', 'xmp',
    };

    void extractText(dom.Node node, StringBuffer buffer) {
      if (node is dom.Text) {
        // Clean up and write text
        final text = node.text.replaceAll(RegExp(r'\s+'), ' ');
        buffer.write(text);
      } else if (node is dom.Element) {
        for (var child in node.nodes) {
          extractText(child, buffer);
          if (child is dom.Element && blockElements.contains(child.localName)) {
            buffer.write('\n');
          }
        }
      }
    }

    final buffer = StringBuffer();
    extractText(document.body ?? document.documentElement!, buffer);

    // Normalize multiple newlines and trim output
    return buffer.toString().replaceAll(RegExp(r'\n\s*\n+'), '\n\n').trim();
    // Add commentMore actions
  }

  void copyAllSection() async {
    List<CopyModel> copyModel = initCopyModel();
    copyMedicalRecordToClipboard(copyModel);
  }

  // List<CopyModel> initCopyModel() {
  //   List<CopyModel> copyModel = List.empty();
  //
  //   copyModel.add(CopyModel(contentModel: [ContentModel(htmlContent: editableDataForCancerHistory.first.htmlContent)], sectionName: "Cancer History"));
  //
  //   copyModel.add(
  //     CopyModel(
  //       sectionName: "Impressions and Plan",
  //       contentModel:
  //           impressionAndPlanListFullNote.map((element) {
  //             return ContentModel(label: element.title, htmlContent: element.htmlContent);
  //           }).toList(),
  //     ),
  //   );
  //
  //   return copyModel;
  // }

  List<CopyModel> initCopyModel() {
    List<CopyModel> copyModel = [];

    copyModel.add(CopyModel(contentModel: [ContentModel(htmlContent: editableDataForCancerHistory.first.htmlContent)], sectionName: "Cancer History"));
    copyModel.add(CopyModel(contentModel: [ContentModel(htmlContent: editableDataForSkinHistory.first.htmlContent)], sectionName: "Skin History"));
    copyModel.add(CopyModel(contentModel: [ContentModel(htmlContent: editableDataForSocialHistory.first.htmlContent)], sectionName: "Social History"));
    copyModel.add(CopyModel(contentModel: [ContentModel(htmlContent: editableDataForMedication.first.htmlContent)], sectionName: "Medications"));
    copyModel.add(CopyModel(contentModel: [ContentModel(htmlContent: editableDataForAllergies.first.htmlContent)], sectionName: "Allergies"));
    copyModel.add(CopyModel(contentModel: [ContentModel(htmlContent: editableDataHpiView.first.htmlContent)], sectionName: "HPI"));
    copyModel.add(CopyModel(contentModel: [ContentModel(htmlContent: editableDataForReviewOfSystems.first.htmlContent)], sectionName: "Review of Systems"));
    copyModel.add(CopyModel(contentModel: [ContentModel(htmlContent: editableDataForExam.first.htmlContent)], sectionName: "Exam"));

    copyModel.add(
      CopyModel(
        sectionName: "Impressions and Plan",
        contentModel:
            impressionAndPlanListFullNote.map((element) {
              return ContentModel(label: element.title, htmlContent: element.htmlContent);
            }).toList(),
      ),
    );

    return copyModel;
  }

  void loadPatientNotePDF(String visitID) async {
    var response = await _patientInfoRepository.loadPatientNotePDF(visitId, "${patientData.value?.responseData?.patientFirstName}_${patientData.value?.responseData?.patientLastName}_patient_note_${patientData.value?.responseData?.visitTime}");
  }

  Future<void> closeDoctorPopOverController() async {
    if (doctorPopoverController.opened) {
      doctorPopoverController.close();
    }
  }

  Future<void> closeAllProcedureDiagnosisPopover() async {
    if (doctorPopoverController.opened) {
      doctorPopoverController.close();
    }

    for (int s = 0; s < (tableModel.value?.rows.length ?? 0); s++) {
      if (tableModel.value?.rows[s].popoverController != null) {
        // if (tableModel.value?.rows[s].popoverController.opened == false) {
        //   tableModel.value?.rows[s].popoverController.close();
        // }
        if (tableModel.value?.rows[s].popoverController.opened == true) {
          tableModel.value?.rows[s].popoverController.close();
        }
      }

      if (tableModel.value?.rows[s].modifierPopoverController != null) {
        // if (tableModel.value?.rows[s].modifierPopoverController.opened == false) {
        //   tableModel.value?.rows[s].modifierPopoverController.close();
        // }

        if (tableModel.value?.rows[s].modifierPopoverController.opened == true) {
          tableModel.value?.rows[s].modifierPopoverController.close();
        }
      }
    }

    impressionAndPlanListFullNote.forEach((element) {
      element.popoverController.close();
    });

    impressionAndPlanList.forEach((element) {
      element.popoverController.close();
    });

    impressionAndPlanList.forEach((element) {
      if (element.focusNode.hasFocus) {
        customPrint("unit found");
        element.focusNode.unfocus();
      }
    });

    impressionAndPlanListFullNote.forEach((element) {
      if (element.focusNode.hasFocus) {
        customPrint("unit found");
        element.focusNode.unfocus();
      }
    });

    for (int rows = 0; rows < (tableModel.value?.rows.length ?? 0); rows++) {
      for (int cols = 0; cols < (tableModel.value?.rows[rows].cells.length ?? 0); cols++) {
        for (int newItems = 0; newItems < (tableModel.value?.rows[rows].cells[cols].items.length ?? 0); newItems++) {
          if (tableModel.value?.rows[rows].cells[cols].items[newItems].unitFocusNode.hasFocus ?? false) {
            customPrint("unit found");
            tableModel.value?.rows[rows].cells[cols].items[newItems].unitFocusNode.unfocus();
          }

          if (tableModel.value?.rows[rows].cells[cols].items[newItems].focusNode.hasFocus ?? false) {
            customPrint("focusnode found");
            tableModel.value?.rows[rows].cells[cols].items[newItems].focusNode.unfocus();
          }

          for (int diag = 0; diag < (tableModel.value?.rows[rows].cells[cols].items[newItems].diagnosisModelList?.length ?? 0); diag++) {
            tableModel.value?.rows[rows].cells[cols].items[newItems].diagnosisModelList?[diag].popoverController.close();
          }
        }
      }
    }
  }

  Future<void> updateImpressionAndPlanFullNoteAttachmentName(String? title, int? id) async {
    Map<String, dynamic> params = {};

    if ((title ?? "").isNotEmpty) {
      params["file_name"] = title;
      customPrint(params);

      try {
        var response = await _patientInfoRepository.updateImpressionAndPlanFullNoteAttachmentName(id: id ?? 0, params: params);
        customPrint("messages:ImpressionAttachment $response");
      } catch (e) {
        customPrint(e);
      }
    }
  }

  Future<void> closeOnlyDoctorviewPopover() async {
    for (int s = 0; s < (tableModel.value?.rows.length ?? 0); s++) {
      if (tableModel.value?.rows[s].popoverController != null) {
        if (tableModel.value?.rows[s].popoverController.opened == false) {
          tableModel.value?.rows[s].popoverController.close();
        }
      }

      if (tableModel.value?.rows[s].modifierPopoverController != null) {
        if (tableModel.value?.rows[s].modifierPopoverController.opened == false) {
          tableModel.value?.rows[s].modifierPopoverController.close();
        }
      }
    }

    for (int rows = 0; rows < (tableModel.value?.rows.length ?? 0); rows++) {
      for (int cols = 0; cols < (tableModel.value?.rows[rows].cells.length ?? 0); cols++) {
        for (int newItems = 0; newItems < (tableModel.value?.rows[rows].cells[cols].items.length ?? 0); newItems++) {
          for (int diag = 0; diag < (tableModel.value?.rows[rows].cells[cols].items[newItems].diagnosisModelList?.length ?? 0); diag++) {
            tableModel.value?.rows[rows].cells[cols].items[newItems].diagnosisModelList?[diag].popoverController.close();
          }
        }
      }
    }
  }

  void updateLists() {
    impressionAndPlanListFullNote.refresh();
    generalAttachments?.refresh();
    isFullNoteAttachment.value = true;
    updateImpressionAndPlanFullNote();
  }

  bool isValidIndex(int index, List list) => index >= 0 && index < list.length;

  void safeInsert(List list, dynamic item, int index) {
    index = index.clamp(0, list.length);
    list.insert(index, item);
  }

  void safeRemoveAt(List list, int index) {
    if (isValidIndex(index, list)) {
      list.removeAt(index);
    }
  }
}

class KeyboardController extends GetxController {
  static KeyboardController get to => Get.find();

  final RxBool isKeyboardOpen = false.obs;
  final RxDouble keyboardHeight = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _setupKeyboardListener();
  }

  void _setupKeyboardListener() {
    // Using WidgetsBinding to listen to keyboard changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Listen for changes in the view insets
      WidgetsBinding.instance.addPersistentFrameCallback((_) {
        _checkKeyboardStatus();
      });
    });
  }

  void _checkKeyboardStatus() {
    final viewInsets = EdgeInsets.fromViewPadding(WidgetsBinding.instance.window.viewInsets, WidgetsBinding.instance.window.devicePixelRatio);
    final newHeight = viewInsets.bottom;

    keyboardHeight.value = newHeight;
    isKeyboardOpen.value = newHeight > 0;
  }

  // Helper method to close keyboard
  void closeKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}

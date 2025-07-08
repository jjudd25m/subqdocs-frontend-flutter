import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html;
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:subqdocs/app/modules/patient_info/model/patient_fullnote_model.dart';
import 'package:subqdocs/app/modules/patient_info/model/patient_view_list_model.dart';
import 'package:subqdocs/app/modules/patient_info/repository/patient_info_repository.dart';
import 'package:toastification/toastification.dart';

import '../../../../utils/Loader.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/app_string.dart';
import '../../../../widget/custom_animated_button.dart';
import '../../../../widgets/custom_toastification.dart';
import '../../../core/common/app_preferences.dart';
import '../../../core/common/global_mobile_controller.dart';
import '../../../core/common/logger.dart';
import '../../../data/service/socket_service.dart';
import '../../../models/ChangeModel.dart';
import '../../../modules/login/model/login_model.dart';
import '../../../modules/patient_info/model/icd10_code_list_model.dart';
import '../../../modules/patient_info/model/impresion_and_plan_view_model.dart';
import '../../../modules/patient_info/model/patient_doctor_visit_data_model.dart';
import '../../../modules/visit_main/model/patient_transcript_upload_model.dart';
import '../../../modules/visit_main/model/visit_main_model.dart';
import '../../../modules/visit_main/repository/visit_main_repository.dart';
import '../../../routes/app_pages.dart';
import '../copy_model.dart';

class PatientInfoMobileViewController extends GetxController with GetTickerProviderStateMixin {
  final List<GlobalKey> tabKeys = [
    GlobalKey(), // For "Full Note" (index 0)
    GlobalKey(), // For "Patient Note" (index 1)
    GlobalKey(), // For "Power View" (index 2)
    GlobalKey(), // For "Transcript" (index 3)
  ];
  final ScrollController scrollController = ScrollController();

  final GlobalMobileController globalController = Get.find();

  Rxn<PatientDoctorVisitDataModel> patientDoctorVisitDataModel = Rxn();
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

  SocketService socketService = SocketService();
  String patientId = "";
  String visitId = "";

  final VisitMainRepository _visitMainRepository = VisitMainRepository();
  final PatientInfoRepository repository = PatientInfoRepository();
  Rxn<PatientFullNoteModel> patientFullNoteModel = Rxn();
  Rxn<PatientViewListModel> patientViewListModel = Rxn();

  // RxString isFullNoteLoadText = RxString("Waiting for response!");
  // RxString isPatientViewLoadText = RxString("Waiting for response!");
  RxnString isFullNoteErrorText = RxnString();
  RxnString isPatientViewErrorText = RxnString();
  Rxn<VisitMainPatientDetails> patientData = Rxn();

  String? fromRecording;

  RxList<ImpresionAndPlanViewModel> impressionAndPlanListFullNote = RxList();
  RxList<ImpresionAndPlanViewModel> impressionAndPlanList = RxList();
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
  RxList<Attachments> generalAttachments = <Attachments>[].obs;
  Rxn<LoginModel> loginData = Rxn();
  RxBool isFullNoteAttachment = RxBool(false);

  @override
  Future<void> onInit() async {
    patientId = Get.arguments["patientId"];
    visitId = Get.arguments["visitId"];

    if (Get.arguments["fromRecording"] == "1") {
      fromRecording = Get.arguments["fromRecording"];
    }

    loginData.value = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

    await getPatientDetails();

    if (fromRecording == null) {
      if (patientData.value?.responseData?.visitStatus == "In-Exam") {
        getSocketEventData();
      } else {
        getInitData();
      }
    }

    print("visit status ${patientData.value?.responseData?.visitStatus}");

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    // getAllPatientInfo();
    getSocketEventData();
  }

  Future<void> getSocketEventData() async {
    customPrint("its on claaed");
    var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

    if (patientTranscriptUploadModel.responseData != null) {
      customPrint("socket status:- ${socketService.socket.connected}");
      if (socketService.socket.connected) {
        customPrint("socket is connected");

        isFullTranscriptLoading.value = true;
        isFullTranscriptLoadText.value = "Waiting for response";

        socketService.socket.emit("joinRoom", [loginData.responseData?.user?.id, visitId]);

        setUpFullNoteSocket();

        socketService.socket.on("openaiStatusUpdate", (data) {
          var res = data as Map<String, dynamic>;
          customPrint('Open Ai server status $res');

          CustomToastification().showChatGPTDownBanner();
        });

        socketService.socket.on("AllTabStatus", (data) {
          var res = data as Map<String, dynamic>;
          customPrint("---------------------------------------------");
          customPrint("AllTabStatus status is :- $res");

          String status = res["status"];
          String message = res["message"];

          if (status.toLowerCase() == "failure") {
            customPrint("PatientViewStatus failure");

            getPatientDetails();
            showPromptDialog(message);
          }
        });

        socketService.socket.on("DoctorsViewStatus", (data) {
          var res = data as Map<String, dynamic>;
          customPrint("---------------------------------------------");
          customPrint("DoctorsViewStatus status is :- $res");

          int visit_id = res["visit_id"];
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

              // getDoctorNote();
            } else if (status.toLowerCase() == "failure") {
              isDoctorViewLoading.value = false;
              isDoctorViewLoadText.value = "failure";
            }
          }
        });

        socketService.socket.on("FullNoteStatus", (data) {
          var res = data as Map<String, dynamic>;
          customPrint("---------------------------------------------");
          customPrint("FullNoteStatus status is :- $res");

          int visit_id = res["visit_id"];
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
              getPatientFullNoteData();
              // getFullNote();
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
              // getTranscript();
            }
          }
        });
      } else {
        customPrint("socket is not connected");
      }
    } else {
      if (visitId.isNotEmpty) {
        socketService.socket.emit("joinRoom", [loginData.responseData?.user?.id, int.parse(visitId)]);

        setUpFullNoteSocket();

        socketService.socket.on("openaiStatusUpdate", (data) {
          var res = data as Map<String, dynamic>;
          customPrint('Open Ai server status $res');

          CustomToastification().showChatGPTDownBanner();
        });

        socketService.socket.on("AllTabStatus", (data) {
          var res = data as Map<String, dynamic>;
          customPrint("---------------------------------------------");
          customPrint("AllTabStatus status is :- $res");

          String status = res["status"];
          String message = res["message"];

          if (status.toLowerCase() == "failure") {
            customPrint("PatientViewStatus failure");

            showPromptDialog(message);
            // showPrompError(Get.context!, message);
          }
        });

        socketService.socket.on("DoctorsViewStatus", (data) {
          var res = data as Map<String, dynamic>;
          customPrint("---------------------------------------------");
          customPrint("DoctorsViewStatus status is :- $res");

          int visit_id = res["visit_id"];
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

              // getDoctorNote();
            } else if (status.toLowerCase() == "failure") {
              isDoctorViewLoading.value = false;
              isDoctorViewLoadText.value = "failure";
            }
          }
        });

        socketService.socket.on("FullNoteStatus", (data) {
          var res = data as Map<String, dynamic>;
          customPrint("---------------------------------------------");
          customPrint("FullNoteStatus status is :- $res");

          int visit_id = res["visit_id"];
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

              getPatientFullNoteData();
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
              // getTranscript();
            }
          }
        });
      }
    }
  }

  Future<void> showPromptDialog(String message) async {
    showDialog(
      context: Get.context!,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 16,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: const BoxDecoration(color: AppColors.backgroundPurple, borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
                  child: Padding(padding: const EdgeInsets.all(10), child: Row(mainAxisSize: MainAxisSize.min, children: [Text("", style: AppFonts.medium(15, Colors.white)), const Spacer(), const SizedBox(width: 10)])),
                ),
                Container(
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      const Icon(Icons.info_outline, color: AppColors.redText, size: 100),
                      const SizedBox(height: 20),
                      Text(message, style: AppFonts.medium(17, AppColors.textBlack)),
                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          spacing: 20,
                          children: [
                            Expanded(
                              child: CustomAnimatedButton(
                                onPressed: () {
                                  // Get.put(GlobalController());
                                  // Get.until(Routes.HOME);

                                  Get.until((route) => Get.currentRoute == Routes.HOME_VIEW_MOBILE);
                                  // final GlobalController globalController = Get.find();
                                  // globalController.breadcrumbHistory.clear();
                                  // globalController.addRoute(Routes.HOME);
                                },
                                text: " Okay ",
                                isOutline: true,
                                enabledTextColor: AppColors.textWhite,
                                enabledColor: AppColors.backgroundPurple,
                                outLineEnabledColor: AppColors.textGrey,
                                outlineColor: AppColors.backgroundPurple,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> getPatientDoctorVisitData() async {
    patientDoctorVisitDataModel.value = await repository.getDoctorVisitData(id: visitId);
    getPatientDetails();
    // customPrint("getPatientDoctorVisitData is :- ${patientDoctorVisitDataModel.value?.toJson()}");
  }

  Future<void> getPatientView() async {
    patientViewListModel.value = await repository.getPatientView(id: visitId);

    setPatientViewEditableData();
    getPatientDetails();
    customPrint("getPatientView is :- ${patientViewListModel.value?.toJson()}");
  }

  Future<void> getPatientDetails() async {
    Map<String, dynamic> param = {};
    param['visit_id'] = visitId;
    patientData.value = await _visitMainRepository.getPatientDetails(param: param);

    // print("visit status:- ${patientData.value?.responseData?.visitStatus}");
  }

  void getInitData() async {
    await Future.wait([getPatientFullNoteData(), getPatientNoteData()]);
  }

  Future<void> getPatientFullNoteData() async {
    try {
      patientFullNoteModel.value = await repository.getFullNote(id: visitId.toString());

      if (patientFullNoteModel.value?.responseData == null) {
        isFullNoteErrorText.value = "No data found";
        update();
      }
      setImpressionAndPlanListPatientView();
    } catch (e) {
      isFullNoteErrorText.value = e.toString();
      e.printError();
    }
  }

  void setImpressionAndPlanListPatientView() {
    if (patientFullNoteModel.value?.responseData?.fullNoteDetails?.impressionsAndPlan != null) {
      impressionAndPlanListFullNote.clear();

      for (var impressionsAndPlan in patientFullNoteModel.value?.responseData?.fullNoteDetails?.impressionsAndPlan ?? []) {
        HtmlEditorController htmlEditorController = HtmlEditorController();
        // htmlEditorController.setText(ImpressionsAndPlan.content ?? "");

        impressionAndPlanListFullNote.add(ImpresionAndPlanViewModel(htmlContent: impressionsAndPlan.content ?? "", htmlEditorController: htmlEditorController, title: impressionsAndPlan.title, siblingIcd10FullNote: impressionsAndPlan.siblingIcd10,attachments: impressionsAndPlan.attachments ?? []));
      }

      impressionAndPlanListFullNote.refresh();
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

  Future<void> getPatientNoteData() async {
    try {
      patientViewListModel.value = await repository.getPatientView(id: visitId.toString());

      setPatientViewEditableData();

      if (patientViewListModel.value?.responseData == null) {
        isPatientViewErrorText.value = "No data found!";
      }
    } catch (e) {
      isPatientViewErrorText.value = e.toString();
      e.printError();
    }
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

  Future<void> changeStatus(Map<String, dynamic> param) async {
    Loader().showLoadingDialogForSimpleLoader();

    ChangeStatusModel changeStatusModel = await repository.changeStatus(id: visitId.toString(), params: param);
    if (changeStatusModel.responseType == "success") {
      Loader().stopLoader();
      Get.until((route) => Get.currentRoute == Routes.HOME_VIEW_MOBILE);
    } else {
      Loader().stopLoader();
      CustomToastification().showToast("${changeStatusModel.message}", type: ToastificationType.error);
    }
  }

  void copyPatientViewSection() async {
    final StringBuffer formattedText = StringBuffer();

    // Add static heading
    formattedText.writeln('PATIENT NOTE \n');

    String plainText = _parsePatientViewHtmlToFormattedText(patientViewListModel.value?.responseData?.visitNoteDetails?.patientViewNoteHtml ?? "");

    await Clipboard.setData(ClipboardData(text: plainText));
    CustomToastification().showToast("Content copied to clipboard", type: ToastificationType.info);
  }

  void copyAllSection() async {
    List<CopyModel> copyModel = initCopyModel();
    copyMedicalRecordToClipboard(copyModel);
  }

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

    // dom.Document document = html.parse(htmlString);
    //
    // // Comprehensive list of block-level elements
    // final Set<String> blockElements = {
    //   'address', 'article', 'aside', 'blockquote', 'canvas', 'dd', 'div',
    //   'dl', 'dt', 'fieldset', 'figcaption', 'figure', 'footer', 'form', 'h1',
    //   'h2', 'h3', 'h4', 'h5', 'h6', 'header', 'hr', 'li', 'main', 'nav',
    //   'noscript', 'ol', 'p', 'pre', 'section', 'table', 'tfoot', 'ul', 'video',
    //   'br', 'tr', 'td', 'th', 'thead', 'tbody', 'caption', 'colgroup', 'col',
    //   'article', 'aside', 'details', 'dialog', 'summary', 'menu', 'menuitem',
    //   'output', 'progress', 'meter', 'legend', 'map', 'object', 'iframe',
    //   // Deprecated but still seen in legacy HTML
    //   'center', 'dir', 'isindex', 'listing', 'plaintext', 'xmp',
    // };
    //
    // void extractText(dom.Node node, StringBuffer buffer) {
    //   if (node is dom.Text) {
    //     // Clean up and write text
    //     final text = node.text.replaceAll(RegExp(r'\s+'), ' ');
    //     buffer.write(text);
    //   } else if (node is dom.Element) {
    //     // Check if this is a title element (has color #6b4fe4)
    //     final isTitle = node.attributes['style']?.contains('#6b4fe4') ?? false;
    //
    //     // Add newline before title if it's not the first element
    //     if (isTitle && buffer.isNotEmpty) {
    //       buffer.write('\n');
    //     }
    //
    //     for (var child in node.nodes) {
    //       extractText(child, buffer);
    //       if (child is dom.Element && blockElements.contains(child.localName)) {
    //         buffer.write('\n');
    //       }
    //     }
    //   }
    // }
    //
    // final buffer = StringBuffer();
    // extractText(document.body ?? document.documentElement!, buffer);
    //
    // // Normalize multiple newlines and trim output
    // return buffer.toString().replaceAll(RegExp(r'\n\s*\n+'), '\n\n').trim();
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

  Future<void> updateImpressionAndPlanFullNote() async {
    Map<String, List<dynamic>> params = {};

    params["impressions_and_plan"] = impressionAndPlanListFullNote.map((item) => item.toJsonFullNote()).where((map) => map.isNotEmpty).toList();

    print(params);

    try {
      var response = await repository.updateImpressionAndPlanFullNote(id: patientFullNoteModel.value?.responseData?.id ?? 0, params: params);
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateFullNote(String keyName, List<ImpresionAndPlanViewModel> list) async {
    var response = await repository.updateFullNote(id: patientFullNoteModel.value?.responseData?.id ?? 0, params: buildParams(keyName, list));
  }

  Future<void> updatePatientView(String keyName, List<ImpresionAndPlanViewModel> list) async {
    var response = await repository.updatePatientView(id: patientViewListModel.value?.responseData?.id ?? 0, params: buildParams(keyName, list));
  }

  Map<String, String> buildParams(String keyName, List<ImpresionAndPlanViewModel> list) {
    return {keyName: list.firstOrNull?.htmlContent ?? ""};
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

  Future<void> closeAllProcedureDiagnosisPopover() async {
    for (var element in impressionAndPlanListFullNote) {
      element.popoverController.close();
    }

    for (var element in impressionAndPlanList) {
      element.popoverController.close();
    }

    for (var element in impressionAndPlanList) {
      if (element.focusNode.hasFocus) {
        element.focusNode.unfocus();
      }
    }

    for (var element in impressionAndPlanListFullNote) {
      if (element.focusNode.hasFocus) {
        element.focusNode.unfocus();
      }
    }
  }

  Future<Icd10CodeListModel> getIcd10CodeList(Map<String, dynamic> param) async {
    return await repository.getIcd10CodeAll(param: param);
  }

  Future<void> setUpFullNoteSocket() async {
    socketService.socket.on("isMedicalTranscriptStatus", (data) {
      var res = data as Map<String, dynamic>;

      String status = res["status"];
      String message = res["message"];

      if (status.toLowerCase() == "failure") {
        getInitData();
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
        print("patientFullNoteModel:- ${patientFullNoteModel.toJson()}");
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
        print("patientFullNoteModel:- ${patientFullNoteModel.toJson()}");
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
        getPatientDetails();
      }
    });

    socketService.socket.on("ImpressionAndPlanStatus", (data) {
      var res = data as Map<String, dynamic>;

      String status = res["status"];
      String message = res["message"];

      if (status.toLowerCase() == "success") {
        Map<String, dynamic> responseData = res["responseData"];
        Map<String, dynamic> fullNoteResponseData = responseData["full_note_details"];
        patientFullNoteModel.value = PatientFullNoteModel(message: "", toast: true, responseType: "success", responseData: PatientFullNoteResponseData(id: 0, message: "", status: "Success", fullNoteDetails: FullNoteDetails.fromJson(fullNoteResponseData)));

        impressionAndPlanListFullNote.clear();

        if (patientFullNoteModel.value?.responseData?.fullNoteDetails?.isImageGenerated ?? false) {
          socketService.socket.on("PhotoMetaDataStatus", (data) {
            var res = data as Map<String, dynamic>;
            String status = res["status"];
            String message = res["message"];

            if (status.toLowerCase() == "success") {
              Map<String, dynamic> responseData = res["responseData"];
              Map<String, dynamic> fullNoteResponseData = responseData["full_note_details"];

              patientFullNoteModel.value = PatientFullNoteModel(message: "", toast: true, responseType: "success", responseData: PatientFullNoteResponseData(id: responseData["id"], message: "", status: "Success", fullNoteDetails: FullNoteDetails.fromJson(fullNoteResponseData)));
            }
            for (var impressionsAndPlan in patientFullNoteModel.value?.responseData?.fullNoteDetails?.impressionsAndPlan ?? []) {
              HtmlEditorController htmlEditorController = HtmlEditorController();
              customPrint("message:attach ${impressionsAndPlan.attachments}");
              customPrint("message:attach ${impressionsAndPlan.title}");
              customPrint("message:attach ${impressionsAndPlan.content}");
              impressionAndPlanListFullNote.add(ImpresionAndPlanViewModel(htmlContent: impressionsAndPlan.content ?? "",
                  htmlEditorController: htmlEditorController,
                  title: impressionsAndPlan.title,
                  siblingIcd10FullNote: impressionsAndPlan.siblingIcd10,
                  slidableController: SlidableController(this),
                  attachments: impressionsAndPlan.attachments ?? []

              ));
            }
          });
        } else {
          for (var impressionsAndPlan in patientFullNoteModel.value?.responseData?.fullNoteDetails?.impressionsAndPlan ?? []) {
            HtmlEditorController htmlEditorController = HtmlEditorController();

            impressionAndPlanListFullNote.add(
              ImpresionAndPlanViewModel(
                htmlContent: impressionsAndPlan.content ?? "",
                htmlEditorController: htmlEditorController,
                title: impressionsAndPlan.title,
                siblingIcd10FullNote: impressionsAndPlan.siblingIcd10,
                slidableController: SlidableController(this),
                // attachments: [
                //   Attachments(
                //     id: 1863,
                //     fileName: "SubQDocs 1.png",
                //     filePath:
                //         "https://subqdocs-local-bucket.s3.us-east-2.amazonaws.com/uploads/attachments/1489-1751446179060-SubQDocs%201.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIA3RYC52MVG2KLA3OE%2F20250702%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250702T084939Z&X-Amz-Expires=604800&X-Amz-Signature=c012ba5bb09ba2be169aaaccedf81de92105ad40bfd28f3f5c7b129de5e6ab9c&X-Amz-SignedHeaders=host&x-amz-checksum-mode=ENABLED&x-id=GetObject",
                //     fileType: "image/png",
                //     fileSize: 107386,
                //     uploadedBy: 201,
                //     uploadedAt: "2025-07-02T08:49:39.346Z",
                //     visitId: 9014,
                //     patientId: 1489,
                //     isActive: false,
                //     timestamp: "00:00:47",
                //     createdAt: "2025-07-02T08:49:39.346Z",
                //     updatedAt: "2025-07-02T08:49:39.346Z",
                //     deletedAt: null,
                //   ),
                //   Attachments(
                //     id: 1860,
                //     fileName: "kajal.jpg",
                //     filePath:
                //         "https://subqdocs-local-bucket.s3.us-east-2.amazonaws.com/uploads/attachments/1489-1751446179055-kajal.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIA3RYC52MVG2KLA3OE%2F20250702%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250702T084939Z&X-Amz-Expires=604800&X-Amz-Signature=2a724179bce52e7303577f4e307ffe37edd8b508c8e646dbd61b04d5dfb1e77c&X-Amz-SignedHeaders=host&x-amz-checksum-mode=ENABLED&x-id=GetObject",
                //     fileType: "image/jpeg",
                //     fileSize: 29980,
                //     uploadedBy: 201,
                //     uploadedAt: "2025-07-02T08:49:39.298Z",
                //     visitId: 9014,
                //     patientId: 1489,
                //     isActive: false,
                //     timestamp: "00:00:20",
                //     createdAt: "2025-07-02T08:49:39.298Z",
                //     updatedAt: "2025-07-02T08:49:39.298Z",
                //     deletedAt: null,
                //   ),
                //   Attachments(
                //     id: 1862,
                //     fileName: "background.jpg",
                //     filePath:
                //         "https://subqdocs-local-bucket.s3.us-east-2.amazonaws.com/uploads/attachments/1489-1751446179055-background.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIA3RYC52MVG2KLA3OE%2F20250702%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250702T084939Z&X-Amz-Expires=604800&X-Amz-Signature=ade146f6ba73cdce808c5760fcc950eb54b43bf79fa745fdfe0466218d861feb&X-Amz-SignedHeaders=host&x-amz-checksum-mode=ENABLED&x-id=GetObject",
                //     fileType: "image/jpeg",
                //     fileSize: 1752623,
                //     uploadedBy: 201,
                //     uploadedAt: "2025-07-02T08:49:39.334Z",
                //     visitId: 9014,
                //     patientId: 1489,
                //     isActive: false,
                //     timestamp: "00:00:14",
                //     createdAt: "2025-07-02T08:49:39.334Z",
                //     updatedAt: "2025-07-02T08:49:39.334Z",
                //     deletedAt: null,
                //   ),
                //   Attachments(
                //     id: 1861,
                //     fileName: "Avatar.png",
                //     filePath:
                //         "https://subqdocs-local-bucket.s3.us-east-2.amazonaws.com/uploads/attachments/1489-1751446179053-Avatar.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIA3RYC52MVG2KLA3OE%2F20250702%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250702T084939Z&X-Amz-Expires=604800&X-Amz-Signature=52cf804afb395c3b5cbb9c137376d265f608dab8ffca28c4883f6e6ae57fd490&X-Amz-SignedHeaders=host&x-amz-checksum-mode=ENABLED&x-id=GetObject",
                //     fileType: "image/png",
                //     fileSize: 1449,
                //     uploadedBy: 201,
                //     uploadedAt: "2025-07-02T08:49:39.313Z",
                //     visitId: 9014,
                //     patientId: 1489,
                //     isActive: false,
                //     timestamp: "00:00:14",
                //     createdAt: "2025-07-02T08:49:39.313Z",
                //     updatedAt: "2025-07-02T08:49:39.313Z",
                //     deletedAt: null,
                //   ),
                //   Attachments(
                //     id: 1865,
                //     fileName: "out side (1).png",
                //     filePath:
                //         "https://subqdocs-local-bucket.s3.us-east-2.amazonaws.com/uploads/attachments/1489-1751446179059-out%20side%20%281%29.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIA3RYC52MVG2KLA3OE%2F20250702%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250702T084939Z&X-Amz-Expires=604800&X-Amz-Signature=30c9cdb3e8cdeabc6ecb8be1049c65eb4f4a05a2e07e24ee882a29a9859793f8&X-Amz-SignedHeaders=host&x-amz-checksum-mode=ENABLED&x-id=GetObject",
                //     fileType: "image/png",
                //     fileSize: 2083214,
                //     uploadedBy: 201,
                //     uploadedAt: "2025-07-02T08:49:39.433Z",
                //     visitId: 9014,
                //     patientId: 1489,
                //     isActive: false,
                //     timestamp: "00:00:32",
                //     createdAt: "2025-07-02T08:49:39.433Z",
                //     updatedAt: "2025-07-02T08:49:39.433Z",
                //     deletedAt: null,
                //   ),
                // ],
                attachments: impressionsAndPlan.attachments ?? [],
              ),
            );
          }
        }

        impressionAndPlanListFullNote.refresh();
        getPatientDetails();
      }
    });
  }

  Future<void> updateImpressionAndPlanFullNoteAttachmentName(String? title, int? id) async {
    Map<String, dynamic> params = {};

    if ((title ?? "").isNotEmpty) {
      params["file_name"] = title;
      customPrint(params);

      try {
        var response = await repository.updateImpressionAndPlanFullNoteAttachmentName(id: id ?? 0, params: params);
        customPrint("messages:ImpressionAttachment $response");
      } catch (e) {
        customPrint(e);
      }
    }
  }
}

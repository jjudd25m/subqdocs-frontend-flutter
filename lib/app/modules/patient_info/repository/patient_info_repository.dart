// import 'dart:io';
// import 'dart:convert';
// import 'dart:async';
import 'dart:async';
import 'dart:io';

// import 'dart:io';
// import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:subqdocs/utils/Loader.dart';
import 'package:subqdocs/widgets/custom_toastification.dart';
import 'package:toastification/toastification.dart';

import '../../../core/common/logger.dart';
import '../../../data/provider/api_provider.dart';
import '../../../models/ChangeModel.dart';
import '../../visit_main/model/doctor_view_model.dart';
import '../model/check_doctor_pin_expired_model.dart';
import '../model/get_CPT_code_model.dart';
import '../model/get_doctor_list_by_role_model.dart';
import '../model/get_modifier_code_model.dart';
import '../model/icd10_code_list_model.dart';
import '../model/patient_doctor_visit_data_model.dart';
import '../model/patient_fullnote_model.dart';
import '../model/patient_view_list_model.dart';
import '../model/transcript_list_model.dart';

class PatientInfoRepository {
  Future<TranscriptListModel> getTranscript({required String id}) async {
    try {
      var response = await ApiProvider.instance.callGet("patient/transcript/$id");
      customPrint("try getTranscript API  internal response $response");
      return TranscriptListModel.fromJson(response);
    } catch (e) {
      customPrint("catch getTranscript API  internal response $e");
      return TranscriptListModel(message: "$e", responseType: "Failure");
    }
  }

  Future<PatientViewListModel> getPatientView({required String id}) async {
    try {
      var response = await ApiProvider.instance.callGet("patient-view/$id");
      customPrint("try getPatientView API  internal response $response");
      return PatientViewListModel.fromJson(response);
    } catch (e) {
      customPrint("catch getPatientView API  internal response  $e");
      return PatientViewListModel(message: "$e", responseType: "error", responseData: null);
    }
  }

  Future<ChangeStatusModel> getStatus() async {
    var response = await ApiProvider.instance.callGet("patient/visit/status", queryParameters: {});
    customPrint("getPatientView API  internal response $response");
    return ChangeStatusModel.fromJson(response);
  }

  Future<ChangeStatusModel> changeStatus({required String id, required Map<String, dynamic> params}) async {
    var response = await ApiProvider.instance.callPut("patient/updateVisitStatus/$id", params);
    customPrint("getPatientView API  internal response $response");
    return ChangeStatusModel.fromJson(response);
  }

  Future<PatientDoctorVisitDataModel> getDoctorVisitData({required String id}) async {
    var response = await ApiProvider.instance.callGet("patient-visit/$id");
    customPrint("getPatientView API  internal response $response");
    return PatientDoctorVisitDataModel.fromJson(response);
  }

  Future<dynamic> updateImpressionAndPlan({required int id, required Map<String, dynamic> params}) async {
    var response = await ApiProvider.instance.callPut("doctors-view/impression_plan/update/$id", params);
    customPrint("getPatientView API  internal response $response");
    return response;
  }

  Future<dynamic> updateImpressionAndPlanFullNote({required int id, required Map<String, dynamic> params}) async {
    var response = await ApiProvider.instance.callPut("full-note/impression_plan/update/$id", params);
    customPrint("getPatientView API  internal response $response");
    return response;
  }

  Future<dynamic> updateFullNote({required int id, required Map<String, dynamic> params}) async {
    var response = await ApiProvider.instance.callPut("full-note/update/$id", params);
    customPrint("getPatientView API  internal response $response");
    return response;
  }

  Future<dynamic> updatePatientView({required int id, required Map<String, dynamic> params}) async {
    var response = await ApiProvider.instance.callPut("patient-view/update/$id", params);
    customPrint("getPatientView API  internal response $response");
    return response;
  }

  Future<PatientFullNoteModel> getFullNote({required String id}) async {
    // try {
    var response = await ApiProvider.instance.callGet("full-note/$id");
    customPrint("getFullNote API  internal response $response");
    PatientFullNoteModel res = PatientFullNoteModel.fromJson(response);
    return res;
    // return PatientFullNoteModel.fromJson(response);
    // } catch (e) {
    //   customPrint("getFullNote API  internal response $e");
    //   return PatientFullNoteModel(message: "$e", responseType: "error", responseData: null);
    // }
  }

  Future<DoctorViewModel> getDoctorNote({required String id}) async {
    try {
      var response = await ApiProvider.instance.callGet("doctors-view/$id");
      customPrint("try getDoctorNote API  internal response $response");
      return DoctorViewModel.fromJson(response);
    } catch (e) {
      customPrint("catch getDoctorNote API  internal response $e");
      return DoctorViewModel(message: "$e", responseType: "error", responseData: null);
    }
  }

  Future<dynamic> updateDoctorView({required String id, required Map<String, dynamic> params}) async {
    var response = await ApiProvider.instance.callPut("doctors-view-table/update/$id", params);
    customPrint("updateDoctorView API  internal response $response");
    return response;
  }

  Future<GetCPTCodeModel> getCPTCodeAll({required Map<String, dynamic> param}) async {
    var response = await ApiProvider.instance.callGet("cpt-code/getAll", queryParameters: param);
    return GetCPTCodeModel.fromJson(response);
  }

  Future<dynamic> hasEncounter({required String id}) async {
    var response = await ApiProvider.instance.callGet("patient-visit/hasEncounter/$id", queryParameters: {});
    print("hasEncounter repo response ${response}");
    return response;
  }

  Future<Icd10CodeListModel> getIcd10CodeAll({required Map<String, dynamic> param}) async {
    var response = await ApiProvider.instance.callGet("icd-10/getAll", queryParameters: param);
    return Icd10CodeListModel.fromJson(response);
  }

  Future<GetModifierCodeModel> getModifierCodeAll({required Map<String, dynamic> param}) async {
    var response = await ApiProvider.instance.callGet("modifier-code/getAll", queryParameters: param);
    return GetModifierCodeModel.fromJson(response);
  }

  Future<GetDoctorListByRoleModel> getDoctorByRole() async {
    var response = await ApiProvider.instance.callGet("getUsersByRole", queryParameters: {'role': 'Doctor'});
    return GetDoctorListByRoleModel.fromJson(response);
  }

  Future<CheckDoctorPinExpiredModel> checkDoctorPIN(String doctorId) async {
    var response = await ApiProvider.instance.callGet("user/getUserPin/$doctorId", queryParameters: {});
    return CheckDoctorPinExpiredModel.fromJson(response);
  }

  Future<dynamic> updateImpressionAndPlanFullNoteAttachmentName({required int id, required Map<String, dynamic> params}) async {
    var response = await ApiProvider.instance.callPut("patient-visit/update-attachment/$id", params);
    customPrint("getPatientView API  internal response $response");
    return response;
  }

  // Future<void> loadDoctorviewPDF(String visitID) async {
  //   try {
  //     // Call the API to get the PDF bytes directly
  //     Uint8List pdfBytes = await ApiProvider.instance.callGetDownloadPDF("download-doctors-view-pdf?visit_id=$visitID", queryParameters: {});
  //
  //     // Get temporary directory
  //     Directory directory = await getApplicationDocumentsDirectory();
  //     String filePath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}_doctor_view.pdf';
  //
  //     // Write bytes to file
  //     File file = File(filePath);
  //     await file.writeAsBytes(pdfBytes);
  //
  //     customPrint("PDF saved to: $filePath");
  //
  //     // Open PDF viewer
  //     Navigator.push(Get.context!, MaterialPageRoute(builder: (context) => PDFScreen(path: filePath)));
  //   } catch (e) {
  //     customPrint("Error downloading or displaying PDF: $e");
  //     // Show error to user
  //     Get.snackbar("Error", "Failed to load PDF: ${e.toString()}", snackPosition: SnackPosition.BOTTOM);
  //   }
  // }

  Future<void> loadPatientNotePDF(String visitID, String pdfName) async {
    Loader().showLoadingDialogForSimpleLoader();

    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();

    try {
      // Call the API to get the PDF bytes
      Uint8List pdfBytes = await ApiProvider.instance.callGetDownloadPDF("download-patient-view-pdf?visit_id=$visitID&timezone=$currentTimeZone", queryParameters: {});

      // Generate a filename
      String fileName = '$pdfName.pdf';

      // Save to app's PDF folder
      String filePath = await savePdfToAppFolder(pdfBytes, fileName);

      customPrint("PDF saved to: $filePath");
      Loader().stopLoader();
      CustomToastification().showToast("PDF download successfully!", type: ToastificationType.success);
      // Open PDF viewer
      // Navigator.push(
      //   Get.context!,
      //   PageRouteBuilder(
      //     pageBuilder: (context, animation, secondaryAnimation) => PDFScreen(path: filePath),
      //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
      //       return FadeTransition(
      //         opacity: animation,
      //         child: Container(
      //           color: Colors.white, // Background color
      //           child: child,
      //         ),
      //       );
      //     },
      //   ),
      // );
      // Navigator.push(
      //   Get.context!,
      //   MaterialPageRoute(theme: Theme.of(context).copyWith(scaffoldBackgroundColor: Colors.white, canvasColor: Colors.white), builder: (context) => PDFScreen(path: filePath)),
      // );
    } catch (e) {
      Loader().stopLoader();
      customPrint("Error downloading or displaying PDF: $e");
      Get.snackbar("Error", "Failed to load PDF: ${e.toString()}", snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> loadFullNotePDF(String visitID, String pdfName) async {
    Loader().showLoadingDialogForSimpleLoader();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();

    try {
      // Call the API to get the PDF bytes
      Uint8List pdfBytes = await ApiProvider.instance.callGetDownloadPDF("download-notes?visit_id=$visitID&timezone=$currentTimeZone", queryParameters: {});

      // Generate a filename
      String fileName = '$pdfName.pdf';

      // Save to app's PDF folder
      String filePath = await savePdfToAppFolder(pdfBytes, fileName);

      customPrint("PDF saved to: $filePath");
      Loader().stopLoader();
      CustomToastification().showToast("PDF download successfully!", type: ToastificationType.success);
      // Open PDF viewer
      // Navigator.push(
      //   Get.context!,
      //   PageRouteBuilder(
      //     pageBuilder: (context, animation, secondaryAnimation) => PDFScreen(path: filePath),
      //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
      //       return FadeTransition(
      //         opacity: animation,
      //         child: Container(
      //           color: Colors.white, // Background color
      //           child: child,
      //         ),
      //       );
      //     },
      //   ),
      // );
      // Navigator.push(
      //   Get.context!,
      //   MaterialPageRoute(theme: Theme.of(context).copyWith(scaffoldBackgroundColor: Colors.white, canvasColor: Colors.white), builder: (context) => PDFScreen(path: filePath)),
      // );
    } catch (e) {
      Loader().stopLoader();
      customPrint("Error downloading or displaying PDF: $e");
      Get.snackbar("Error", "Failed to load PDF: ${e.toString()}", snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> loadDoctorviewPDF(String visitID, String pdfName) async {
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();

    Loader().showLoadingDialogForSimpleLoader();

    try {
      // Call the API to get the PDF bytes
      Uint8List pdfBytes = await ApiProvider.instance.callGetDownloadPDF("download-doctors-view-pdf?visit_id=$visitID&timezone=$currentTimeZone", queryParameters: {});

      // Generate a filename
      String fileName = '$pdfName.pdf';

      // Save to app's PDF folder
      String filePath = await savePdfToAppFolder(pdfBytes, fileName);

      customPrint("PDF saved to: $filePath");
      Loader().stopLoader();

      CustomToastification().showToast("PDF download successfully!", type: ToastificationType.success);
      // Open PDF viewer
      // Navigator.push(
      //   Get.context!,
      //   PageRouteBuilder(
      //     pageBuilder: (context, animation, secondaryAnimation) => PDFScreen(path: filePath),
      //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
      //       return FadeTransition(
      //         opacity: animation,
      //         child: Container(
      //           color: Colors.white, // Background color
      //           child: child,
      //         ),
      //       );
      //     },
      //   ),
      // );
      // Navigator.push(
      //   Get.context!,
      //   MaterialPageRoute(theme: Theme.of(context).copyWith(scaffoldBackgroundColor: Colors.white, canvasColor: Colors.white), builder: (context) => PDFScreen(path: filePath)),
      // );
    } catch (e) {
      Loader().stopLoader();
      customPrint("Error downloading or displaying PDF: $e");
      Get.snackbar("Error", "Failed to load PDF: ${e.toString()}", snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Helper function to save PDF to app folder
  Future<String> savePdfToAppFolder(Uint8List pdfBytes, String fileName) async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final Directory pdfDir = Directory('${appDocDir.path}/pdfs');

    if (!await pdfDir.exists()) {
      await pdfDir.create(recursive: true);
    }

    final String filePath = '${pdfDir.path}/$fileName';
    await File(filePath).writeAsBytes(pdfBytes);

    return filePath;
  }

  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }
      return status.isGranted;
    }
    return true; // No permission needed on iOS for app directories
  }
}

class PDFScreen extends StatefulWidget {
  final String? path;

  const PDFScreen({super.key, this.path});

  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  final Completer<PDFViewController> _controller = Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("")),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: true,
            pageSnap: true,
            defaultPage: currentPage!,
            fitPolicy: FitPolicy.BOTH,
            preventLinkNavigation: false,
            // if set to true the link is handled in flutter
            backgroundColor: const Color(0xFFFEF7FF),
            onRender: (_pages) {
              setState(() {
                pages = _pages;
                isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
              customPrint(error.toString());
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = '$page: ${error.toString()}';
              });
              customPrint('$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
            onLinkHandler: (String? uri) {
              customPrint('goto uri: $uri');
            },
            onPageChanged: (int? page, int? total) {
              customPrint('page change: ${page ?? 0 + 1}/$total');
              setState(() {
                currentPage = page;
              });
            },
          ),
          errorMessage.isEmpty
              ? !isReady
                  ? const Center(child: CircularProgressIndicator())
                  : Container()
              : Center(child: Text(errorMessage)),
        ],
      ),
      // floatingActionButton: FutureBuilder<PDFViewController>(
      //   future: _controller.future,
      //   builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
      //     if (snapshot.hasData) {
      //       return FloatingActionButton.extended(
      //         label: Text("Go to ${pages! ~/ 2}"),
      //         onPressed: () async {
      //           await snapshot.data!.setPage(pages! ~/ 2);
      //         },
      //       );
      //     }
      //
      //     return Container();
      //   },
      // ),
    );
  }
}

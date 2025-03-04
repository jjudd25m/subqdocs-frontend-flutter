import 'package:get/get.dart';

class GlobalController extends GetxController {
  RxInt homeTabIndex = RxInt(0);

  // LoginModel loginData = LoginModel();
  // Rxn<UserWorkStationModel> workStationData = Rxn<UserWorkStationModel>();
  // RxList<ProjectRatingTradeModel> userProjectRating = RxList();
  // RxDouble avgUserProjectRating = RxDouble(0.0);
  //
  // RxBool workStationFlowStep1 = RxBool(false);
  // RxBool workStationFlowStep2 = RxBool(false);
  // RxBool workStationFlowStep3 = RxBool(false);
  // RxBool workStationFlowStep4 = RxBool(false);
  // RxBool workStationFlowStep5 = RxBool(false);
  //
  // RxList<TradePassportJobListModel> tradePassportJobListModel = RxList<TradePassportJobListModel>();
  // RxList<WorkStationSkillModel> workStationSkillModel = RxList<WorkStationSkillModel>();
  // RxList<WorkStationInsuranceModel> workStationInsuranceModel = RxList<WorkStationInsuranceModel>();
  // RxList<WorkStationCertificateModel> workStationCertificateModel = RxList<WorkStationCertificateModel>();
  // RxList<WorkStationGalleryModel> workStationGalleryModel = RxList<WorkStationGalleryModel>();
  // RxList<GetServiceSkillModel> getServiceSkillModel = RxList<GetServiceSkillModel>();
  //
  // RxList<TradeReviewListModel> tradeReviewListModel = RxList<TradeReviewListModel>();
  //
  // // RxList<GetServiceSkillModel> serviceSkillList = RxList<GetServiceSkillModel>();
  // Rxn<UserDetailModel> userDetailModel = Rxn<UserDetailModel>();
  // RxList<JobTemplateModel> getJobTemplateList = RxList<JobTemplateModel>();
  // RxString profileUrl = RxString("");

  @override
  void onInit() async {
    super.onInit();

    // loadData();
  }

  // Future<void> loadData() async {
  //   loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));
  //
  //   String activeWorkStation = AppPreference.instance.getString(AppString.prefkeyActiveWorkStation);
  //   Map<String, dynamic> dsd = json.decode(activeWorkStation);
  //   workStationData.value = UserWorkStationModel.fromJson(dsd);
  // }
}

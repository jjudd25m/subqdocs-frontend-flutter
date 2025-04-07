import 'package:get/get.dart';

import '../modules/add_patient/bindings/add_patient_binding.dart';
import '../modules/add_patient/views/add_patient_view.dart';
import '../modules/all_attachment/bindings/all_attachment_binding.dart';
import '../modules/all_attachment/views/all_attachment_view.dart';
import '../modules/edit_patient_details/bindings/edit_patent_details_binding.dart';
import '../modules/edit_patient_details/views/edit_patent_details_view.dart';
import '../modules/forgot_password/bindings/forgot_password_binding.dart';
import '../modules/forgot_password/views/forgot_password_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/invited_user_submitted/bindings/invited_user_submitted_binding.dart';
import '../modules/invited_user_submitted/views/invited_user_submitted_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/patient_info/bindings/patient_info_binding.dart';
import '../modules/patient_info/views/patient_info_view.dart';
import '../modules/patient_profile/bindings/patient_profile_binding.dart';
import '../modules/patient_profile/views/patient_profile_view.dart';
import '../modules/patient_view_read_only/bindings/patient_view_read_only_binding.dart';
import '../modules/patient_view_read_only/views/patient_view_read_only_view.dart';
import '../modules/personal_setting/bindings/personal_setting_binding.dart';
import '../modules/personal_setting/views/personal_setting_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/sign_up/bindings/sign_up_binding.dart';
import '../modules/sign_up/views/sign_up_view.dart';
import '../modules/sign_up_profile_complete/bindings/sign_up_profile_complete_binding.dart';
import '../modules/sign_up_profile_complete/views/sign_up_profile_complete_view.dart';
import '../modules/sign_up_set_organization_info/bindings/sign_up_set_organization_info_binding.dart';
import '../modules/sign_up_set_organization_info/views/sign_up_set_organization_info_view.dart';
import '../modules/sign_up_set_password/bindings/sign_up_set_password_binding.dart';
import '../modules/sign_up_set_password/views/sign_up_set_password_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/visit_main/bindings/visit_main_binding.dart';
import '../modules/visit_main/views/visit_main_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.VISIT_MAIN,
      page: () => VisitMainView(),
      binding: VisitMainBinding(),
    ),
    GetPage(
      name: _Paths.PATIENT_INFO,
      page: () => PatientInfoView(),
      binding: PatientInfoBinding(),
    ),
    GetPage(
      name: _Paths.ALL_ATTACHMENT,
      page: () => AllAttachmentView(),
      binding: AllAttachmentBinding(),
    ),
    GetPage(
      name: _Paths.PATIENT_VIEW_READ_ONLY,
      page: () => PatientViewReadOnlyView(),
      binding: PatientViewReadOnlyBinding(),
    ),
    GetPage(
      name: _Paths.ADD_PATIENT,
      page: () => AddPatientView(),
      binding: AddPatientBinding(),
    ),
    GetPage(
      name: _Paths.SCHEDULE_PATIENT,
      page: () => AddPatientView(),
      binding: AddPatientBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PATENT_DETAILS,
      page: () => EditPatentDetailsView(),
      binding: EditPatentDetailsBinding(),
    ),
    GetPage(
      name: _Paths.PATIENT_PROFILE,
      page: () => PatientProfileView(),
      binding: PatientProfileBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: _Paths.SIGN_UP,
      page: () => SignUpView(),
      binding: SignUpBinding(),
    ),
    GetPage(
      name: _Paths.PERSONAL_SETTING,
      page: () => PersonalSettingView(),
      binding: PersonalSettingBinding(),
    ),
    GetPage(
      name: _Paths.INVITED_USER_SUBMITTED,
      page: () => InvitedUserSubmittedView(),
      binding: InvitedUserSubmittedBinding(),
    ),
    GetPage(
      name: _Paths.SIGN_UP_SET_PASSWORD,
      page: () => SignUpSetPasswordView(),
      binding: SignUpSetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.SIGN_UP_SET_ORGANIZATION_INFO,
      page: () => SignUpSetOrganizationInfoView(),
      binding: SignUpSetOrganizationInfoBinding(),
    ),
    GetPage(
      name: _Paths.SIGN_UP_PROFILE_COMPLETE,
      page: () => SignUpProfileCompleteView(),
      binding: SignUpProfileCompleteBinding(),
    ),
  ];
}

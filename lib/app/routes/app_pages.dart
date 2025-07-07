import 'package:get/get.dart';

import '../mobile_modules/add_patient_mobile_view/bindings/add_patient_mobile_view_binding.dart';
import '../mobile_modules/add_patient_mobile_view/views/add_patient_mobile_view_view.dart';
import '../mobile_modules/add_recording_mobile_view/bindings/add_recording_mobile_view_binding.dart';
import '../mobile_modules/add_recording_mobile_view/views/add_recording_mobile_view_view.dart';
import '../mobile_modules/generate_note_mobile_view/bindings/generate_note_mobile_view_binding.dart';
import '../mobile_modules/generate_note_mobile_view/views/generate_note_mobile_view_view.dart';
import '../mobile_modules/home_view_mobile/bindings/home_view_mobile_binding.dart';
import '../mobile_modules/home_view_mobile/views/home_view_mobile_view.dart';
import '../mobile_modules/login_view_mobile/bindings/login_view_mobile_binding.dart';
import '../mobile_modules/login_view_mobile/views/login_view_mobile_view.dart';
import '../mobile_modules/patient_info_mobile_view/bindings/patient_info_mobile_view_binding.dart';
import '../mobile_modules/patient_info_mobile_view/views/patient_info_mobile_view.dart';
import '../mobile_modules/patient_profile_mobile_view/bindings/patient_profile_mobile_view_binding.dart';
import '../mobile_modules/patient_profile_mobile_view/views/patient_profile_mobile_view_view.dart';
import '../mobile_modules/personal_setting_mobile_view/bindings/personal_setting_mobile_view_binding.dart';
import '../mobile_modules/personal_setting_mobile_view/views/personal_setting_mobile_view_view.dart';
import '../modules/add_patient/bindings/add_patient_binding.dart';
import '../modules/add_patient/views/add_patient_view.dart';
import '../modules/all_attachment/bindings/all_attachment_binding.dart';
import '../modules/all_attachment/views/all_attachment_view.dart';
import '../modules/beta_tester_code/bindings/beta_tester_code_binding.dart';
import '../modules/beta_tester_code/views/beta_tester_code_view.dart';
import '../modules/doctor_to_doctor_sign_finalize_authenticate_view/bindings/doctor_to_doctor_sign_finalize_authenticate_view_binding.dart';
import '../modules/doctor_to_doctor_sign_finalize_authenticate_view/views/doctor_to_doctor_sign_finalize_authenticate_view_view.dart';
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
import '../modules/personal_setting/bindings/personal_setting_binding.dart';
import '../modules/personal_setting/views/personal_setting_view.dart';
import '../modules/quick_start_view/bindings/quick_start_view_binding.dart';
import '../modules/quick_start_view/views/quick_start_view_view.dart';
import '../modules/sign_finalize_authenticate_view/bindings/sign_finalize_authenticate_view_binding.dart';
import '../modules/sign_finalize_authenticate_view/controllers/sign_finalize_authenticate_view_controller.dart';
import '../modules/sign_finalize_authenticate_view/views/sign_finalize_authenticate_view_view.dart';
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
    GetPage(name: _Paths.HOME, page: () => HomeView(), binding: HomeBinding()),
    GetPage(name: _Paths.LOGIN, page: () => LoginView(), binding: LoginBinding()),
    GetPage(name: _Paths.SPLASH, page: () => const SplashView(), binding: SplashBinding()),
    GetPage(name: _Paths.VISIT_MAIN, page: () => const VisitMainView(), binding: VisitMainBinding()),
    GetPage(name: _Paths.PATIENT_INFO, page: () => const PatientInfoView(), binding: PatientInfoBinding()),
    GetPage(name: _Paths.ALL_ATTACHMENT, page: () => AllAttachmentView(), binding: AllAttachmentBinding()),
    GetPage(name: _Paths.ADD_PATIENT, page: () => AddPatientView(), binding: AddPatientBinding()),
    GetPage(name: _Paths.SCHEDULE_PATIENT, page: () => AddPatientView(), binding: AddPatientBinding()),
    GetPage(name: _Paths.EDIT_PATENT_DETAILS, page: () => EditPatentDetailsView(), binding: EditPatentDetailsBinding()),
    GetPage(name: _Paths.PATIENT_PROFILE, page: () => PatientProfileView(), binding: PatientProfileBinding()),
    GetPage(name: _Paths.FORGOT_PASSWORD, page: () => const ForgotPasswordView(), binding: ForgotPasswordBinding()),
    GetPage(name: _Paths.SIGN_UP, page: () => SignUpView(), binding: SignUpBinding()),
    GetPage(name: _Paths.PERSONAL_SETTING, page: () => PersonalSettingView(), binding: PersonalSettingBinding()),
    GetPage(name: _Paths.INVITED_USER_SUBMITTED, page: () => InvitedUserSubmittedView(), binding: InvitedUserSubmittedBinding()),
    GetPage(name: _Paths.SIGN_UP_SET_PASSWORD, page: () => SignUpSetPasswordView(), binding: SignUpSetPasswordBinding()),
    GetPage(name: _Paths.SIGN_UP_SET_ORGANIZATION_INFO, page: () => SignUpSetOrganizationInfoView(), binding: SignUpSetOrganizationInfoBinding()),
    GetPage(name: _Paths.SIGN_UP_PROFILE_COMPLETE, page: () => SignUpProfileCompleteView(), binding: SignUpProfileCompleteBinding()),
    GetPage(name: _Paths.BETA_TESTER_CODE, page: () => BetaTesterCodeView(), binding: BetaTesterCodeBinding()),
    GetPage(name: _Paths.LOGIN_VIEW_MOBILE, page: () => LoginViewMobileView(), binding: LoginViewMobileBinding(), transition: Transition.rightToLeft),
    GetPage(name: _Paths.HOME_VIEW_MOBILE, page: () => HomeViewMobileView(), binding: HomeViewMobileBinding(), transition: Transition.rightToLeft),
    GetPage(name: _Paths.ADD_PATIENT_MOBILE_VIEW, page: () => AddPatientMobileViewView(), binding: AddPatientMobileViewBinding(), transition: Transition.rightToLeft),
    GetPage(name: _Paths.ADD_RECORDING_MOBILE_VIEW, page: () => const AddRecordingMobileViewView(), binding: AddRecordingMobileViewBinding(), transition: Transition.rightToLeft),
    GetPage(name: _Paths.GENERATE_NOTE_MOBILE_VIEW, page: () => GenerateNoteMobileViewView(), binding: GenerateNoteMobileViewBinding(), transition: Transition.rightToLeft),
    GetPage(name: _Paths.PATIENT_PROFILE_MOBILE_VIEW, page: () => const PatientProfileMobileViewView(), binding: PatientProfileMobileViewBinding(), transition: Transition.rightToLeft),
    GetPage(name: _Paths.PATIENT_INFO_MOBILE_VIEW, page: () => const PatientInfoMobileView(), binding: PatientInfoMobileViewBinding(), transition: Transition.rightToLeft),
    GetPage(name: _Paths.PERSONAL_SETTING_MOBILE_VIEW, page: () => PersonalSettingMobileViewView(), binding: PersonalSettingMobileViewBinding()),
    GetPage(name: _Paths.QUICK_START_VIEW, page: () => const QuickStartViewView(), binding: QuickStartViewBinding()),
    GetPage(name: _Paths.SIGN_FINALIZE_AUTHENTICATE_VIEW, page: () => SignFinalizeAuthenticateViewView(controller: SignFinalizeAuthenticateViewController()), binding: SignFinalizeAuthenticateViewBinding()),
    GetPage(name: _Paths.DOCTOR_TO_DOCTOR_SIGN_FINALIZE_AUTHENTICATE_VIEW, page: () => DoctorToDoctorSignFinalizeAuthenticateView(), binding: DoctorToDoctorSignFinalizeAuthenticateViewBinding()),
  ];
}

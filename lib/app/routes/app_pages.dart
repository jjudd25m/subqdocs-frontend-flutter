import 'package:get/get.dart';

import '../modules/add_patient/bindings/add_patient_binding.dart';
import '../modules/add_patient/views/add_patient_view.dart';
import '../modules/custom_drawer/bindings/custom_drawer_binding.dart';
import '../modules/custom_drawer/views/custom_drawer_view.dart';
import '../modules/edit_patent_details/bindings/edit_patent_details_binding.dart';
import '../modules/edit_patent_details/views/edit_patent_details_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/patient_profile/bindings/patient_profile_binding.dart';
import '../modules/patient_profile/views/patient_profile_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

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
      name: _Paths.ADD_PATIENT,
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
      page: () => const PatientProfileView(),
      binding: PatientProfileBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
  ];
}

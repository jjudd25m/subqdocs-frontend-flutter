import 'package:get/get.dart';

import '../modules/all_attachment/bindings/all_attachment_binding.dart';
import '../modules/all_attachment/views/all_attachment_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/patient_info/bindings/patient_info_binding.dart';
import '../modules/patient_info/views/patient_info_view.dart';
import '../modules/patient_view_read_only/bindings/patient_view_read_only_binding.dart';
import '../modules/patient_view_read_only/views/patient_view_read_only_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/visit_main/bindings/visit_main_binding.dart';
import '../modules/visit_main/views/visit_main_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.VISIT_MAIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.VISIT_MAIN,
      page: () => const VisitMainView(),
      binding: VisitMainBinding(),
    ),
    GetPage(
      name: _Paths.PATIENT_INFO,
      page: () => PatientInfoView(),
      binding: PatientInfoBinding(),
    ),
    GetPage(
      name: _Paths.ALL_ATTACHMENT,
      page: () => const AllAttachmentView(),
      binding: AllAttachmentBinding(),
    ),
    GetPage(
      name: _Paths.PATIENT_VIEW_READ_ONLY,
      page: () => PatientViewReadOnlyView(),
      binding: PatientViewReadOnlyBinding(),
    ),
  ];
}

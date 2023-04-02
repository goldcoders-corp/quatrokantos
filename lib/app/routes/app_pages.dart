// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import 'package:quatrokantos/app/modules/home/bindings/home_binding.dart';
import 'package:quatrokantos/app/modules/home/views/home_view.dart';
import 'package:quatrokantos/app/modules/project/bindings/project_binding.dart';
import 'package:quatrokantos/app/modules/project/views/project_view.dart';
import 'package:quatrokantos/app/modules/wizard/bindings/wizard_binding.dart';
import 'package:quatrokantos/app/modules/wizard/views/wizard_view.dart';
import 'package:quatrokantos/middlewares/set_up_middleware.dart';
import 'package:quatrokantos/middlewares/wizard_middleware.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const String INITIAL = Routes.HOME;

  static final List<GetPage<dynamic>> routes = <GetPage<dynamic>>[
    GetPage<dynamic>(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      middlewares: <GetMiddleware>[
        WizardMiddleware(),
      ],
    ),
    GetPage<dynamic>(
      name: _Paths.WIZARD,
      page: () => const WizardView(),
      binding: WizardBinding(),
      middlewares: <GetMiddleware>[
        SetUpMiddleware(),
      ],
    ),
    GetPage<dynamic>(
      name: _Paths.PROJECT,
      page: ProjectView.new,
      binding: ProjectBinding(),
      middlewares: <GetMiddleware>[
        WizardMiddleware(),
      ],
    ),
  ];
}

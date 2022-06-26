import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:quatrokantos/app/routes/app_pages.dart';
import 'package:quatrokantos/services/app_theme.dart';
import 'package:quatrokantos/services/theme_service.dart';
import 'package:quatrokantos/utils/initial_binding.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      enableLog: true,
      initialBinding: InitialBinding(),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      title: dotenv.env['APP_NAME']!,
      debugShowCheckedModeBanner: false,
      theme: AppTheme().darkTheme,
      themeMode: ThemeService().getThemeMode(),
    );
  }
}

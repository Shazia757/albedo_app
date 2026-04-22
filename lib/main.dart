import 'package:albedo_app/config/color_schemes.dart';
import 'package:albedo_app/config/text_theme.dart';
import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/modules/admin/view/session_page.dart';
import 'package:albedo_app/modules/admin/view/settings/settings_page.dart';
import 'package:albedo_app/modules/admin/view/home_page.dart';
import 'package:albedo_app/common_views/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(AuthController(), permanent: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = box.read('isLoggedIn') ?? false;
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: lightColorScheme,
          useMaterial3: true,
          textTheme: AppTextTheme.lightTextTheme,
        ),
        // Dark Theme
        darkTheme: ThemeData(
          textTheme: AppTextTheme.darkTextTheme,
          colorScheme: darkColorScheme,
          useMaterial3: true,
        ),
        themeMode: ThemeMode.system,
        home: isLoggedIn ? SessionPage() : SessionPage());
  }
}

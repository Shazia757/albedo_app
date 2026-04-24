import 'package:albedo_app/config/color_schemes.dart';
import 'package:albedo_app/config/text_theme.dart';
import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/controller/user_controller.dart';
import 'package:albedo_app/modules/admin/view/sessions/batch_session_page.dart';
import 'package:albedo_app/modules/admin/view/sessions/session_page.dart';
import 'package:albedo_app/modules/admin/view/home_page.dart';
import 'package:albedo_app/common_views/login_page.dart';
import 'package:albedo_app/modules/admin/view/users/students_page.dart';
import 'package:albedo_app/modules/admin/view/users/teachers_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(AuthController(), permanent: true);
  Get.put(UserController(), permanent: true);
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
        themeMode: ThemeMode.light,
        home: isLoggedIn ? TeachersPage() : TeachersPage());
  }
}

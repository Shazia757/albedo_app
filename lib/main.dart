import 'package:albedo_app/config/color_schemes.dart';
import 'package:albedo_app/config/text_theme.dart';
import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/controller/home_controller.dart';
import 'package:albedo_app/controller/mentor_controller.dart';
import 'package:albedo_app/controller/notifications_controller.dart';
import 'package:albedo_app/controller/permissions_controller.dart';
import 'package:albedo_app/controller/student_controller.dart';
import 'package:albedo_app/controller/student_wallet_controller.dart';
import 'package:albedo_app/controller/teacher_controller.dart';
import 'package:albedo_app/controller/user_controller.dart';
import 'package:albedo_app/view/login_page.dart';
import 'package:albedo_app/view/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:responsive_framework/responsive_framework.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(AuthController(), permanent: true);
  Get.put(UserController(), permanent: true);
  Get.put(HomeController(), permanent: true);
  Get.put(PermissionsController(), permanent: true);
  Get.put(StudentController(), permanent: true);
  Get.put(TeacherController(), permanent: true);
  Get.put(MentorController(), permanent: true);
  Get.put(StudentWalletController(), permanent: true);
  Get.put(NotificationsController(), permanent: true);

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

      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: const [
          Breakpoint(start: 0, end: 450, name: MOBILE),
          Breakpoint(start: 451, end: 800, name: TABLET),
          Breakpoint(start: 801, end: 1920, name: DESKTOP),
          Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),

      /// 🌞 Light Theme
      theme: ThemeData(
        colorScheme: lightColorScheme,
        useMaterial3: true,
        textTheme: AppTextTheme.lightTextTheme,
      ),

      /// 🌙 Dark Theme
      darkTheme: ThemeData(
        colorScheme: darkColorScheme,
        useMaterial3: true,
        textTheme: AppTextTheme.darkTextTheme,
      ),

      themeMode: ThemeMode.light,

      home: isLoggedIn ? SettingsPage() : LoginView(),
    );
  }
}

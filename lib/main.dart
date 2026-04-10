import 'package:albedo_app/config/color_schemes.dart';
import 'package:albedo_app/view/home_page.dart';
import 'package:albedo_app/view/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
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
          textTheme: GoogleFonts.poppinsTextTheme(),
        ),
        // Dark Theme
        darkTheme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
          colorScheme: darkColorScheme,
          useMaterial3: true,
        ),
        themeMode: ThemeMode.system,
        home: isLoggedIn ? HomeView() : HomeView());
  }
}

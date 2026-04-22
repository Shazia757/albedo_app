import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextTheme {
  /// 🌞 LIGHT TEXT THEME
  static TextTheme lightTextTheme = GoogleFonts.varelaRoundTextTheme().copyWith(
    // 🔤 Headlines
    headlineLarge: const TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
    headlineMedium: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
    headlineSmall: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),

    // 🔠 Titles
    titleLarge: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    titleMedium: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    titleSmall: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),

    // 📄 Body
    bodyLarge: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    bodyMedium: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    bodySmall: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),

    // 🔘 Labels (buttons, chips)
    labelLarge: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    labelMedium: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    labelSmall: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
  );

  /// 🌙 DARK TEXT THEME
  static TextTheme darkTextTheme = GoogleFonts.varelaRoundTextTheme(
    ThemeData.dark().textTheme,
  ).copyWith(
    headlineLarge: const TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
    headlineMedium: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
    headlineSmall: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),

    titleLarge: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    titleMedium: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    titleSmall: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),

    bodyLarge: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    bodyMedium: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    bodySmall: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),

    labelLarge: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    labelMedium: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    labelSmall: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
  );
}
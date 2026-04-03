import 'package:flutter/material.dart';

/// 🔵 BRAND COLORS
const primaryBlue = Color(0xFF1C84B5);
const secondaryPurple = Color(0xFF7A2E7A);

/// 🌞 LIGHT THEME
const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Colors.blue,
  onPrimary: Colors.white,
  primaryContainer: Color(0xFFD6EEFA),
  onPrimaryContainer: Color(0xFF002B3D),
  secondary: Color.fromARGB(255, 121, 48, 190),
  onSecondary: Colors.white,
  secondaryContainer: Color(0xFFF1D8F1),
  onSecondaryContainer: Color(0xFF2A0E2A),
  surface: Color(0xFFF5F7FA),
  onSurface: Color(0xFF1A1A1A),
  error: Color(0xFFB3261E),
  onError: Colors.white,
  outline: Color(0xFFB0B0B0),
  shadow: Colors.black,
  scrim: Colors.black,
  inverseSurface: Color(0xFF2C2C2C),
  onInverseSurface: Colors.white,
  inversePrimary: Color(0xFF8FD3F4),
  tertiary: Colors.orange,
);

/// 🌙 DARK THEME
const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF4FB3E8),
  onPrimary: Color(0xFF00344C),
  primaryContainer: Color(0xFF004C6D),
  onPrimaryContainer: Color(0xFFC8E6FF),
  secondary: Color(0xFFD58AD5),
  onSecondary: Color(0xFF3A0F3A),
  secondaryContainer: Color(0xFF5A1F5A),
  onSecondaryContainer: Color(0xFFF1D8F1),
  surface: Color(0xFF0B1E2D),
  onSurface: Color(0xFFEAF6FF),
  error: Color(0xFFFFB4AB),
  onError: Color(0xFF690005),
  outline: Color(0xFF8A8A8A),
  shadow: Colors.black,
  scrim: Colors.black,
  inverseSurface: Color(0xFFEAF6FF),
  onInverseSurface: Color(0xFF0B1E2D),
  inversePrimary: primaryBlue,
  tertiary: Colors.orange,
);

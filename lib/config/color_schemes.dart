import 'package:flutter/material.dart';

/// 🔵 BRAND COLORS
const primaryBlue = Color(0xFF058DCE);
const secondaryPurple = Color(0xFF793078);

/// 🌞 LIGHT THEME
const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: primaryBlue,
  onPrimary: Colors.white,
  primaryContainer: Color(0xFFD6EEFA),
  onPrimaryContainer: Color(0xFF002B3D),
  secondary: secondaryPurple,
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
  onInverseSurface: Colors.green,
  inversePrimary: Color(0xFF8FD3F4),
  tertiary: Colors.orange,
  onTertiary: Colors.white,
  tertiaryContainer: Color(0xFFFFE0B2),
);

/// 🌙 DARK THEME (BLACK-BASED)
const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,

  // 🔵 Keep brand color but slightly toned for dark UI
  primary: Color(0xFF3EA6FF),
  onPrimary: Colors.black,
  primaryContainer: Color(0xFF1E3A5F),
  onPrimaryContainer: Color(0xFFD6E9FF),

  // 🟣 Secondary (subtle, not glowing)
  secondary: secondaryPurple,
  onSecondary: Colors.black,
  secondaryContainer: Color(0xFF2A2238),
  onSecondaryContainer: Color(0xFFE6DFFF),

  // ⚫ TRUE DARK SURFACE (KEY CHANGE)
  surface: Color(0xFF121212), // standard dark mode base
  onSurface: Color(0xFFEDEDED),

  // ❌ Error
  error: Color(0xFFB3261E),
  onError: Colors.black,

  // 🔘 Borders / dividers
  outline: Color(0xFF2C2C2C),

  shadow: Colors.black,
  scrim: Colors.black,

  // 🔁 Inverse
  inverseSurface: Color(0xFFEDEDED),
  onInverseSurface: Color(0xFF121212),
  inversePrimary: Color(0xFF90CAF9),

  // 🟠 Accent
  tertiary: Color(0xFFFFB74D),
  onTertiary: Colors.black,
  tertiaryContainer: Color(0xFF3E2E1F),
);

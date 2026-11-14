import 'package:flutter/material.dart';

class FlowTheme {
  static const ink = Color(0xFF101D42);
  static const muted = Color(0xFF465A77);
  static const teal = Color(0xFF006D80);
  static const purple = Color(0xFF6331CE);
  static const green = Color(0xFF087D38);
  static const background = Color(0xFFF3F7FF);
  static const gradient = LinearGradient(
    colors: [purple, Color(0xFF2455CF), teal],
  );
  static ThemeData get data => ThemeData(
    useMaterial3: true,
    fontFamily: 'LifeFlow',
    appBarTheme: const AppBarTheme(
      backgroundColor: background,
      foregroundColor: ink,
      elevation: 0,
    ),
    scaffoldBackgroundColor: background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: teal,
      primary: teal,
      error: const Color(0xFFB3261E),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: 16, color: ink),
      bodyLarge: TextStyle(fontSize: 18, color: ink),
      titleLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: ink,
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(minimumSize: const Size(48, 48)),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(48, 52),
        foregroundColor: ink,
        side: const BorderSide(color: muted),
        textStyle: const TextStyle(
          fontFamily: 'LifeFlow',
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.all(18),
    ),
  );
}

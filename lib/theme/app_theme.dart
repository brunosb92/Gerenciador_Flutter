// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryDarkBlue = Color(0xFF323876);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryDarkBlue,
      scaffoldBackgroundColor: Colors.blue[50],
      colorScheme: ColorScheme.light(
        primary: primaryDarkBlue,
        secondary: Colors.orange[700]!,
        background: Colors.blue[50]!,
        surface: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: primaryDarkBlue,
        onSurface: Colors.black87,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          backgroundColor: Colors.orange[700],
          foregroundColor: Colors.white,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(color: Colors.grey[500]),
        labelStyle: const TextStyle(color: primaryDarkBlue),
        prefixIconColor: primaryDarkBlue,
        suffixIconColor: primaryDarkBlue,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),
      textTheme: const TextTheme(
        headlineMedium:
            TextStyle(color: primaryDarkBlue, fontWeight: FontWeight.bold),
      ),
    );
  }
}

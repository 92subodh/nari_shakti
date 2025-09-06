import 'package:flutter/material.dart';

ThemeData getTheme() {
  return ThemeData(
    colorScheme: ColorScheme.light(
      primary: Color(0xFFE91E63), // Pink color matching the image
      primaryContainer: Color(0xFFFFE6EA), // Light pink background
      secondary: Color(0xFF3F3D56), // Dark text color
      onSecondary: Color(0xFF8A8A8A), // Medium gray
      surface: Colors.white,
      error: Colors.red,
      outline: Color(0xFFEAEEF4),
      secondaryContainer: Color(0xFFFAFAFB),
      onSecondaryContainer: Color(0xFF8A8A8A),
      surfaceContainer: Color(0xFFF7F7F7),
      surfaceDim: Color(0xFF1B1B1B),
      tertiary: Color(0xFFFF1100), // Red color for greetings
    ),

    fontFamily: 'Poppins',

    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 28,
        color: Color(0xFF3F3D56),
      ),
      titleMedium: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 22,
        color: Color(0xFF3F3D56),
      ),
      titleSmall: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 17,
        color: Color(0xFF3F3D56),
      ),

      headlineLarge: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 28,
        color: Color(0xFFFF1100), // Red for greetings
      ),
      headlineMedium: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),

      labelLarge: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
      labelMedium: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
      labelSmall: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),

      displayMedium: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
      displaySmall: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 18,
        color: Colors.grey,
      ),

      bodyLarge: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
      bodyMedium: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 12,
        color: Color(0xFF8A8A8A),
      ),
      bodySmall: TextStyle(
        fontWeight: FontWeight.w300,
        fontSize: 10,
        color: Color(0xFFE91E63), // Pink for small text
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Color(0xffF7F7F7)),
        foregroundColor: WidgetStatePropertyAll(Colors.black),
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Color(0xffEAEEF4)),
          ),
        ),
        textStyle: WidgetStatePropertyAll(
          TextStyle(color: Colors.amber, fontSize: 12),
        ),
      ),
    ),
  );
}

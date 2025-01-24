import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConfigurationTheme {
  const ConfigurationTheme();
  static InputDecorationTheme get inputDecorationTheme {
    return InputDecorationTheme(
        contentPadding: const EdgeInsets.all(16),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1.5,
              color: Colors.red,
            ),
            borderRadius: BorderRadius.circular(10)),
        errorMaxLines: 1,
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1.5,
              color: Colors.red,
            ),
            borderRadius: BorderRadius.circular(10)),
        errorStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Colors.red,
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1.5,
              color: Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(10)));
  }

  static TextTheme get textTheme {
    return TextTheme(
      displayLarge: GoogleFonts.montserrat(
        fontSize: 34,
        fontWeight: FontWeight.w700,
      ),
      displayMedium: GoogleFonts.montserrat(
        fontSize: 28,
        fontWeight: FontWeight.w700,
      ),
      displaySmall: GoogleFonts.montserrat(
        fontSize: 22,
        fontWeight: FontWeight.w700,
      ),
      headlineLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: GoogleFonts.montserrat(
        fontSize: 22,
        fontWeight: FontWeight.w500,
      ),
      titleMedium: GoogleFonts.montserrat(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: GoogleFonts.montserrat(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  static ElevatedButtonThemeData get elevatedButtonTheme {
    return ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16))));
  }
}

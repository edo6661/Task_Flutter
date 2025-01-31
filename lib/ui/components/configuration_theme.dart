import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConfigurationTheme {
  const ConfigurationTheme();
  static AppBarTheme appBarTheme(BuildContext context) {
    return AppBarTheme(
      backgroundColor: Theme.of(context).colorScheme.surface,
      scrolledUnderElevation: 0,
    );
  }

  static ColorScheme get colorScheme {
    return ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
    );
  }

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
      headlineLarge: GoogleFonts.montserrat(
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: GoogleFonts.montserrat(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: GoogleFonts.montserrat(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w500,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        fontFamily: "Cera Pro",
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        fontFamily: "Cera Pro",
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        fontFamily: "Cera Pro",
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      labelLarge: TextStyle(
        fontFamily: "Cera Pro",
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      labelMedium: TextStyle(
        fontFamily: "Cera Pro",
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      labelSmall: TextStyle(
        fontFamily: "Cera Pro",
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

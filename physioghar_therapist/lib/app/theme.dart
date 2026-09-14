import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    scaffoldBackgroundColor: AppColors.cream,

    colorScheme:
        ColorScheme.fromSeed(
          seedColor: AppColors.pine,
          brightness: Brightness.light,
        ).copyWith(
          primary: AppColors.pine,
          secondary: AppColors.amber,
          surface: AppColors.cream,
          error: AppColors.danger,
        ),

    textTheme: TextTheme(
      displayLarge: GoogleFonts.fraunces(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.ink,
      ),

      displayMedium: GoogleFonts.fraunces(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors.ink,
      ),

      headlineSmall: GoogleFonts.fraunces(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.ink,
      ),

      titleLarge: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
      ),

      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
      ),

      bodyLarge: GoogleFonts.inter(fontSize: 16, color: AppColors.inkMid),

      bodyMedium: GoogleFonts.inter(fontSize: 14, color: AppColors.inkMid),

      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
      ),
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.cream,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.fraunces(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.ink,
      ),
      iconTheme: const IconThemeData(color: AppColors.ink),
    ),

    cardTheme: CardThemeData(
      color: AppColors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.zero,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.white,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.pine, width: 1.5),
      ),

      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.pine,
        foregroundColor: AppColors.white,
        minimumSize: const Size(44, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
      ),
    ),
  );
}

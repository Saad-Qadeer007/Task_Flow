import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'App_Colors.dart';

class AppTheme {
  ThemeData lightTheme = ThemeData(
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme).apply(
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    ),
    scaffoldBackgroundColor: AppColors.background,
    inputDecorationTheme: InputDecorationTheme(
      prefixIconColor: Colors.black,
      hintStyle: TextStyle(color: AppColors.moderateGrey, fontWeight: FontWeight.bold),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}

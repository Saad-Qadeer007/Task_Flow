import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'App_Colors.dart';

class AppTheme {
  ThemeData lightTheme = ThemeData(
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme).apply(
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.background,
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: AppColors.secondaryTextColor,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColors.successColor,
    ),
    cardColor: AppColors.cards,
    scaffoldBackgroundColor: AppColors.background,
    inputDecorationTheme: InputDecorationTheme(
      prefixIconColor: Colors.black,
      hintStyle: TextStyle(
        color: AppColors.moderateGrey,
        fontWeight: FontWeight.bold,
      ),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    ),
    dialogTheme: DialogThemeData(backgroundColor: AppColors.background),
  );
  ThemeData darkTheme = ThemeData(
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).apply(
      bodyColor: AppColors.textPrimaryLight,
      displayColor: AppColors.textPrimaryLight,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkBackground,
      selectedItemColor: AppColors.lightColor,
      unselectedItemColor: AppColors.secondaryTextColor,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
    ),
    cardColor: AppColors.darkCard,
    scaffoldBackgroundColor: AppColors.darkBackground,
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColors.primaryColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      prefixIconColor: AppColors.lightColor,
      hintStyle: TextStyle(
        color: AppColors.lightColor,
        fontWeight: FontWeight.bold,
      ),
      filled: true,
      fillColor: AppColors.darkGrey,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    ),
    dialogTheme: DialogThemeData(backgroundColor: AppColors.moderateGrey),
  );
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:finance_tracker/core/constants/app_color.dart';

class AppThemes {
  const AppThemes._();

  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: const MaterialColor(AppColors.primarySwatch, AppColors.primaryColorMap),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryColor,
      primary: AppColors.primaryColor,
      brightness: Brightness.light,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.bottomNavBarLightBg,
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
    ),
    textSelectionTheme: const TextSelectionThemeData(cursorColor: AppColors.primaryColor),
    canvasColor: Colors.transparent,
    useMaterial3: true,
    fontFamily: GoogleFonts.inter().fontFamily,
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: const MaterialColor(AppColors.primarySwatch, AppColors.primaryColorMap),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryColor,
      primary: AppColors.primaryColor,
      brightness: Brightness.dark,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.bottomNavBarDarkBg,
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
    ),
    canvasColor: Colors.transparent,
    useMaterial3: true,
    fontFamily: GoogleFonts.inter().fontFamily,
  );
}

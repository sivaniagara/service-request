import 'package:flutter/material.dart';

class AppColors {
  static const navy900 = Color(0xFF14274E);
  static const navy800 = Color(0xFF1B3B6F);
  static const blue500 = Color(0xFF3B82F6);
  static const blue100 = Color(0xFFDCEBFF);
  static const orange500 = Color(0xFFF59E0B);
  static const orange100 = Color(0xFFFEEBD0);
  static const red500 = Color(0xFFEF4444);
  static const red100 = Color(0xFFFDE2E2);
  static const purple500 = Color(0xFF7C6CF0);
  static const purple100 = Color(0xFFE7E3FD);
  static const green500 = Color(0xFF22B573);
  static const green100 = Color(0xFFDFF6EA);
  static const amber500 = Color(0xFFF0A72A);
  static const bg = Color(0xFFF4F6FB);
  static const card = Color(0xFFFFFFFF);
  static const ink900 = Color(0xFF131B33);
  static const ink600 = Color(0xFF5B6478);
  static const ink400 = Color(0xFF95A0B4);
  static const line = Color(0xFFEDF0F6);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.navy900,
        primary: AppColors.navy900,
        secondary: AppColors.blue500,
        surface: AppColors.card,
        error: AppColors.red500,
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.line),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.card,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.ink900,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: AppColors.ink900,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: AppColors.ink900,
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          color: AppColors.ink900,
          fontSize: 14.5,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
          color: AppColors.ink600,
          fontSize: 14.5,
        ),
        bodyMedium: TextStyle(
          color: AppColors.ink600,
          fontSize: 13.5,
        ),
        labelLarge: TextStyle(
          color: AppColors.ink400,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.04,
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.ink600,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: AppColors.navy900,
          borderRadius: BorderRadius.circular(11),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.bg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: AppColors.line, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: AppColors.line, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: AppColors.blue500, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taskati_app/core/constants/app_fonts.dart';
import 'package:taskati_app/core/styles/colors.dart';
import 'package:taskati_app/core/styles/text_style.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    fontFamily: AppFonts.lexandDeca,
    scaffoldBackgroundColor: Colors.transparent,
    primaryColor: AppColors.primaryColor,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(0),
        minimumSize: Size.zero,
        foregroundColor: AppColors.primaryColor,
      ),
    ),
    dividerColor: Colors.transparent,
    cardColor: AppColors.whiteColor,
    hoverColor: AppColors.accentColor,
    dividerTheme: const DividerThemeData(color: AppColors.seconderyColor),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: AppColors.whiteColor,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleTextStyle: AppTextStyles.headline.copyWith(
        color: AppColors.blackColor,
        fontFamily: AppFonts.lexandDeca,
      ),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryColor,
      onSurface: AppColors.blackColor,
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: AppColors.blackColor),
    ),
    iconTheme: const IconThemeData(color: AppColors.blackColor),
    datePickerTheme: const DatePickerThemeData(
      backgroundColor: AppColors.whiteColor,
      headerForegroundColor: AppColors.primaryColor,
    ),
    timePickerTheme: const TimePickerThemeData(
      backgroundColor: AppColors.whiteColor,
      hourMinuteColor: AppColors.primaryColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: AppColors.whiteColor,
      filled: true,
      hintStyle: AppTextStyles.caption1.copyWith(color: AppColors.seconderyColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
    ),
  );

  static ThemeData get dark => ThemeData(
    fontFamily: AppFonts.lexandDeca,
    scaffoldBackgroundColor: Colors.transparent,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(0),
        minimumSize: Size.zero,
        foregroundColor: AppColors.primaryColor,
      ),
    ),
    dividerColor: Colors.transparent,
    primaryColor: AppColors.primaryColor,
    cardColor: AppColors.blackColor,
    hoverColor: AppColors.blackColor,
    dividerTheme: const DividerThemeData(color: AppColors.seconderyColor),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: AppColors.whiteColor,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: AppTextStyles.headline.copyWith(
        color: AppColors.whiteColor,
        fontFamily: AppFonts.lexandDeca,
      ),
    ),
    datePickerTheme: const DatePickerThemeData(
      backgroundColor: AppColors.blackColor,
      headerForegroundColor: AppColors.primaryColor,
    ),
    timePickerTheme: const TimePickerThemeData(
      backgroundColor: AppColors.blackColor,
      hourMinuteColor: AppColors.primaryColor,
      dialBackgroundColor: AppColors.seconderyColor,
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryColor,
      brightness: Brightness.dark,
      onSurface: AppColors.whiteColor, // text color
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: AppColors.whiteColor),
    ),
    iconTheme: const IconThemeData(color: AppColors.whiteColor),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: AppColors.blackColor,
      filled: true,
      hintStyle: AppTextStyles.caption1.copyWith(color: AppColors.seconderyColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
    ),
  );
}

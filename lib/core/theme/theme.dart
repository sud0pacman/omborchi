import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:omborchi/core/theme/style_res.dart';

import 'colors.dart';

class AppTheme {
  static ThemeData get theme {
    ThemeData base = ThemeData.light();

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.backgroundLight,
      cardColor: Colors.white,
      textTheme: base.textTheme.copyWith(
        bodySmall: base.textTheme.bodyMedium!.copyWith(
          color: const Color(0xff757575),
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: Colors.white,
        titleTextStyle: pbold.copyWith(
          fontSize: 18,
          color: AppColors.midnightBlue,
        ),
        contentTextStyle: pmedium.copyWith(
          fontSize: 16,
          color: AppColors.midnightBlue,
        ),
      ),
      datePickerTheme: DatePickerThemeData(
        todayBackgroundColor: MaterialStateProperty.all(AppColors.primary),
        headerBackgroundColor: AppColors.appBarLight,
        backgroundColor: AppColors.backgroundLight,
        dayStyle: pmedium.copyWith(
          fontSize: 16,
          color: AppColors.midnightBlue,
        ),
        headerHelpStyle: pmedium.copyWith(
          fontSize: 16,
          color: AppColors.midnightBlue,
        ),
        headerHeadlineStyle: pbold.copyWith(
          fontSize: 24,
          color: AppColors.midnightBlue,
        ),
        weekdayStyle: pbold.copyWith(
          fontSize: 14,
          color: AppColors.midnightBlue,
        ),
        yearStyle: pmedium.copyWith(
          fontSize: 16,
          color: AppColors.midnightBlue,
        ),
        confirmButtonStyle: TextButton.styleFrom(
          foregroundColor: AppColors.midnightBlue,
          textStyle: pbold.copyWith(fontSize: 16), // Matn uslubi
          backgroundColor: AppColors.appBarLight, // Tugma foni
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
        cancelButtonStyle: TextButton.styleFrom(
          foregroundColor: AppColors.midnightBlue,
          textStyle: pmedium.copyWith(fontSize: 16),
          backgroundColor: AppColors.backgroundLight,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
      primaryColor: AppColors.primary,
      brightness: Brightness.light,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        elevation: 12,
        selectedItemColor: Colors.orangeAccent,
        unselectedItemColor: Colors.grey,
      ),
      textSelectionTheme: const TextSelectionThemeData(
          selectionColor: AppColors.primary,
          cursorColor: AppColors.primary,
          selectionHandleColor: AppColors.primary),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: const IconThemeData(color: AppColors.black),
        centerTitle: true,
        elevation: 0, // Asosiy soyani yo'q qilish
        titleTextStyle: pmedium.copyWith(
          color: AppColors.white,
          fontSize: 18,
        ),
        toolbarHeight: 56,
      ),
    );
  }

  static ThemeData get darkTheme {
    ThemeData base = ThemeData.dark();
    return base.copyWith(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      cardColor: const Color.fromARGB(255, 225, 165, 165),
      textTheme: base.textTheme.copyWith(
        bodySmall: base.textTheme.bodyMedium!.copyWith(
          color: const Color(0xffcdcdcd),
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: Colors.black,
        titleTextStyle: pbold.copyWith(
          fontSize: 18,
          color: AppColors.white,
        ),
        contentTextStyle: pmedium.copyWith(
          fontSize: 16,
          color: AppColors.white,
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
          selectionColor: AppColors.primary,
          cursorColor: AppColors.primary,
          selectionHandleColor: AppColors.primary),
      brightness: Brightness.dark,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.black,
        elevation: 12,
        selectedItemColor: Colors.orangeAccent,
        unselectedItemColor: Colors.grey,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xff393E46),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: const IconThemeData(color: AppColors.white),
        centerTitle: true,
        elevation: 0,
        titleTextStyle: pregular.copyWith(
          color: AppColors.white,
          fontSize: 18,
        ),
      ),
      datePickerTheme: DatePickerThemeData(
        todayBackgroundColor: MaterialStateProperty.all(AppColors.primary),
        todayForegroundColor: MaterialStateProperty.all(AppColors.white),
        headerBackgroundColor: AppColors.appBarDark,
        backgroundColor: AppColors.backgroundDark,
        dayStyle: pmedium.copyWith(
          fontSize: 16,
          color: AppColors.white,
        ),
        headerHelpStyle: pmedium.copyWith(
          fontSize: 16,
          color: AppColors.white,
        ),
        headerHeadlineStyle: pbold.copyWith(
          fontSize: 24,
          color: AppColors.white,
        ),
        weekdayStyle: pbold.copyWith(
          fontSize: 14,
          color: AppColors.white,
        ),
        yearStyle: pmedium.copyWith(
          fontSize: 16,
          color: AppColors.white,
        ),
        confirmButtonStyle: TextButton.styleFrom(
          foregroundColor: AppColors.white,
          textStyle: pbold.copyWith(fontSize: 16), // Matn uslubi
          backgroundColor: AppColors.appBarDark, // Tugma foni
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
        cancelButtonStyle: TextButton.styleFrom(
          foregroundColor: AppColors.white,
          textStyle: pmedium.copyWith(fontSize: 16),
          backgroundColor: AppColors.backgroundDark,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'colors.dart';

extension CustomColorScheme on ColorScheme {
  Color get textColor =>
      brightness == Brightness.light ? AppColors.midnightBlue : AppColors.white;

  Color get itemColor => brightness == Brightness.light
      ? AppColors.white
      : AppColors.backgroundDark;

  Color get bottomNavBarColor => brightness == Brightness.light
      ? AppColors.bottomBarLight
      : AppColors.bottomBarDark;

  Color get topBgColor => brightness == Brightness.light
      ? AppColors.bgImageColor
      : AppColors.bottomBarDark;

  Color get appBarColor => brightness == Brightness.light
      ? AppColors.appBarLight
      : AppColors.appBarDark;

  Color get appBarDivColor => brightness == Brightness.light
      ? AppColors.black
      : AppColors.paleBlue;

  Color get shimmerBaseColor => brightness == Brightness.light
      ? AppColors.shimmerColor
      : AppColors.backgroundDark;

  Color get shimmerHighColor =>
      brightness == Brightness.light ? AppColors.white : AppColors.appBarDark;

  Color get baseLightColor =>
      brightness == Brightness.light ? Colors.white60 : Colors.black54;

  Color get crossColor =>
      brightness == Brightness.light ? Colors.black : Colors.white;

  Color get crossLightColor => brightness == Brightness.light
      ? const Color(0xffcdcdcd)
      : AppColors.midnightBlue;

  Color get dividerColor => brightness == Brightness.light
      ? const Color(0xFFeeeeee)
      : const Color(0xFFeeeeee);

  Color get cardBgColor => brightness == Brightness.light
      ? AppColors.midnightBlue.withOpacity(0.4)
      : const Color(0xff212121);

  Color get iconCardBgColor =>
      brightness == Brightness.light ? const Color(0xffF5F5F5) : Colors.black;

  Color get toolbarExpandedColor => brightness == Brightness.light
      ? const Color(0xFFffffff)
      : const Color(0xFF000000);

  Color get toolbarCollapsedColor => brightness == Brightness.light
      ? const Color(0xFFffffff)
      : const Color(0xFF212121);

  Color get dialogBgColor =>
      brightness == Brightness.light ? Colors.white : const Color(0xff212121);

  Color get infoDialogBgColor => brightness == Brightness.light
      ? const Color(0xFFf7f7f7)
      : const Color(0xff212121);

  Color get dialogGifBgColor =>
      brightness == Brightness.light ? Colors.white : const Color(0xff424242);

  Color get triangleLineColor => brightness == Brightness.light
      ? const Color(0xffeeeeee)
      : const Color(0xff424242);
}

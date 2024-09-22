import 'package:flutter/material.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/core/theme/style_res.dart';

AppBar simpleAppBar(
    {required String leadingIcon,
    required VoidCallback onTapLeading,
    required String title}) {
  return AppBar(
    backgroundColor: AppColors.primary,
    elevation: 0.0,
    leading: IconButton(
        onPressed: onTapLeading,
        icon: Image.asset(
          leadingIcon,
          color: AppColors.white,
          width: 24,
          height: 24,
          // colorFilter:
          //     const ColorFilter.mode(AppColors.midnightBlue, BlendMode.srcIn),
        )
        
    ),
    title: Text(
      title,
      style: boldWhite.copyWith(fontSize: 18),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/core/theme/style_res.dart';

AppBar simpleAppBar({
  required String leadingIcon,
  required VoidCallback onTapLeading,
  required String title,
  List<String>? actions,
  Function(int)? onTapAction,
}) {
  return AppBar(
    backgroundColor: AppColors.primary,
    elevation: 0.0,
    leading: IconButton(
        onPressed: onTapLeading,
        icon: SvgPicture.asset(
          leadingIcon,
          colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
          width: 24,
          height: 24,
          // colorFilter:
          //     const ColorFilter.mode(AppColors.midnightBlue, BlendMode.srcIn),
        )),
    actions: [
      if (actions != null) 
        for (int i = 0; i < actions.length; ++i) 
          IconButton(
            onPressed: () {
              onTapAction!(i);
            },
            icon: SvgPicture.asset(
              actions[i],
              colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
              height: 24,
              width: 24,
            ),
          ),
    ],
    title: Text(
      title,
      style: boldWhite.copyWith(fontSize: 18),
    ),
  );
}

bool isNullList<T>(T? element) => element != null;
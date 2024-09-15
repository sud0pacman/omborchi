import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/core/utils/consants.dart';

AppBar homeAppBar(
  {required VoidCallback onTapLeading,}
) {
  return AppBar(
    elevation: 0.0,
    backgroundColor: AppColors.primary,
    leading: IconButton(onPressed: onTapLeading, icon: const Icon(Icons.menu, color: AppColors.white,)),
    actions: [
      IconButton(
        onPressed: () {},
        icon: SvgPicture.asset(
          AssetRes.icSearch,
          width: 24,
          height: 24,
          colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
        ),
      ),
    ],
  );
}

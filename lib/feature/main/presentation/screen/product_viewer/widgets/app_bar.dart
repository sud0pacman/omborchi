import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/core/theme/style_res.dart';

AppBar productViewAppBar({
  required String leadingIcon,
  required VoidCallback onTapLeading,
  required VoidCallback onTapEdit,
  required VoidCallback onTapDelete,
  required String title,
  String? actionTitle,
  Color? actionColor,
  List<String>? actions,
  Function(int)? onTapAction,
}) {
  return AppBar(
    elevation: 0.0,
    scrolledUnderElevation: 0,
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
      if (actionTitle != null)
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Text(
            actionTitle,
            style: boldWhite.copyWith(fontSize: 18),
          ),
        ),
      if (actions != null)
        for (int i = 0; i < actions.length; ++i)
          IconButton(
            onPressed: () {
              onTapAction!(i);
            },
            icon: SvgPicture.asset(
              actions[i],
              colorFilter: ColorFilter.mode(
                  actionColor ?? AppColors.white, BlendMode.srcIn),
              height: 24,
              width: 24,
            ),
          ),
      PopupMenuButton<String>(
        icon: const Icon(
          Icons.more_vert,
          color: AppColors.white,
        ),
        // `icMore` o‘rniga
        onSelected: (String value) {
          if (value == 'edit') {
            onTapEdit.call();
          } else if (value == 'delete') {
            onTapDelete.call();
          }
        },
        itemBuilder: (BuildContext context) => [
          PopupMenuItem(
            value: 'edit',
            child: Row(
              children: [
                Text(
                  "O'zgartirish".tr,
                  style: regular,
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Text(
                  "O'chirish".tr,
                  style: regular,
                ),
              ],
            ),
          ),
        ],
      ),
    ],
    title: Text(
      title,
      style: boldWhite.copyWith(fontSize: 18),
    ),
  );
}

bool isNullList<T>(T? element) => element != null;

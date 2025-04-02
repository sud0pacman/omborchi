import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:omborchi/core/custom/extensions/context_extensions.dart';
import 'package:omborchi/core/theme/color_scheme.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/core/theme/style_res.dart';

AppBar productViewAppBar(
  BuildContext context, {
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
      icon: const Icon(
        CupertinoIcons.back,
        color: AppColors.white,
      ),
    ),
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(1),
      child: Container(
        color: context.colorScheme().appBarDivColor,
        height: 1,
      ),
    ),
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

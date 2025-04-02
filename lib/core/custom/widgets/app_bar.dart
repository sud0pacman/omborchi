import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:omborchi/core/custom/extensions/context_extensions.dart';
import 'package:omborchi/core/theme/color_scheme.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/core/theme/style_res.dart';

AppBar customAppBar(
  BuildContext context, {
  Icon? leadingIcon,
  VoidCallback? onTapLeading,
  String? title,
  String? actionTitle,
  Color? actionColor,
  List<IconData>? actions,
  Function(int)? onTapAction,
}) {
  return AppBar(
    elevation: 0.0,
    automaticallyImplyLeading: false,
    scrolledUnderElevation: 0,
    leading: onTapLeading != null
        ? IconButton(
            onPressed: onTapLeading ?? () => Navigator.pop(context),
            icon: leadingIcon ??
                const Icon(
                  CupertinoIcons.back,
                  color: AppColors.white,
                ),
          )
        : null,
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
            icon: Icon(
              actions[i],
            ),
          ),
    ],
    title: Text(
      title ?? "",
      style: boldWhite.copyWith(fontSize: 18),
    ),
  );
}

bool isNullList<T>(T? element) => element != null;

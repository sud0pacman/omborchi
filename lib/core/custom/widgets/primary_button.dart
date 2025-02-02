import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omborchi/core/custom/extensions/context_extensions.dart';

import '../../theme/style_res.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.title,
    this.backgroundColor,
    this.onPressed,
    this.width,
    this.height = 56,
    this.textStyle,
  });

  final String title;
  final Color? backgroundColor;
  final VoidCallback? onPressed;
  final double? width;
  final double height;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height.h,
      width: width,
      child: TextButton(
          onPressed: onPressed,
          style: backgroundColor == null
              ? kButtonShadowThemeStyle
              : kButtonShadowThemeStyle.copyWith(
                  backgroundColor: WidgetStateProperty.all(backgroundColor)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: textStyle ??
                    boldWhite.copyWith(
                        fontSize: 16, color: context.textColor()),
              ),
            ],
          )),
    );
  }
}

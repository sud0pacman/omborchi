import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omborchi/core/custom/extensions/context_extensions.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/core/theme/style_res.dart';

class InfoDialog extends StatelessWidget {
  final String title;
  final String message;
  final String positiveText;
  final String negativeText;
  final VoidCallback onPositiveTap;
  final VoidCallback onNegativeTap;

  const InfoDialog(
      {super.key,
      required this.title,
      required this.message,
      required this.positiveText,
      required this.negativeText,
      required this.onPositiveTap,
      required this.onNegativeTap});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: bold.copyWith(fontSize: 18, color: context.textColor()),
              textAlign: TextAlign.center,
            ),
            16.verticalSpace,
            Text(
              message,
              style: medium.copyWith(fontSize: 14, color: context.textColor()),
              textAlign: TextAlign.center,
            ),
            24.verticalSpace,
            Row(
              children: [
                const Spacer(),
                TextButton(
                    onPressed: onNegativeTap,
                    style: actionTextButtonStyle,
                    child: Text(
                      negativeText,
                      style: mediumTheme.copyWith(
                          fontSize: 14, color: context.textColor()),
                    )),
                8.horizontalSpace,
                TextButton(
                    onPressed: onPositiveTap,
                    style: actionTextButtonStyle,
                    child: Text(
                      positiveText,
                      style: mediumTheme.copyWith(
                          fontSize: 14, color: context.textColor()),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}

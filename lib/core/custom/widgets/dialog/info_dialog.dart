import 'package:flutter/material.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/core/theme/style_res.dart';

class InfoDialog extends StatelessWidget {
  final String title;
  final String message;
  final String positiveText;
  final String negativeText;
  final VoidCallback onPositiveTap;
  final VoidCallback onNegativeTap;

  const 
  InfoDialog({super.key, required this.title, required this.message, required this.positiveText, required this.negativeText, required this.onPositiveTap, required this.onNegativeTap});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: bold,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 16,
            ),

            Text(
              message,
              style: medium.copyWith(
                fontSize: 14
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(
              height: 24,
            ),
            Row(
              children: [
                const Spacer(),
                TextButton(
                  onPressed: onNegativeTap,
                  style: actionTextButtonStyle,
                  child: Text(
                    negativeText,
                    style: mediumTheme.copyWith(
                      fontSize: 14
                    ),
                  )
                ),

                const SizedBox(
                  width: 8,
                ),

                TextButton(
                  onPressed: onPositiveTap,
                  style: actionTextButtonStyle,
                  child: Text(
                    positiveText,
                    style: mediumTheme.copyWith(
                      fontSize: 14
                    ),
                  )
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

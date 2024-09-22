import 'package:flutter/material.dart';
import '../../theme/style_res.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.title,
    this.onPressed,
    this.width,
    this.height = 48,
    this.textStyle,
  });

  final String title;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: TextButton(
          onPressed: onPressed,
          style: kButtonShadowThemeStyle,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: textStyle ?? boldWhite.copyWith(fontSize: 16),
              ),
            ],
          )),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:omborchi/core/custom/extensions/context_extensions.dart';
import 'package:omborchi/core/utils/consants.dart';

class CustomButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color splashColor;
  final Color highlightColor;
  final double elevation;
  final double borderRadius;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Color shadowColor;

  const CustomButton({
    super.key,
    required this.child,
    this.onTap,
    this.backgroundColor,
    this.splashColor = Colors.grey,
    this.highlightColor = Colors.grey,
    this.elevation = 4.0,
    this.borderRadius = 12.0,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.shadowColor = Colors.black,
  });

  Color _getContrastingColor(Color baseColor) {
    final luminance = baseColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ?? context.containerColor();
    final effectiveSplashColor = _getContrastingColor(effectiveBackgroundColor);
    final effectiveHighlightColor =
        _getContrastingColor(effectiveBackgroundColor);

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        margin: margin,
        decoration: containerBoxDecoration.copyWith(
          borderRadius: BorderRadius.circular(borderRadius),
          color: context.containerColor()
        ),
        child: Material(
          color: effectiveBackgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(borderRadius),
            splashColor: effectiveSplashColor.withOpacity(0.1),
            highlightColor: effectiveHighlightColor.withOpacity(0.2),
            child: Container(
              padding: padding ?? EdgeInsets.symmetric(horizontal: 16),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

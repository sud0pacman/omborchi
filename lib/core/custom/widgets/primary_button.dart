
import 'package:flutter/material.dart';
import 'package:omborchi/core/custom/extensions/color_to_hsl.dart';
import 'package:omborchi/core/custom/widgets/loading_widget.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/core/theme/style_res.dart';


abstract class AnimationControllerState<T extends StatefulWidget>
    extends State<T> with SingleTickerProviderStateMixin {
  AnimationControllerState(this.animationDuration);

  final Duration animationDuration;
  late final AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: animationDuration);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    super.key,
    this.child,
    this.text,
    this.hslColor,
    this.height = 48,
    this.width,
    this.elevation = 5.0,
    this.shadow,
    this.onPressed,
    this.borderRadius = BorderRadius.zero,
    this.isLoading = false,
  }) : assert(height > 0);

  final Widget? child;
  final String? text;
  final HSLColor? hslColor;
  final double height;
  final double? width;
  final double elevation;
  final BoxShadow? shadow;
  final BorderRadius borderRadius;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  PrimaryButtonState createState() =>
      PrimaryButtonState(const Duration(milliseconds: 100));
}

class PrimaryButtonState extends AnimationControllerState<PrimaryButton> {
  PrimaryButtonState(super.duration);

  late BoxShadow shadow;

  void _handleTapDown(TapDownDetails details) {
    if (!widget.isLoading) {
      animationController.forward(); // Bosilganda darhol animatsiya boshlanadi
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.isLoading) {
      animationController.reverse(); // Bo‘shatilganda darhol qaytadi
      widget.onPressed?.call();
    }
  }

  void _handleTapCancel() {
    if (!widget.isLoading) {
      animationController.reverse(); // Bekor qilinganda qaytadi
    }
  }

  @override
  void initState() {
    shadow = widget.shadow ??
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 0,
          blurRadius: 4,
          offset: const Offset(0, 2),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final totalHeight = widget.height + widget.elevation;
    var borderRadius = widget.borderRadius == BorderRadius.zero
        ? BorderRadius.circular(14)
        : widget.borderRadius;

    return SizedBox(
      height: totalHeight,
      width: widget.width,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            final top = animationController.value * widget.elevation;
            final hslColor = widget.hslColor ?? AppColors.primary.toHSL();
            final bottomHslColor =
            hslColor.withLightness(hslColor.lightness - 0.15);

            return Stack(
              children: [
                // Pastki qism (shadow bilan)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: totalHeight - top,
                    width: widget.width,
                    decoration: BoxDecoration(
                      color: bottomHslColor.toColor(),
                      boxShadow: [shadow],
                      borderRadius: borderRadius,
                    ),
                  ),
                ),
                // Yuqori qism (buttonning o'zi)
                Positioned(
                  left: 0,
                  right: 0,
                  top: top,
                  child: Container(
                    height: widget.height,
                    width: widget.width,
                    decoration: ShapeDecoration(
                      color: hslColor.toColor(),
                      shape: RoundedRectangleBorder(
                        borderRadius: borderRadius,
                      ),
                    ),
                    child: Center(
                      child: widget.isLoading
                          ? const LoadingWidget(
                        color: Colors.white,
                        size: 24,
                      ) // Loading holati
                          : widget.child ??
                          Text(
                            widget.text ?? "",
                            style: semiBold.copyWith(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

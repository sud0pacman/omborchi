import 'package:flutter/material.dart';
import 'package:omborchi/core/custom/extensions/color_to_hsl.dart';

extension ColorExtensions on Color {
  Color getDarkenColor() {
    final hslColor = toHSL();
    final darkenedColor = hslColor.withLightness(hslColor.lightness - 0.15);
    return darkenedColor.toColor();
  }

  Color getLightenColor() {
    final hslColor = toHSL();
    final lightenedColor = hslColor.withLightness(hslColor.lightness + 0.15);
    return lightenedColor.toColor();
  }
}

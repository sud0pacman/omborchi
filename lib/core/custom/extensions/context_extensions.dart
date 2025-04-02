import 'package:flutter/material.dart';
import 'package:omborchi/core/theme/color_scheme.dart';

extension ContextExtensions on BuildContext {
  Color textColor() {
    return Theme.of(this).colorScheme.textColor;
  }
  ColorScheme colorScheme() {
    return Theme.of(this).colorScheme;
  }

  Color containerColor() {
    return Theme.of(this).colorScheme.appBarColor;
  }
  Color backgroundColor() {
    return Theme.of(this).scaffoldBackgroundColor;
  }
}

import 'package:flutter/widgets.dart';
import 'package:omborchi/core/theme/colors.dart';

Widget customDivider({bool? hasMargin}) => Container(
      margin: hasMargin == null || hasMargin == true
          ? const EdgeInsets.symmetric(horizontal: 16.0)
          : EdgeInsets.zero,
      height: 0.5,
      color: AppColors.steelGrey,
    );

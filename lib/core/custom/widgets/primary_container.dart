import 'package:flutter/material.dart';
import 'package:omborchi/core/theme/colors.dart';

class PrimaryContainer extends StatelessWidget {
  final Widget child;
  final BoxConstraints? constraints;
  const PrimaryContainer({super.key, required this.child, this.constraints});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 6.0),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      constraints: constraints,
      decoration: BoxDecoration(
          color: AppColors.white, borderRadius: BorderRadius.circular(24)),
      child: child,
    );
  }
}

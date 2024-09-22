import 'package:flutter/material.dart';
import 'package:omborchi/core/theme/colors.dart';

FloatingActionButton primaryFloatingActionButton(
    {required VoidCallback onTap}) {
  return FloatingActionButton(
    onPressed: onTap,
    shape: const CircleBorder(),
    backgroundColor: AppColors.primary,
    child: const Icon(
      Icons.add,
      color: AppColors.white,
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:omborchi/core/theme/colors.dart';

FloatingActionButton primaryFloatingActionButton(
    {required VoidCallback onTap, IconData icon = Icons.add}) {
  return FloatingActionButton(
    onPressed: onTap,
    shape: const CircleBorder(),
    backgroundColor: AppColors.primary,
    child: Icon(
      icon,
      color: AppColors.white,
    ),
  );
}

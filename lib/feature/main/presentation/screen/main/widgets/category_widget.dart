import 'package:flutter/material.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/core/theme/style_res.dart';
import 'package:omborchi/core/utils/consants.dart';

class CategoryWidget extends StatelessWidget {
  final bool isActive;
  final String name;
  final int count;
  final VoidCallback onTap;


  const CategoryWidget(
      {super.key,
      required this.isActive,
      required this.name,
      required this.count,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: IconButton(
        onPressed: onTap,
        style: kButtonThemeStyle.copyWith(
            padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(
              vertical: 8,
            )),
            backgroundColor: WidgetStatePropertyAll(
                isActive ? AppColors.primary.withOpacity(.8) : AppColors.white)),
        icon: Container(
          width: 86,
          alignment: Alignment.center,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                AssetRes.icFolder,
                width: 46,
                height: 46,
              ),
              Text(
                '$name ($count)',
                style: psemibold.copyWith(fontSize: 12),
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
      ),
    );
  }
}

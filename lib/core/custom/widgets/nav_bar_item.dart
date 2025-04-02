import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:omborchi/core/custom/extensions/context_extensions.dart';
import 'package:omborchi/core/theme/colors.dart';

import '../../theme/style_res.dart';

class NavBarItem extends StatelessWidget {
  final String title;
  final String? iconPath;
  final IconData? iconData;
  final String? badge;
  final VoidCallback onTap;

  const NavBarItem(
      {super.key,
      required this.title,
      this.iconPath,
      this.iconData,
      this.badge,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      height: 48,
      child: TextButton(
        onPressed: onTap,
        style: kButtonThemeStyle.copyWith(
            backgroundColor: const WidgetStatePropertyAll(Colors.transparent)),
        child: Row(
          children: [
            iconPath != null
                ? SvgPicture.asset(
                    iconPath!,
                    width: 26,
                    height: 26,
                    colorFilter:
                        ColorFilter.mode(context.textColor(), BlendMode.srcIn),
                  )
                : Icon(
                    iconData,
                    color: context.textColor(),
                    size: 26,
                  ),
            const SizedBox(
              width: 19,
            ),
            Expanded(
              child: Text(title,
                  overflow: TextOverflow.ellipsis,
                  style: semiBold.copyWith(
                    fontSize: 16,
                    color: context.textColor(),
                    overflow: TextOverflow.ellipsis,
                  )),
            ),
            if (badge != null) badgeItem(badge!)
          ],
        ),
      ),
    );
  }

  Widget badgeItem(String count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
          color: Colors.red, borderRadius: BorderRadius.circular(12)),
      child: Text(
        count,
        style: pbold.copyWith(color: AppColors.white, fontSize: 8),
      ),
    );
  }
}

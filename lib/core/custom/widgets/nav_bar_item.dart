import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:omborchi/core/theme/colors.dart';

import '../../theme/style_res.dart';

class NavBarItem extends StatelessWidget {
  final String title;
  final String iconPath;
  final String? badge;
  final VoidCallback onTap;

  const NavBarItem(
      {super.key,
      required this.title,
      required this.iconPath,
      this.badge,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      height: 48,
      child: TextButton(
        onPressed: onTap,
        style: kButtonThemeStyle.copyWith(
            backgroundColor: const WidgetStatePropertyAll(Colors.transparent)),
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath,
              width: 26,
              height: 26,
              colorFilter:
                  const ColorFilter.mode(AppColors.steelGrey, BlendMode.srcIn),
            ),
            const SizedBox(
              width: 19,
            ),
            Expanded(
              child: Text(title,
                  overflow: TextOverflow.ellipsis,
                  style: semiBold.copyWith(
                    fontSize: 16,
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

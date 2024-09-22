import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/core/theme/style_res.dart';

class PopUpMenu extends StatelessWidget {
  final List<String> actions;
  final List<String> iconPaths;
  final Function(int) onPressed;

  const PopUpMenu(
      {super.key,
      required this.actions,
      required this.iconPaths,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < actions.length; i++)
          item(() => onPressed(i), iconPaths[i], actions[i])
      ],
    );
  }

  Widget item(VoidCallback onPressed, String path, String title) {
    return TextButton(
        onPressed: onPressed,
        style: kButtonTransparentStyle.copyWith(
          shape: WidgetStateProperty.all(
            const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0))),
          ),
        ),
        child: SizedBox(
          height: 32,
          child: Row(children: [
            SvgPicture.asset(
              path,
              width: 22,
              height: 22,
              colorFilter: const ColorFilter.mode(
                  AppColors.midnightBlue, BlendMode.srcIn),
            ),
          
            const SizedBox(width: 15,),
          
            Text(
              title,
              style: semiBold.copyWith(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            )
          ]),
        ));
  }
}

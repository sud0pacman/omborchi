import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:omborchi/core/custom/extensions/my_extensions.dart';
import 'package:omborchi/core/custom/widgets/app_bar.dart';
import 'package:omborchi/core/modules/hive_db_helper.dart';
import 'package:omborchi/core/theme/color_scheme.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/core/theme/style_res.dart';
import 'package:omborchi/core/utils/consants.dart';

class SelectThemeScreen extends StatefulWidget {
  const SelectThemeScreen({super.key});

  @override
  State<SelectThemeScreen> createState() => _SelectThemeScreenState();
}

class _SelectThemeScreenState extends State<SelectThemeScreen> {
  final preferences = inject<AppPreferences>();
  late String selectedTheme;

  @override
  void initState() {
    super.initState();
    final themeMode = preferences.theme;
    selectedTheme = _themeModeToString(themeMode);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300), // Animatsiya davomiyligi
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: Scaffold(
        key: ValueKey(selectedTheme), // Har bir theme uchun unique key
        appBar: customAppBar(
          onTapLeading: () {
            Navigator.pop(context);
          },
          context,
          title: "Rejimni tanlang",
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              8.verticalSpace,
              buildThemeItem("Yorqin".tr, const Icon(CupertinoIcons.sun_max)),
              8.verticalSpace,
              buildThemeItem("Qorong'i".tr, const Icon(CupertinoIcons.moon)),
              8.verticalSpace,
              buildThemeItem(
                  "Tizim".tr, const Icon(CupertinoIcons.device_phone_portrait)),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildThemeItem(String title, Icon icon) {
    return InkWell(
      onTap: () => _changeTheme(title),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: containerBoxDecoration.copyWith(
          borderRadius: BorderRadius.circular(14),
          color: Theme.of(context).colorScheme.appBarColor,
        ),
        padding: const EdgeInsets.all(8),
        child: ListTile(
          leading: icon,
          title: Text(
            title,
            style: pmedium.copyWith(
              fontSize: 16,
              color: Theme.of(context).colorScheme.textColor,
            ),
          ),
          trailing: Radio<String>(
            value: title,
            groupValue: selectedTheme,
            activeColor: AppColors.primary,
            onChanged: (value) {
              if (value != null) _changeTheme(value);
            },
          ),
        ),
      ),
    );
  }

  void _changeTheme(String newTheme) {
    setState(() {
      selectedTheme = newTheme;
      final themeMode = _stringToThemeMode(newTheme);
      preferences.changeTheme(themeMode);
    });
  }

  String _themeModeToString(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return "Yorqin";
      case ThemeMode.dark:
        return "Qorong'i";
      case ThemeMode.system:
        return "Tizim";
    }
  }

  ThemeMode _stringToThemeMode(String theme) {
    switch (theme) {
      case "Yorqin":
        return ThemeMode.light;
      case "Qorong'i":
        return ThemeMode.dark;
      case "Tizim":
      default:
        return ThemeMode.system;
    }
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:omborchi/core/custom/widgets/app_bar.dart';
import 'package:omborchi/core/theme/color_scheme.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/core/theme/style_res.dart';
import 'package:omborchi/core/utils/consants.dart';
import 'package:provider/provider.dart';

import '../../../../../core/database/app_storage.dart';

class ThemeProvider with ChangeNotifier {
  final AppStorage _storage = AppStorage();
  ThemeMode _themeMode;

  ThemeProvider() : _themeMode = ThemeMode.system {
    _themeMode = _storage.getTheme();
  }

  ThemeMode get themeMode => _themeMode;

  void changeTheme(ThemeMode newTheme) {
    _themeMode = newTheme;
    _storage.saveTheme(newTheme);
    notifyListeners();
  }

  String? getString(String key) {
    return _storage.getString(key);
  }
}

class SelectThemeScreen extends StatelessWidget {
  const SelectThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final selectedTheme = _themeModeToString(themeProvider.themeMode);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: Scaffold(
        key: ValueKey(selectedTheme),
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
              buildThemeItem(context, "Yorqin".tr,
                  const Icon(CupertinoIcons.sun_max), selectedTheme),
              8.verticalSpace,
              buildThemeItem(context, "Qorong'i".tr,
                  const Icon(CupertinoIcons.moon), selectedTheme),
              8.verticalSpace,
              buildThemeItem(
                  context,
                  "Tizim".tr,
                  const Icon(CupertinoIcons.device_phone_portrait),
                  selectedTheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildThemeItem(
      BuildContext context, String title, Icon icon, String selectedTheme) {
    return InkWell(
      onTap: () => _changeTheme(context, title),
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
              if (value != null) _changeTheme(context, value);
            },
          ),
        ),
      ),
    );
  }

  void _changeTheme(BuildContext context, String newTheme) {
    final themeMode = _stringToThemeMode(newTheme);
    Provider.of<ThemeProvider>(context, listen: false).changeTheme(themeMode);
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

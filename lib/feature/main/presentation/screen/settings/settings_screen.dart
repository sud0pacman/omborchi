import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:omborchi/config/router/app_routes.dart';
import 'package:omborchi/core/custom/extensions/context_extensions.dart';
import 'package:omborchi/core/custom/widgets/app_bar.dart';
import 'package:omborchi/core/custom/widgets/custom_button.dart';
import 'package:omborchi/core/theme/color_scheme.dart';
import 'package:omborchi/core/theme/style_res.dart';
import 'package:omborchi/core/utils/consants.dart';
import 'package:omborchi/feature/main/presentation/screen/settings/widgets/support_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/custom/widgets/custom_divider.dart';

class SettingsItem {
  final String title;
  final Icon icon;
  final VoidCallback? onTap;
  final Color? iconColor;

  SettingsItem({
    required this.title,
    required this.icon,
    this.onTap,
    this.iconColor,
  });
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List<List<SettingsItem>> get _settingsSections =>
      [
        [
          SettingsItem(
            title: "Tungi rejim".tr,
            icon: const Icon(CupertinoIcons.moon),
            onTap: () {
              Navigator.pushNamed(context, RouteManager.selectThemeScreen);
            },
          ),
        ],
        [
          SettingsItem(
            title: "Xatolik haqida xabar berish".tr,
            icon: const Icon(CupertinoIcons.exclamationmark_triangle),
            onTap: () {
              _openUrl();
            },
          ),
          SettingsItem(
            title: "Qo'llab quvvatlashga qo'ngiroq qilish".tr,
            icon: const Icon(CupertinoIcons.question_circle),
            onTap: () async {
              await showModalBottomSheet(
                context: context,
                builder: (ctx) {
                  return SupportDialog(
                    onTapContinue: () async {
                      final Uri phoneUri =
                      Uri.parse("tel:${Constants.supportPhone}");
                      if (await canLaunchUrl(phoneUri)) {
                        await launchUrl(phoneUri);
                      }
                    },
                  );
                },
              );
            },
          ),
        ],
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, title: "Sozlamalar", onTapLeading: () {
        Navigator.pop(context);
      }),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          8.verticalSpace,
          16.verticalSpace,
          AnimationLimiter(
            child: Column(
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 375),
                childAnimationBuilder: (widget) =>
                    FadeInAnimation(
                      curve: Curves.bounceInOut,
                      child: FadeInAnimation(child: widget),
                    ),
                children: _settingsSections
                    .asMap()
                    .entries
                    .map((entry) => _buildSection(context, entry.value))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, List<SettingsItem> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: CustomButton(
        backgroundColor: context.containerColor(),
        child: Column(
          children: items
              .asMap()
              .entries
              .map((entry) {
            final item = entry.value;
            final isLast = entry.key == items.length - 1;
            return Column(
              children: [
                _buildItem(context, item),
                if (!isLast) customDivider(),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, SettingsItem item) {
    return ListTile(
      minVerticalPadding: 0,
      minTileHeight: 54,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      leading: item.icon,
      title: Text(
        item.title,
        style: pmedium.copyWith(
          color: Theme
              .of(context)
              .colorScheme
              .textColor,
          fontSize: 18,
        ),
      ),
      trailing: const Icon(CupertinoIcons.right_chevron, size: 18),
      onTap: item.onTap,
    );
  }

  Future<void> _reportBug() async {
    String deviceInfo = await _getDeviceInfo();
    String subject = "${Constants.appName}\nDevice: $deviceInfo";
    final Uri emailUri = Uri.parse(
      "mailto:${Constants.supportEmail}?subject=${Uri.encodeFull(subject)}",
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  Future<void> _openUrl({String? url}) async {
    final Uri emailUri = Uri.parse(url ?? "https://t.me/mobiledeveloper0");
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  Future<String> _getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return 'Android ${androidInfo.version.release} - ${androidInfo.model}';
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return 'iOS ${iosInfo.systemVersion} - ${iosInfo.utsname.machine}';
    }
    return 'Unknown Device';
  }
}

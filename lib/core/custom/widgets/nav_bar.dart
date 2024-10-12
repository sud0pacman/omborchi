import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:omborchi/core/custom/widgets/nav_bar_item.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/core/theme/style_res.dart';
import 'package:omborchi/core/utils/consants.dart';

class PrimaryNavbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const PrimaryNavbar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            alignment: Alignment.topLeft,
            color: AppColors.primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 42),
                Image.asset(
                  AssetRes.icAppLogo,
                  width: 65,
                  height: 65,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  'Omborchi',
                  style: boldWhite.copyWith(fontSize: 14),
                ),
                const SizedBox(
                  height: 12,
                ),
              ],
            ),
          ),
          const SizedBox(height: 47),
          NavBarItem(
              title: "Maxsulot qo'shish".tr,
              iconPath: AssetRes.icProduct,
              onTap: () => onItemTapped(0)),
          NavBarItem(
              title: "Kategoriya qo'shish".tr,
              iconPath: AssetRes.icInactive,
              onTap: () => onItemTapped(1)),

          NavBarItem(
              title: "Xomashyo".tr,
              iconPath: AssetRes.icMaterialRaw,
              onTap: () => onItemTapped(2)),

          NavBarItem(
              title: "Xomashyo turi".tr,
              iconPath: AssetRes.icMaterialRawType,
              onTap: () => onItemTapped(3)),

          const Spacer(),
          NavBarItem(
            title: "Ma'lumotlarni sinxronlash".tr,
            iconPath: AssetRes.icSynchronization,
            onTap: () => onItemTapped(-1),
          ),
          const SizedBox(height: 36),
        ],
      ),
    );
  }
}

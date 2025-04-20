import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:omborchi/core/custom/extensions/context_extensions.dart';
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
      backgroundColor: context.backgroundColor(),
      child: Column(
        children: [
          Container(
            height: 200.h,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            alignment: Alignment.topLeft,
            color: AppColors.primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset(
                  AssetRes.icAppLogo,
                  width: 76.w,
                  height: 76.h,
                  fit: BoxFit.cover,
                ),
                16.verticalSpace,
                Text(
                  'Omborchi',
                  style: bold.copyWith(fontSize: 18, color: AppColors.white),
                ),
                16.verticalSpace
              ],
            ),
          ),
          24.verticalSpace,
          NavBarItem(
              title: "Maxsulot qo'shish".tr,
              iconPath: AssetRes.icProduct,
              onTap: () => onItemTapped(0)),
          NavBarItem(
              title: "Kategoriya".tr,
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
          NavBarItem(
              title: "Sozlamalar".tr,
              iconData: CupertinoIcons.gear,
              onTap: () => onItemTapped(4)),
          const Spacer(),
          NavBarItem(
            title: "Ba'zani yangilash".tr,
            iconPath: AssetRes.icSynchronization,
            onTap: () => onItemTapped(-1),
          ),
          24.verticalSpace
        ],
      ),
    );
  }
}

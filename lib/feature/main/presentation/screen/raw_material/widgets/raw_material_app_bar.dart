import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/core/theme/style_res.dart';
import 'package:omborchi/core/utils/consants.dart';
import 'package:omborchi/feature/main/presentation/screen/raw_material/widgets/tab_item.dart';

AppBar rawMaterialAppBar(
    {required VoidCallback onTapLeading, required List<String> tabs}) {
  return AppBar(
    backgroundColor: AppColors.primary,
    leading: IconButton(
        onPressed: onTapLeading,
        icon: SvgPicture.asset(
          AssetRes.icBack,
          colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
          width: 24,
          height: 24,
        )),
    bottom: TabBar(
        isScrollable: true,
        labelColor: AppColors.white,
        labelStyle: medium.copyWith(fontSize: 15),
        unselectedLabelStyle: medium.copyWith(fontSize: 15),
        unselectedLabelColor: AppColors.white.withOpacity(.9),
        indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: AppColors.white,
        indicatorWeight: 4,
        overlayColor: WidgetStatePropertyAll(AppColors.overlay),
        padding: EdgeInsets.zero,
        dividerHeight: 0.0,
        tabAlignment: TabAlignment.start,
        tabs: [for (int i = 0; i < tabs.length; i++) TabItem(title: tabs[i])]),
  );
}

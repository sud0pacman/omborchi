import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/core/theme/style_res.dart';
import 'package:omborchi/feature/main/presentation/screen/raw_material/widgets/tab_item.dart';

AppBar rawMaterialAppBar(
    {required VoidCallback onTapLeading,
    required String title,
    required List<String> tabs,
    List<Widget>? actions}) {
  return AppBar(
    title: Text(
      title,
      style: bold.copyWith(fontSize: 18, color: AppColors.white),
    ),
    leading: IconButton(
      onPressed: onTapLeading,
      icon: const Icon(CupertinoIcons.back),
    ),
    actions: actions,
    bottom: TabBar(
        isScrollable: true,
        labelColor: AppColors.white,
        labelStyle: bold.copyWith(fontSize: 15),
        unselectedLabelStyle: bold.copyWith(fontSize: 15),
        unselectedLabelColor: AppColors.white.withOpacity(.85),
        indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: AppColors.white,
        indicatorWeight: 4,
        overlayColor: WidgetStatePropertyAll(AppColors.overlay),
        padding: EdgeInsets.zero,
        // labelPadding: EdgeInsets.zero,
        indicatorPadding: EdgeInsets.zero,
        dividerHeight: 0.0,
        tabAlignment: TabAlignment.start,
        tabs: [for (int i = 0; i < tabs.length; i++) TabItem(title: tabs[i])]),
  );
}

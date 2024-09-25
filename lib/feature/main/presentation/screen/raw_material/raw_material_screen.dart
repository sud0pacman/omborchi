import 'package:flutter/material.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/feature/main/presentation/screen/raw_material/widgets/raw_material_app_bar.dart';

class RawMaterialScreen extends StatefulWidget {
  const RawMaterialScreen({super.key});

  @override
  State<RawMaterialScreen> createState() => _RawMaterialScreenState();
}

class _RawMaterialScreenState extends State<RawMaterialScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 10, 
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: rawMaterialAppBar(onTapLeading: () {}, tabs: ["All", "Tosh", "Skotch", "Qolip", "Tab4", "Tab5", "Tab6", "Tab7", "Tab8", "Tab9", "Tab10"]),
        body: TabBarView(
          children: [

          ]
        ),
      )
    );
  }
}
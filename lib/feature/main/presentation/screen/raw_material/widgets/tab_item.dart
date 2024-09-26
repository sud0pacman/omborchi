import 'package:flutter/material.dart';
import 'package:omborchi/core/custom/functions/custom_functions.dart';

class TabItem extends StatelessWidget {
  final String title;
  const TabItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(
        capitalizeFirstLetter(title),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

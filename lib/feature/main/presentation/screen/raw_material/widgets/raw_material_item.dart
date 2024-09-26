import 'package:flutter/material.dart';
import 'package:omborchi/core/theme/style_res.dart';

class RawMaterialItem extends StatelessWidget {
  final String name;
  const RawMaterialItem({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: kButtonWhiteStyle.copyWith(
        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
        shape: const WidgetStatePropertyAll(RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(0)),
        )),
      ),
      onPressed: () {},
      child: Container(
        width: double.infinity,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Text(
          name,
          style: bold, // Assuming you have a 'bold' text style defined
        ),
      ),
    );
  }
}

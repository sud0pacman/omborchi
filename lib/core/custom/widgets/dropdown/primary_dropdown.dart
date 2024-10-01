import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/core/theme/style_res.dart';
import 'package:omborchi/core/utils/consants.dart';

class PrimaryDropdown extends StatelessWidget {
  final List<String> items;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;
  final double buttonHeight;
  final double buttonWidth;
  final double maxHeight;
  final double itemWidth;
  final double itemHeight;
  final EdgeInsets itemPadding;
  final String? defValue;

  const PrimaryDropdown({
    super.key,
    required this.items,
    this.selectedValue,
    required this.onChanged,
    this.buttonHeight = 46,
    this.buttonWidth = 82,
    this.maxHeight = 220,
    this.itemWidth = 90,
    this.itemHeight = 40,
    this.itemPadding = const EdgeInsets.only(left: 14, right: 14),
    this.defValue,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<String>(
      decoration: InputDecoration(
        // Add Horizontal padding using menuItemStyleData.padding so it matches
        // the menu padding when button's width is not specified.
        contentPadding: itemPadding,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: AppColors.background,
          ),
        ),
        // Add more decoration..
      ),
      items: items
          .map((String item) => DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: medium.copyWith(fontSize: 16),
                ),
              ))
          .toList(),
      value: selectedValue,
      onChanged: onChanged,
      buttonStyleData: ButtonStyleData(
        height: buttonHeight,
        width: buttonWidth,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: AppColors.white,
        ),
        elevation: 0,
      ),
      iconStyleData: IconStyleData(
        icon: SizedBox(
          height: 20,
          width: 20,
          child: SvgPicture.asset(
            AssetRes.icDropDownUpArrow,
          ),
        ),
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: maxHeight,
        width: itemWidth,
        elevation: 0,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.white,
        ),
      ),
      menuItemStyleData: MenuItemStyleData(
        height: itemHeight,
        padding: itemPadding,
      ),
    );
  }
}

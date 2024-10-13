import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/core/theme/style_res.dart';

import '../../../../domain/model/raw_material.dart';

class RawMaterialDropdown extends StatelessWidget {
  const RawMaterialDropdown({
    required this.hint,
    required this.value,
    required this.dropdownItems,
    required this.onChanged,
    this.selectedItemBuilder,
    this.hintAlignment,
    this.valueAlignment,
    this.buttonHeight,
    this.buttonWidth,
    this.buttonPadding,
    this.buttonDecoration,
    this.buttonElevation,
    this.icon,
    this.iconSize,
    this.iconEnabledColor,
    this.iconDisabledColor,
    this.itemHeight,
    this.itemPadding,
    this.dropdownHeight,
    this.dropdownWidth,
    this.dropdownPadding,
    this.dropdownDecoration,
    this.dropdownElevation,
    this.scrollbarRadius,
    this.scrollbarThickness,
    this.scrollbarAlwaysShow,
    this.offset = Offset.zero,
    this.buttonColor,
    this.itemColor,
    this.buttonTextStyle,
    this.itemTextStyle,
    super.key,
  });

  final String hint;
  final RawMaterial? value; // Change to RawMaterial
  final List<RawMaterial> dropdownItems; // Change to list of RawMaterial
  final ValueChanged<RawMaterial?>? onChanged; // Change to handle RawMaterial
  final DropdownButtonBuilder? selectedItemBuilder;
  final Alignment? hintAlignment;
  final Alignment? valueAlignment;
  final double? buttonHeight, buttonWidth;
  final EdgeInsetsGeometry? buttonPadding;
  final BoxDecoration? buttonDecoration;
  final int? buttonElevation;
  final Widget? icon;
  final double? iconSize;
  final Color? iconEnabledColor;
  final Color? iconDisabledColor;
  final double? itemHeight;
  final EdgeInsetsGeometry? itemPadding;
  final double? dropdownHeight, dropdownWidth;
  final EdgeInsetsGeometry? dropdownPadding;
  final BoxDecoration? dropdownDecoration;
  final int? dropdownElevation;
  final Radius? scrollbarRadius;
  final double? scrollbarThickness;
  final bool? scrollbarAlwaysShow;
  final Offset offset;
  final Color? buttonColor;
  final Color? itemColor;
  final TextStyle? buttonTextStyle;
  final TextStyle? itemTextStyle;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: AppColors.primary,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<RawMaterial>(
          isExpanded: true,
          hint: Container(
            alignment: hintAlignment,
            child: Text(
              value?.name ?? "",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: mediumTheme.copyWith(
                fontSize: 14,
                color: AppColors.midnightBlue,
              ),
            ),
          ),
          value: value,
          items: dropdownItems
              .map((RawMaterial item) => DropdownMenuItem<RawMaterial>(
                    value: item,
                    child: Container(
                      alignment: valueAlignment,
                      child: Text(
                        item.name ?? "", // Display the RawMaterial name
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: buttonTextStyle,
                      ),
                    ),
                  ))
              .toList(),
          onChanged: onChanged,
          selectedItemBuilder: selectedItemBuilder,
          buttonStyleData: ButtonStyleData(
            height: buttonHeight ?? 40,
            width: buttonWidth ?? 140,
            padding:
                buttonPadding ?? const EdgeInsets.only(left: 14, right: 14),
            decoration: buttonDecoration ??
                BoxDecoration(
                  color: buttonColor, // Change background color
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.black45,
                  ),
                ),
            elevation: buttonElevation,
          ),
          iconStyleData: IconStyleData(
            icon: icon ?? const Icon(Icons.arrow_forward_ios_outlined),
            iconSize: iconSize ?? 12,
            iconEnabledColor: iconEnabledColor,
            iconDisabledColor: iconDisabledColor,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: dropdownHeight ?? 200,
            width: dropdownWidth ?? 140,
            padding: dropdownPadding,
            decoration: dropdownDecoration ??
                BoxDecoration(
                  color: itemColor,
                  borderRadius: BorderRadius.circular(14),
                ),
            elevation: dropdownElevation ?? 8,
            offset: offset,
            scrollbarTheme: ScrollbarThemeData(
              radius: scrollbarRadius ?? const Radius.circular(40),
              thickness: scrollbarThickness != null
                  ? WidgetStateProperty.all<double>(scrollbarThickness!)
                  : null,
              thumbVisibility: scrollbarAlwaysShow != null
                  ? WidgetStateProperty.all<bool>(scrollbarAlwaysShow!)
                  : null,
            ),
          ),
          menuItemStyleData: MenuItemStyleData(
            height: itemHeight ?? 40,
            padding: itemPadding ?? const EdgeInsets.only(left: 14, right: 14),
          ),
        ),
      ),
    );
  }
}

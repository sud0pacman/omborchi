import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:omborchi/core/custom/formatters/thousand_formatter.dart';
import 'package:omborchi/core/custom/functions/custom_functions.dart';
import 'package:omborchi/core/custom/widgets/custom_text_field.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/core/theme/style_res.dart';
import 'package:omborchi/core/utils/consants.dart';
import 'package:omborchi/feature/main/presentation/screen/add_product/widgets/raw_material_dropdown.dart';
import 'package:omborchi/feature/main/presentation/screen/add_product/widgets/raw_material_type_dropdown.dart';

import '../../../../domain/model/raw_material.dart';
import '../../../../domain/model/raw_material_type.dart';

class AddRawMaterialItem extends StatefulWidget {

  final TextEditingController textController;
  final Function(double value) changedCost;
  final Map<RawMaterialType, List<RawMaterial>>? rawMaterials;

  const AddRawMaterialItem({super.key, required this.textController, required this.changedCost, this.rawMaterials});

  @override
  State<AddRawMaterialItem> createState() => _AddRawMaterialItemState();
}

class _AddRawMaterialItemState extends State<AddRawMaterialItem> {
  RawMaterialType? selectedRawMaterialType; // Tanlangan material turi
  RawMaterial? selectedRawMaterial; // Tanlangan xomashyo
  String? errorText; // Xatolik matni (agar bo‘lsa)

  // RawMaterialType tanlanganda UI'ni yangilaymiz
  void onRawMaterialTypeChanged(RawMaterialType? newType) {
    setState(() {
      selectedRawMaterialType = newType;
      selectedRawMaterial = null; // Xomashyoni tozalaymiz
    });
  }

  // RawMaterial tanlanganda UI'ni yangilaymiz
  void onRawMaterialChanged(RawMaterial? newMaterial) {
    setState(() {
      selectedRawMaterial = newMaterial;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RawMaterialTypeDropdown(
                hint: "Turini tanlang",
                value: selectedRawMaterialType,
                itemColor: AppColors.background,
                buttonColor: AppColors.white,
                buttonTextStyle: medium.copyWith(fontSize: 16),
                itemTextStyle: medium.copyWith(fontSize: 16),
                dropdownItems: widget.rawMaterials?.keys.toList() ?? [],
                onChanged: onRawMaterialTypeChanged,
              ),
              RawMaterialDropdown(
                hint: "Xomashyo tanlang",
                value: selectedRawMaterial,
                itemColor: AppColors.background,
                buttonColor: AppColors.white,
                buttonTextStyle: medium.copyWith(fontSize: 16),
                itemTextStyle: medium.copyWith(fontSize: 16),
                dropdownItems:
                    widget.rawMaterials?[selectedRawMaterialType] ?? [],
                onChanged: onRawMaterialChanged,
              ),
            ],
          ),
          if (errorText != null) // Agar xato mavjud bo‘lsa, uni ko‘rsatamiz
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                errorText!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          const SizedBox(height: 16),
          TextWithTextFieldSmokeWhiteWidget(
            controller: widget.textController,
            textInputType: TextInputType.number,
            errorText: errorText,
            onChanged: (value) {
              double quantity = convertToInt(value).toDouble();
              if (selectedRawMaterial != null) {
                double newCost = quantity * (selectedRawMaterial!.price ?? 0.0);
                AppRes.logger.w("$quantity || $newCost");
                widget.changedCost(newCost);
              }
            },
            constraints: const BoxConstraints(maxHeight: 48),
            inputFormatters: [
              ThousandsSeparatorInputFormatter(),
              LengthLimitingTextInputFormatter(9)
            ],
            hint: "Soni".tr,
          ),
        ],
      ),
    );
  }
}

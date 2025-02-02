import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:omborchi/core/custom/extensions/context_extensions.dart';
import 'package:omborchi/core/custom/functions/custom_functions.dart';
import 'package:omborchi/core/custom/widgets/primary_button.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/core/utils/consants.dart';
import 'package:omborchi/feature/main/data/model/local_model/raw_material_ui.dart';
import 'package:omborchi/feature/main/domain/model/product_model.dart';

import '../../../../../../core/theme/style_res.dart';

void showProductDetailsBottomSheet(
    BuildContext context, ProductModel product, List<RawMaterialUi> list) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    // To allow BottomSheet to expand properly
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    backgroundColor: AppColors.background,
    builder: (BuildContext context) {
      var tannarx = MoneyFormatter(amount: product.sotuv?.toDouble() ?? 0)
          .output
          .withoutFractionDigits;
      var sotuv = MoneyFormatter(
              amount: (product.sotuv ?? 0) +
                  (product.xizmat ?? 0) +
                  (product.foyda ?? 0).toDouble())
          .output
          .withoutFractionDigits;
      return SingleChildScrollView(

        child: Container(
          color: context.containerColor(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                16.verticalSpace,
                 Text(
                  "Xomashyolar",
                  style: bold.copyWith(color: context.textColor()),
                ),
                8.verticalSpace,
                for (var item in list)
                  _buildInfoRow(
                      title: item.name ?? "",
                      value: "${item.quantity.toString()} ta", context: context,),
                16.verticalSpace,
                _buildInfoRow(
                    title: "Nomer:", value: product.description.toString(), context: context,),
                _buildInfoRow(
                    title: "Razmer:", value: "${product.boyi} X ${product.eni}", context: context,),
                _buildInfoRow(title: "Tannarx:", value: "$tannarx so'm", context: context,),
                _buildInfoRow(
                    context: context,
                    title: "Xizmat narxi:",
                    value:
                        "${MoneyFormatter(amount: product.xizmat?.toDouble() ?? 0).output.withoutFractionDigits} so'm" ??
                            "N/A"),
                _buildInfoRow(
                    context: context,
                    title: "Foyda:",
                    value:
                        "${MoneyFormatter(amount: product.foyda?.toDouble() ?? 0).output.withoutFractionDigits} so'm" ??
                            "N/A"),
                _buildInfoRow(title: "Sotuv:", value: "$sotuv so'm" ?? "N/A", context: context,),
                const SizedBox(height: 16),
                Center(
                  child: PrimaryButton(
                    title: "Yopish",
                    width: double.infinity,
                    onPressed: () {
                      Navigator.pop(context); // Close BottomSheet
                    },
                  ),
                ),
                const SizedBox(
                  height: 16,
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildInfoRow(
    {required String title,
    required String value,
    required BuildContext context}) {
  String changedValue = value;
  if (value.isNumericOnly) {
    AppRes.logger.d("isNumericOnly success $title $value");
    MoneyFormatter formatter =
        MoneyFormatter(amount: value.toIntOrZero().toDouble());
    changedValue = formatter.output.withoutFractionDigits;
  }
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            title,
            style: medium.copyWith(fontSize: 18, color: context.textColor()),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            changedValue,
            style: bold.copyWith(fontSize: 18, color: context.textColor()),
            textAlign: TextAlign.end,
            softWrap: true, // Allows text to wrap into new lines
            overflow: TextOverflow.visible, // Overflow handled
          ),
        ),
      ],
    ),
  );
}

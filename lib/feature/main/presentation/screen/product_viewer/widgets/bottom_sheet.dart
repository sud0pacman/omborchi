import 'package:flutter/material.dart';
import 'package:omborchi/core/custom/widgets/primary_button.dart';
import 'package:omborchi/core/theme/colors.dart';
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
      var tannarx =
          (product.sotuv ?? 0) - (product.xizmat ?? 0) - (product.foyda ?? 0);
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 16,
              ),
              const Text(
                "Xomashyolar",
                style: bold,
              ),
              const SizedBox(
                height: 8,
              ),
              for (var item in list)
                _buildInfoRow(
                    title: item.name ?? "",
                    value: "${item.quantity.toString()} ta"),
              const SizedBox(
                height: 16,
              ),
              _buildInfoRow(title: "Nomer:", value: product.nomer.toString()),
              _buildInfoRow(
                  title: "Razmer:", value: "${product.boyi} X ${product.eni}"),
              _buildInfoRow(title: "Tannarx:", value: "$tannarx so'm"),
              _buildInfoRow(
                  title: "Xizmat narxi:",
                  value: "${product.xizmat?.toString()} so'm" ?? "N/A"),
              _buildInfoRow(
                  title: "Foyda:",
                  value: "${product.foyda?.toString()} so'm" ?? "N/A"),
              _buildInfoRow(
                  title: "Sotuv:",
                  value: "${product.sotuv?.toString()} so'm" ?? "N/A"),
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
      );
    },
  );
}

Widget _buildInfoRow({required String title, required String value}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            title,
            style: medium.copyWith(fontSize: 18),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            value,
            style: bold.copyWith(fontSize: 18),
            textAlign: TextAlign.end,
            softWrap: true, // Allows text to wrap into new lines
            overflow: TextOverflow.visible, // Overflow handled
          ),
        ),
      ],
    ),
  );
}

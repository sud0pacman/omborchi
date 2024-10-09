import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:omborchi/core/custom/widgets/primary_button.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/feature/main/domain/model/product_model.dart';
import '../../../../../../core/theme/style_res.dart';

void showProductDetailsBottomSheet(BuildContext context, ProductModel product) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // To allow BottomSheet to expand properly
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    backgroundColor: AppColors.background,
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.7, // Initial visible size (70% of screen)
        minChildSize: 0.3,     // Minimum BottomSheet size (40% of screen)
        maxChildSize: 0.95,    // Maximum size (95% of screen)
        expand: false,         // Prevents the sheet from taking full screen
        builder: (BuildContext context, ScrollController scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(title: "ID:", value: product.id?.toString() ?? "N/A"),
                  _buildInfoRow(title: "Nomer:", value: product.nomer.toString()),
                  _buildInfoRow(title: "Rasm yo'li:", value: product.pathOfPicture ?? "N/A"),
                  _buildInfoRow(title: "Razmer:", value: product.razmer ?? "N/A"),
                  _buildInfoRow(title: "Xizmat narxi:", value: product.xizmat?.toString() ?? "N/A"),
                  _buildInfoRow(title: "Foyda:", value: product.foyda?.toString() ?? "N/A"),
                  _buildInfoRow(title: "Sotuv:", value: product.sotuv?.toString() ?? "N/A"),
                  _buildInfoRow(title: "Tavsif:", value: product.description ?? "N/A"),
                  _buildInfoRow(title: "Kategoriya ID:", value: product.categoryId?.toString() ?? "N/A"),
                  _buildInfoRow(title: "Yaratilgan sana:", value: product.createdAt != null ? product.createdAt.toString() : "N/A"),
                  _buildInfoRow(title: "Tasdiqlangan:", value: product.isVerified ? "Ha" : "Yo'q"),
                  _buildInfoRow(title: "Yangilangan sana:", value: product.updatedAt != null ? product.updatedAt.toString() : "N/A"),
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
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Widget _buildInfoRow({required String title, required String value}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start, // To handle long text properly
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

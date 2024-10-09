import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:omborchi/core/custom/functions/custom_functions.dart';
import 'package:omborchi/core/custom/widgets/app_bar.dart';
import 'package:omborchi/feature/main/domain/model/product_model.dart';
import 'package:omborchi/feature/main/presentation/screen/product_viewer/widgets/bottom_sheet.dart';

import '../../../../../core/custom/widgets/under_save_button.dart';
import '../../../../../core/utils/consants.dart';

class ProductViewScreen extends StatefulWidget {
  final ProductModel product;

  const ProductViewScreen({super.key, required this.product});

  @override
  State<ProductViewScreen> createState() => _ProductViewScreenState();
}

class _ProductViewScreenState extends State<ProductViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        leadingIcon: AssetRes.icBack,
        actionTitle: replaceSpaceWithX(widget.product.razmer ?? '0 0'),
        onTapLeading: () {
          closeScreen(context);
        },
        title: "#${widget.product.nomer.toString()}",
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: InteractiveViewer(
                  boundaryMargin: const EdgeInsets.all(20.0),
                  minScale: 0.5,
                  maxScale: 4.0, // Maximum zoom level
                  child: Image.file(
                    File(widget.product.pathOfPicture ?? ""),
                    fit: BoxFit.contain, // Adjust fit to allow for zooming
                  ),
                ),
              ),
            ),
          ),
          UnderSaveButton(
            title: "Malumotlarni ko'rish".tr,
            onPressed: () {
              showProductDetailsBottomSheet(context, widget.product);
            },
          ),
        ],
      ),
    );
  }
}

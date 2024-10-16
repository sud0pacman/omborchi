import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:omborchi/core/custom/functions/custom_functions.dart';
import 'package:omborchi/core/modules/app_module.dart';
import 'package:omborchi/feature/main/data/model/local_model/raw_material_ui.dart';
import 'package:omborchi/feature/main/domain/model/product_model.dart';
import 'package:omborchi/feature/main/presentation/bloc/product_view/product_view_bloc.dart';
import 'package:omborchi/feature/main/presentation/screen/product_viewer/widgets/app_bar.dart';
import 'package:omborchi/feature/main/presentation/screen/product_viewer/widgets/bottom_sheet.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../config/router/app_routes.dart';
import '../../../../../core/custom/widgets/dialog/info_dialog.dart';
import '../../../../../core/custom/widgets/under_save_button.dart';
import '../../../../../core/utils/consants.dart';

class ProductViewScreen extends StatefulWidget {
  final ProductModel product;

  const ProductViewScreen({super.key, required this.product});

  @override
  State<ProductViewScreen> createState() => _ProductViewScreenState();
}

class _ProductViewScreenState extends State<ProductViewScreen> {
  final ProductViewBloc _bloc =
      ProductViewBloc(serviceLocator(), serviceLocator());

  void showDeleteDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return InfoDialog(
            title: "O'chirish".tr,
            message: "Ushbu mahsulotni o'chirmoqchimisiz?".tr,
            positiveText: "O'chirish".tr,
            negativeText: "Bekor qilish",
            onPositiveTap: () {
              _bloc.add(DeleteProduct(product: widget.product));
              closeDialog(context);
            },
            onNegativeTap: () {
              closeDialog(context);
            },
          );
        });
  }

  @override
  void initState() {
    _bloc.add(GetProductMaterials(productId: widget.product.id ?? 0));
    super.initState();
  }

  List<RawMaterialUi> materials = [];
  int materialSum = 0;

  @override
  Widget build(BuildContext context) {
    var sotuv = (materialSum) +
        (widget.product.xizmat ?? 0) +
        (widget.product.foyda ?? 0);
    final marketSum = MoneyFormatter(amount: sotuv.toDouble());
    return Scaffold(
      appBar: productViewAppBar(
        onTapDelete: () {
          showDeleteDialog(context);
        },
        onTapEdit: () async {
          Navigator.pushReplacementNamed(
              context, RouteManager.updateProductScreen,
              arguments: widget.product);
        },
        leadingIcon: AssetRes.icBack,
        // actionTitle: "${widget.product.boyi ?? 0} X ${widget.product.eni ?? 0}",
        onTapLeading: () {
          closeScreen(context);
        },
        actions: [AssetRes.icShare],
        onTapAction: (tappedIndex) async {
          if (tappedIndex == 0) {
            final result = await Share.shareXFiles([
              XFile('${widget.product.pathOfPicture}')
            ], text: "Sotuvda: ${marketSum.output.withoutFractionDigits} so'm");

            if (result.status == ShareResultStatus.success) {
              AppRes.logger.i('Thank you for sharing my website!');
            }
          }
        },
        title: "#${widget.product.description.toString()}",
      ),
      body: BlocProvider.value(
        value: _bloc,
        child: BlocConsumer<ProductViewBloc, ProductViewState>(
          listener: (context, state) {
            if (state.materials.isNotEmpty) {
              materials = state.materials;
              for (var material in state.materials) {
                materialSum += ((material.quantity?.toDouble() ?? 0) *
                        (material.price?.toDouble() ?? 0))
                    .toInt();
              }
              setState(() {});
            }
            if (state.error != null) {
              AppRes.showSnackBar(context, state.error!);
            }
            if (state.isBack) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text(
                    "Muvaffaqiyatli o'chirildi. Iltimos oyna malumotlarini yangilang."),
                behavior: SnackBarBehavior.floating,
              ));
              closeScreen(context, arg: true);
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: InteractiveViewer(
                              minScale: 0.5,
                              maxScale: 4.0, // Maximum zoom level
                              child: Image.file(
                                File(widget.product.pathOfPicture ?? ""),
                                fit: BoxFit
                                    .contain, // Adjust fit to allow for zooming
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 108),
                      // Leave space for UnderSaveButton
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: UnderSaveButton(
                    title: "${marketSum.output.withoutFractionDigits} so'm",
                    onPressed: () {
                      showProductDetailsBottomSheet(
                          context,
                          widget.product.copyWith(sotuv: materialSum),
                          materials);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

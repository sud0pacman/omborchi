import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:omborchi/core/custom/extensions/context_extensions.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'dart:io';

import 'package:omborchi/feature/main/domain/model/product_model.dart';

import '../../../../../../core/custom/widgets/loading_widget.dart';

class ProductListItem extends StatelessWidget {
  final ProductModel product;
  final int selectedIndex;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const ProductListItem({
    Key? key,
    required this.product,
    required this.selectedIndex,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  bool isValidUrl(String url) {
    // Implement your URL validation logic here
    return Uri.tryParse(url)?.hasAbsolutePath ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: context.containerColor(),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: product.pathOfPicture != null
                    ? isValidUrl(product.pathOfPicture!)
                    ? CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: product.pathOfPicture!,
                  placeholder: (___, __) => const LoadingWidget(),
                  alignment: Alignment.center,
                  errorWidget: (___, __, _) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Rasmni yuklashda xatolik",
                        style: TextStyle(
                          color: context.textColor(),
                          fontSize: 16,
                          fontWeight: FontWeight.w500, // Assuming pmedium is similar
                        ),
                      ),
                    ),
                  ),
                )
                    : CachedMemoryImage(
                  fit: BoxFit.cover,
                  bytes: File(product.pathOfPicture!).readAsBytesSync(),
                  uniqueKey: "${product.pathOfPicture}",
                  alignment: Alignment.center,
                  placeholder: const LoadingWidget(),
                  errorWidget: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Rasmni yuklashda xatolik",
                      style: TextStyle(
                        color: context.textColor(),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
                    : Icon(
                  Icons.error,
                  color: context.textColor(),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(4),
                    bottomLeft: Radius.circular(4),
                    bottomRight: Radius.circular(4),
                  ),
                  color: AppColors.appBarDark.withAlpha(70),
                ),
                child: Text(
                  '#${product.description}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:omborchi/core/custom/extensions/context_extensions.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/core/theme/style_res.dart';
import 'package:omborchi/core/utils/consants.dart';

class PickedImage extends StatelessWidget {
  final XFile? image;
  final VoidCallback onTap;

  const PickedImage({super.key, required this.image, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return IconButton(
      onPressed: onTap,
      style: kButtonWhiteStyle.copyWith(
          backgroundColor: WidgetStatePropertyAll(
              context.containerColor()), // Ensure background color is white
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(24)),
              side: BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
          ),
          padding: const WidgetStatePropertyAll(EdgeInsets.zero)),
      icon: SizedBox(
        width: width / 2,
        height: width / 2,
        child: image == null
            ? Container(
                alignment:
                    Alignment.center, // Centers the icon within the container
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: SvgPicture.asset(
                    AssetRes.icGallery,
                    colorFilter: ColorFilter.mode(
                        context.textColor(), BlendMode.srcIn),
                  ),
                ),
              )
            : ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(24)),
                child: Image.file(
                  File(image!.path),
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }
}

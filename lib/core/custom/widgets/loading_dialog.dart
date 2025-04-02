import 'package:flutter/material.dart';
import 'package:omborchi/core/custom/extensions/context_extensions.dart';
import 'package:omborchi/core/custom/widgets/loading_widget.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/core/theme/style_res.dart';

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Orqaga bosishni o'chirib qo'yish
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const LoadingWidget(),
              const SizedBox(height: 20),
              Text(
                'Bu biroz vaqt olishi mumkin. Iltimos ekranni o\'chirmang!',
                style: medium.copyWith(color: context.textColor(), fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    },
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:omborchi/core/custom/extensions/color_to_hsl.dart';
import 'package:omborchi/core/custom/extensions/context_extensions.dart';
import 'package:omborchi/core/theme/style_res.dart';
import 'package:omborchi/core/utils/consants.dart';

import '../../../../../../core/custom/widgets/primary_button.dart';
import '../../../../../../core/theme/colors.dart';

class SupportDialog extends StatelessWidget {
  final VoidCallback onTapContinue;

  const SupportDialog({
    super.key,
    required this.onTapContinue,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(14),
        topLeft: Radius.circular(14),
      ),
      child: Container(
        height: 216.h,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              Constants.supportPhone.tr,
              textAlign: TextAlign.center,
              style:
                  pmedium.copyWith(fontSize: 24.sp, color: context.textColor()),
            ),
            PrimaryButton(
              text: "Qo'ngiroq qilish".tr,
              hslColor: AppColors.primary.toHSL(),
              onPressed: onTapContinue,
            ),
          ],
        ),
      ),
    );
  }
}

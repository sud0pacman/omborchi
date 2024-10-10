import 'package:flutter/material.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/core/theme/style_res.dart';

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Orqaga bosishni o'chirib qo'yish
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child:  const Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: AppColors.primary,),
              SizedBox(height: 20),
              Text(
                'Bu biroz vaqt olishi mumkin. Iltimos ekranni o\'chirmang!',
                style: medium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    },
  );
}

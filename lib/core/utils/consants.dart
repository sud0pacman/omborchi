import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:omborchi/core/custom/extensions/context_extensions.dart';
import 'package:omborchi/core/theme/colors.dart';

import '../theme/style_res.dart';

class AppRes {
  static final logger = Logger();

  static void showSnackBar(
    BuildContext context, {
    required String message,
    bool? isErrorMessage,
    bool? isSuccessMessage,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 6.0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        dismissDirection: DismissDirection.horizontal,
        backgroundColor: context.containerColor(),
        content: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: Text(
            message,
            style: pregular.copyWith(
              color: isErrorMessage == true
                  ? AppColors.red
                  : isSuccessMessage == true
                      ? AppColors.emeraldGreen
                      : context.textColor(),
              fontSize: 16.0,
            ),
          ),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

class Constants {
  static const String noNetwork =
      "Iltimos, internetingizni tekshiring va qayta urinib ko'ring";
  static const String noImage =
      "https://st4.depositphotos.com/14953852/24787/v/450/depositphotos_247872612-stock-illustration-no-image-available-icon-vector.jpg";

  static const String successUpdated = "Muvaffaqiyatli yangilandi!";
  static const String appName = "Omborchi";
  static const String appNamespace = "";
  static String supportPhone = "+998 77 737 97 30";
  static String supportEmail = "abdulbasitmakhsudov@gmail.com";
}

BoxDecoration containerBoxDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(16),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.1), // Subtle shadow
      blurRadius: 10,
      offset: const Offset(0, 4),
      spreadRadius: 2,
    ),
  ],
);
class AppSecrets {
  static const String anonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpjbmhzdWpjaHJzdG1oeGxyamNkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDUwNjEzOTgsImV4cCI6MjA2MDYzNzM5OH0.N7QsfauH_PnJKFxQri5u4MaWyBpbsBQ4L4vkVhukGDw";
  static const String url =
      "https://zcnhsujchrstmhxlrjcd.supabase.co";



  static const String supabaseAnonKey = anonKey;
  static const String supabaseUrl = url;
}
class ExpenseFields {
  static const String employeeTable = 'employee';
  static const String categoryTable = 'category';
  static const String productTable = 'product';
  static const String deletedProductTable = 'deleted_products';
  static const String productPriceTable = 'tannarx';
  static const String rawMaterialTypeTable = 'types';
  static const String rawMaterialTable = 'xomashyo';
  static const String adminKeyTable = 'admin';
  static const String productImageBucket = "product.images";

  static const String myBox = 'myBox';
}



class AssetRes {
  static const _base = 'assets/icons/';
  static const icBack = '${_base}ic_left_arrow.svg';
  static const icSearch = '${_base}ic_search.svg';
  static const icShare = '${_base}ic_share.svg';
  static const icLogout = '${_base}ic_logout.svg';
  static const icFolder = '${_base}folder.png';
  static const icAppLogo = '${_base}logo.png';
  static const icInactive = '${_base}ic_inactive.svg';
  static const icProduct = '${_base}ic_product.svg';
  static const icMaterialRaw = '${_base}ic_material_raw.svg';
  static const icMaterialRawType = '${_base}ic_materialraw_type.svg';
  static const icEyeHidden = '${_base}ic_eye_hidden.svg';
  static const icEyeShowed = '${_base}ic_eye_showed.svg';
  static const icTrash = '${_base}ic_trash.svg';
  static const icEdit = '${_base}ic_edit.svg';
  static const icSynchronization = '${_base}ic_synch.svg';
  static const icGallery = '${_base}ic_gallery.svg';
  static const icMore = '${_base}ic_more.svg';
  static const icDropDownUpArrow = '${_base}ic_drop_down_up_arrow.svg';
}

class LastUpdates {
  static const String type = 'type_last_update_time';
  static const String product = 'product_last_update_time';
  static const String material = 'material_last_update_time';
  static const String category = 'category_last_update_time';
}

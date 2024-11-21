import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../theme/style_res.dart';

class AppRes {
  static final logger = Logger();

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: regularWhite.copyWith(fontSize: 14),
      ),
      behavior: SnackBarBehavior.floating,
    ));
  }
}

class Constants {
  static const String noNetwork =
      "Iltimos, internetingizni tekshiring va qayta urinib ko'ring";
  static const String noImage =
      "https://st4.depositphotos.com/14953852/24787/v/450/depositphotos_247872612-stock-illustration-no-image-available-icon-vector.jpg";

  static const String successUpdated = "Muvaffaqiyatli yangilandi!";
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
  static const String productImageBucket = 'product_images';

  static const String myBox = 'myBox';
}

class AppSecrets {
  static const String supabaseAnonKey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRzemVudnFsbWV2a2FtZnB6Z2lyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzAxODk1MDUsImV4cCI6MjA0NTc2NTUwNX0.G-MSkckFK-CPsx2OC8YNZvHOnaGcwT0TSfPw9HdyKF8";

  static const String supabaseUrl = "https://tszenvqlmevkamfpzgir.supabase.co";
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

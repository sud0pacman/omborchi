import 'package:flutter/material.dart';
import 'package:omborchi/feature/main/presentation/screen/add_product/add_product_screen.dart';
import 'package:omborchi/feature/main/presentation/screen/category/category_screen.dart';
import 'package:omborchi/feature/main/presentation/screen/main/main_screen.dart';
import 'package:omborchi/feature/main/presentation/screen/product_viewer/product_view_screen.dart';
import 'package:omborchi/feature/main/presentation/screen/raw_material/raw_material_screen.dart';
import 'package:omborchi/feature/main/presentation/screen/raw_material_type/raw_material_type_screen.dart';
import 'package:omborchi/feature/main/presentation/screen/splash/splash_screen.dart';

import '../../feature/main/domain/model/product_model.dart';

class RouteManager {
  static const String splashScreen = '/splashScreen';
  static const String mainScreen = '/mainScreen';
  static const String addProductScreen = '/addProductScreen';
  static const String categoryScreen = '/categoryScreen';
  static const String rawMaterialScreen = '/rawMaterialScreen';
  static const String rawMaterialTypeScreen = '/rawMaterialTypeScreen';
  static const String productViewScreen = '/productViewScreen';

  static generateRoute(RouteSettings settings) {
    var args = settings.arguments;
    const duration = Duration(milliseconds: 200);

    switch (settings.name) {
      case '/':
      case splashScreen:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );

      case mainScreen:
        return MaterialPageRoute(builder: (_) => const MainScreen());

      case addProductScreen:
        return MaterialPageRoute(builder: (_) => const AddProductScreen());

      case categoryScreen:
        return MaterialPageRoute(builder: (_) => const CategoryScreen());

      case rawMaterialScreen:
        return MaterialPageRoute(builder: (_) => const RawMaterialScreen());

      case rawMaterialTypeScreen:
        return MaterialPageRoute(builder: (_) => const RawMaterialTypeScreen());

      case productViewScreen:
        final product = settings.arguments
            as ProductModel; // Argument sifatida productni qabul qilish
        return MaterialPageRoute(
          builder: (_) => ProductViewScreen(product: product),
        );
    }
  }
}

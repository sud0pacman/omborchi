import 'package:flutter/material.dart';
import 'package:omborchi/feature/main/presentation/screen/add_product/add_product_screen.dart';
import 'package:omborchi/feature/main/presentation/screen/category/category_screen.dart';
import 'package:omborchi/feature/main/presentation/screen/main/main_screen.dart';
import 'package:omborchi/feature/main/presentation/screen/product_viewer/product_view_screen.dart';
import 'package:omborchi/feature/main/presentation/screen/raw_material/raw_material_screen.dart';
import 'package:omborchi/feature/main/presentation/screen/raw_material_type/raw_material_type_screen.dart';
import 'package:omborchi/feature/main/presentation/screen/splash/splash_screen.dart';
import 'package:omborchi/feature/main/presentation/screen/sync/sync_screen.dart';

import '../../feature/main/domain/model/product_model.dart';

class RouteManager {
  static const String splashScreen = '/splashScreen';
  static const String mainScreen = '/mainScreen';
  static const String addProductScreen = '/addProductScreen';
  static const String categoryScreen = '/categoryScreen';
  static const String rawMaterialScreen = '/rawMaterialScreen';
  static const String rawMaterialTypeScreen = '/rawMaterialTypeScreen';
  static const String productViewScreen = '/productViewScreen';
  static const String syncScreen = '/syncScreen';

  static Route<bool?>? generateRoute(RouteSettings settings) {
    var args = settings.arguments;

    switch (settings.name) {
      case splashScreen:
        return MaterialPageRoute<bool?>(
          builder: (_) => const SplashScreen(),
        );

      case mainScreen:
        return MaterialPageRoute<bool?>(
          builder: (_) => const MainScreen(),
        );

      case addProductScreen:
        return MaterialPageRoute<bool?>(
          builder: (_) => const AddProductScreen(),
        );

      case categoryScreen:
        return MaterialPageRoute<bool?>(
          builder: (_) => const CategoryScreen(),
        );

      case rawMaterialScreen:
        return MaterialPageRoute<bool?>(
          builder: (_) => const RawMaterialScreen(),
        );

      case rawMaterialTypeScreen:
        return MaterialPageRoute<bool?>(
          builder: (_) => const RawMaterialTypeScreen(),
        );

      case syncScreen:
        return MaterialPageRoute<bool?>(
          builder: (_) => const SyncScreen(),
        );

      case productViewScreen:
        final product = settings.arguments as ProductModel;
        return MaterialPageRoute<bool?>(
          builder: (_) => ProductViewScreen(product: product),
        );

      default:
        return null;
    }
  }
}

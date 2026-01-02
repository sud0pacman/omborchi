import 'package:flutter/material.dart';
import 'package:omborchi/feature/main/presentation/screen/add_product/add_product_screen.dart';
import 'package:omborchi/feature/main/presentation/screen/category/category_screen.dart';
import 'package:omborchi/feature/main/presentation/screen/main/main_screen.dart';
import 'package:omborchi/feature/main/presentation/screen/product_viewer/product_view_screen.dart';
import 'package:omborchi/feature/main/presentation/screen/raw_material/raw_material_screen.dart';
import 'package:omborchi/feature/main/presentation/screen/raw_material_type/raw_material_type_screen.dart';
import 'package:omborchi/feature/main/presentation/screen/select_theme/select_theme_screen.dart';
import 'package:omborchi/feature/main/presentation/screen/settings/settings_screen.dart';
import 'package:omborchi/feature/main/presentation/screen/splash/splash_screen.dart';
import 'package:omborchi/feature/main/presentation/screen/sync/migrate_screen.dart';
import 'package:omborchi/feature/main/presentation/screen/sync/sync_screen.dart';
import 'package:omborchi/feature/main/presentation/screen/update_product/update_product_screen.dart';
import '../../feature/main/domain/model/product_model.dart';
import '../../feature/main/presentation/screen/sync/rename.dart';

class RouteManager {
  static const String splashScreen = '/splashScreen';
  static const String mainScreen = '/mainScreen';
  static const String addProductScreen = '/addProductScreen';
  static const String updateProductScreen = '/updateProductScreen';
  static const String categoryScreen = '/categoryScreen';
  static const String rawMaterialScreen = '/rawMaterialScreen';
  static const String rawMaterialTypeScreen = '/rawMaterialTypeScreen';
  static const String productViewScreen = '/productViewScreen';
  static const String syncScreen = '/syncScreen';
  static const String settingsScreen = '/settingsScreen';
  static const String selectThemeScreen = '/selectThemeScreen';

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case splashScreen:
        return customRoute(const SplashScreen());

      case mainScreen:
        return customRoute(const MainScreen(), );

      case addProductScreen:
        return customRoute(const AddProductScreen());

      case categoryScreen:
        return customRoute(const CategoryScreen());

      case rawMaterialScreen:
        return customRoute(const RawMaterialScreen());

      case rawMaterialTypeScreen:
        return customRoute(const RawMaterialTypeScreen());

      case syncScreen:
        return customRoute(const SyncScreen());

      case settingsScreen:
        return customRoute(const SettingsScreen());

      case selectThemeScreen:
        return customRoute(const SelectThemeScreen());

      case productViewScreen:
        final product = args as ProductModel;
        return customRoute(ProductViewScreen(product: product));

      case updateProductScreen:
        final product = args as ProductModel;
        return customRoute(UpdateProductScreen(product: product));

      default:
        return null;
    }
  }

  static PageRouteBuilder customRoute(
      Widget screen, {
        SlideDirection direction = SlideDirection.rightToLeft,
      }) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        Offset beginEnter;
        Offset beginExit;
        switch (direction) {
          case SlideDirection.rightToLeft:
            beginEnter = const Offset(1, 0);
            beginExit = const Offset(-1, 0);
            break;
          case SlideDirection.leftToRight:
            beginEnter = const Offset(-1, 0);
            beginExit = const Offset(1, 0);
            break;
          case SlideDirection.bottomToTop:
            beginEnter = const Offset(0, 1);
            beginExit = const Offset(0, -1);
            break;
          case SlideDirection.topToBottom:
            beginEnter = const Offset(0, -1);
            beginExit = const Offset(0, 1);
            break;
          case SlideDirection.rightToLeftStatic:
            beginEnter = const Offset(1, 0);
            beginExit = const Offset(0, 0);
            break;
        }

        const end = Offset.zero;
        const curve = Curves.ease;

        var enterTween =
        Tween(begin: beginEnter, end: end).chain(CurveTween(curve: curve));
        var exitTween =
        Tween(begin: end, end: beginExit).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(enterTween),
          child: SlideTransition(
            position: secondaryAnimation.drive(exitTween),
            child: child,
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return screen;
      },
    );
  }
}
enum SlideDirection {
  rightToLeft,
  leftToRight,
  bottomToTop,
  topToBottom,
  rightToLeftStatic,
}
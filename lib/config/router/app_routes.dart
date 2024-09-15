import 'package:flutter/material.dart';
import 'package:omborchi/feature/main/presentation/screen/main/main_screen.dart';
import 'package:omborchi/feature/main/presentation/screen/splash/splash_screen.dart';

class RouteManager {
  static const String splashScreen = '/splashScreen';
  static const String mainScreen = '/mainScreen';

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
    }
  }
}

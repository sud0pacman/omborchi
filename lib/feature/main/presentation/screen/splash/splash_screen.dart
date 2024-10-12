import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:omborchi/core/utils/consants.dart';
import 'package:omborchi/feature/main/domain/repository/product_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../config/router/app_routes.dart';
import '../../../../../core/modules/app_module.dart';
import '../../../../../core/network/network_state.dart' as NetworkState;
import '../../../data/repository_impl/product_repository_impl.dart';
import '../../../data/repository_impl/temp/database_read_methods.dart';
import '../../../domain/model/product_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }



  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 2)); // Adjust delay as needed
    _checkSyncStatus();
  }

  Future<void> _checkSyncStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isSynced = prefs.getBool('isSynced') ?? false; // default: false

    // Delay before navigating to avoid issues with multiple navigations
    await Future.delayed(const Duration(milliseconds: 500));

    if (isSynced) {
      Navigator.pushReplacementNamed(context, RouteManager.mainScreen);
    } else {
      Navigator.pushReplacementNamed(context, RouteManager.syncScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Set status bar text and icon color to dark (for light backgrounds)
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Transparent background
      statusBarIconBrightness:
          Brightness.dark, // Dark icons for light background
    ));

    return Scaffold(
      body: Center(
        child: Lottie.asset(
          'assets/lottie/splash.json',
          height: 176,
        ), // Show Lottie animation when empty
      ),
    );
  }
}

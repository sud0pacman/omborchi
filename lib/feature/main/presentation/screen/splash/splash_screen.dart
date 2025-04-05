import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:omborchi/core/utils/consants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../config/router/app_routes.dart';
import '../../../../../core/modules/app_module.dart';
import '../../../../../core/network/network_state.dart' as NetworkState;
import '../../../data/data_sources/remote_data_source/product_remote_data_source.dart';
import '../../../data/model/remote_model/product_network.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final productRemoteDataSource = ProductRemoteDataSourceImpl(serviceLocator());

  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  // Future<void> _updateProductImagePaths() async {
    // For SQL Editor
    // UPDATE product
    // SET path_of_picture = REPLACE(path_of_picture, 'https://tszenvqlmevkamfpzgir.supabase.co/storage/v1/object/public/product_images/', 'https://zhbmndjtuhowaeeexxkg.supabase.co/storage/v1/object/public/product.images/')
    // WHERE path_of_picture LIKE 'https://tszenvqlmevkamfpzgir.supabase.co/storage/v1/object/public/product_images/%';
  // }
  Future<void> updateProductImageUrls() async {
    final response = await Supabase.instance.client.from('product').select();
    final products = response as List;

    for (var product in products) {
      final oldUrl = product['path_of_picture'] as String?;
      if (oldUrl != null &&
          oldUrl.startsWith(
              'https://tszenvqlmevkamfpzgir.supabase.co/storage/v1/object/public/product_images/')) {
        final newUrl = oldUrl.replaceFirst(
          'https://tszenvqlmevkamfpzgir.supabase.co/storage/v1/object/public/product_images/',
          'https://zhbmndjtuhowaeeexxkg.supabase.co/storage/v1/object/public/product.images/',
        );

        await Supabase.instance.client
            .from('product')
            .update({'path_of_picture': newUrl}).eq('id', product['id']);
      }
    }
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 2));
    _checkSyncStatus();
  }

  Future<void> _checkSyncStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isSynced = prefs.getBool('isSynced') ?? false;
    await Future.delayed(const Duration(milliseconds: 500));
    // Navigator.pushReplacementNamed(context, RouteManager.mainScreen);
    if (isSynced) {
      Navigator.pushReplacementNamed(context, RouteManager.mainScreen);
    } else {
      Navigator.pushReplacementNamed(context, RouteManager.syncScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isLightTheme
            ? Brightness.dark
            : Brightness.light, // Icon brightness
        statusBarBrightness: isLightTheme
            ? Brightness.light
            : Brightness.dark, // Status bar brightness (iOS)
      ),
    );

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

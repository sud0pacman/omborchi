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
    // _updateProductImagePaths();
    _navigateAfterDelay();
  }

  Future<void> _updateProductImagePaths() async {
    final bool hasNetwork = await InternetConnectionChecker().hasConnection;
    if (hasNetwork) {
      final networkRes = await productRemoteDataSource.getProducts();
      if (networkRes is NetworkState.Success) {
        final List<ProductNetwork> products = networkRes.value;
        final appDir = await getApplicationDocumentsDirectory();
        for (int i = 5; i < products.length; i++) {
          if (products[i].pathOfPicture != null &&
              !(products[i].pathOfPicture!.startsWith("/data")) &&
              products[i].pathOfPicture!.isNotEmpty) {
            AppRes.logger.i("$i. Shart To'gri: ${products[i].toString()}");
            try {
              final imageName =
                  "${products[i].id ?? DateTime
                  .now()
                  .millisecondsSinceEpoch}.jpg";
              final String localImagePath = '${appDir.path}/$imageName';
              await Dio().download(products[i].pathOfPicture!, localImagePath);
              final response = await productRemoteDataSource.uploadImage(
                  imageName, localImagePath);
              if (response is NetworkState.Success) {
                productRemoteDataSource.updateProduct(
                    products[i].copyWith(pathOfPicture: response.value));
                double progress = (i + 1) / products.length * 100;
                AppRes.logger.f("Updating Progress: $progress");
              }
            } catch (e) {
              AppRes.logger.e(e);
            }
          } else {
            AppRes.logger.f("$i. Shart Noto'gri: ${products[i].toString()}");
            try {
              final imageName =
                  "${products[i].id ?? DateTime
                  .now()
                  .millisecondsSinceEpoch}.jpg";
              final String localImagePath = '${appDir.path}/$imageName';
              await Dio().download(Constants.noImage, localImagePath);
              final response = await productRemoteDataSource.uploadImage(
                  imageName, localImagePath);
              if (response is NetworkState.Success) {
                productRemoteDataSource.updateProduct(
                    products[i].copyWith(pathOfPicture: response.value));
                double progress = (i + 1) / products.length * 100;
                AppRes.logger.f("Updating Progress: $progress");
              }
            } catch (e) {
              AppRes.logger.e(e);
            }
          }
        }
      }
    }
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 2)); // Adjust delay as needed
    _checkSyncStatus();
  }

  Future<void> _checkSyncStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isSynced = prefs.getBool('isSynced') ?? false; // default: false
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

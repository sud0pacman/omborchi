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
    fetchDataAndSendOnline();
  }

  Future<String?> renameImageFile(String imageName) async {
    String originalPath = '/storage/emulated/0/Download/omborchi/$imageName';
    File imageFile = File(originalPath);

    if (await imageFile.exists()) {
      // Create the new file path by appending .jpg
      String newPath = '$originalPath.jpg';

      // Rename the file
      File renamedFile = await imageFile.rename(newPath);

      return renamedFile.path;
    } else {
      return null;
    }
  }

  Future<void> fetchDataAndSendOnline() async {
    final productRepository = TempProductRepository();
    final categoryRepository = TempCategoryRepository();
    final tannarxRepository = TempTannarxRepository();
    final typesRepository = TempTypesRepository();
    final xomashyoRepository = TempXomashyoRepository();

    final products = await productRepository.getAllProducts();
    final categories = await categoryRepository.getAllCategories();
    final tannarxList = await tannarxRepository.getAllTannarx();
    final types = await typesRepository.getAllTypes();
    final xomashyoList = await xomashyoRepository.getAllXomashyo();

    AppRes.logger.d(products.length);
    AppRes.logger.i(categories.length);
    AppRes.logger.f(tannarxList.length);
    AppRes.logger.t(types.length);
    AppRes.logger.w(xomashyoList.length);
    final ProductRepository repository =
        ProductRepositoryImpl(serviceLocator());
    // Ma'lum indeksdan boshlab mahsulotlarni qo'shish uchun
    int startIndex = 764;

    for (int i = startIndex; i < products.length; i++) {
      Product product = products[i];
      String imageName = product.pathOfPicture ?? ""; // The image file name

      // Define the directory where your image files are stored
      File imageFile = File('/storage/emulated/0/Download/omborchi/$imageName.jpg');

      if (await imageFile.exists()) {
        final response = await repository.uploadImage("$imageName.jpg", imageFile.path);
        if (response is NetworkState.Success) {
          final res = await repository.createProduct(
            product.toProductNetwork().toModel().copyWith(pathOfPicture: response.value),
          );
          if (res is NetworkState.Success) {
            final newProduct = await res.value as ProductModel;
            AppRes.logger.d("Successfully ${newProduct.pathOfPicture}");
          }
        } else {
          AppRes.logger.f("uploadImage Image error ${product.id}");
        }
      } else {
        AppRes.logger.d("Not Success ${product.pathOfPicture}");
        final res = await repository.createProduct(
          product.toProductNetwork().toModel().copyWith(
            pathOfPicture: "https://filestore.community.support.microsoft.com/api/images/989e4699-1106-453a-9e24-3ac6347b7ba2?upload=true",
          ),
        );
        if (res is NetworkState.Success) {
          final newProduct = await res.value as ProductModel;
          AppRes.logger.d("Successfully ${newProduct.pathOfPicture}");
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

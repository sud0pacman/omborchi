import 'dart:io';
import 'dart:typed_data';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:omborchi/core/network/network_state.dart';
import 'package:omborchi/core/utils/consants.dart';
import 'package:omborchi/feature/main/data/model/remote_model/cost_network.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:image/image.dart' as img;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:isar/isar.dart';
import 'package:omborchi/core/custom/functions/custom_functions.dart';
import 'package:omborchi/core/modules/isar_helper.dart';
import 'package:omborchi/core/network/network_state.dart';
import 'package:omborchi/feature/main/data/data_sources/remote_data_source/product_remote_data_source.dart';
import 'package:omborchi/feature/main/data/model/local_model/product_entity.dart';
import 'package:omborchi/feature/main/data/model/remote_model/cost_network.dart';
import 'package:omborchi/feature/main/data/model/remote_model/product_network.dart';
import 'package:omborchi/feature/main/domain/model/cost_model.dart';
import 'package:omborchi/feature/main/domain/model/product_model.dart';
import 'package:omborchi/feature/main/domain/repository/product_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/utils/consants.dart';
import '../../domain/model/category_model.dart';
import '../../domain/model/raw_material.dart';
import '../../domain/model/raw_material_type.dart';
import '../model/local_model/cost_entity.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource productRemoteDataSource;
  final IsarHelper isarHelper = IsarHelper();

  final InternetConnectionChecker networkChecker = InternetConnectionChecker();

  ProductRepositoryImpl(this.productRemoteDataSource);

  @override
  Future<State> createProduct(ProductModel product) async {
    try {
      final hasConnection = await networkChecker.hasConnection;
      if (hasConnection) {
        return productRemoteDataSource.createProduct(product.toNetwork());
      } else {
        await saveProductToLocal(product.toEntity());
        return NoInternet("Saved locally, will sync when online.");
      }
    } catch (e) {
      return GenericError(e);
    }
  }

  @override
  Future<State> addProductCost(List<CostModel> list) async {
    AppRes.logger.i(list.map((e) => e.toString()).join(', \n'));

    try {
      final hasConnection = await networkChecker.hasConnection;
      if (hasConnection) {
        for (var cost in list) {
          AppRes.logger.t(cost.toString());
          final result =
              await productRemoteDataSource.addProductCost(cost.toNetwork());

          if (result is GenericError) {
            AppRes.logger.e(result.value);
            return result;
          }
        }
        await isarHelper.insertAllCosts(list.map((e) => e.toEntity()).toList());
        return Success("Success added!");
      } else {
        return NoInternet("No Internet");
      }
    } catch (e) {
      return GenericError(e);
    }
  }

  @override
  Future<State> deleteProduct(ProductModel product) async {
    try {
      final hasConnection = await networkChecker.hasConnection;
      if (hasConnection) {
        final res =
            await productRemoteDataSource.addDeletedProduct(product.id!);
        AppRes.logger.i(res.runtimeType.toString());
        if (res is Success) {
          AppRes.logger.w("Muvaffaqiyatli o'chirilgani qo'shilibdi");
          await isarHelper.deleteProduct(product.id ?? 0);
          return productRemoteDataSource.deleteProduct(product.toNetwork());
        } else {
          return res;
        }
      } else {
        return NoInternet("Internetga ulanmagansiz!");
      }
    } catch (e) {
      return GenericError(e);
    }
  }

  @override
  Future<State> addDeletedProduct(int productId) async {
    try {
      final hasConnection = await networkChecker.hasConnection;
      if (hasConnection) {
        return productRemoteDataSource.addDeletedProduct(productId);
      } else {
        return NoInternet("Internetga ulanmagansiz!");
      }
    } catch (e) {
      return GenericError(e);
    }
  }

  @override
  Future<State> deleteCosts(int id) async {
    try {
      final hasConnection = await networkChecker.hasConnection;
      if (hasConnection) {
        await productRemoteDataSource.deleteCost(id);
        await isarHelper.deleteAllCostsById(id);
        return Success("O'chirish muvaffaqiyatli");
      } else {
        return NoInternet("Internetga ulanmagansiz!");
      }
    } catch (e) {
      return GenericError(e);
    }
  }

  @override
  Future<State> getProducts(int categoryId) async {
    try {
      final hasConnection = await networkChecker.hasConnection;
      if (hasConnection) {
        return productRemoteDataSource.getProductsByCategoryId(categoryId);
      } else {
        final localProducts = await fetchAllProductsFromLocal();
        return Success(localProducts.map((p) => p.toModel()).toList());
      }
    } catch (e) {
      return GenericError(e);
    }
  }

  @override
  Future<State> syncProducts(Function(double) onProgress,
      {int startIndex = 0}) async {
    if (!await networkChecker.hasConnection) {
      AppRes.logger.w("Internet aloqasi mavjud emas");
      return NoInternet("Internet aloqasi yo'q");
    }

    try {
      AppRes.logger.i(
          "Mahsulotlarni sinxronlash boshlandi, boshlang'ich indeks: $startIndex...");
      final [networkRes, fetchDeletedRes] = await Future.wait([
        productRemoteDataSource.getProducts(),
        productRemoteDataSource.getAllDeletedProductIds(),
      ]);

      if (networkRes is! Success) {
        AppRes.logger
            .e("Mahsulotlarni olishda xatolik: ${networkRes.toString()}");
        return networkRes;
      }
      if (fetchDeletedRes is! Success) {
        AppRes.logger.e(
            "O'chirilgan mahsulot ID'larini olishda xatolik: ${fetchDeletedRes.toString()}");
        return GenericError("O'chirilgan mahsulotlarni olishda xatolik");
      }

      final List<ProductNetwork> products = networkRes.value;
      final deletedList = fetchDeletedRes.value as List<int>;
      AppRes.logger.i(
          "${products.length} ta mahsulot va ${deletedList.length} ta o'chirilgan ID olindi");

      if (deletedList.isNotEmpty) {
        await isarHelper.deleteAllProducts(deletedList);
        AppRes.logger
            .i("${deletedList.length} ta mahsulot mahalliy bazadan o'chirildi");
      }

      final appDir = await getApplicationDocumentsDirectory();
      int lastSyncedIndex = startIndex;

      for (int i = startIndex; i < products.length; i++) {
        final remoteProduct = products[i];
        final localProduct =
            await isarHelper.getProductById(remoteProduct.id ?? 0);

        if (localProduct != null &&
            remoteProduct.updatedAt?.toLocal().toIso8601String() ==
                localProduct.updatedAt?.toLocal().toIso8601String()) {
          AppRes.logger
              .w("Index $i: ${remoteProduct.id} ID'li mahsulot o'zgarmagan");
          _updateProgress(onProgress, i + 1, products.length);
          continue;
        }

        try {
          final updatedProduct = await _downloadAndUpdateProduct(
            remoteProduct,
            localProduct,
            appDir.path,
            i,
          );
          await isarHelper.addProduct(updatedProduct.toEntity());
          AppRes.logger.i(
              "${updatedProduct.id} ID'li mahsulot mahalliy bazaga yangilandi");
          lastSyncedIndex = i + 1;
        } catch (e) {
          AppRes.logger.e(
            "Index $i: Mahsulotni yangilashda xatolik: $e",
          );
          return GenericError(
              "Index $i: Mahsulotni yangilashda xatolik: $e, oxirgi muvaffaqiyatli indeks: $lastSyncedIndex");
        }

        _updateProgress(onProgress, i + 1, products.length);
      }

      final allProducts = await isarHelper.getAllProducts();
      AppRes.logger.i(
          "Sinxlash muvaffaqiyatli yakunlandi, jami: ${allProducts.length} ta mahsulot");
      return Success(allProducts);
    } catch (e) {
      AppRes.logger.e("Sinxlashda umumiy xatolik: $e");
      return GenericError("Sinxlashda xatolik yuz berdi: $e");
    }
  }

  Future<ProductNetwork> _downloadAndUpdateProduct(
    ProductNetwork remoteProduct,
    ProductEntity? localProduct,
    String appDirPath,
    int index,
  ) async {
    final imageName =
        "${DateTime.now().millisecondsSinceEpoch}_${remoteProduct.id}.jpg";
    final localImagePath = '$appDirPath/$imageName';

    final hasValidImage = remoteProduct.pathOfPicture != null &&
        !remoteProduct.pathOfPicture!.startsWith("/data") &&
        remoteProduct.pathOfPicture!.isNotEmpty &&
        remoteProduct.pathOfPicture!.startsWith("https");

    final imageUrl =
        hasValidImage ? remoteProduct.pathOfPicture! : Constants.noImage;

    AppRes.logger.i(
        "Index $index: ${remoteProduct.id} ID'li mahsulot uchun rasm yuklanmoqda: $imageUrl");

    const maxRetries = 3;
    int attempt = 0;

    while (attempt < maxRetries) {
      try {
        final dio = Dio();
        final response = await dio.get<List<int>>(
          imageUrl,
          options: Options(responseType: ResponseType.bytes),
        );

        final originalBytes = Uint8List.fromList(response.data!);
        final image = img.decodeImage(originalBytes);
        if (image == null) throw Exception("Rasmni dekodlashda xatolik");

        final resizedImage = img.copyResize(image, width: 400);
        final resizedBytes = img.encodeJpg(resizedImage, quality: 90);

        final file = File(localImagePath);
        await file.writeAsBytes(resizedBytes);

        AppRes.logger.i(
            "Index $index: ${remoteProduct.id} ID'li mahsulot rasmi kichik holatda saqlandi: $localImagePath");

        return remoteProduct.copyWith(
          pathOfPicture: localImagePath,
          id: remoteProduct.id,
        );
      } catch (e) {
        attempt++;
        AppRes.logger.w(
          "Index $index: ${remoteProduct.id} ID'li mahsulot rasmini yuklashda xatolik. "
          "Urinish $attempt/$maxRetries, Rasm URL: $imageUrl, Xatolik: $e",
        );

        if (attempt >= maxRetries) {
          AppRes.logger.e(
            "Index $index: ${remoteProduct.id} ID'li mahsulot rasmini yuklashda maksimal urinishlar soni oshdi. "
            "Rasm URL: $imageUrl, Oxirgi xatolik: $e",
          );
          return remoteProduct.copyWith(
            pathOfPicture: null,
            id: remoteProduct.id,
          );
        }

        await Future.delayed(const Duration(seconds: 3));
      }
    }

    AppRes.logger.e(
      "Index $index: ${remoteProduct.id} ID'li mahsulot rasmini yuklashda kutilmagan holat. Rasm URL: $imageUrl",
    );
    return remoteProduct.copyWith(
      pathOfPicture: null,
      id: remoteProduct.id,
    );
  }

  void _updateProgress(Function(double) onProgress, int current, int total) {
    final progress = (current / total) * 100;
    AppRes.logger.t("Sinxlash jarayoni: ${progress.toStringAsFixed(1)}%");
    onProgress(progress);
  }

  @override
  Future<State> syncCosts(Function(double) onProgress) async {
    final bool hasNetwork = await networkChecker.hasConnection;
    if (hasNetwork) {
      final networkRes = await productRemoteDataSource.getCosts();
      if (networkRes is Success) {
        final List<CostNetwork> costs = networkRes.value;
        final List<CostEntity> costEntities =
            costs.map((e) => e.toEntity()).toList();
        await isarHelper.clearCosts();
        for (int i = 0; i < costEntities.length; i++) {
          await isarHelper.addCost(costEntities[i]);
          double progress = (i + 1) / costEntities.length * 100;
          onProgress(progress);
        }
        return Success(await isarHelper.getAllCosts());
      } else {
        return networkRes;
      }
    } else {
      return NoInternet(Constants.noNetwork);
    }
  }

  @override
  Future<State> updateProduct(ProductModel product) async {
    try {
      final hasConnection = await networkChecker.hasConnection;
      if (hasConnection) {
        return productRemoteDataSource.updateProduct(product.toNetwork());
      } else {
        return Success("Updated locally, will sync when online.");
      }
    } catch (e) {
      return GenericError(e);
    }
  }
  @override
  Future<State> uploadImage(String imageName, String image) async {
    try {
      final file = File(image);
      final fileBytes = await file.readAsBytes();

      // Cloudflare R2 configuration
      const String accountId = '04455701552c024s7485876e73f6cbfe1';
      const String accessKeyId = '248522beb13a04b75cf5a97c54d14456';
      const String secretAccessKey = '146bd52bd48a305fae851b27fdefec7e3520fc45359de70c419ac81a8e3aeead';
      const String bucketName = 'omborchi';
      const String region = 'auto';
      const String endpoint = 'https://$accountId.r2.cloudflarestorage.com';
      const String publicUrl = 'https://pub-ac2058e7c6384a688264ad7c4669cc88.r2.dev';

      // Remove special characters from image name for better compatibility
      final cleanImageName = imageName.replaceAll(RegExp(r'[^\w\.-]'), '_');
      String path = 'images/$cleanImageName';

      // Date and time for AWS signature
      final now = DateTime.now().toUtc();
      final dateStamp = _formatDate(now);
      final amzDate = _formatDateTime(now);

      // Content type detection
      String contentType = 'image/jpeg';
      if (cleanImageName.toLowerCase().endsWith('.png')) {
        contentType = 'image/png';
      } else if (cleanImageName.toLowerCase().endsWith('.jpg') || cleanImageName.toLowerCase().endsWith('.jpeg')) {
        contentType = 'image/jpeg';
      } else if (cleanImageName.toLowerCase().endsWith('.gif')) {
        contentType = 'image/gif';
      } else if (cleanImageName.toLowerCase().endsWith('.webp')) {
        contentType = 'image/webp';
      }

      // Create canonical request
      final payloadHash = sha256.convert(fileBytes).toString();

      final canonicalUri = '/$bucketName/$path';
      final canonicalQueryString = '';
      final canonicalHeaders = 'host:$accountId.r2.cloudflarestorage.com\n'
          'x-amz-content-sha256:$payloadHash\n'
          'x-amz-date:$amzDate\n';

      final signedHeaders = 'host;x-amz-content-sha256;x-amz-date';

      final canonicalRequest = 'PUT\n'
          '$canonicalUri\n'
          '$canonicalQueryString\n'
          '$canonicalHeaders\n'
          '$signedHeaders\n'
          '$payloadHash';

      // Create string to sign
      final algorithm = 'AWS4-HMAC-SHA256';
      final credentialScope = '$dateStamp/$region/s3/aws4_request';
      final canonicalRequestHash = sha256.convert(utf8.encode(canonicalRequest)).toString();

      final stringToSign = '$algorithm\n'
          '$amzDate\n'
          '$credentialScope\n'
          '$canonicalRequestHash';

      // Calculate signature
      final signature = _calculateSignature(secretAccessKey, dateStamp, region, stringToSign);

      // Create authorization header
      final authorization = '$algorithm Credential=$accessKeyId/$credentialScope, '
          'SignedHeaders=$signedHeaders, Signature=$signature';

      // Upload to R2
      final uploadUrl = '$endpoint/$bucketName/$path';
      final response = await http.put(
        Uri.parse(uploadUrl),
        headers: {
          'Host': '$accountId.r2.cloudflarestorage.com',
          'x-amz-content-sha256': payloadHash,
          'x-amz-date': amzDate,
          'Authorization': authorization,
          'Content-Type': contentType,
        },
        body: fileBytes,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        final String downloadUrl = '$publicUrl/$path';
        return Success(downloadUrl);
      } else {
        AppRes.logger.e('Upload failed: ${response.statusCode} - ${response.body}');
        return GenericError(Exception('Upload failed: ${response.statusCode}'));
      }

    } on SocketException catch (e) {
      AppRes.logger.e(e);
      return NoInternet(Exception("No Internet"));
    } on TimeoutException catch (e) {
      AppRes.logger.e(e);
      return NoInternet(Exception("No Internet"));
    } catch (e) {
      AppRes.logger.e(e);
      return GenericError(e);
    }
  }

    String _formatDate(DateTime date) {
    return '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}';
    }

    String _formatDateTime(DateTime date) {
    return '${_formatDate(date)}T'
    '${date.hour.toString().padLeft(2, '0')}'
    '${date.minute.toString().padLeft(2, '0')}'
    '${date.second.toString().padLeft(2, '0')}Z';
    }

    String _calculateSignature(String secretKey, String dateStamp, String region, String stringToSign) {
    final kDate = _hmacSha256(utf8.encode('AWS4$secretKey'), utf8.encode(dateStamp));
    final kRegion = _hmacSha256(kDate, utf8.encode(region));
    final kService = _hmacSha256(kRegion, utf8.encode('s3'));
    final kSigning = _hmacSha256(kService, utf8.encode('aws4_request'));
    final signature = _hmacSha256(kSigning, utf8.encode(stringToSign));

    return signature.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
    }

    List<int> _hmacSha256(List<int> key, List<int> data) {
    final hmac = Hmac(sha256, key);
    return hmac.convert(data).bytes;
    }
  // @override
  // Future<State> uploadImage(String imageName, String image) async {
  //   try {
  //     return productRemoteDataSource.uploadImage(imageName, image);
  //   } catch (e) {
  //     return GenericError(e);
  //   }
  // }

  @override
  Future<State> downloadImage(
      {required String path, required String name}) async {
    try {
      return productRemoteDataSource.downloadImage(path: path, name: name);
    } catch (e) {
      return GenericError(e);
    }
  }

  @override
  Future<void> saveProductToLocal(ProductEntity product) async {
    await isarHelper.addProduct(product);
  }

  @override
  Future<List<ProductModel?>> fetchProductFromLocalById(
      int id, int categoryId) async {
    var res = await isarHelper.getProduct(id, categoryId);
    return res.map((product) => product?.toModel()).toList();
  }

  @override
  Future<List<ProductModel?>> fetchProductFromLocalByCategoryId(
      int categoryId) async {
    final products = await isarHelper.getAllProductByCategoryId(categoryId);

    return products.map((product) => product.toModel()).toList();
  }

  @override
  Future<List<ProductModel>> fetchAllProductsFromLocal() async {
    final products = await isarHelper.getAllProducts();
    final productModels =
        products.map((productEntity) => productEntity.toModel()).toList();

    return productModels;
  }

  @override
  Future<List<CostModel>> fetchAllCostsFromLocal() async {
    final products = await isarHelper.getAllCosts();
    final productModels =
        products.map((productEntity) => productEntity.toModel()).toList();

    return productModels;
  }

  @override
  Future<List<ProductModel?>> fetchProductFromLocalByQuery(
    String nomer,
    String eni,
    String boyi,
    String narxi,
    String marja,
    int categoryId,
  ) async {
    final isar = await isarHelper.db;

    final List<int> nomerRange = _parseRange(nomer);
    final List<int> eniRange = _parseRange(eni);
    final List<int> boyiRange = _parseRange(boyi);
    final List<int> sotuvRange = _parseRange(narxi);
    final List<int> foydaRange = _parseRange(marja);

    final query = categoryId == 0
        ? isar.productEntitys
            .filter()
            .nomerBetween(nomerRange[0], nomerRange[1])
            .eniBetween(eniRange[0], eniRange[1])
            .boyiBetween(boyiRange[0], boyiRange[1])
            .sotuvBetween(sotuvRange[0], sotuvRange[1])
            .foydaBetween(foydaRange[0], foydaRange[1])
        : isar.productEntitys
            .filter()
            .categoryIdEqualTo(categoryId)
            .nomerBetween(nomerRange[0], nomerRange[1])
            .eniBetween(eniRange[0], eniRange[1])
            .boyiBetween(boyiRange[0], boyiRange[1])
            .sotuvBetween(sotuvRange[0], sotuvRange[1])
            .foydaBetween(foydaRange[0], foydaRange[1]);
    AppRes.logger.w("${nomerRange[0]} || ${nomerRange[1]}");
    AppRes.logger.w("${eniRange[0]} || ${eniRange[1]}");
    AppRes.logger.w("${boyiRange[0]} || ${boyiRange[1]}");
    AppRes.logger.w("${sotuvRange[0]} || ${sotuvRange[1]}");
    AppRes.logger.w("${sotuvRange[0]} || ${sotuvRange[1]}");

    final products = await query.findAll();

    return products.map((productEntity) => productEntity.toModel()).toList();
  }

  List<int> _parseRange(String value) {
    if (value.isEmpty) {
      return [0, 999999];
    }

    int maxInt = (1 << 63) - 1;

    final parts = value.split(' ');
    final lower = parts[0].toIntOrZero();
    final upper = (parts.length > 1) ? parts[1].toIntOrZero() : lower;
    return [lower, upper == 0 ? maxInt : upper];
  }

  @override
  Future<void> updateLocalProduct(ProductEntity product) async {
    await isarHelper.updateProduct(product);
  }

  @override
  Future<void> removeProductFromLocal(int id) async {
    await isarHelper.deleteProduct(id);
  }

  @override
  Future<ProductModel?> getProductById(int id) async {
    var res = await isarHelper.getProductById(id);
    return res?.toModel();
  }

  @override
  Future<void> removeProductsFromLocal(List<int> ids) async {
    await isarHelper.deleteProductsByIds(ids);
  }

  @override
  Future<State> getCategories() async {
    return Success(await _getCategoriesFromLocal());
  }

  @override
  Future<State> getRawMaterialsWithTypes() async {
    final List<RawMaterialType> types = await _getTypesFromLocal();
    final Map<RawMaterialType, List<RawMaterial>> rawMaterials = {};

    for (var rawMaterialType in types) {
      rawMaterials[rawMaterialType] =
          await _getRawMaterialsFromLocalByTypeId(rawMaterialType.id!);
    }

    return Success(rawMaterials);
  }

  Future<List<RawMaterial>> _getRawMaterialsFromLocalByTypeId(int id) async {
    final lastUpdate = DateTime.parse(
        await Hive.box(ExpenseFields.myBox).get(LastUpdates.type) ??
            DateTime.now().toLocal().toIso8601String());

    final List<RawMaterial> rawMaterials =
        await isarHelper.getRawMaterialsByTypeId(id).then((onValue) {
      return onValue.map((e) => e.toModel(DateTime(2024, 8, 19))).toList();
    });

    return rawMaterials;
  }

  Future<List<RawMaterialType>> _getTypesFromLocal() async {
    final isarRes = await isarHelper.getAllTypes();
    final lastUpdate = DateTime.parse(
        await Hive.box(ExpenseFields.myBox).get(LastUpdates.type) ??
            DateTime.now().toLocal().toIso8601String());

    return isarRes.map((e) {
      return e.toModel(DateTime(2024, 8, 19));
    }).toList();
  }

  Future<List<CategoryModel>> _getCategoriesFromLocal() async {
    final isarRes = await isarHelper.getAllCategories();

    return isarRes.map((e) {
      return e.toModel(DateTime.now());
    }).toList();
  }

  @override
  Future<void> saveCostToLocal(CostEntity cost) async {
    await isarHelper.addCost(cost);
  }

  @override
  Future<void> saveCostListToLocal(List<CostModel> cost) async {
    await isarHelper.insertAllCosts(cost.map((e) => e.toEntity()).toList());
  }

  @override
  Future<void> updateLocalCost(CostEntity cost) async {
    await isarHelper.updateCost(cost);
  }

  @override
  Future<void> deleteLocalCost(int costId) async {
    await isarHelper.deleteCost(costId);
  }

  @override
  Future<List<CostEntity>> getCostListById(int productId) async {
    return await isarHelper.getCost(productId);
  }

  @override
  Future<State> getProductByIdRemote(int id) async {
    var res = await productRemoteDataSource.getProductById(id);
    return res;
  }
}

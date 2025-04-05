import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
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
  Future<State> syncProducts(Function(double) onProgress) async {
    if (!await networkChecker.hasConnection) {
      AppRes.logger.w("Internet aloqasi mavjud emas");
      return NoInternet("Internet aloqasi yo'q");
    }

    try {
      final [networkRes, fetchDeletedRes] = await Future.wait([
        productRemoteDataSource.getProducts(),
        productRemoteDataSource.getAllDeletedProductIds()
      ]);

      if (networkRes is! Success) {
        AppRes.logger.e("Mahsulotlarni tarmoqdan olishda xatolik");
        return networkRes;
      }
      if (fetchDeletedRes is! Success) {
        AppRes.logger.e("O'chirilgan mahsulot ID'larini olishda xatolik");
        return GenericError("O'chirilgan mahsulotlarni olishda xatolik");
      }

      final List<ProductNetwork> products = networkRes.value;
      final deletedList = fetchDeletedRes.value as List<int>;
      AppRes.logger.i(
          "${products.length} ta mahsulot va ${deletedList.length} ta o'chirilgan ID olindi");

      if (deletedList.isNotEmpty) {
        await isarHelper.deleteAllProducts(deletedList);
        AppRes.logger.i("${deletedList.length} ta mahsulot o'chirildi");
      }

      final appDir = await getApplicationDocumentsDirectory();
      final batchSize = 10;

      for (int i = 0; i < products.length; i += batchSize) {
        if (!await networkChecker.hasConnection) {
          AppRes.logger.w("${i ~/ batchSize}-guruhda internet uzildi");
          return NoInternet("Sinxlash jarayonida internet uzildi");
        }

        final batch = products.sublist(
          i,
          i + batchSize > products.length ? products.length : i + batchSize,
        );

        final localProducts = await Future.wait(
          batch.map((p) => isarHelper.getProductById(p.id ?? 0)),
        );

        final productsToUpdate = <ProductNetwork>[];
        final updateFutures = <Future<ProductNetwork>>[];

        for (int j = 0; j < batch.length; j++) {
          final remoteProduct = batch[j];
          final localProduct = localProducts[j];

          if (localProduct != null &&
              remoteProduct.updatedAt?.toLocal().toIso8601String() ==
                  localProduct.updatedAt?.toLocal().toIso8601String()) {
            AppRes.logger.w("${remoteProduct.id} ID'li mahsulot o'zgarmagan");
            continue;
          }

          productsToUpdate.add(remoteProduct);
          updateFutures.add(_downloadAndUpdateProduct(
            remoteProduct,
            localProduct,
            appDir.path,
          ));
        }

        if (updateFutures.isNotEmpty) {
          final updatedProducts = await Future.wait(updateFutures);
          for (final product in updatedProducts) {
            await isarHelper.addProduct(product.toEntity());
            AppRes.logger.i("${product.id} ID'li mahsulot yangilandi");
          }
        }

        _updateProgress(onProgress, i + batch.length, products.length);
      }

      final allProducts = await isarHelper.getAllProducts();
      AppRes.logger.i("Sinxlash muvaffaqiyatli yakunlandi");
      return Success(allProducts);
    } catch (e, stackTrace) {
      AppRes.logger.e("Sinxlashda xatolik: $e");
      return GenericError("Sinxlashda xatolik yuz berdi: ${e.toString()}");
    }
  }

  Future<ProductNetwork> _downloadAndUpdateProduct(
    ProductNetwork remoteProduct,
    ProductEntity? localProduct,
    String appDirPath,
  ) async {
    final imageName = "${DateTime.now().millisecondsSinceEpoch}.jpg";
    final localImagePath = '$appDirPath/$imageName';

    final hasValidImage = remoteProduct.pathOfPicture != null &&
        !remoteProduct.pathOfPicture!.startsWith("/data") &&
        remoteProduct.pathOfPicture!.isNotEmpty;

    final imageUrl =
        hasValidImage ? remoteProduct.pathOfPicture! : Constants.noImage;

    AppRes.logger.t(
        "${remoteProduct.id} ID'li mahsulot uchun rasm yuklanmoqda: $imageUrl");
    await Dio().download(imageUrl, localImagePath);

    return remoteProduct.copyWith(
      pathOfPicture: localImagePath,
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
      return productRemoteDataSource.uploadImage(imageName, image);
    } catch (e) {
      return GenericError(e);
    }
  }

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

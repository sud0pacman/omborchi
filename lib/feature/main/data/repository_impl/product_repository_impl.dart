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
        await saveProductToLocal(product.toEntity()); // Save to Hive locally
        return NoInternet("Saved locally, will sync when online.");
      }
    } catch (e) {
      return GenericError(e);
    }
  }

  @override
  Future<State> addProductCost(List<CostModel> list) async {
    try {
      final hasConnection = await networkChecker.hasConnection;
      if (hasConnection) {
        for (var cost in list) {
          final result =
              await productRemoteDataSource.addProductCost(cost.toNetwork());

          if (result is Error) {
            return result; // Stop and return if there's an error
          }
        }
        await isarHelper.insertAllCosts(list
            .map((e) => e.toEntity())
            .toList()); // Save cost using IsarHelper
        return Success(
            "Success added!"); // Return success if all inserts were successful
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
        await isarHelper.deleteProduct(product.id ?? 0);
        return productRemoteDataSource.deleteProduct(product.toNetwork());
      } else {
        return NoInternet("Internetga ulanmagansiz!");
      }
    } catch (e) {
      return GenericError(e);
    }
  }

  @override
  Future<State> deleteCosts(List<int> deleteCostsIds) async {
    try {
      final hasConnection = await networkChecker.hasConnection;
      if (hasConnection) {
        for (int costId in deleteCostsIds) {
          await productRemoteDataSource.deleteCost(costId);
        }
        await isarHelper.deleteAllCosts(deleteCostsIds);
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
        return Success(localProducts
            .map((p) => p.toModel())
            .toList()); // Convert local entities back to ProductModel
      }
    } catch (e) {
      return GenericError(e);
    }
  }

  @override
  Future<State> syncProducts(Function(double) onProgress) async {
    final bool hasNetwork = await networkChecker.hasConnection;
    if (hasNetwork) {
      final networkRes = await productRemoteDataSource.getProducts();
      if (networkRes is Success) {
        final List<ProductNetwork> products = networkRes.value;
        final appDir = await getApplicationDocumentsDirectory();
        await isarHelper.clearProducts();

        for (int i = 0; i < products.length; i++) {
          if (products[i].pathOfPicture != null &&
              products[i].pathOfPicture!.isNotEmpty) {
            try {
              final imageName = "${DateTime.now().millisecondsSinceEpoch}.jpg";
              final String localImagePath = '${appDir.path}/$imageName';
              await Dio().download(products[i].pathOfPicture!, localImagePath);
              final data = products[i]
                  .copyWith(pathOfPicture: localImagePath, id: products[i].id);
              await isarHelper.addProduct(data.toEntity());
              double progress = (i + 1) / products.length * 100;
              onProgress(progress); // Update progress
            } catch (e) {
              return GenericError("Qandaydir xatolik");
            }
          } else {
            final imageName = "${DateTime.now().millisecondsSinceEpoch}.jpg";
            final String localImagePath = '${appDir.path}/$imageName';
            await Dio().download(Constants.noImage, localImagePath);
            final data = products[i]
                .copyWith(pathOfPicture: localImagePath, id: products[i].id);
            await isarHelper.addProduct(data.toEntity());
            double progress = (i + 1) / products.length * 100;
            onProgress(progress); // Update progress
          }
        }
        return Success(await isarHelper.getAllProducts());
      } else {
        return networkRes;
      }
    } else {
      return NoInternet(Constants.noNetwork);
    }
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
          onProgress(progress); // Update progress
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

  // Method to save a product to Isar local storage
  @override
  Future<void> saveProductToLocal(ProductEntity product) async {
    await isarHelper.addProduct(product); // Save product using IsarHelper
  }

// Method to fetch a single product from Isar by ID
  @override
  Future<List<ProductModel?>> fetchProductFromLocalById(
      int id, int categoryId) async {
    var res = await isarHelper.getProduct(id, categoryId);
    return res
        .map((product) => product?.toModel())
        .toList(); // Get product by its ID using IsarHelper
  }

// Method to fetch products by productId from Isar
  @override
  Future<List<ProductModel?>> fetchProductFromLocalByCategoryId(
      int categoryId) async {
    final products = await isarHelper.getAllProductByCategoryId(categoryId);

    return products.map((product) => product.toModel()).toList();
  }

// Method to fetch all products from Isar
  @override
  Future<List<ProductModel>> fetchAllProductsFromLocal() async {
    final products =
        await isarHelper.getAllProducts(); // This returns List<ProductEntity>
    final productModels =
        products.map((productEntity) => productEntity.toModel()).toList();

    return productModels; // Return List<ProductModel>
  }

  @override
  Future<List<CostModel>> fetchAllCostsFromLocal() async {
    final products =
        await isarHelper.getAllCosts(); // This returns List<ProductEntity>
    final productModels =
        products.map((productEntity) => productEntity.toModel()).toList();

    return productModels; // Return List<ProductModel>
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

    // Parsing the strings into int ranges or setting default bounds if empty
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

// Helper method to parse the range from a string
  List<int> _parseRange(String value) {
    if (value.isEmpty) {
      // If value is empty, we set a wide default range
      return [0, 999999];
    }

    // Splitting the string by space and parsing the range values
    int maxInt = (1 << 63) - 1; // For 64-bit platforms

    final parts = value.split(' ');
    final lower = parts[0].toIntOrZero();
    final upper = (parts.length > 1)
        ? parts[1].toIntOrZero()
        : lower; // If only one number, treat it as both lower and upper bound
    return [lower, upper == 0 ? maxInt : upper];
  }

// Method to update a product in Isar
  @override
  Future<void> updateLocalProduct(ProductEntity product) async {
    await isarHelper.updateProduct(product);
  }

// Method to remove a product from Isar by its ID
  @override
  Future<void> removeProductFromLocal(int id) async {
    await isarHelper.deleteProduct(id); // Delete product by its ID in Isar
  }
  @override
  Future<ProductModel?> getProductById(int id) async {
    var res = await isarHelper.getProductById(id);
    return res?.toModel();
  }

// Method to remove multiple products by their IDs in Isar
  @override
  Future<void> removeProductsFromLocal(List<int> ids) async {
    await isarHelper
        .deleteProductsByIds(ids); // Delete products by IDs using IsarHelper
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

  // Local CRUD for costs
  @override
  Future<void> saveCostToLocal(CostEntity cost) async {
    await isarHelper.addCost(cost); // Save cost using IsarHelper
  }

  // Local CRUD for costs
  @override
  Future<void> saveCostListToLocal(List<CostModel> cost) async {
    await isarHelper.insertAllCosts(
        cost.map((e) => e.toEntity()).toList()); // Save cost using IsarHelper
  }

  @override
  Future<void> updateLocalCost(CostEntity cost) async {
    await isarHelper.updateCost(cost); // Update cost in Isar
  }

  @override
  Future<void> deleteLocalCost(int costId) async {
    await isarHelper.deleteCost(costId); // Delete cost from Isar
  }

  @override
  Future<List<CostEntity>> getCostListById(int productId) async {
    return await isarHelper.getCost(productId); // Get cost by ID from Isar
  }
}

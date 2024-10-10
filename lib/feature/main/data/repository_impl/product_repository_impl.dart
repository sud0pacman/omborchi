import 'package:hive/hive.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:isar/isar.dart';
import 'package:omborchi/core/modules/isar_helper.dart';
import 'package:omborchi/core/network/network_state.dart';
import 'package:omborchi/feature/main/data/data_sources/remote_data_source/product_remote_data_source.dart';
import 'package:omborchi/feature/main/data/model/local_model/product_entity.dart';
import 'package:omborchi/feature/main/data/model/remote_model/product_network.dart';
import 'package:omborchi/feature/main/domain/model/cost_model.dart';
import 'package:omborchi/feature/main/domain/model/product_model.dart';
import 'package:omborchi/feature/main/domain/repository/product_repository.dart';

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
        return productRemoteDataSource.deleteProduct(product.toNetwork());
      } else {
        await removeProductFromLocal(product.id!); // Remove from Hive locally
        return Success("Deleted locally, will sync when online.");
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
  Future<State> syncProducts() async {
    try {
      final hasConnection = await networkChecker.hasConnection;
      if (hasConnection) {
        final response = await productRemoteDataSource.getProducts();
        final localProducts = await fetchAllProductsFromLocal();

        if (response is Success) {
          final List<int> productIdList =
              localProducts.map((e) => e.id!).toList();

          final List<ProductNetwork> products = response.value;
          final List<ProductEntity> productsEntity =
              products.map((e) => e.toEntity()).toList();
          await isarHelper.deleteAllProducts(productIdList);
          await isarHelper.insertAllProducts(productsEntity);
          final local = await fetchAllProductsFromLocal();
          return Success(local);
        } else {
          return GenericError("Nimadir xato ketti");
        }
      } else {
        return NoInternet("Iltimos internetingizni tekshiring");
      }
    } catch (e) {
      return GenericError(e);
    }
  }

  @override
  Future<State> updateProduct(ProductModel product) async {
    try {
      final hasConnection = await networkChecker.hasConnection;
      if (hasConnection) {
        return productRemoteDataSource.updateProduct(product.toNetwork());
      } else {
        await updateLocalProduct(product.toEntity()); // Update in Hive locally
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
  Future<List<ProductModel?>> fetchProductFromLocalById(int id) async {
    var res = await isarHelper.getProduct(id);
    return res
        .map((product) => product?.toModel())
        .toList(); // Get product by its ID using IsarHelper
  }

// Method to fetch products by productId from Isar
  @override
  Future<List<ProductModel?>> fetchProductFromLocalByCategoryId(
      int categoryId) async {
    final isar = await isarHelper.db;
    final products = await isar.productEntitys
        .filter()
        .categoryIdEqualTo(categoryId)
        .findAll(); // Filter products by categoryId in Isar

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
  Future<List<ProductModel?>> fetchProductFromLocalByQuery(
      String nomer,
      String eni,
      String boyi,
      String narxi,
      String marja,
      int categoryId) async {
    final isar = await isarHelper.db;

    final query = isar.productEntitys.filter().categoryIdEqualTo(categoryId);

    // Helper function to extract lower and upper bo unds
    void applyBetweenFilter(
        String? value, Function(int lower, int upper) applyFilter) {
      if (value != null && value.isNotEmpty) {
        final parts = value.split(' ');
        if (parts.length == 2) {
          final lower = parts[0];
          final upper = parts[1];
          applyFilter(lower as int, upper as int);
        }
      }
    }

    // Apply filters conditionally based on whether values are provided
    applyBetweenFilter(nomer, query.nomerBetween);
    // applyBetweenFilter(eni, query.eniBetween);
    // applyBetweenFilter(boyi, query.boyiBetween);
    // applyBetweenFilter(narxi, query.narxiBetween);
    // applyBetweenFilter(marja, query.marjaBetween);

    // Execute query and map result
    final products = await query.findAll();

    return products.map((productEntity) => productEntity?.toModel()).toList();
  }

// Method to update a product in Isar
  @override
  Future<void> updateLocalProduct(ProductEntity product) async {
    await isarHelper
        .updateProduct(product); // Update product in Isar using IsarHelper
  }

// Method to remove a product from Isar by its ID
  @override
  Future<void> removeProductFromLocal(int id) async {
    await isarHelper.deleteProduct(id); // Delete product by its ID in Isar
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
      return onValue.map((e) => e.toModel(lastUpdate)).toList();
    });

    return rawMaterials;
  }

  Future<List<RawMaterialType>> _getTypesFromLocal() async {
    final isarRes = await isarHelper.getAllTypes();
    final lastUpdate = DateTime.parse(
        await Hive.box(ExpenseFields.myBox).get(LastUpdates.type) ??
            DateTime.now().toLocal().toIso8601String());

    return isarRes.map((e) {
      return e.toModel(lastUpdate);
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
  Future<CostEntity?> getLocalCostById(int costId) async {
    return await isarHelper.getCost(costId); // Get cost by ID from Isar
  }
}

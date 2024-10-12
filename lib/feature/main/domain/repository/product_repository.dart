import 'package:omborchi/feature/main/data/model/local_model/product_entity.dart';
import 'package:omborchi/feature/main/domain/model/cost_model.dart';
import 'package:omborchi/feature/main/domain/model/product_model.dart';

import '../../../../core/network/network_state.dart';
import '../../data/model/local_model/cost_entity.dart';

abstract interface class ProductRepository {
  Future<State> getProducts(int categoryId);
  Future<State> syncProducts(Function(double) onProgress);
  Future<State> syncCosts(Function(double) onProgress);

  Future<State> createProduct(ProductModel product);

  Future<State> addProductCost(List<CostModel> list);

  Future<State> updateProduct(ProductModel product);

  Future<State> deleteProduct(ProductModel product);

  Future<State> uploadImage(String imageName, String image);

  Future<State> downloadImage({required String path, required String name});

  Future<State> getCategories();

  Future<State> getRawMaterialsWithTypes();

  // For Local CRUD

  Future<void> saveProductToLocal(ProductEntity product);

  Future<List<ProductModel?>> fetchProductFromLocalById(int id, int categoryId);

  Future<List<ProductModel?>> fetchProductFromLocalByQuery(
    final String nomer,
    final String eni,
    final String boyi,
    final String narxi,
    final String marja,
    final int categoryId,
  );

  Future<List<ProductModel?>> fetchProductFromLocalByCategoryId(int id);

  Future<List<ProductModel>> fetchAllProductsFromLocal();
  Future<List<CostModel>> fetchAllCostsFromLocal();

  Future<void> updateLocalProduct(ProductEntity product);

  Future<void> removeProductFromLocal(int id);
  // Local CRUD for costs
  Future<void> saveCostToLocal(CostEntity cost);
  Future<void> saveCostListToLocal(List<CostModel> cost);
  Future<void> updateLocalCost(CostEntity cost);
  Future<void> deleteLocalCost(int costId);
  Future<List<CostEntity>> getCostListById(int costId);
}

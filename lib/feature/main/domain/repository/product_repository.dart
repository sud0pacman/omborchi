import 'package:omborchi/feature/main/data/model/local_model/product_entity.dart';
import 'package:omborchi/feature/main/domain/model/product_model.dart';

import '../../../../core/network/network_state.dart';

abstract interface class ProductRepository {
  Future<State> getProducts(int categoryId);

  Future<State> createProduct(ProductModel product);

  Future<State> updateProduct(ProductModel product);

  Future<State> deleteProduct(ProductModel product);

  Future<State> uploadImage(String imageName, String image);

  Future<State> downloadImage({required String path, required String name});

  Future<State> getCategories();

  Future<State> getRawMaterialsWithTypes();

  // For Local CRUD

  Future<void> saveProductToLocal(ProductEntity product);

  Future<List<ProductModel?>> fetchProductFromLocalById(int id);

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

  Future<void> updateLocalProduct(ProductEntity product);

  Future<void> removeProductFromLocal(int id);
}

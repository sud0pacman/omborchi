import 'package:hive/hive.dart';
import 'package:omborchi/feature/main/data/model/local_model/product_entity.dart';

import '../../feature/main/domain/model/product_model.dart';

class HiveHelper {
  static const String productBoxName = 'productBox';

  // Save product to Hive
  Future<void> saveProductToLocal(ProductEntity product) async {
    final box = await Hive.openBox<ProductEntity>(productBoxName);
    await box.put(product.id, product); // Using product ID as key
  }

  // Fetch product from Hive by ID
  Future<ProductEntity?> fetchProductFromLocalById(int id) async {
    final box = await Hive.openBox<ProductEntity>(productBoxName);
    return box.get(id); // Return the product with the given ID
  }

  // Fetch products by category ID
  Future<List<ProductModel?>> fetchProductFromLocalByCategoryId(int categoryId) async {
    final box = await Hive.openBox<ProductEntity>(productBoxName);
    final products = box.values.where((product) => product.categoryId == categoryId).toList();

    return products.map((product) => product.toModel()).toList(); // Convert to ProductModel
  }

  // Fetch all products from Hive
  Future<List<ProductEntity>> fetchAllProductsFromLocal() async {
    final box = await Hive.openBox<ProductEntity>(productBoxName);
    return box.values.toList(); // Return all products as a list
  }

  // Update product in Hive
  Future<void> updateLocalProduct(ProductEntity product) async {
    final box = await Hive.openBox<ProductEntity>(productBoxName);
    await box.put(product.id, product); // Update the product with the same ID
  }

  // Remove product from Hive by ID
  Future<void> removeProductFromLocal(int id) async {
    final box = await Hive.openBox<ProductEntity>(productBoxName);
    await box.delete(id); // Remove the product with the given ID
  }
}

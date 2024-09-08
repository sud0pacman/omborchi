import 'package:image_picker/image_picker.dart';
import 'package:omborchi/feature/main/domain/model/product_model.dart';

import '../../../../core/network/network_state.dart';

abstract interface class ProductRepository {
  Future<State> getProducts(int categoryId);
  Future<State> createProduct(ProductModel product);
  Future<State> updateProduct(ProductModel product);
  Future<State> deleteProduct(ProductModel product);
  Future<State> uploadImage(String imageName, XFile file);
  Future<State> downloadImage({required String path, required String name});
}
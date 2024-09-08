import 'package:cross_file/src/types/interface.dart';

import 'package:omborchi/core/network/network_state.dart';

import 'package:omborchi/feature/main/domain/model/product_model.dart';

import '../../../domain/repository/product_repository.dart';
import '../product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource productRemoteDataSource;

  ProductRepositoryImpl(this.productRemoteDataSource);


  @override
  Future<State> createProduct(ProductModel product) {
    return productRemoteDataSource.createProduct(product.toNetwork());
  }

  @override
  Future<State> deleteProduct(ProductModel product) {
    return productRemoteDataSource.deleteProduct(product.toNetwork());
  }

  @override
  Future<State> getProducts(int categoryId) {
    return productRemoteDataSource.getProducts(categoryId);
  }

  @override
  Future<State> updateProduct(ProductModel product) {
    return productRemoteDataSource.updateProduct(product.toNetwork());
  }

  @override
  Future<State> uploadImage(String imageName, XFile file) async {
    return productRemoteDataSource.uploadImage(imageName, file);
  }

  @override
  Future<State> downloadImage({required String path, required String name}) {
    return productRemoteDataSource.downloadImage(path: path, name: name);
  }

}
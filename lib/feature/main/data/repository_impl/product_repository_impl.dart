import 'package:hive/hive.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:omborchi/core/modules/isar_helper.dart';
import 'package:omborchi/core/network/network_state.dart';
import 'package:omborchi/core/utils/consants.dart';
import 'package:omborchi/feature/main/data/data_sources/remote_data_source/product_remote_data_source.dart';
import 'package:omborchi/feature/main/domain/model/category_model.dart';

import 'package:omborchi/feature/main/domain/model/product_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:omborchi/feature/main/domain/model/raw_material.dart';
import 'package:omborchi/feature/main/domain/model/raw_material_type.dart';
import 'package:omborchi/feature/main/domain/repository/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource productRemoteDataSource;
  final InternetConnectionChecker networkChecker = InternetConnectionChecker();
  final isarHelper = IsarHelper();
  late DateTime now;

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
}

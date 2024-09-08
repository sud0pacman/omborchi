import 'package:omborchi/core/network/network_state.dart';
import 'package:omborchi/feature/main/data/remote_data_source/model/category_network.dart';

import 'package:omborchi/feature/main/domain/model/category_model.dart';

import '../../../domain/repository/category_repository.dart';
import '../category_remote_data_source.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource categoryRemoteDataSource;

  CategoryRepositoryImpl(this.categoryRemoteDataSource);

  @override
  Future<State> createCategory(CategoryModel category) async {
    final res = await categoryRemoteDataSource.createCategory(category.toNetwork());

    if (res is Success) {
      final CategoryNetwork category = res.value;
      return Success(category.toModel());
    } else {
      return res;
    }
  }

  @override
  Future<State> deleteCategory(CategoryModel category) {
    return categoryRemoteDataSource.deleteCategory(category.toNetwork());
  }

  @override
  Future<State> getCategories() async {
    final response = await categoryRemoteDataSource.getCategories();

    if (response is Success) {
      final List<CategoryNetwork> categories = response.value;
      final List<CategoryModel> categoriesModel =
          categories.map((e) => e.toModel()).toList();

      return Success(categoriesModel);
    } else {
      return response;
    }
  }

  @override
  Future<State> updateCategory(CategoryModel category) {
    return categoryRemoteDataSource.updateCategory(category.toNetwork());
  }
}

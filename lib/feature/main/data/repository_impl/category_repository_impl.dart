import 'package:omborchi/core/modules/db_helper.dart';
import 'package:omborchi/core/network/network_state.dart';
import 'package:omborchi/core/utils/consants.dart';
import 'package:omborchi/feature/main/data/data_sources/remote_data_source/category_remote_data_source.dart';
import 'package:omborchi/feature/main/data/model/remote_model/category_network.dart';

import 'package:omborchi/feature/main/domain/model/category_model.dart';
import 'package:omborchi/feature/main/domain/repository/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource categoryRemoteDataSource;
  final MyDatabaseHelper myDatabaseHelper;

  CategoryRepositoryImpl(this.categoryRemoteDataSource, this.myDatabaseHelper);

  @override
  Future<State> createCategory(CategoryModel category) async {
    bool isHaveNetwork = true;

    final localData = category.toLocal();

    AppRes.logger.i(localData);

    final response = await myDatabaseHelper.addCategory(localData);

    AppRes.logger.i(response);

    if (response != -1) {
      if (isHaveNetwork) {
        final res = await categoryRemoteDataSource
            .createCategory(category.copyWith(id: response).toNetwork());


        if (res is Success) {
          final CategoryNetwork category = res.value;
          return Success(category.toModel());
        } else {
          return res;
        }
      }
    } else {
      AppRes.logger.e('$response');
      return GenericError('$response');
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

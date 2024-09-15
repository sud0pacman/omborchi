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
    bool isHaveNetwork = category.id == null;

    final localData = category.copyWith(id: 0).toLocal();

    AppRes.logger.i(localData);

    final response = await myDatabaseHelper.addCategory(localData);

    AppRes.logger.i(response);

    if (response != -1) {
      if (isHaveNetwork) {
        final res = await categoryRemoteDataSource
            .createCategory(category.copyWith(id: response).toNetwork());

        // if (res is Success) {
        //   final CategoryNetwork category = res.value;
        //   return Success(category.toModel());
        // } else {
          return res;
        // }
      } else {
        await myDatabaseHelper.deleteCategory(response);
        AppRes.logger.wtf('Weak network');
        return NoInternet('Weak network');
      }
    } else {
      AppRes.logger.e('$response');
      return GenericError('$response');
    }
  }

  @override
  Future<State> deleteCategory(CategoryModel category) async {
    bool isHaveNetwork = category.id != null;
    if (isHaveNetwork) {
      final res =
          await categoryRemoteDataSource.deleteCategory(category.toNetwork());

      if (res is Success) {
        final localRes =
            await categoryRemoteDataSource.deleteCategory(category.toNetwork());
        AppRes.logger.t(localRes);
        return Success(res.value);
      } else {
        return res;
      }
    } else {
      return NoInternet('Weak network');
    }
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
  Future<State> updateCategory(CategoryModel category) async {
    final res =
        await categoryRemoteDataSource.updateCategory(category.toNetwork());

    if (res is Success) {
      await myDatabaseHelper.updateCategory(category.toLocal()); 
    }

    return res;
  }
  
  @override
  Future<State> syncCategories() {
    // TODO: implement syncCategories
    throw UnimplementedError();
  }
}
